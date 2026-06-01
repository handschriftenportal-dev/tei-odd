<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:h1="http://www.startext.de/HiDA/DefService/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="h1 tei xs"
    version="2.0">
    
    <xsl:variable name="listPlace" select="document('../../../nachweis_daten/1_0_Normdaten/hsp_TEI_Import_Orte.xml')"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/">
        <xsl:element name="TEI" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="teiHeader" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="fileDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="titleStmt" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">Normdaten Persons</xsl:element>
                    </xsl:element>
                    <xsl:element name="publicationStmt" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="publisher" namespace="http://www.tei-c.org/ns/1.0">Handschriftenportal</xsl:element>
                    </xsl:element>
                    <xsl:element name="sourceDesc" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:text>Automatisch generierte Personenliste aus einem </xsl:text>
                            <xsl:if test="h1:DocumentSet/h1:ContentInfo/h1:Format"><xsl:value-of select="concat('im ', h1:DocumentSet/h1:ContentInfo/h1:Format, 'Format')"/></xsl:if>
                            <xsl:if test="h1:DocumentSet/h1:ContentInfo/h1:CreationDate"><xsl:value-of select="concat(' am ', h1:DocumentSet/h1:ContentInfo/h1:CreationDate, ' erstellten Datendump')"/></xsl:if>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="text" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="body" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="listPerson" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:apply-templates select="descendant::h1:Document
                            [
                             (descendant::h1:Field[@Type='99fm' and starts-with(@Value, 'GND-ID:') and not(@Value = preceding::h1:Field[@Type='99fm' and starts-with(@Value, 'GND-ID:')]/@Value)])
                             or 
                             descendant::h1:Field[@Type='449a'][@Value='GND-Nummer']
                             ]
                            [not(descendant::h1:Field[@Type='9904'])]"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="h1:Document">
        <xsl:variable name="xmlid" select="translate(normalize-space(@DocKey), ', ', '-_')"/>
        <xsl:element name="person" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="xml:id" select="$xmlid"/>
            <xsl:apply-templates select="descendant::h1:Field[@Type='4140']"/>
            <xsl:apply-templates select="descendant::h1:Field[@Type='4100']"/>
            <xsl:apply-templates select="descendant::h1:Field[@Type='4105']"/>
            <xsl:apply-templates select="descendant::h1:Field[@Type='z830']"/>
            <xsl:apply-templates select="descendant::h1:Field[@Type='4270']"/>
            <xsl:apply-templates select="descendant::h1:Field[@Type='4330']"/>
            <xsl:apply-templates select="descendant::h1:Field[@Type='4165']"/>
            <xsl:apply-templates select="descendant::h1:Field[@Type='99fm'][starts-with(@Value, 'GND-ID:')]"/>
            <xsl:apply-templates select="descendant::h1:Field[@Type='449a'][@Value='GND-Nummer']"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="h1:Field[@Type='4100']">
        <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select=" 'default' "/>
            <xsl:value-of select="@Value"/>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="h1:Field[@Type='4105']">
        <xsl:for-each select="tokenize(@Value, '&amp;')">
            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select=" 'alternative' "/>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="h1:Field[@Type='4140']">
        <xsl:attribute name="sex" select="upper-case(@Value)"/>
    </xsl:template>
    <xsl:template match="h1:Field[@Type='4165']">
        <xsl:for-each select="tokenize(@Value, '&amp;')">
            <xsl:element name="occupation" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="h1:Field[@Type='4270']">
        <xsl:element name="birth" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:if test="@Value != '---' ">
                <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:if test="matches(@Value, '\d{4}\.\d{2}\.\d{2}') and not(contains(@Value, '/'))">
                        <xsl:attribute name="when" select="translate(@Value, '.', '-')"/>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="matches(@Value, '\d{4}\.\d{2}\.\d{2}') and not(contains(@Value, '/'))">
                            <xsl:value-of select="substring(@Value, 9, 2)"/>
                            <xsl:text>.</xsl:text>
                            <xsl:value-of select="substring(@Value, 6, 2)"/>
                            <xsl:text>.</xsl:text>
                            <xsl:value-of select="substring(@Value, 1, 4)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@Value"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:if>
            <xsl:if test="h1:Field[@Type='4290']">
                <xsl:element name="placeName" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:if test="$listPlace//tei:place[tei:placeName = current()/h1:Field[@Type='4290']/@Value]">
                        <xsl:attribute name="ref" select="$listPlace//tei:place[tei:placeName = current()/h1:Field[@Type='4290']/@Value]/tei:idno[@type='gnd']"/>
                    </xsl:if>
                    <xsl:value-of select="normalize-space(h1:Field[@Type='4290']/@Value)"/>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[@Type='4330']">
        <xsl:element name="death" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:if test="@Value != '---' ">
                <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:if test="matches(@Value, '\d{4}\.\d{2}\.\d{2}') and not(contains(@Value, '/'))">
                        <xsl:attribute name="when" select="translate(@Value, '.', '-')"/>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="matches(@Value, '\d{4}\.\d{2}\.\d{2}') and not(contains(@Value, '/'))">
                            <xsl:value-of select="substring(@Value, 9, 2)"/>
                            <xsl:text>.</xsl:text>
                            <xsl:value-of select="substring(@Value, 6, 2)"/>
                            <xsl:text>.</xsl:text>
                            <xsl:value-of select="substring(@Value, 1, 4)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@Value"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:if>
            <xsl:if test="h1:Field[@Type='4350']">
                <xsl:element name="placeName" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:if test="$listPlace//tei:place[tei:placeName = current()/h1:Field[@Type='4350']/@Value]">
                        <xsl:attribute name="ref" select="$listPlace//tei:place[tei:placeName = current()/h1:Field[@Type='4350']/@Value]/tei:idno[@type='gnd']"/>
                    </xsl:if>
                    <xsl:value-of select="normalize-space(h1:Field[@Type='4350']/@Value)"/>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[@Type='449a'][@Value='GND-Nummer']">
        <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select=" 'gnd' "/>
            <xsl:attribute name="xml:id" select="concat('gnd_', @Value)"/>
            <xsl:value-of select="concat('http://d-nb.info/gnd/', @Value)"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[@Type='99fm'][starts-with(@Value, 'GND-ID:')]">
        <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select=" 'gnd' "/>
            <xsl:attribute name="xml:id" select="concat('gnd_', substring-after(@Value, 'GND-ID:'))"/>
            <xsl:value-of select="concat('http://d-nb.info/gnd/', substring-after(@Value, 'GND-ID:'))"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[@Type='z001']">
        <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select=" 'z001' "/>
            <xsl:attribute name="xml:id" select="concat('z001_', translate(@Value, ' ', '_'))"/>
            <xsl:value-of select="@Value"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[@Type='z830']">
        <xsl:for-each select="tokenize(@Value, '&amp;')">
            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select=" 'alternative' "/>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
<!-- Felder
4007 - Relation
4010 - relatedTo
4018 - relatedTo_infoAbout
4100gi
4140
4160 - Stand
4165 - Beruf(e) (&amp;)
4180
4204
449a
449e
4500
4564
4590
4594
4596
4600
4996
8330
8334
8350 - Literatur
9900
99hs
bezsoz
z001a
z002a
z003
z020a
z029
z800
z801
z814
z814a
z814b
z814i
z816
z820
-->
    
</xsl:stylesheet>
