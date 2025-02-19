<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:h1="http://www.startext.de/HiDA/DefService/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="h1 tei xs"
    version="2.0">
    
    <xsl:variable name="crlf" select=" '&#x0A;' "/>
    <xsl:variable name="listKOD" select="doc('../../../nachweis_daten/catalog_KOD.xml')"/>
    <xsl:output method="text" encoding="UTF-8" indent="no"/>
    
    <!-- 
    <xsl:variable name="listKOD" select="collection('../nachweis_daten/3_0_Produktion/?select=01_*.xml;recurse=yes')"/>
    <xsl:key name="idnos" match="$listKOD//tei:msIdentifier" use="concat(tei:settlement, ', ', tei:repository, ', ', tei:idno)" />
    
    <xsl:template match="/">
        <xsl:for-each select="//doc">
            <xsl:for-each select="document(replace(@href, '.csv', '.xml'))">
                <xsl:for-each select="//h1:Block[@Type='obj']/h1:Field[@Type='bezsoz'][@Value='Verwaltung']">
                    <xsl:if test="not(key('idnos', concat(h1:Field[@Type='4650']/@Value))">
                    </xsl:if>
                        <xsl:value-of select="concat($crlf, 
                            '   idno &quot;', @Value, '&quot; not available in KOD list ', )"/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    -->
    
    <!-- 
    <xsl:key name="colors" match="/root/Colors/Color" use="@Name" />
    <xsl:template match="/root/Words/Element[key('colors', .)]">
          <xsl:value-of select="." />
    </xsl:template>
    -->
    
    <xsl:template match="/">
        <xsl:for-each select="//doc">
            <xsl:variable name="institution" select="tokenize(@href, '/')[12]"/>
            <xsl:variable name="listDesc">
                <list>
                    <xsl:for-each select="document(replace(@href, '.csv', '.xml'))">
                        <xsl:for-each select="//h1:Block[@Type='obj']/h1:Field[@Type='bezsoz'][@Value='Verwaltung']/h1:Field[@Type='4650']/@Value">
                            <item><xsl:value-of select="."/></item>
                        </xsl:for-each>
                    </xsl:for-each>
                </list>
            </xsl:variable>
            <xsl:variable name="listOrgID">
                <list>
                    <xsl:for-each select="document(replace(@href, '.csv', '.xml'))">
                        <xsl:for-each select="distinct-values(//h1:Block[@Type='obj']/h1:Field[@Type='bezsoz'][@Value='Verwaltung'][h1:Field[@Type='4502norm']]/h1:Field[@Type='4502norm']/@Value)">
                            <item><xsl:value-of select="."/></item>
                        </xsl:for-each>
                    </xsl:for-each>
                </list>
            </xsl:variable>
            <xsl:variable name="listKODs">
                <list>
                    <xsl:for-each select="document($listKOD//doc[contains(@href, $institution)]/replace(@href, '.csv', '.xml'))">
                        <xsl:for-each select="//tei:msDesc/tei:msIdentifier/descendant::tei:idno">
                            <item><xsl:value-of select="."/></item>
                        </xsl:for-each>
                    </xsl:for-each>
                </list>
            </xsl:variable>
            <xsl:variable name="listKODOrgIDs">
                <list>
                    <xsl:for-each select="document($listKOD//doc[contains(@href, $institution)]/replace(@href, '.csv', '.xml'))">
                        <xsl:for-each select="distinct-values(//tei:msDesc/tei:msIdentifier/tei:repository/@key)">
                            <item><xsl:value-of select="."/></item>
                        </xsl:for-each>
                    </xsl:for-each>
                </list>
            </xsl:variable>
            <xsl:variable name="messages">
                <xsl:value-of select="concat($crlf, tokenize(@href, '/')[13])"/>
                <xsl:for-each select="$listDesc//item">
                    <xsl:if test="not($listKODs//item = current())">
                        <xsl:value-of select="concat($crlf, '   idno not available in KOD list: &quot;', ., '&quot;')"/></xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$listOrgID//item">
                    <xsl:if test="not($listKODOrgIDs//item = current())">
                        <xsl:value-of select="concat($crlf, '   GND not identical with the one in KOD list: &quot;', ., '&quot;')"/></xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:if test="$messages != concat($crlf, tokenize(@href, '/')[13])">
                <xsl:value-of select="$messages"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
