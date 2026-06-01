<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:h1="http://www.startext.de/HiDA/DefService/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="h1 tei xs"
    version="2.0">
    
    <xsl:variable name="listPlace" select="document('../../../nachweis_daten/1_0_Normdaten/hsp_TEI_Import_Orte.xml')"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/">
        <xsl:element name="TEI" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="teiHeader" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="fileDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="titleStmt" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">Normdaten Organization</xsl:element>
                    </xsl:element>
                    <xsl:element name="publicationStmt" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="publisher" namespace="http://www.tei-c.org/ns/1.0">Handschriftenportal</xsl:element>
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
                    <xsl:element name="listOrg" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:apply-templates select="//h1:Block[ @Type = 'soz' ]
                            [not(starts-with(h1:Field[ @Type = '4600' ]/@Value, 'ZU LÖSCHEN'))]
                            [
                            h1:Field[ @Type = '499a' ][ @Value = 'GND-Nummer' ][h1:Field[ @Type = '499e' ][ not(contains(@Value, ' (')) and not(contains(@Value, '...')) ]] or
                            h1:Field[ @Type = '499a' ][ @Value = 'ISIL-Sigle' ][h1:Field[ @Type = '499e' ][ not(contains(@Value, ' (')) and not(contains(@Value, '...')) ]]
                            ]
                            [$listPlace//tei:placeName = h1:Field[ @Type = '4564' ]/@Value]"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
        <!-- ========= Relationen ========== -->
        <xsl:result-document href="hsp_TEI_Import_Relationen-soz.xml" method="xml" encoding="UTF-8" indent="yes">
            <xsl:element name="TEI" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="teiHeader" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="fileDesc" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="titleStmt" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">Relationen Körperschaften</xsl:element>
                        </xsl:element>
                        <xsl:element name="publicationStmt" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">Publication Information</xsl:element>
                        </xsl:element>
                        <xsl:element name="sourceDesc" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">Information about the source</xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="text" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="body" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="listRelation" namespace="http://www.tei-c.org/ns/1.0">
                            
                            <xsl:variable name="tempList">
                                <xsl:element name="list">

                                    <xsl:for-each select="//h1:Block[ @Type = 'soz' ]
                                        [not(starts-with(h1:Field[ @Type = '4600' ]/@Value, 'ZU LÖSCHEN'))]
                                        [
                                        h1:Field[ @Type = '499a' ][ @Value = 'GND-Nummer' ][h1:Field[ @Type = '499e' ][ not(contains(@Value, ' (')) and not(contains(@Value, '...')) ]] or
                                        h1:Field[ @Type = '499a' ][ @Value = 'ISIL-Sigle' ][h1:Field[ @Type = '499e' ][ not(contains(@Value, ' (')) and not(contains(@Value, '...')) ]]
                                        ]
                                        [$listPlace//tei:placeName = h1:Field[ @Type = '4564' ]/@Value]">

                                        <xsl:element name="item">
                                            <xsl:element name="orgName"><xsl:value-of select="h1:Field[ @Type = '4600' ]/@Value"/></xsl:element>
                                            <xsl:element name="idno"><xsl:value-of select="concat('soz_', h1:Field[ @Type = '4500' ]/@Value)"/></xsl:element>
                                            <xsl:for-each select="tokenize(h1:Field[ @Type = '4564' ]/@Value, '&amp;')">
                                                <xsl:element name="relation">
                                                    <xsl:value-of select="substring-after($listPlace//tei:place[ tei:placeName = normalize-space(current()) ]/tei:idno, 'http://d-nb.info/gnd/')"/>
                                                </xsl:element>
                                            </xsl:for-each>
                                            <xsl:if test="h1:Field[ @Type = '2154'] 
                                                and h1:Field[ @Type = '2154'][ current()/@Value != preceding-sibling::h1:Field[ @Type = '4564']/@Value ]">
                                                <xsl:element name="relation">
                                                    <xsl:value-of select="substring-after($listPlace//tei:place[ tei:placeName = h1:Field[ @Type = '2154']/@Value ]/tei:idno, 'http://d-nb.info/gnd/')"/>
                                                </xsl:element>
                                            </xsl:if>
                                            
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:variable>
                                        
                            <xsl:for-each select="$tempList//relation">
                                <xsl:element name="relation" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="type" select=" 'schema' "/>
                                    <xsl:attribute name="name" select=" 'location' "/>
                                    <xsl:attribute name="active" select=" preceding-sibling::idno "/>
                                    <xsl:attribute name="passive" select="concat('place_gnd_', .)"/>
                                    <xsl:attribute name="xml:id" select=" concat('location_', preceding-sibling::idno, '_', .) "/>
                                </xsl:element>
                                <xsl:element name="relation" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="type" select=" 'schema' "/>
                                    <xsl:attribute name="name" select=" 'areaServed' "/>
                                    <xsl:attribute name="active" select=" preceding-sibling::idno "/>
                                    <xsl:attribute name="passive" select="concat('place_gnd_', .)"/>
                                    <xsl:attribute name="xml:id" select=" concat('areaServed_', preceding-sibling::idno, '_', .) "/>
                                </xsl:element>
                            </xsl:for-each>
                            
                            <!--
                                <xsl:if test="h1:Field[ @Type = '2154'] 
                                    and h1:Field[ @Type = '2154'][ current()/@Value != preceding-sibling::h1:Field[ @Type = '4564']/@Value ]">
                                    <xsl:element name="relation" namespace="http://www.tei-c.org/ns/1.0">
                                        <xsl:attribute name="type" select=" 'schema' "/>
                                        <xsl:attribute name="name" select=" 'location' "/>
                                        <xsl:attribute name="active" select="concat('soz_', h1:Field[ @Type = '4500']/@Value)"/>
                                        <xsl:attribute name="passive" select="h1:Field[ @Type = '2154']/@Value"/>
                                        <xsl:attribute name="xml:id" select="concat('location_', concat('soz_', h1:Field[ @Type = '4500']/@Value), '_', translate(h1:Field[ @Type = '2154']/@Value, ' /()&lt;&gt;&amp;,\.', '-\-'))"/>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:element name="relation" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="type" select=" 'schema' "/>
                                    <xsl:attribute name="name" select=" 'areaServed' "/>
                                    <xsl:attribute name="active" select="concat('soz_', h1:Field[ @Type = '4500']/@Value)"/>
                                    <xsl:attribute name="passive" select="h1:Field[ @Type = '4564' ]/(if (contains(@Value, '&amp;')) then translate(normalize-space(substring-before(@Value, '&amp;')), ' /()&lt;&gt;,\.', '-\-') else translate(@Value, ' /()&lt;&gt;,\.', '-\-'))"/>
                                    <xsl:attribute name="xml:id" select="translate(concat('areaServed_', concat('soz_', h1:Field[ @Type = '4500']/@Value), '_', h1:Field[ @Type = '4564' ]/(if (contains(@Value, '&amp;')) then normalize-space(substring-before(@Value, '&amp;')) else @Value)), ' /()&lt;&gt;,\.', '-\-')"/>
                                </xsl:element>
                                <xsl:if test="contains(h1:Field[ @Type = '4564' ]/@Value, '&amp;')">
                                    <xsl:message><xsl:value-of select="concat('###', h1:Field[ @Type = '4564' ]/normalize-space(substring-after(@Value, '&amp;')), '***')"/></xsl:message>
                                    <xsl:call-template name="writeRelations">
                                        <xsl:with-param name="name" select=" 'areaServed' "/>
                                        <xsl:with-param name="active" select="concat('soz_', h1:Field[ @Type = '4500']/@Value)"/>
                                        <xsl:with-param name="passive" select="h1:Field[ @Type = '4564' ]/normalize-space(substring-after(@Value, '&amp;'))"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>-->
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="*"/>
    
    <xsl:template match="h1:Block[ @Type = 'soz' ]
        [not(starts-with(h1:Field[ @Type = '4600' ]/@Value, 'ZU LÖSCHEN'))]
        [
        h1:Field[ @Type = '499a' ][ @Value = 'GND-Nummer' ][h1:Field[ @Type = '499e' ][ not(contains(@Value, ' (')) and not(contains(@Value, '...')) ]] or
        h1:Field[ @Type = '499a' ][ @Value = 'ISIL-Sigle' ][h1:Field[ @Type = '499e' ][ not(contains(@Value, ' (')) and not(contains(@Value, '...')) ]]
        ]
        [$listPlace//tei:placeName = h1:Field[ @Type = '4564' ]/@Value]">
        <xsl:element name="org" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="xml:id" select="concat('soz_', h1:Field[ @Type = '4500']/@Value)"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="h1:Field[ @Type = '4600' ]">
        <xsl:element name="orgName" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="xml:lang" select=" 'de' "/>
            <xsl:attribute name="type" select=" 'default' "/>
            <xsl:value-of select="@Value"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '4602' ]">
        <xsl:choose>
            <xsl:when test="contains(@Value, '&amp;')">
                <xsl:for-each select="tokenize(@Value, '&amp;')">
                    <xsl:element name="orgName" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:choose>
                            <xsl:when test="contains(., '(Abkürzung)')">
                                <xsl:attribute name="type" select=" 'alternative' "/>
                                <xsl:attribute name="subtype" select=" 'short' "/>
                                <xsl:value-of select="normalize-space(substring-before(., ' (Abkürzung)'))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!--<xsl:attribute name="xml:lang" select=" 'de' "/>-->
                                <xsl:attribute name="type" select=" 'alternative' "/>
                                <xsl:value-of select="normalize-space(.)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="contains(@Value, ' / ')">
                <xsl:for-each select="tokenize(@Value, ' / ')">
                    <xsl:element name="orgName" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:choose>
                            <xsl:when test="contains(., '(Abkürzung)')">
                                <xsl:attribute name="type" select=" 'alternative' "/>
                                <xsl:attribute name="subtype" select=" 'short' "/>
                                <xsl:value-of select="substring-before(., ' (Abkürzung)')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!--<xsl:attribute name="xml:lang" select=" 'de' "/>-->
                                <xsl:attribute name="type" select=" 'alternative' "/>
                                <xsl:value-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="orgName" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="xml:lang" select=" 'de' "/>
                    <xsl:attribute name="type" select=" 'alternative' "/>
                    <xsl:value-of select="@Value"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Art der Beziehung:
        Aktuelle Verwaltung
        Vorgänger
        Provenienz
        Nachfolger
        Verwaltung
        Vorbesitz
        Beziehung
    -->
    <xsl:template match="h1:Field[ @Type = '4507' ][ @Value = 'Vorgänger' ]">
        <xsl:choose>
            <xsl:when test="contains(h1:Field[ @Type = '4510' ]/@Value, ' / ')">
                <xsl:for-each select="tokenize(h1:Field[ @Type = '4510' ]/@Value, ' / ')">
                    <xsl:element name="orgName" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="xml:lang" select=" 'de' "/>
                        <xsl:attribute name="type" select=" 'former' "/>
                        <xsl:value-of select="."/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="orgName" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="xml:lang" select=" 'de' "/>
                    <xsl:attribute name="type" select=" 'former' "/>
                    <xsl:value-of select="h1:Field[ @Type = '4510' ]/@Value"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
        <!--<xsl:apply-templates select="h1:Field[ @Type = '459t' ][starts-with(@Value, 'GND-Nummer')]"/>-->
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '459t' ][starts-with(@Value, 'GND-Nummer')]">
        <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:choose>
                <xsl:when test="starts-with(@Value, 'GND-Nummer')">
                    <xsl:attribute name="type" select=" 'gnd_former' "/>
                    <xsl:attribute name="xml:id" select="concat('gnd_', substring-after(@Value, 'GND-Nummer: '))"/>
                    <xsl:value-of select="concat('http://d-nb.info/gnd/', substring-after(@Value, 'GND-Nummer: '))"/>
                </xsl:when>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '499a' ][ (@Value = 'GND-Nummer') or (@Value = 'ISIL-Sigle') ]
        [h1:Field[ @Type = '499e' ][ not(contains(@Value, ' (')) and not(contains(@Value, '...')) and not(@Value = 'nicht vorhanden') ]]">
        <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:choose>
                <xsl:when test="@Value = 'GND-Nummer' and h1:Field[ @Type = '499e' ][ @Value = 'nicht vorhanden' ]"/>
                <xsl:when test="@Value = 'GND-Nummer' ">
                    <xsl:attribute name="type" select=" 'gnd' "/>
                    <xsl:attribute name="xml:id" select="concat('gnd_', h1:Field[ @Type = '499e' ]/@Value)"/>
                    <xsl:value-of select="concat('http://d-nb.info/gnd/', h1:Field[ @Type = '499e' ]/@Value)"/>
                </xsl:when>
                <xsl:when test="@Value = 'ISIL-Sigle' and h1:Field[ @Type = '499e' ][ @Value = 'nicht vorhanden' ]"/>
                <xsl:when test="@Value = 'ISIL-Sigle' ">
                    <xsl:attribute name="type" select=" 'isil' "/>
                    <xsl:attribute name="xml:id" select="concat('isil_', h1:Field[ @Type = '499e' ]/@Value)"/>
                    <xsl:value-of select="concat('http://sigel.staatsbibliothek-berlin.de/suche/?isil=', h1:Field[ @Type = '499e' ]/@Value)"/>
                </xsl:when>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '499a' ][ (@Value = 'GND-Ansetzung') ]
        [h1:Field[ @Type = '499e' ]/@Value != preceding-sibling::h1:Field[ @Type = '4600' ]/@Value]">
        <xsl:element name="orgName" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="xml:lang" select=" 'de' "/>
            <xsl:attribute name="type" select=" 'alternative' "/>
            <xsl:value-of select="h1:Field[ @Type = '499e' ]/@Value"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="writeRelations">
        <xsl:param name="active"/>
        <xsl:param name="passive"/>
        <xsl:param name="name"/>
        <xsl:variable name="apos">'</xsl:variable>
        <xsl:element name="relation" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select=" 'schema' "/>
            <xsl:attribute name="name" select="$name"/>
            <xsl:attribute name="active" select="$active"/>
            <xsl:attribute name="passive" select="if (contains($passive, '&amp;')) then translate(normalize-space(substring-before($passive, '&amp;')), ' /()&lt;&gt;,\.', '--') else translate($passive, ' /()&lt;&gt;,\.', '--')"/>
            <xsl:attribute name="xml:id" select="translate(concat($name, '_', $active, '_', if (contains($passive, '&amp;')) then normalize-space(substring-before($passive, '&amp;')) else $passive), concat(' /()&lt;&gt;&amp;,\.', $apos), '--')"/>
        </xsl:element>
        <xsl:if test="contains($passive, '&amp;')">
            <xsl:call-template name="writeRelations">
                <xsl:with-param name="name" select="$name"/>
                <xsl:with-param name="active" select="$active"/>
                <xsl:with-param name="passive" select="normalize-space(substring-after($passive, '&amp;'))"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
