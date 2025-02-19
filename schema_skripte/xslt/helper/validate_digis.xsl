<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:h1="http://www.startext.de/HiDA/DefService/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="h1 tei xs"
    version="2.0">
    
    <xsl:variable name="crlf" select=" '&#x0A;' "/>
    <xsl:variable name="listKOD" select="doc('file:///Users/schassan/Documents/_GitHub-clones/HSP/tei-odd/nachweis_daten/catalog_KOD.xml')"/>
    <xsl:output method="text" encoding="UTF-8" indent="no"/>
    
    <xsl:template match="/">
        <xsl:for-each select="//doc">
            <xsl:variable name="institution" select="tokenize(@href, '/')[12]"/>
            <xsl:variable name="listDigis">
                <list>
                    <xsl:for-each select="document(replace(@href, '.csv', '.xml'))">
                        <xsl:for-each select="//tei:ref[@type='hsp:object']">
                            <item><xsl:value-of select="@target"/></item>
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
            <xsl:variable name="messages">
                <xsl:value-of select="concat($crlf, tokenize(@href, '/')[13])"/>
                <xsl:for-each select="$listDigis//item">
                    <xsl:if test="not($listKODs//item = current())">
                        <xsl:value-of select="concat($crlf, '   idno for digis not available in KOD list: &quot;', ., '&quot;')"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:if test="$messages != concat($crlf, tokenize(@href, '/')[13])">
                <xsl:value-of select="$messages"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
