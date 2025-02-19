<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:h1="http://www.startext.de/HiDA/DefService/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!--<xsl:variable name="descriptions" select="collection('../nachweis_daten/3_0_Produktion/?select=02_*.xml;recurse=yes')"/>-->
    <xsl:variable name="crlf" select=" '&#x0A;' "/>
    <xsl:output method="text"/>

    <xsl:template match="/">
        <xsl:text>"par";"5230";"5210";"5209";"obj-Nr.";"Blocknr."</xsl:text>
        <xsl:value-of select="$crlf"/>
        <!--<xsl:for-each select="$descriptions//h1:Block[h1:Field[starts-with(@Type, 'par')][ @Value != '' ]]">-->
        <xsl:for-each select="//doc/@href">
            <xsl:variable name="contents" select="doc(.)"/>
            <xsl:for-each select="$contents//h1:Block[h1:Field[starts-with(@Type, 'par')][ @Value != '' ]]">
                <xsl:text>"</xsl:text>
                <xsl:for-each select="h1:Field[starts-with(@Type, 'par')][ @Value != '' ]">
                    <xsl:value-of select="substring-after(@Type, 'par')"/>
                    <xsl:if test="not(position() = last())">
                        <xsl:text>-</xsl:text>
                    </xsl:if>
                </xsl:for-each>
                <xsl:text>";"</xsl:text>
                <xsl:value-of select="h1:Field[ (@Type = '5230') ]/@Value"/>
                <xsl:text>";"</xsl:text>
                <xsl:value-of select="h1:Field[ (@Type = '5210') ]/@Value"/>
                <xsl:text>";"</xsl:text>
                <xsl:value-of select="h1:Field[ (@Type = '5209') ]/@Value"/>
                <xsl:text>";"</xsl:text>
                <xsl:value-of select="ancestor-or-self::h1:Block[h1:Field[ @Type = '5000' ]]/h1:Field[ @Type = '5000' ]/@Value"/>
                <xsl:text>";"</xsl:text>
                <xsl:value-of select="h1:Field[ (@Type = '5001') or (@Type = '5002') or (@Type = '5003') or (@Type = '5004') ]/@Value"/>
                <xsl:text>"</xsl:text>
                <xsl:value-of select="$crlf"/>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>