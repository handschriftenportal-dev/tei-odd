<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" exclude-result-prefixes="dc tei" version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/">
        <oai_dc:dc 
            xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" 
            xmlns:dc= "http://purl.org/dc/elements/1.1/" 
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd ">
            <xsl:call-template name="identifier"/>
            <xsl:call-template name="language"/>
            <xsl:call-template name="publisher"/>
            <xsl:call-template name="rights"/>
            <xsl:call-template name="title"/>
            <dc:type>Text</dc:type>
        </oai_dc:dc>
        </xsl:template>

    <xsl:template name="identifier">
        <dc:identifier><xsl:value-of select="descendant::tei:msDesc/@xml:id"/></dc:identifier>
        <dc:identifier><xsl:value-of select="descendant::tei:msIdentifier[parent::tei:msDesc]/concat(tei:settlement, ', ', tei:repository, ', ', tei:idno)"/></dc:identifier>
    </xsl:template>

    <xsl:template name="language">
        <dc:language>Sprache der Beschreibung: 
            <xsl:choose>
                <xsl:when test="descendant::tei:msDesc/@xml:lang = 'de' ">deutsch</xsl:when>
                <xsl:otherwise>deutsch</xsl:otherwise>
            </xsl:choose>
        </dc:language>
        <xsl:for-each select="distinct-values(descendant::tei:textLang[not(.='')])">
            <dc:language>Sprache(n) in der Handschrift: <xsl:value-of select="."/></dc:language>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="publisher">
        <dc:publisher><xsl:value-of select="descendant::tei:publisher/tei:name"/></dc:publisher>
    </xsl:template>

    <xsl:template name="rights">
        <xsl:if test="descendant::tei:licence/@target">
            <dc:rights><xsl:value-of select="descendant::tei:licence/@target"/></dc:rights>
        </xsl:if>
        <xsl:if test="descendant::tei:licence/tei:p">
            <dc:rights><xsl:apply-templates select="descendant::tei:licence/tei:p"/></dc:rights>
        </xsl:if>
    </xsl:template>

    <xsl:template name="title">
        <dc:title><xsl:value-of select="descendant::tei:title[parent::tei:titleStmt]"/></dc:title>
    </xsl:template>

    <xsl:template match="tei:p">
        <xsl:if test="preceding-sibling::tei:p"><xsl:text> </xsl:text></xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
