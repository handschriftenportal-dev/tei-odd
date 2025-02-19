<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="tei xi xsi">
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:preserve-space elements="*"/>
    
    <xsl:template match="processing-instruction()"/>
    <xsl:template match="comment()"/>
    <xsl:template match="@*[name() = 'xsi:schemaLocation']"/>

    <xsl:template match="/">
        <xsl:for-each select="//table/tr">
            <xsl:variable name="catalog" select="doc(concat('../nachweis_daten/4_KATALOGE_nicht_prozessiert/', td[1]))"/>
            <xsl:result-document href="bearbeitet/{td[1]}" indent="yes">
                <xsl:apply-templates select="$catalog/tei:TEI">
                    <xsl:with-param name="td1" select="td[1]"/>
                    <xsl:with-param name="td3" select="td[3]"/>
                    <xsl:with-param name="td5" select="td[5]"/>
                </xsl:apply-templates>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="tei:fileDesc">
        <xsl:param name="td1"/>
        <xsl:param name="td3"/>
        <xsl:param name="td5"/>
        <xsl:variable name="title">
            <xsl:call-template name="processTitle"/>
        </xsl:variable>
        <xsl:message><xsl:value-of select="normalize-space($title)"/></xsl:message>
        <xsl:element name="tei:fileDesc">
            <xsl:apply-templates select="tei:titleStmt"><xsl:with-param name="title" select="$title"/></xsl:apply-templates>
            <xsl:apply-templates select="tei:publicationStmt">
                <xsl:with-param name="title" select="normalize-space($title)"/>
                <xsl:with-param name="td3" select="$td3"/>
                <xsl:with-param name="td5" select="$td5"/>
            </xsl:apply-templates>
            <xsl:if test="starts-with(tokenize($title, '. - ')[last()], '(')">
                <xsl:element name="tei:seriesStmt">
                    <xsl:element name="tei:title">
                        <xsl:value-of select="substring-before(substring-after(tokenize($title, ': ')[last()], '('), '; ')"/>
                    </xsl:element>
                    <xsl:element name="tei:biblScope">
                        <xsl:attribute name="unit" select=" 'volume' "/>
                        <xsl:value-of select="substring-before(substring-after(substring-after(tokenize($title, ': ')[last()], '('), '; '), ')')"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:element name="tei:sourceDesc">
                <xsl:element name="tei:p">
                    <xsl:text>OCR-Ausgangsdatei: </xsl:text>
                    <xsl:value-of select="$td1"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:titleStmt">
        <xsl:param name="title"/>
        <xsl:copy>
            <xsl:element name="tei:title">
                <xsl:value-of select="substring-before(substring-after($title, ': '), '. - ')"/>
            </xsl:element>
            <xsl:element name="tei:respStmt">
                <xsl:element name="tei:resp">Beschrieben durch</xsl:element>
                <xsl:choose>
                    <xsl:when test="contains(substring-before(tei:title, ': '), 'und')">
                        <xsl:element name="tei:persName">
                            <xsl:attribute name="role" select=" 'author' "/>
                            <xsl:value-of select="substring-after(substring-before(tei:title, ' und '), ', ')"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="substring-before(tei:title, ', ')"/>
                        </xsl:element>
                        <xsl:element name="tei:persName">
                            <xsl:attribute name="role" select=" 'author' "/>
                            <xsl:value-of select="substring-after(substring-before(tei:title, ': '), ' und ')"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="tei:persName">
                            <xsl:attribute name="role" select=" 'author' "/>
                            <xsl:value-of select="substring-after(substring-before(tei:title, ': '), ', ')"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="substring-before(tei:title, ', ')"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:publicationStmt">
        <xsl:param name="td3"/>
        <xsl:param name="td5"/>
        <xsl:param name="title"/>
        <xsl:copy>
            <xsl:element name="tei:publisher">
                <xsl:value-of select="substring-before(tokenize($title, ': ')[last()], ', ')"/>
            </xsl:element>
            <xsl:element name="tei:pubPlace">
                <xsl:value-of select="substring-before(substring-after($title, '. - '), ': ')"/>
                <xsl:element name="tei:ptr">
                    <xsl:attribute name="type" select=" 'thumbnail' "/>
                    <xsl:if test="$td5 != ''"><xsl:attribute name="target" select="$td5"/></xsl:if>
                </xsl:element>
            </xsl:element>
            <xsl:element name="tei:date">
                <xsl:choose>
                    <xsl:when test="contains(substring-after(tokenize($title, ': ')[last()], ', '), '. - (')">
                        <xsl:value-of select="substring-before(substring-after(tokenize($title, ': ')[last()], ', '), '. - (')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="translate(substring-after(tokenize($title, ': ')[last()], ', '), '.', '')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:element name="tei:idno">
                <xsl:attribute name="type" select=" 'hsk' "/>
                <xsl:choose>
                    <xsl:when test="matches(tei:publisher, '\d+')">
                        <xsl:value-of select="tei:publisher"/>
                    </xsl:when>
                    <xsl:when test="tei:sourceDesc[starts-with(., 'BIB-Dokument Nr. ')]">
                        <xsl:value-of select="substring-after(tei:sourceDesc, 'BIB-Dokument Nr. ')"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:element>
            <xsl:element name="tei:availability">
                <xsl:element name="tei:licence">
                    <xsl:attribute name="target" select=" 'https://rightsstatements.org/page/InC/1.0/' "/>
                    <xsl:element name="tei:p">In copyright.</xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="tei:ptr">
                <xsl:attribute name="type" select=" 'hsp' "/>
                <xsl:if test="$td3 != ''"><xsl:attribute name="target" select="$td3"/></xsl:if>
            </xsl:element>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="processTitle">
        <xsl:apply-templates select="tei:titleStmt/tei:title" mode="text"/>
    </xsl:template>
    <xsl:template match="text() | *" mode="text">
        <xsl:value-of select="."/>
    </xsl:template>
</xsl:stylesheet>