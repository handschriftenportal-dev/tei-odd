<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    
    <xsl:output method="text" encoding="UTF-8" indent="no"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="KODs" select="base-uri()"/>
    
    <xsl:variable name="institution" select="tokenize(tokenize($KODs, '1_Neue_KODs/01_')[2], '_ERG')[1]"/>
    <xsl:variable name="nachweis_daten_path" select="tokenize($KODs, '1_Neue_KODs/')[1]"/>
    
    
    <xsl:template match="tei:msDesc/tei:msIdentifier//tei:idno">
        
        <xsl:variable name="newKOD"><xsl:value-of select="."/></xsl:variable>
        
        <xsl:for-each select="collection(concat(string($nachweis_daten_path), string($institution), '/?select=01_*.xml'))">
           
            <xsl:value-of select="base-uri()"/>
            
        </xsl:for-each>
        
    </xsl:template>
    
</xsl:stylesheet>
