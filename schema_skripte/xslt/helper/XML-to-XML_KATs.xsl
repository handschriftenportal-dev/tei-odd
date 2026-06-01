<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">

    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:template match="tei:catchwords | tei:del | 
        tei:height | tei:idno[parent::tei:p] | 
        tei:material | tei:measure | tei:note | 
        tei:origDate | tei:origPlace | 
        tei:settlement[parent::tei:p] | tei:span | tei:title[parent::tei:p] | 
        tei:watermark | tei:width">
        <xsl:value-of select="text()"/>
    </xsl:template>
    <xsl:template match="tei:pb | tei:lb"/>

</xsl:stylesheet>