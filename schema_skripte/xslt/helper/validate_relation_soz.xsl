<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="tei xs"
    version="2.0">
    
    <xsl:variable name="crlf" select=" '&#xA0;' "/>
    <xsl:output method="text" encoding="UTF-8" indent="no"/>
    <xsl:variable name="listPlace" select="document('../../../nachweis_daten/1_0_Normdaten/hsp_TEI_Import_Orte.xml')"/>
    <xsl:variable name="listOrg" select="document('../../../nachweis_daten/1_0_Normdaten/hsp_TEI_Import_Koerperschaften.xml')"/>
    
    <xsl:template match="/">
        <xsl:for-each select="distinct-values(//tei:relation/(@active))">
            <xsl:if test="not($listOrg//tei:org[@xml:id = current()]) and not($listOrg//tei:orgName[. = current()])">
                org <xsl:value-of select="."/> not available in imported normdata<xsl:value-of select="$crlf"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="distinct-values(//tei:relation/(@passive))">
            <xsl:if test="not($listPlace//tei:place[@xml:id = current()]) and not($listPlace//tei:placeName[. = current()])">
                place <xsl:value-of select="."/> not available in imported normdata<xsl:value-of select="$crlf"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
