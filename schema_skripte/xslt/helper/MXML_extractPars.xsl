<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:h1="http://www.startext.de/HiDA/DefService/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:import href="../MXML2TEI/extractPars.xsl"/>
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:param name="mode"/>
    
    <xsl:template name="main" match="/">
        <xsl:for-each select="//doc/@href">
            <xsl:variable name="contents" select="doc(.)"/>
            <xsl:variable name="institution" select="tokenize(., '/')[12]"/>
            <xsl:variable name="file" select="substring-before(tokenize(., '/')[13], '.xml')"/>
            <xsl:for-each select="$contents//descendant::h1:Field[starts-with(@Type, 'par')][@Value and @Value != '']">
                <xsl:variable name="constructName">
                    <xsl:for-each select="ancestor-or-self::h1:Block">
                        <xsl:if test="parent::h1:Block">_</xsl:if>
                        <xsl:value-of select="h1:Field[ (@Type = '5000') or (@Type = '5001') or (@Type = '5002') or (@Type = '5003') or (@Type = '5004') ]/@Value"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:result-document href="../nachweis_daten/_par-files/{$institution}/{$file}_{$constructName}_{@Type}.rtf" encoding="UTF-8" method="text">
                    <xsl:value-of select="@Value"/>
                </xsl:result-document>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>