<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:h1="http://www.startext.de/HiDA/DefService/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="h1 tei xs"
    version="2.0">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:variable name="listPlace" select="document('../nachweis_daten/1_0_Normdaten/1_1_Orte/Export-MXML_geo.xml')"/>
    
    <xsl:template match="/">
        <xsl:message><xsl:copy-of select="$listPlace"/></xsl:message>
        <xsl:element name="listOrg" namespace="">
            
            <xsl:for-each select="//h1:Block[ @Type = 'soz' ]
                [not(starts-with(h1:Field[ @Type = '4600' ]/@Value, 'ZU LÖSCHEN'))]
                [
                h1:Field[ @Type = '499a' ][ @Value = 'GND-Nummer' ][h1:Field[ @Type = '499e' ][ (@Value != 'nicht vorhanden') and not(contains(@Value, ' ('))  and not(contains(@Value, '...')) ]] or
                h1:Field[ @Type = '499a' ][ @Value = 'ISIL-Sigle' ][h1:Field[ @Type = '499e' ][ (@Value != 'nicht vorhanden') and not(contains(@Value, ' ('))  and not(contains(@Value, '...')) ]]
                ]
                ">
                <xsl:sort select="h1:Field[ @Type = '4564']/@Value" lang="de"/>
                <xsl:sort select="h1:Field[ @Type = '4600']/@Value" lang="de"/>
                <xsl:variable name="GND_org" select="h1:Field[@Type = '499a' ][ @Value = 'GND-Nummer' ]/h1:Field[ @Type = '499e' ][ (@Value != 'nicht vorhanden') and not(contains(@Value, ' ('))  and not(contains(@Value, '...')) ]/@Value"/>
                <xsl:variable name="GND_place" select="$listPlace//h1:Block[
                    h1:Field[ @Type = '2050' ][ @Value = current()/h1:Field[ @Type = '4564' ]/@Value]
                    ]/h1:Field[ @Type = '219a' ][ @Value = 'GND-GEO-Nummer' ]/h1:Field[ @Type = '219e' ]/@Value"/>
                <xsl:element name="org" namespace="">
                    <xsl:attribute name="xml:id" select="concat('soz_', h1:Field[ @Type = '4500']/@Value)"/>
                    <orgName><xsl:value-of select="h1:Field[ @Type = '4600']/@Value"/></orgName>
                    <idno type="gnd">
                        <xsl:attribute name="xml:id" select="concat('gnd_', $GND_org)"/>
                        <xsl:value-of select="concat('http://d-nb.info/gnd/', $GND_org)"/>
                    </idno>
                    <placeName><xsl:value-of select="h1:Field[ @Type = '4564']/@Value"/></placeName>
                    <idno type="gnd">
                        <xsl:attribute name="xml:id" select="concat('gnd_', $GND_place)"/>
                        <xsl:value-of select="concat('http://d-nb.info/gnd/', $GND_place)"/>
                    </idno>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>