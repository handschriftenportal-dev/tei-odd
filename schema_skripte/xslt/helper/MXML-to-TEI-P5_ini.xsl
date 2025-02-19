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
    <xsl:variable name="crlf" select=" '&#x000A;' "/>
    <xsl:variable name="descriptions">
        <xsl:for-each select="doc(//doc/@href"></xsl:for-each>
    </xsl:variable>
    <!--  select="collection('../nachweis_daten/3_0_Produktion?select=*.xml;recurse=yes')" -->
    <!--<xsl:variable name="listIni" select="document('../nachweis_daten/1_0_Normdaten/hsp_TEI_Import_Initien.xml')"/>-->
    
    <xsl:template match="/">
        <!-- ========== TEI list ========== -->
        <xsl:result-document href="../nachweis_daten/1_0_Normdaten/hsp_TEI_Import_Initien_neu.xml">
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
                                <xsl:text>Automatisch generierte Initienliste</xsl:text>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="publicationStmt" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:element name="publisher" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:text>Handschriftenportal</xsl:text>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="text" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="body" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="list" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'initien' "/>
                            <!-- 5666d -->
                            <xsl:for-each-group select="descendant::h1:Field[ @Type = '5650' ][ @Value = 'Initium' ][h1:Field[ @Type = '5666d' ]]" group-by="h1:Field[ @Type = '5666d' ]/@Value">
                                <xsl:sort select="current-grouping-key()"/>
                                <xsl:element name="item" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="xml:lang" select=" 'de' "/>
                                    <xsl:value-of select="current-grouping-key()"/>
                                </xsl:element>
                            </xsl:for-each-group>
                            <!-- 5666g -->
                            <xsl:for-each-group select="descendant::h1:Field[ @Type = '5650' ][ @Value = 'Initium' ][h1:Field[ @Type = '5666g' ]]" group-by="h1:Field[ @Type = '5666g' ]/@Value">
                                <xsl:sort select="current-grouping-key()"/>
                                <xsl:element name="item" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="xml:lang" select=" 'grc' "/>
                                    <xsl:value-of select="current-grouping-key()"/>
                                </xsl:element>
                            </xsl:for-each-group>
                            <!-- 5666l -->
                            <xsl:for-each-group select="descendant::h1:Field[ @Type = '5650' ][ @Value = 'Initium' ][h1:Field[ @Type = '5666l' ]]" group-by="h1:Field[ @Type = '5666l' ]/@Value">
                                <xsl:sort select="current-grouping-key()"/>
                                <xsl:element name="item" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="xml:lang" select=" 'la' "/>
                                    <xsl:value-of select="current-grouping-key()"/>
                                </xsl:element>
                            </xsl:for-each-group>
                            <!-- 5666v -->
                            <xsl:for-each-group select="descendant::h1:Field[ @Type = '5650' ][ @Value = 'Initium' ][h1:Field[ @Type = '5666v' ]]" group-by="h1:Field[ @Type = '5666v' ]/@Value">
                                <xsl:sort select="current-grouping-key()"/>
                                <xsl:element name="item" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:value-of select="current-grouping-key()"/>
                                </xsl:element>
                            </xsl:for-each-group>
                            <!-- Block/1800 -->
                            <xsl:for-each-group select="descendant::h1:Block[h1:Field[ @Type = '5230' ][ contains(@Value, 'Initium') ]][h1:Field[ @Type = '1800' ]]" group-by="h1:Field[ @Type = '1800' ]/@Value">
                                <xsl:sort select="current-grouping-key()"/>
                                <xsl:element name="item" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="xml:lang" select=" 'la' "/>
                                    <xsl:value-of select="current-grouping-key()"/>
                                </xsl:element>
                            </xsl:for-each-group>
                            <!-- Block/1802 -->
                            <xsl:for-each-group select="descendant::h1:Block[h1:Field[ @Type = '5230' ][ contains(@Value, 'Initium') ]][h1:Field[ @Type = '1802' ]]" group-by="h1:Field[ @Type = '1802' ]/@Value">
                                <xsl:sort select="current-grouping-key()"/>
                                <xsl:element name="item" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="xml:lang" select=" 'de' "/>
                                    <xsl:value-of select="current-grouping-key()"/>
                                </xsl:element>
                            </xsl:for-each-group>
                            <!-- Block/1804 -->
                            <xsl:for-each-group select="descendant::h1:Block[h1:Field[ @Type = '5230' ][ contains(@Value, 'Initium') ]][h1:Field[ @Type = '1804' ]]" group-by="h1:Field[ @Type = '1804' ]/@Value">
                                <xsl:sort select="current-grouping-key()"/>
                                <xsl:element name="item" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:value-of select="current-grouping-key()"/>
                                </xsl:element>
                            </xsl:for-each-group>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="h1:Field[@Type='4100']">
        <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select=" 'default' "/>
            <xsl:value-of select="@Value"/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>