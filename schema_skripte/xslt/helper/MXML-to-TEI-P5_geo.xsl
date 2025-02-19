<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:h1="http://www.startext.de/HiDA/DefService/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="h1 tei xs"
    version="2.0">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:key name="place-ref" match="h1:Field[ @Type = '2050' ]" use="@Value"/>
    <xsl:variable name="principal-root" select="/"/>
    
    <xsl:template match="/">
        <xsl:element name="TEI" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="teiHeader" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="fileDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="titleStmt" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">Normdaten Geographica</xsl:element>
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
                    <xsl:element name="listPlace" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:apply-templates select="//h1:Block[ @Type = 'geo' ]
                            [h1:Field[ @Type = '219a' ][ @Value = 'GND-GEO-Nummer' ]
                            [h1:Field[@Type = '219e'][@Value != 'nicht vorhanden']]]">
                            <xsl:sort select="h1:Field[ @Type = '2055' ]/@Value"/>
                            <xsl:sort select="h1:Field[ @Type = '2050' ]/@Value"/>
                        </xsl:apply-templates>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>

        <!-- ========= Relationen ========== -->
        <xsl:result-document href="hsp_TEI_Import_Relationen-geo.xml" method="xml" encoding="UTF-8" indent="yes">
            <xsl:element name="TEI" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="teiHeader" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="fileDesc" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="titleStmt" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">Relationen Geographica</xsl:element>
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
                                    <xsl:for-each select="//h1:Block[ @Type = 'geo' ]
                                        [h1:Field[ @Type = '219a' ][ @Value = 'GND-GEO-Nummer' ]
                                        [h1:Field[@Type = '219e'][@Value != 'nicht vorhanden']]]
                                        [h1:Field[ @Type = '2055' ][ (@Value = 'Ort') or (@Value = 'Landschaft') ]]">
                                        <xsl:sort select="h1:Field[ @Type = '2055' ]/@Value"/>
                                        <xsl:sort select="h1:Field[ @Type = '2050' ]/@Value"/>">
                                        <xsl:element name="item">
                                            <xsl:element name="placeName"><xsl:value-of select="h1:Field[ @Type = '2050' ]/@Value"/></xsl:element>
                                            <xsl:element name="idno"><xsl:value-of select="h1:Field[ @Type = '219a' ][ @Value = 'GND-GEO-Nummer' ]/h1:Field[ @Type = '219e' ]/@Value"/></xsl:element>
                                            <xsl:for-each select="tokenize(h1:Field[ @Type = '2154' ]/@Value, '&amp;')">
                                                <xsl:element name="relation">
                                                    <xsl:value-of select="$principal-root//h1:Block[ @Type = 'geo' ]
                                                        [ h1:Field[ @Type = '2050' ][ @Value = normalize-space(current()) ]]/h1:Field[ @Type = '219a' ][ @Value = 'GND-GEO-Nummer' ]/h1:Field[ @Type = '219e']/@Value"/>
                                                </xsl:element>
                                            </xsl:for-each>
                                            <xsl:if test="h1:Field[ @Type = '2190' ] and $principal-root//h1:Block
                                                [ @Type = 'geo' ]
                                                [ h1:Field[ @Type = '2050' ]
                                                    [ @Value = current()/h1:Field[ @Type = '2190' ]/@Value ]
                                                    [ h1:Field[ @Type = '219a' ][ @Value = 'GND-GEO-Nummer' ]]
                                                ]/h1:Field[ @Type = '219a' ][ @Value = 'GND-GEO-Nummer' ]/h1:Field[ @Type = '219e']/@Value">
                                                <xsl:element name="relation">
                                                    <xsl:value-of select="$principal-root//h1:Block[ @Type = 'geo' ]
                                                        [ h1:Field[ @Type = '2050' ][ @Value = current()/h1:Field[ @Type = '2190' ]/@Value ]]/h1:Field[ @Type = '219a' ][ @Value = 'GND-GEO-Nummer' ]/h1:Field[ @Type = '219e']/@Value"/>
                                                </xsl:element>
                                            </xsl:if>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:variable>
                            
                            <xsl:for-each select="$tempList//relation">
                                <xsl:element name="relation" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="type" select=" 'schema' "/>
                                    <xsl:attribute name="name" select=" 'containedInPlace' "/>
                                    <xsl:attribute name="active" select="concat('place_gnd_', preceding-sibling::idno)"/>
                                    <xsl:attribute name="passive" select="concat('place_gnd_', .)"/>
                                    <xsl:attribute name="xml:id" select=" concat('containedInPlace_', preceding-sibling::idno, '_', .) "/>
                                </xsl:element>
                            </xsl:for-each>
                            
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="*"/>
    
    <xsl:template match="h1:Block[ @Type = 'geo' ]">
        <xsl:variable name="active" select="concat('place_gnd_', h1:Field[ @Type = '219a' ][ @Value = 'GND-GEO-Nummer' ]/h1:Field[ @Type = '219e']/@Value)"/>
        <xsl:variable name="apos">'</xsl:variable>
        <xsl:element name="place" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="xml:id" select="$active"/>
            <xsl:choose>
                <xsl:when test="h1:Field[ @Type = '2055' ][ @Value = 'Ort' ]">
                    <xsl:attribute name="type" select=" 'city' "/>
                </xsl:when>
                <xsl:when test="h1:Field[ @Type = '2055' ][ @Value = 'Land' ]">
                    <xsl:attribute name="type" select=" 'country' "/>
                </xsl:when>
                <xsl:when test="h1:Field[ @Type = '2055' ][ @Value = 'Landschaft' ]">
                    <xsl:attribute name="type" select=" 'region' "/>
                </xsl:when>
            </xsl:choose>
            
            <xsl:apply-templates/>
            
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="h1:Field[ @Type = '2050' ]">
        <xsl:element name="placeName" namespace="http://www.tei-c.org/ns/1.0">
            <!--<xsl:attribute name="xml:lang" select=" 'de' "/>-->
            <xsl:attribute name="type" select=" 'default' "/>
            <xsl:value-of select="normalize-space(@Value)"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '2050a' ]">
        <xsl:choose>
            <xsl:when test="contains(@Value, '&amp;')">
                <xsl:for-each select="tokenize(@Value, '&amp;')">
                    <xsl:element name="placeName" namespace="http://www.tei-c.org/ns/1.0">
                        <!--<xsl:attribute name="xml:lang" select=" 'de' "/>-->
                        <xsl:attribute name="type" select=" 'alternative' "/>
                        <xsl:value-of select="normalize-space(.)"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="placeName" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="xml:lang" select=" 'de' "/>
                    <xsl:attribute name="type" select=" 'alternative' "/>
                    <xsl:value-of select="normalize-space(@Value)"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="h1:Field[ @Type = '219a' ][ @Value = 'GND-GEO-Nummer' ]">
        <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:choose>
                <xsl:when test=" @Value = 'GND-GEO-Nummer' ">
                    <xsl:attribute name="type" select=" 'gnd' "/>
                    <xsl:attribute name="xml:id" select="concat('gnd_', h1:Field[ @Type = '219e' ]/@Value)"/>
                    <xsl:value-of select="concat('http://d-nb.info/gnd/', h1:Field[ @Type = '219e' ]/@Value)"/>
                </xsl:when>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
