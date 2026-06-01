<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="tei xs"
    version="2.0">
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>  
    </xsl:template>
    
    <xsl:template match="tei:settlement | tei:repository">
        <xsl:copy>
            <xsl:apply-templates select="@*[not(name() = 'ref')]"/>
            <xsl:choose>
                <xsl:when test="starts-with(@ref, 'http')">
                    <xsl:copy-of select="@ref"/>
                </xsl:when>
                <xsl:when test="matches(@ref, '[\dX\-]+')">
                    <xsl:copy>
                        <xsl:value-of select="concat('https://d-nb.info/gnd/', @ref)"/>
                    </xsl:copy>
                </xsl:when>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>