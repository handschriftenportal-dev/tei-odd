<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:template match="node() | @* | comment() | processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="node() | @* | comment() | processing-instruction()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@Value">
        <xsl:attribute name="Value">
            <xsl:call-template name="clearFromLinks">
                <xsl:with-param name="content" select="."/>
            </xsl:call-template>
        </xsl:attribute>
    </xsl:template>

    <xsl:template name="clearFromLinks">
        <xsl:param name="content"/>
        <xsl:choose>
            <xsl:when test="contains($content, '{')">
                <xsl:value-of select="substring-before($content, '{')"/>
                <xsl:value-of select="substring-before(substring-after(substring-after($content, '{'), '?u '), '}')"/>
                <xsl:call-template name="clearFromLinks">
                    <xsl:with-param name="content" select="substring-after($content, '}')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$content"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>