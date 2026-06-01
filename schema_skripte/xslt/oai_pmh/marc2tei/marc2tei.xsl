<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:ckm="http://handschriftenportal.de/ckm"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:h1="http://www.startext.de/HiDA/DefService/XMLSchema"
    xmlns:h2="katneu4-2009-12-richedit-illum-neu.xml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:rtftools="http://www.startext.de/rtftools"
    xmlns:sbbfunc="http://dev.sbb.berlin/sbb"
    xmlns="http://www.openarchives.org/OAI/2.0/"
    xmlns:marcxml="http://www.loc.gov/MARC21/slim"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:mx="info:lc/xmlns/marcxchange-v1"
    xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd"
    extension-element-prefixes="saxon"
    exclude-result-prefixes="#all">
    <xsl:import href="marc2tei_utilities.xsl"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:preserve-space elements="text"/>
    <xsl:param name="separator" select=" ' · ' "/>
    
    <xsl:template match="/">
        <xsl:variable name="creation_format"    select="oai:OAI-PMH/oai:request/text()"/>
        <xsl:variable name="creation_set"       select="oai:OAI-PMH/oai:request/@set"/>
        <xsl:for-each select="oai:OAI-PMH/oai:ListRecords/oai:record">
            <xsl:variable name="datestamp_year" select="substring(oai:header/oai:datestamp/text(), 1, 4)"/>
            <xsl:variable name="signature"      select="replace(oai:metadata/mx:record/mx:datafield[@tag = '955']/mx:subfield[@code = 'a'], '#Mikroform', '')"/>
            <xsl:variable name="id"             select="oai:metadata/mx:record/mx:controlfield[@tag='001']/text()"/>
            <xsl:message><xsl:text>Dok-ID: </xsl:text><xsl:value-of select="$id"/></xsl:message>
            <!-- Check if signature is in KOD-Lists. If not, skip this object, else continue with creating TEI-file -->
            <xsl:variable name="signature_in_kods" as="xs:boolean">
                <xsl:call-template name="check_kods">
                    <xsl:with-param name="signature" select="$signature"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:if test="$signature_in_kods = true()">
                <xsl:call-template name="check_fields"/> <!-- checks for certain fields that are not yet included in this script. If field contains a value a message os send. -->
                
                <xsl:result-document href="{concat('../result-files_TEI/', $id, '_TEI-HSP.xml')}">
                    
                    <!-- Fill variables with values from MARC-file, modify them so that they are useable in TEI -->
                    <!-- MATERIAL -->
                    <xsl:variable name="raw_material"       select="oai:metadata/mx:record/mx:datafield[@tag = '300']/mx:subfield[@code = 'a']"/> <!-- 300a: Physical Description - Extent -->
                    <xsl:variable name="norm_material">
                        <xsl:call-template name="material">
                            <xsl:with-param name="value" select="replace($raw_material, ',', '')"/>
                        </xsl:call-template>
                    </xsl:variable>
                                        
                    <!-- MEASURE -->
                    <xsl:variable name="raw_measure"        select="tokenize(oai:metadata/mx:record/mx:datafield[@tag = '300']/mx:subfield[@code = 'a'], ' - ')[1]"/> <!-- 300a: Physical Description - Extent -->
                    <xsl:variable name="norm_measure">
                        <xsl:call-template name="measure">
                            <xsl:with-param name="value" select="$raw_measure"/>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    <!-- DIMENSION -->
                    <xsl:variable name="raw_dimension"      select="oai:metadata/mx:record/mx:datafield[@tag = '300']/mx:subfield[@code = 'c']"/> <!-- 300c: Physical Description - Dimensions -->
                    <xsl:variable name="norm_dimensions">
                        <xsl:call-template name="dimension">
                            <xsl:with-param name="value" select="$raw_dimension"/>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    <!-- FORMAT -->
                    <xsl:variable name="norm_format">
                        <xsl:call-template name="format">
                            <xsl:with-param name="norm_value" select="$norm_dimensions"/>
                            <xsl:with-param name="raw_value" select="$raw_dimension"/>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    <!-- ENTSTEHUNGSORT -->
                    <xsl:variable name="hss_origPlace_raw"     select="oai:metadata/mx:record/mx:datafield[@tag = '264']/mx:subfield[@code = 'a']"/> <!-- 264a: Place of production, publication, distribution, manufacture -->
                    <xsl:variable name="hss_origPlace_norm">
                        <xsl:call-template name="origPlace">
                            <xsl:with-param name="value" select="$hss_origPlace_raw"/>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    <!-- TITEL -->
                    <xsl:variable name="hss_title"          select="tokenize(oai:metadata/mx:record/mx:datafield[@tag = '245']/mx:subfield[@code = 'a'], ' - ')[1]"/> <!-- 245: Titel -->
                    
                    <!-- ENTSTEHUNGSJAHR -->
                    <xsl:variable name="hss_origDate_raw"    select="oai:metadata/mx:record/mx:datafield[@tag = '264']/mx:subfield[@code = 'c']"/> <!-- 264c: Date of production, publication, distribution, manufacture, or copyright notice -->
                    <xsl:variable name="hss_origDate_norm">
                        <!-- return: value§§§notBefore§§§notAfter§§§type -->
                        <xsl:call-template name="origDate">
                            <xsl:with-param name="value" select="$hss_origDate_raw"/>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    <!-- Ort, besitzende Einrichtung -->
                    <xsl:variable name="hss_settlement_raw" select="oai:metadata/mx:record/mx:datafield[@tag = '955']/mx:subfield[@code = 'b']"/>
                    <xsl:variable name="hss_settlement_norm">
                        <xsl:call-template name="norm_settlement">
                            <xsl:with-param name="value" select="$hss_settlement_raw"/>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    <!-- SPRACHE -->
                    <xsl:variable name="hss_language_raw" select="oai:metadata/mx:record/mx:datafield[@tag = '041']/mx:subfield[@code = 'a']"/> <!-- 041a: Language code of text/sound track or separate title -->
                    
                    <!-- other variables -->
                    <!-- Katalogangaben -->
                    <xsl:variable name="catalog_author"     select="oai:metadata/mx:record/mx:datafield[@tag = '787']/mx:subfield[@code = 'a']"/> <!-- 787a: Other Relationship Entry - Main entry heading (Geistiger Schöpfer) -->
                    <xsl:variable name="catalog_title"      select="oai:metadata/mx:record/mx:datafield[@tag = '787']/mx:subfield[@code = 't']"/> <!-- 787t: Other Relationship Entry - Title -->
                    <xsl:variable name="catalog_publish"    select="oai:metadata/mx:record/mx:datafield[@tag = '787']/mx:subfield[@code = 'd']"/> <!-- 787d: Other Relationship Entry - Place, publisher, and date of publication -->
                    <xsl:variable name="catalog_publish_year"   select="substring($catalog_publish, string-length($catalog_publish)-3, 4)"/> <!-- 787d: Other Relationship Entry - Place, publisher, and date of publication -->
                    <xsl:variable name="catalog_series"     select="oai:metadata/mx:record/mx:datafield[@tag = '787']/mx:subfield[@code = 'k']"/> <!-- 787k: Other Relationship Entry - Series data for related item -->
                    <xsl:variable name="link_volltext"      select="oai:metadata/mx:record/mx:datafield[@tag = '856']/mx:subfield[@code = 'u']"/>
                    
                    <!-- FRAGE: Ist das Feld 005 wirklich das Erstellungsdarum? -->
                    <xsl:variable name="creationDate_year"  select="substring(oai:metadata/mx:record/mx:controlfield[@tag = '005'], 1, 4)"/> <!-- 005: Control Field - Date and Time of Latest Transaction -->
                    <xsl:variable name="creationDate_month" select="substring(oai:metadata/mx:record/mx:controlfield[@tag = '005'], 5, 2)"/> <!-- 005: Control Field - Date and Time of Latest Transaction -->
                    <xsl:variable name="creationDate_day"   select="substring(oai:metadata/mx:record/mx:controlfield[@tag = '005'], 7, 2)"/> <!-- 005: Control Field - Date and Time of Latest Transaction -->
                    <xsl:variable name="marc_revision_date" select="oai:metadata/mx:record/mx:datafield[@tag = '982']/mx:subfield[@code = 'd']"/>
                    
                    <!-- ANFANG TEI -->
                    <xsl:element name="TEI" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:namespace name="xi"    select=" 'http://www.w3.org/2001/XInclude' "/>
                        <xsl:namespace name="dcr"   select=" 'http://www.isocat.org/ns/dcr' "/>
                        <xsl:namespace name="egXML" select=" 'http://www.tei-c.org/ns/Examples' "/>
                        <xsl:namespace name="xsi"   select=" 'http://www.w3.org/2001/XMLSchema-instance' "/>
                        
                        <!-- ANFANG TEI-HEAD -->
                        <xsl:element name="teiHeader" namespace="http://www.tei-c.org/ns/1.0">
                            
                            <xsl:element name="fileDesc" namespace="http://www.tei-c.org/ns/1.0">
                                
                                <xsl:element name="titleStmt" namespace="http://www.tei-c.org/ns/1.0"> <!-- FERTIG: titleStmt - ggf. noch Normdaten referenzieren? -->
                                    <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">
                                        <xsl:text>Beschreibung von BSB-Hss </xsl:text><xsl:value-of select="$signature"/>
                                    </xsl:element>
                                    <xsl:if test="$catalog_author != ''">
                                        <xsl:element name="respStmt" namespace="http://www.tei-c.org/ns/1.0">
                                            <xsl:element name="resp" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:text>Beschrieben von</xsl:text>
                                            </xsl:element>
                                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="role" select=" 'author' "/>
                                                <xsl:value-of select="$catalog_author"/>
                                            </xsl:element>
                                        </xsl:element>    
                                    </xsl:if>
                                </xsl:element>
                               
                                <xsl:element name="editionStmt" namespace="http://www.tei-c.org/ns/1.0"> <!-- FERTIG: editionStmt - Farge klären, wegen Feld 005, ob das auch das creation Date ist?? -->
                                    <xsl:element name="edition" namespace="http://www.tei-c.org/ns/1.0">Elektronische Ausgabe nach TEI P5</xsl:element>
                                    <xsl:element name="respStmt" namespace="http://www.tei-c.org/ns/1.0">
                                        <xsl:element name="resp" namespace="http://www.tei-c.org/ns/1.0">
                                            <xsl:text>Automatisch generierte Handschriftenbeschreibung aus einem </xsl:text>
                                            <xsl:if test="$creationDate_year != '' and $creationDate_year != '0000' ">
                                                <xsl:value-of select="concat('am ', $creationDate_day, '.', $creationDate_month, '.', $creationDate_year, ' erstellten ')"/>
                                            </xsl:if>
                                            <xsl:text>Eintrag der OAI-PMH Schnittstelle </xsl:text>
                                            <xsl:if test="$creation_format != '' ">
                                                <xsl:value-of select="$creation_format"/>
                                            </xsl:if>
                                            <xsl:if test="$creation_set != ''">
                                                <xsl:value-of select="concat(' mit dem Set-Name ', $creation_set)"/>
                                            </xsl:if>
                                            <xsl:text>.</xsl:text>
                                        </xsl:element>  
                                        <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
                                            <xsl:attribute name="type" select=" 'org' "/>
                                            <xsl:text>Handschriftenportal</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                                
                                <xsl:element name="publicationStmt" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:element name="publisher" namespace="http://www.tei-c.org/ns/1.0">
                                        <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
                                            <xsl:attribute name="type" select=" 'org' "/>
                                                <xsl:text>Handschriftenportal</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="ptr" namespace="http://www.tei-c.org/ns/1.0">
                                            <xsl:attribute name="target" select=" 'http://www.handschriftenportal.de' "/>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
                                        <xsl:variable name="date_primary">
                                            <xsl:choose>
                                                <xsl:when test="matches($catalog_publish_year, '^\d\d\d\d$') and $catalog_publish_year != '0000'">
                                                    <xsl:value-of select="$catalog_publish_year"/>
                                                </xsl:when>
                                                <xsl:when test="matches($creationDate_year, '^\d\d\d\d$')and $creationDate_year != '0000'">
                                                    <xsl:value-of select="$creationDate_year"/>
                                                </xsl:when>
                                                <xsl:when test="matches($datestamp_year, '^\d\d\d\d$')and $datestamp_year != '0000'">
                                                    <xsl:value-of select="$datestamp_year"/>
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xsl:attribute name="type" select=" 'primary' "/>
                                        <xsl:attribute name="when" select="$date_primary"/>
                                        <xsl:value-of select="$date_primary"/>
                                    </xsl:element>
                                    
                                    <xsl:element name="availability" namespace="http://www.tei-c.org/ns/1.0">
                                        <xsl:attribute name="status" select=" 'free' "></xsl:attribute>
                                        <xsl:element name="licence" namespace="http://www.tei-c.org/ns/1.0">
                                            <!-- FRAGE: Welche License wann? -->
                                            <xsl:attribute name="target" select=" oai:metadata/mx:record/mx:datafield[@tag = '845']/mx:subfield[@code = 'u'] "/>
                                            <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:if test="oai:metadata/mx:record/mx:datafield[@tag = '845']/mx:subfield[@code = 'a'] = 'CC0' ">
                                                    <xsl:text>Für den OPAC-Eintrag verzichtet die Einrichtung </xsl:text><xsl:value-of select="oai:metadata/mx:record/mx:datafield[@tag = '845']/mx:subfield[@code = 'b']"/><xsl:text> auf alle Nutzungsrechte.</xsl:text>
                                                </xsl:if>
                                            </xsl:element>
                                            <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:text>Für die Nutzung weiterer Daten wie Digitalisaten gelten gegebenenfalls andere Lizenzen. Vgl. die </xsl:text>
                                                <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                                                    <xsl:attribute name="target" select="'http://www.handschriftenportal.de'"/>
                                                        <xsl:text>Nutzungsbedingungen</xsl:text>
                                                </xsl:element>
                                                <xsl:text>des Handschriftenportals.</xsl:text>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                                
                                <xsl:element name="sourceDesc" namespace="http://www.tei-c.org/ns/1.0"> <!-- FERTIG: sourceDesc - FRAGE: Was wenn es keine Katalogangaben gibt? WAs wenn es sogar keine Volltextangaben gibt? -->
                                    <xsl:element name="bibl" namespace="http://www.tei-c.org/ns/1.0">
                                        <xsl:if test="$catalog_author != ''">
                                            <xsl:value-of select="$catalog_author"/><xsl:text>: </xsl:text>
                                        </xsl:if>
                                        <xsl:choose>
                                            <xsl:when test="$catalog_title != '' and $catalog_publish != ''">
                                                <xsl:value-of select="$catalog_title"/><xsl:text> - </xsl:text><xsl:value-of select="$catalog_publish"/><xsl:text>.</xsl:text>
                                            </xsl:when>
                                            <xsl:when test="$catalog_title != '' and $catalog_publish = ''">
                                                <xsl:value-of select="$catalog_title"/><xsl:text>.</xsl:text>
                                            </xsl:when>
                                            <xsl:when test="$catalog_title = '' and $catalog_publish != ''">
                                                <xsl:value-of select="$catalog_publish"/><xsl:text>.</xsl:text>
                                            </xsl:when>
                                        </xsl:choose>
                                        <xsl:if test="$catalog_series != ''">
                                            <xsl:text> - (</xsl:text><xsl:value-of select="$catalog_series"/><xsl:text>) - </xsl:text>
                                        </xsl:if>
                                        <xsl:value-of select="oai:metadata/mx:record/mx:datafield[@tag='856'][contains(mx:subfield[@code='3'], 'Volltext')]/mx:subfield[@code='u']"/>
                                    </xsl:element>
                                </xsl:element>
                                
                            </xsl:element>
                            
                            <xsl:element name="profileDesc" namespace="http://www.tei-c.org/ns/1.0"> <!-- FEHLT -->
                                <xsl:element name="creation" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0"/>
                                </xsl:element>
                            </xsl:element>
                            
                            <xsl:element name="revisionDesc" namespace="http://www.tei-c.org/ns/1.0"> <!-- FERTIG: revisionDesc -->
                                <xsl:element name="change" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
                                        <xsl:choose>
                                            <xsl:when test="matches(tokenize($marc_revision_date, ' ')[1], '^\d\d\d\d-\d\d-\d\d$')">
                                                <xsl:attribute name="when" select="tokenize($marc_revision_date, ' ')[1]"/>
                                                <xsl:value-of select="$marc_revision_date"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:attribute name="when" select="oai:header/oai:datestamp/text()"/>
                                                <xsl:value-of select="oai:header/oai:datestamp/text()"/><xsl:text> 00:00:00</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                            
                        </xsl:element>
                        
                        <!-- ENDE TEI-HEAD -->
                        
                        <xsl:element name="text" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:element name="body" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:element name="msDesc" namespace="http://www.tei-c.org/ns/1.0">
    
                                    <!-- MINIMALDATEN -->
    
                                    <xsl:element name="msIdentifier" namespace="http://www.tei-c.org/ns/1.0">
                                        <!-- FEHLT: ggf. collection -->
                                        <!-- hss_settlement_norm: Ort§§§gnd-Ort§§§NORM-Ort§§§Einrichtung§§§gnd-Einrichtung§§§NORM-Einrichtung -->
                                        <xsl:element name="settlement" namespace="http://www.tei-c.org/ns/1.0">
                                            <xsl:if test="tokenize($hss_settlement_norm, $split_var)[3] != ''">
                                                <xsl:attribute name="key" select="tokenize($hss_settlement_norm, $split_var)[3]"></xsl:attribute>
                                            </xsl:if>
                                            <xsl:if test="tokenize($hss_settlement_norm, $split_var)[2] != ''">
                                                <xsl:attribute name="ref" select="tokenize($hss_settlement_norm, $split_var)[2]"></xsl:attribute>
                                            </xsl:if>
                                            <xsl:value-of select="tokenize($hss_settlement_norm, $split_var)[1]"/>
                                        </xsl:element>
                                        <xsl:element name="repository" namespace="http://www.tei-c.org/ns/1.0">
                                            <xsl:if test="tokenize($hss_settlement_norm, $split_var)[6] != ''">
                                                <xsl:attribute name="key" select="tokenize($hss_settlement_norm, $split_var)[6]"></xsl:attribute>
                                            </xsl:if>
                                            <xsl:if test="tokenize($hss_settlement_norm, $split_var)[5] != ''">
                                                <xsl:attribute name="ref" select="tokenize($hss_settlement_norm, $split_var)[5]"></xsl:attribute>
                                            </xsl:if>
                                            <xsl:value-of select="tokenize($hss_settlement_norm, $split_var)[4]"/>
                                        </xsl:element>
                                        <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
                                            <xsl:value-of select="$signature"/>
                                        </xsl:element>
                                        <!-- altIdentifier kann weg bleiben -->
                                    </xsl:element>
                                    
                                    <!-- ENDE MINIMALDATEN -->
                                    
                                    <!-- KERNDATEN -->
    
                                    <xsl:element name="head" namespace="http://www.tei-c.org/ns/1.0">
    
                                        <!-- FRAGE: Was muss im Titel genormt sein? -->
                                        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0"> <!-- NORM TITLE -->
                                            <xsl:attribute name="indexName" select=" 'norm_title' "/>
                                            <xsl:element name="term"  namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="type" select=" 'title' "/>
                                                <xsl:value-of select="$hss_title"/>
                                            </xsl:element>
                                        </xsl:element>
                                        
                                        <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0"><!-- FERTIG: TITLE -->
                                            <xsl:value-of select="$hss_title"/>
                                        </xsl:element>
                                        
                                        <xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0"> <!-- FERTIG: SCHLAGZEILE -->
                                            <xsl:attribute name="type" select=" 'headline' "/> <!-- headline: Material · Umfang · Größe · Entstehungsort · Entstehungszeit -->
                                            <xsl:variable name="schlagzeile">
                                                <xsl:if test="$norm_material != ''">
                                                    <xsl:for-each select="tokenize($norm_material, $split_var)">
                                                        <xsl:value-of select="tokenize(., ' ')[1]"/>
                                                        <xsl:text> </xsl:text>
                                                    </xsl:for-each>
                                                    <xsl:text>· </xsl:text>
                                                </xsl:if>
                                                <xsl:if test="$norm_measure != ''">
                                                    <xsl:value-of select="$raw_measure"/>
                                                    <xsl:text> · </xsl:text>
                                                </xsl:if>
                                                <xsl:if test="$norm_dimensions != ''">
                                                    <xsl:value-of select="$raw_dimension"/>
                                                    <xsl:text> · </xsl:text>
                                                </xsl:if>
                                                <xsl:if test="tokenize($hss_origPlace_norm, $split_var)[1] != ''">
                                                    <xsl:value-of select="tokenize($hss_origPlace_norm, $split_var)[1]"/>
                                                    <xsl:text> · </xsl:text>
                                                </xsl:if>
                                                <xsl:if test="tokenize($hss_origDate_norm, $split_var)[1] != ''">
                                                    <xsl:value-of select="tokenize($hss_origDate_norm, $split_var)[1]"/>
                                                    <xsl:text> · </xsl:text>
                                                </xsl:if>
                                            </xsl:variable>
                                            <xsl:value-of select="substring($schlagzeile, 1, string-length($schlagzeile)-3)"/>
                                        </xsl:element>
                                        
                                        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0"> <!-- FERTIG: BESCHREIBSTOFF / material -->
                                            <xsl:attribute name="indexName" select=" 'norm_material' "/>
                                            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="type" select=" 'material' "></xsl:attribute>
                                                <xsl:for-each select="tokenize($norm_material, '§§§')">
                                                    <xsl:value-of select="tokenize(., ' ')[1]"/>
                                                    <xsl:text> </xsl:text>
                                                </xsl:for-each>
                                            </xsl:element>
                                            <xsl:choose>
                                                <xsl:when test="$norm_material != ''">
                                                    <xsl:for-each select="tokenize($norm_material, '§§§')">
                                                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                            <xsl:attribute name="type" select=" 'material_type' "/>
                                                            <xsl:value-of select="tokenize(., ' ')[2]"/>
                                                        </xsl:element>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                        <xsl:attribute name="type" select=" 'material_type' "/>
                                                    </xsl:element>
                                                </xsl:otherwise>
                                            </xsl:choose>                                            
                                        </xsl:element>
                                        
                                        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0"> <!-- FERTIG: SEITENANZAHL / measure -->
                                            <xsl:attribute name="indexName" select=" 'norm_measure' "/>
                                            <xsl:choose>
                                                <xsl:when test="$norm_measure != ''">
                                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                        <xsl:attribute name="type" select=" 'measure' "/>
                                                        <xsl:value-of select="$raw_measure"/>
                                                    </xsl:element>
                                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                        <xsl:attribute name="type" select=" 'measure_noOfLeaves' "/>
                                                        <xsl:value-of select="$norm_measure"/>
                                                    </xsl:element>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                        <xsl:attribute name="type" select=" 'measure' "/>
                                                    </xsl:element>
                                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                        <xsl:attribute name="type" select=" 'measure_noOfLeaves' "/>
                                                    </xsl:element>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    
                                        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0"> <!-- FERTIG: MAßE / dimensions -->
                                            <xsl:attribute name="indexName" select="'norm_dimensions'"/>
                                            <xsl:choose>
                                                <xsl:when test="$norm_dimensions != ''">
                                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                        <xsl:attribute name="type" select="'dimensions'"/>
                                                        <xsl:value-of select="tokenize($norm_dimensions, $split_var)[1]"/>
                                                    </xsl:element>
                                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                        <xsl:attribute name="type" select="'height'"/>
                                                        <xsl:value-of select="tokenize($norm_dimensions, $split_var)[2]"/>
                                                    </xsl:element>
                                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                        <xsl:attribute name="type" select="'width'"/>
                                                        <xsl:value-of select="tokenize($norm_dimensions, $split_var)[3]"/>
                                                    </xsl:element>
                                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                        <xsl:attribute name="type" select="'depth'"/>
                                                        <xsl:value-of select="tokenize($norm_dimensions, $split_var)[4]"/>
                                                    </xsl:element>
                                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                        <xsl:attribute name="type" select="'dimensions_typeOfInformation'"/>
                                                        <xsl:value-of select="tokenize($norm_dimensions, $split_var)[5]"/>
                                                    </xsl:element>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                        <xsl:attribute name="type" select="'dimensions'"/>
                                                    </xsl:element>
                                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                        <xsl:attribute name="type" select="'height'"/>
                                                    </xsl:element>
                                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                        <xsl:attribute name="type" select="'width'"/>
                                                    </xsl:element>
                                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                        <xsl:attribute name="type" select="'depth'"/>
                                                    </xsl:element>
                                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                        <xsl:attribute name="type" select="'dimensions_typeOfInformation'"/>
                                                    </xsl:element>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                        
                                        <xsl:message><xsl:text>NORM_FORMAT: </xsl:text><xsl:value-of select="$norm_format"/></xsl:message>
                                        
                                        <xsl:choose> <!-- FORMAT / format -->
                                            <xsl:when test="$norm_format != ''">
                                                <xsl:for-each select="tokenize($norm_format, $split_var)">
                                                    <xsl:if test=". != 'factual' and . != 'computed' and . != 'deduced' and . != ''">
                                                        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                                                            <xsl:attribute name="indexName" select=" 'norm_format' "/>
                                                            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                                <xsl:attribute name="type" select=" 'format' "/>
                                                                <xsl:value-of select="."/>
                                                            </xsl:element>
                                                            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                                <xsl:attribute name="type" select=" 'format_typeOfInformation' "/>
                                                                <xsl:value-of select="tokenize($norm_format, $split_var)[1]"/>
                                                            </xsl:element>
                                                        </xsl:element>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                                                    <xsl:attribute name="indexName" select=" 'norm_format' "/>
                                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                        <xsl:attribute name="type" select=" 'format' "/>
                                                    </xsl:element>
                                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                        <xsl:attribute name="type" select=" 'format_typeOfInformation' "/>
                                                    </xsl:element>
                                                </xsl:element>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        
                                        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0"> <!-- FERTIG: ENTSTEHUNGSORT / origPlace -->
                                            <xsl:attribute name="indexName" select="'norm_origPlace'"/>
                                            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="type" select="'origPlace'"/>
                                                <xsl:value-of select="tokenize($hss_origPlace_norm, $split_var)[1]"/>
                                            </xsl:element>
                                            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="type" select="'origPlace_norm'"/>
                                                <xsl:if test="tokenize($hss_origPlace_norm, $split_var)[2] != ''">
                                                    <xsl:attribute name="ref" select="tokenize($hss_origPlace_norm, $split_var)[3]"/>
                                                    <xsl:value-of select="tokenize($hss_origPlace_norm, $split_var)[2]"/>
                                                </xsl:if>
                                            </xsl:element>
                                        </xsl:element>
                                        
                                        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0"> <!-- ENTSTEHUNGSJAHR / origDate -->
                                            <xsl:attribute name="indexName" select=" 'norm_origDate' "/>
                                            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="type" select=" 'origDate' "/>
                                                <xsl:value-of select="tokenize($hss_origDate_norm, $split_var)[1]"/>
                                            </xsl:element>
                                            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="type" select=" 'origDate_notBefore' "/>
                                                <xsl:value-of select="tokenize($hss_origDate_norm, $split_var)[2]"/>
                                            </xsl:element>
                                            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="type" select=" 'origDate_notAfter' "/>
                                                <xsl:value-of select="tokenize($hss_origDate_norm, $split_var)[3]"/>
                                            </xsl:element>
                                            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="type" select=" 'origDate_type' "/>
                                                <xsl:value-of select="tokenize($hss_origDate_norm, $split_var)[4]"/>
                                            </xsl:element>
                                        </xsl:element>
                                        
                                        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0"> <!-- FERTIG: SPRACHE / textLang -->
                                            <xsl:attribute name="indexName" select=" 'norm_textLang' "/>
                                            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="type" select=" 'textLang' "/>
                                                <xsl:value-of select="$hss_language_raw"/>
                                            </xsl:element>
                                            <xsl:choose>
                                                <xsl:when test="$hss_language_raw != ''">
                                                    <xsl:for-each select="$hss_language_raw">
                                                        <!-- return: language§§§gnd-id§§§NORM -->
                                                        <xsl:variable name="hss_language_norm">
                                                            <xsl:call-template name="norm_Lang">
                                                                <xsl:with-param name="value" select="."/>
                                                            </xsl:call-template>
                                                        </xsl:variable>
                                                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                            <xsl:if test="tokenize($hss_language_norm, $split_var)[3] != ''">
                                                                <xsl:attribute name="key" select="tokenize($hss_language_norm, $split_var)[3]"/>
                                                            </xsl:if>
                                                            <xsl:if test="tokenize($hss_language_norm, $split_var)[2] != ''">
                                                                <xsl:attribute name="ref" select="tokenize($hss_language_norm, $split_var)[2]"/>
                                                            </xsl:if>
                                                            <xsl:attribute name="type" select="'textLang-ID'"/>
                                                            <xsl:value-of select="tokenize($hss_language_norm, $split_var)[1]"/>
                                                        </xsl:element>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                        <xsl:attribute name="type">textLang-ID</xsl:attribute>
                                                    </xsl:element>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                        
                                        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0"> <!-- FORM - FRAGE: Wo finde ich diese Information? Frage Torsten: Würde die Angabe in Feld 338 = Band ausreichen, um daraus das Kerndatenfeld norm_form zu belegen? -->
                                            <xsl:attribute name="indexName" select=" 'norm_form' "/>
                                            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="type" select="'form'"/>
                                            </xsl:element>
                                        </xsl:element>
                                        
                                        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0"> <!-- STATUS - FRAGE: Wo finde ich diese Information? -->
                                            <xsl:attribute name="indexName" select=" 'norm_status' "/>
                                            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="type" select="'status'"/>
                                            </xsl:element>
                                        </xsl:element>
                                        
                                        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0"> <!-- DECORATION - FRAGE: Wo finde ich diese Information? -->
                                            <xsl:attribute name="indexName" select=" 'norm_decoration' "/>
                                            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="type" select="'decoration'"/>
                                            </xsl:element>
                                        </xsl:element>
                                        
                                        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0"> <!-- MUSIC NOTATION - FRAGE: Wo finde ich diese Information? -->
                                            <xsl:attribute name="indexName" select=" 'norm_musicNotation' "/>
                                            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="type" select="'musicNotation'"/>
                                            </xsl:element>
                                        </xsl:element>
                                        
                                    </xsl:element>
                                    
                                    <!-- ENDE KERNDATEN -->
                            
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:result-document>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>