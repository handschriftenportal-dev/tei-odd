<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:h1="http://www.startext.de/HiDA/DefService/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="h1 tei xs"
    version="2.0">
    
    <xsl:variable name="crlf" select=" '&#x0A;' "/>
    <xsl:output method="text" encoding="UTF-8" indent="no"/>
    <xsl:variable name="listPlace" select="document('../../../nachweis_daten/1_0_Normdaten/hsp_TEI_Import_Orte.xml')"/>
    <xsl:variable name="listOrg" select="document('../../../nachweis_daten/1_0_Normdaten/hsp_TEI_Import_Koerperschaften.xml')"/>
    
    <xsl:template match="/">
        <xsl:for-each select="//doc">
            <xsl:variable name="listPlaceDesc">
                <list>
                    <xsl:for-each select="document(replace(@href, '.csv', '.xml'))">
                        <xsl:for-each select="distinct-values(//h1:Block[@Type='obj']/h1:Field[@Type='bezsoz'][@Value='Verwaltung']/h1:Field[@Type='4564']/@Value)">
                            <item><xsl:value-of select="."/></item>
                        </xsl:for-each>
                    </xsl:for-each>
                </list>
            </xsl:variable>
            <xsl:variable name="listOrgDesc">
                <list>
                    <xsl:for-each select="document(replace(@href, '.csv', '.xml'))">
                        <xsl:for-each select="distinct-values(//h1:Block[@Type='obj']/h1:Field[@Type='bezsoz'][@Value='Verwaltung']/h1:Field[@Type='4600']/@Value)">
                            <item><xsl:value-of select="."/></item>
                        </xsl:for-each>
                    </xsl:for-each>
                </list>
            </xsl:variable>
            <xsl:variable name="listNoOrgID">
                <list>
                    <xsl:for-each select="document(replace(@href, '.csv', '.xml'))">
                        <xsl:for-each select="//h1:Block[@Type='obj']/h1:Field[@Type='bezsoz'][@Value='Verwaltung'][not(h1:Field[@Type='4502norm'])]/h1:Field[@Type='4650']/@Value">
                            <item><xsl:value-of select="."/></item>
                        </xsl:for-each>
                    </xsl:for-each>
                </list>
            </xsl:variable>
            <xsl:variable name="messages">
                <xsl:value-of select="concat($crlf, tokenize(@href, '/')[13])"/>
                <xsl:for-each select="$listPlaceDesc//item">
                    <xsl:if test="not($listPlace//tei:placeName = current())">
                        <xsl:value-of select="concat($crlf, '   place not available in normdata file: &quot;', ., '&quot;')"/></xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$listOrgDesc//item">
                    <xsl:if test="not($listOrg//tei:orgName = current())">
                        <xsl:value-of select="concat($crlf, '   org not available in normdata file: &quot;', ., '&quot;')"/></xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$listNoOrgID//item">
                    <xsl:value-of select="concat($crlf, '   no org ID available for: &quot;', ., '&quot;')"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:if test="$messages != concat($crlf, tokenize(@href, '/')[13])">
                <xsl:value-of select="$messages"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
