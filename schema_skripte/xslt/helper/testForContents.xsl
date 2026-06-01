<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="tei xs"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <xsl:template match="/">
        <xsl:element name="result">
            <xsl:for-each select="descendant::tei:*">
                <xsl:sort select="name()"/>
                <xsl:sort select="@type"/>
                <xsl:sort select="@n"/>
                <xsl:sort select="@role"/>
                <xsl:sort select="@ref"/>
                <xsl:sort select="@indexName"/>
                <xsl:sort select="."/>
                <xsl:value-of select=" '&#x0A;' "/>
                <xsl:element name="{local-name()}">
                    <xsl:for-each select="@*">
                        <xsl:sort/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:variable name="content">
                        <xsl:for-each select="text()"><xsl:copy-of select="."/></xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="normalize-space($content)"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>