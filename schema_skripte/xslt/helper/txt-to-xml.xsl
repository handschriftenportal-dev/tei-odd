<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="#all"
    version="2.0">

    <xsl:variable name="DIGs" select="unparsed-text('../../../nachweis_daten/catalog_DIG_neu.txt', 'UTF-8')"/>
    <xsl:variable name="DSCs" select="unparsed-text('../../../nachweis_daten/catalog_DSC_neu.txt', 'UTF-8')"/>
    <xsl:variable name="DSC-TEIs" select="unparsed-text('../../../nachweis_daten/catalog_DSC-TEI_neu.txt', 'UTF-8')"/>
    <xsl:variable name="KATs" select="unparsed-text('../../../nachweis_daten/catalog_KAT_neu.txt', 'UTF-8')"/>
    <xsl:variable name="KODs" select="unparsed-text('../../../nachweis_daten/catalog_KOD_neu.txt', 'UTF-8')"/>

    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>

    <xsl:param name="mode"/>
    <xsl:variable name="toBeReplaced" select=" '\\' "/>
    <xsl:variable name="replacement" select=" '/' "/>
    
    <xsl:template name="main" match="/">
        <xsl:result-document href="catalog_DIG.xml">
            <collection>
                <xsl:for-each select="tokenize($DIGs, '&#xD;')[not(position() = last())]">
                    <doc href="{replace(replace(replace(., $toBeReplaced, $replacement), 'C:/', 'file:///'), '&#xA;', '')}"/>
                </xsl:for-each>
            </collection>
        </xsl:result-document>
        <xsl:result-document href="catalog_DSC.xml">
            <collection>
                <xsl:for-each select="tokenize($DSCs, '&#xD;')[not(position() = last())]">
                    <doc href="{replace(replace(replace(., $toBeReplaced, $replacement), 'C:/', 'file:///'), '&#xA;', '')}"/>
                </xsl:for-each>
            </collection>
        </xsl:result-document>
        <xsl:result-document href="catalog_DSC-TEI.xml">
            <collection>
                <xsl:for-each select="tokenize($DSC-TEIs, '&#xD;')[not(position() = last())]">
                    <doc href="{replace(replace(replace(., $toBeReplaced, $replacement), 'C:/', 'file:///'), '&#xA;', '')}"/>
                </xsl:for-each>
            </collection>
        </xsl:result-document>
        <xsl:result-document href="catalog_KAT.xml">
            <collection>
                <xsl:for-each select="tokenize($KATs, '&#xD;')[not(position() = last())]">
                    <doc href="{replace(replace(replace(., $toBeReplaced, $replacement), 'C:/', 'file:///'), '&#xA;', '')}"/>
                </xsl:for-each>
            </collection>
        </xsl:result-document>
        <xsl:result-document href="catalog_KOD.xml">
            <collection>
                <xsl:for-each select="tokenize($KODs, '&#xD;')[not(position() = last())]">
                    <doc href="{replace(replace(replace(., $toBeReplaced, $replacement), 'C:/', 'file:///'), '&#xA;', '')}"/>
                </xsl:for-each>
            </collection>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
