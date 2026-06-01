<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="tei xs"
    version="2.0">
    
    <xsl:template match="node() | @*">
        <xsl:copy><xsl:apply-templates select="node() | @*"/></xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:ref[@type='thumbnail']">
        <xsl:copy>
            <xsl:copy-of select="@type"/>
            <xsl:attribute name="target">
                <xsl:variable name="webpage" select="unparsed-text(@target)" as="xs:string"/>
                <xsl:choose>
                    <xsl:when test="starts-with(@target, 'http://digital.slub-dresden.de')">
                        <xsl:value-of select="concat(substring-before(substring-after($webpage, '&lt;a class=&quot;download-page image&quot; title=&quot;Einzelseite als Bild herunterladen (JPG)&quot; target=&quot;_blank&quot; href=&quot;'), 'original.jpg&quot;'), 'thumbnail.jpg')"/>
                    </xsl:when>
                    <xsl:when test="starts-with(@target, 'https://digital.slub-dresden.de') and ends-with(@target, '.jpg')">
                        <xsl:copy-of select="@target"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>