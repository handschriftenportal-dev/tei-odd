<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:h1="http://www.startext.de/HiDA/DefService/XMLSchema"
    xmlns:marcxml="http://www.loc.gov/MARC21/slim"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="tei h1 xs"
    version="2.0">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:param name="start" select=" '90000000' "/>
    <xsl:variable name="crlf" select=" '&#x000A;' "/>
    <xsl:variable name="listPerson" select="document('../nachweis_daten/1_0_Normdaten/hsp_TEI_Import_Personen.xml')"/>
    
    <xsl:template match="/">
        <xsl:result-document href="../../1_0_Normdaten/1_3_Personen/ReImport-MXML_per_{descendant::h1:Document[1]/descendant::h1:Field[ @Type = 'bezsoz' ][ @Value = 'Verwaltung' ]/h1:Field[ @Type = '4564' ]/@Value}.xml">
            <xsl:element name="DocumentSet" namespace="http://www.startext.de/HiDA/DefService/XMLSchema">
                <xsl:element name="ContentInfo" namespace="http://www.startext.de/HiDA/DefService/XMLSchema">
                    <xsl:element name="Format" namespace="http://www.startext.de/HiDA/DefService/XMLSchema">HIDA-DOC1-XML</xsl:element>
                    <xsl:element name="CreationDate" namespace="http://www.startext.de/HiDA/DefService/XMLSchema">23.07.2021 17:34:36:746</xsl:element>
                </xsl:element>
                <xsl:for-each-group select="descendant::h1:Field[ @Type = 'bezper' ][h1:Field[ @Type = 'z001' ]][h1:Field[ @Type = '4100' ][not($listPerson//tei:persName = current()/h1:Field[ @Type = '4100' ]/@Value)]]" group-by="h1:Field[ @Type = 'z001' ]/@Value">
                    <xsl:variable name="currentNumber" select="string(number($start) + position())"/>
                    <xsl:element name="Document" namespace="http://www.startext.de/HiDA/DefService/XMLSchema">
                        <xsl:attribute name="DocKey" select=" concat('per     ', $currentNumber)"/>
                        <xsl:element name="Block" namespace="http://www.startext.de/HiDA/DefService/XMLSchema">
                            <xsl:attribute name="Type" select=" 'per' "/>
                            <xsl:element name="Field" namespace="http://www.startext.de/HiDA/DefService/XMLSchema">
                                <xsl:attribute name="Type" select=" '4000' "/>
                                <xsl:attribute name="Value" select="$currentNumber"/>
                            </xsl:element>
                            <xsl:element name="Field" namespace="http://www.startext.de/HiDA/DefService/XMLSchema">
                                <xsl:attribute name="Type" select=" '4100' "/>
                                <xsl:attribute name="Value" select="h1:Field[@Type='4100']/@Value"/>
                                <xsl:element name="Field" namespace="http://www.startext.de/HiDA/DefService/XMLSchema">
                                    <xsl:attribute name="Type" select=" 'z001' "/>
                                    <xsl:attribute name="Value" select="h1:Field[@Type='z001']/@Value"/>
                                </xsl:element>
                            </xsl:element>
                            <xsl:if test="document(concat('http://d-nb.info/gnd/', h1:Field[ @Type = 'z001' ]/@Value, '/about/marcxml')) != ''">
                                <xsl:element name="Field" namespace="http://www.startext.de/HiDA/DefService/XMLSchema">
                                    <xsl:attribute name="Type" select=" '99fm' "/>
                                    <xsl:attribute name="Value" select="document(concat('http://d-nb.info/gnd/', h1:Field[ @Type = 'z001' ]/@Value, '/about/marcxml'))//marcxml:controlfield[@tag='001']"/>
                                </xsl:element>
                            </xsl:if>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each-group>
            </xsl:element>
        </xsl:result-document>
        
        <!-- ========== TEI listPerson ========== -->
        <!--
        <xsl:result-document href="../../1_0_Normdaten/hsp_TEI_Import_Personen_{descendant::h1:Document[1]/descendant::h1:Field[ @Type = 'bezsoz' ][ @Value = 'Verwaltung' ]/h1:Field[ @Type = '4564' ]/@Value}.xml">
            <xsl:value-of select="$crlf"/>
            <xsl:comment>Diese Datei wurde automatisch erzeugt, unter Verwendung der MXML-to-TEI-P5-Stylesheets, die an der Herzog August Bibliothek Wolfenbüttel im Rahmen des Projektes "Handschriftenportal" gepflegt werden.
                <xsl:value-of select="substring(string(current-date()), 1, 10)"/>
            </xsl:comment>
            <xsl:value-of select="$crlf"/>
            <xsl:element name="TEI" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="teiHeader" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="fileDesc" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="titleStmt" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:text>Automatisch generierte Personenliste</xsl:text>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="publicationStmt" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:element name="publisher" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:text>Handschriftenportal</xsl:text>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="sourceDesc" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:text>Automatisch generierte Personenliste aus einem </xsl:text>
                                <xsl:if test="h1:DocumentSet/h1:ContentInfo/h1:Format"><xsl:value-of select="concat('im ', h1:DocumentSet/h1:ContentInfo/h1:Format, 'Format')"/></xsl:if>
                                <xsl:if test="h1:DocumentSet/h1:ContentInfo/h1:CreationDate"><xsl:value-of select="concat(' am ', h1:DocumentSet/h1:ContentInfo/h1:CreationDate, ' erstellten Datendump')"/></xsl:if>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="text" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="body" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="listPerson" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:for-each-group select="descendant::h1:Field[ @Type = 'bezper' ][h1:Field[ @Type = 'z001' ]][h1:Field[ @Type = '4100' ][not($listPerson//tei:persName = current()/h1:Field[ @Type = 'z001' ]/@Value)]]" group-by="h1:Field[ @Type = 'z001' ]/@Value">
                                <xsl:sort select="current-grouping-key()"/>
                                <xsl:element name="person" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:apply-templates select="current-group()[1]/h1:Field[@Type='4140']"/>
                                    <xsl:apply-templates select="current-group()[1]/h1:Field[@Type='4100']"/>
                                    <xsl:apply-templates select="current-group()[1]/h1:Field[@Type='4105']"/>
                                    <xsl:apply-templates select="current-group()[1]/h1:Field[@Type='4270']"/>
                                    <xsl:apply-templates select="current-group()[1]/h1:Field[@Type='4330']"/>
                                    <xsl:apply-templates select="current-group()[1]/h1:Field[@Type='4165']"/>
                                    <xsl:apply-templates select="current-group()[1]/h1:Field[@Type='z001']"/>
                                    <xsl:apply-templates select="current-group()[1]/h1:Field[@Type='99fm'][starts-with(@Value, 'GND-ID:')]"/>
                                </xsl:element>
                            </xsl:for-each-group>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:result-document>
        -->
        <xsl:result-document href="../../1_0_Normdaten/1_3_Personen/hsp_TEI_Import_Personen_{descendant::h1:Document[1]/descendant::h1:Field[ @Type = 'bezsoz' ][ @Value = 'Verwaltung' ]/h1:Field[ @Type = '4564' ]/@Value}_GND-Nummern.csv" method="text" encoding="utf-8">
            <xsl:text>"MXML-Nummer";"mxml_z001";"mxml_4100";"gnd_100a+c"</xsl:text>
            <xsl:value-of select="$crlf"/>
            <xsl:for-each-group select="descendant::h1:Field[ @Type = 'bezper' ][h1:Field[ @Type = 'z001' ]][h1:Field[ @Type = '4100' ][not($listPerson//tei:persName = current()/@Value)]][document(concat('http://d-nb.info/gnd/', h1:Field[ @Type = 'z001' ]/@Value, '/about/marcxml')) != '']" group-by="h1:Field[ @Type = 'z001' ]/@Value">
                <xsl:sort select="current-grouping-key()"/>
                <xsl:text>"</xsl:text>
                <xsl:value-of select="ancestor::h1:Block[@Type='obj']/h1:Field[@Type='5000']/@Value"/>
                <xsl:text>";"</xsl:text>
                <xsl:value-of select="h1:Field[ @Type = 'z001' ]/@Value"/>
                <xsl:text>";"</xsl:text>
                <xsl:value-of select="h1:Field[@Type='4100']/@Value"/>
                <xsl:text>";"</xsl:text>
                <xsl:value-of select="document(concat('http://d-nb.info/gnd/', h1:Field[ @Type = 'z001' ]/@Value, '/about/marcxml'))//marcxml:datafield[@tag='100']/concat(marcxml:subfield[@code='a'], if (marcxml:subfield[@code='c']) then concat(' ', marcxml:subfield[@code='c']) else '', if (marcxml:subfield[@code='b']) then concat(' ', marcxml:subfield[@code='b']) else '')"/>
                <xsl:text>"</xsl:text>
                <xsl:value-of select="$crlf"/>
            </xsl:for-each-group>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="h1:Field[@Type='4100']">
        <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select=" 'default' "/>
            <xsl:value-of select="@Value"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[@Type='4105']">
        <xsl:for-each select="tokenize(@Value, '&amp;')">
            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select=" 'alternative' "/>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="h1:Field[@Type='4140']">
        <xsl:attribute name="sex" select="upper-case(@Value)"/>
    </xsl:template>
    <xsl:template match="h1:Field[@Type='4165']">
        <xsl:for-each select="tokenize(@Value, '&amp;')">
            <xsl:element name="occupation" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="h1:Field[@Type='4270']">
        <xsl:element name="birth" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:if test="matches(@Value, '\d{4}\.\d{2}\.\d{2}') and not(contains(@Value, '/'))">
                    <xsl:attribute name="when" select="translate(@Value, '.', '-')"/>
                </xsl:if>
                <xsl:value-of select="@Value"/>
            </xsl:element>
            <xsl:if test="h1:Field[@Type='4290']">
                <xsl:element name="placeName" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:value-of select="normalize-space(h1:Field[@Type='4290']/@Value)"/>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[@Type='4330']">
        <xsl:element name="death" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:if test="matches(@Value, '\d{4}\.\d{2}\.\d{2}') and not(contains(@Value, '/'))">
                    <xsl:attribute name="when" select="translate(@Value, '.X', '--')"/>
                </xsl:if>
                <xsl:value-of select="@Value"/>
            </xsl:element>
            <xsl:if test="h1:Field[@Type='4350']">
                <xsl:element name="placeName" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:value-of select="normalize-space(h1:Field[@Type='4350']/@Value)"/>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[@Type='99fm'][starts-with(@Value, 'GND-ID:')]">
        <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select=" 'gnd' "/>
            <xsl:attribute name="xml:id" select="concat('gnd_', substring-after(@Value, 'GND-ID:'))"/>
            <xsl:value-of select="concat('http://d-nb.info/gnd/', substring-after(@Value, 'GND-ID:'))"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[@Type='z001']">
        <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="xml:id" select="concat('z001_', @Value)"/>
            <xsl:choose>
                <xsl:when test="document(concat('http://d-nb.info/gnd/', @Value, '/about/marcxml')) != ''">
                    <xsl:attribute name="type" select=" 'gnd' "/>
                    <xsl:attribute name="xml:id" select="concat('gnd_', @Value)"/>
                    <xsl:value-of select="concat('http://d-nb.info/gnd/', @Value)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="type" select=" 'z001' "/>
                    <xsl:value-of select="@Value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
<!-- Felder
4007 - Relation
4010 - relatedTo
4018 - relatedTo_infoAbout
4100gi
4140
4160 - Stand
4165 - Beruf(e) (&amp;)
4180
4204
449a
449e
4500
4564
4590
4594
4596
4600
4996
8330
8334
8350 - Literatur
9900
99hs
bezsoz
z001 - PND-Nummer
z001a
z002a
z003
z020a
z029
z800
z801
z814
z814a
z814b
z814i
z816
z820
z830
-->
    
</xsl:stylesheet>