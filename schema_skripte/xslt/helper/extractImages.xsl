<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:h1="http://www.startext.de/HiDA/DefService/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <xsl:template match="node() | @* | comment() | processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="node() | @* | comment() | processing-instruction()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="h1:Field[ starts-with(@Type, 'par') ][ contains(@Value, '\\pict') ]">
        <xsl:copy>
            <xsl:apply-templates select="@Type"/>
            <xsl:attribute name="Value">
                <xsl:call-template name="extractImages"/>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="extractImages">
        <xsl:variable name="computeFilename">
            <xsl:for-each select="ancestor::h1:Block">
                <xsl:number/>
                <xsl:text>_</xsl:text>
            </xsl:for-each>
            <xsl:value-of select="@Type"/>
            <xsl:value-of select=""/>
        </xsl:variable>
        <xsl:result-document href="{$computeFilename}">
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>