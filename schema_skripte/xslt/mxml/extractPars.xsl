<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:h1="http://www.startext.de/HiDA/DefService/XMLSchema"
    xmlns:h2="katneu4-2009-12-richedit-illum-neu.xml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- 
    curl  -F upload=@..\MXML2TEI\test.rtf "https://teigarage.tei-c.de/ege-webservice/Conversions/rtf%3Aapplication%3Artf/odt%3Aapplication%3Avnd.oasis.opendocument.text/TEI%3Atext%3Axml/xml%3Aapplication%3Axml/"
    
    Suche
    ^(.*?)$
    
    Ersetze
    curl  -F upload=@3_0_Produktion\\_testdaten\\par-files\\$1 "https://teigarage.tei-c.de/ege-webservice/Conversions/rtf%3Aapplication%3Artf/odt%3Aapplication%3Avnd.oasis.opendocument.text/TEI%3Atext%3Axml/xml%3Aapplication%3Axml/" > 3_0_Produktion\\_testdaten\\par-files\\$1.xml
    -->
    
    <xsl:template match="/">
        <xsl:for-each select="descendant-or-self::h1:Field[starts-with(@Type, 'par')]">
            <xsl:result-document href="../_par-files/{ancestor::h1:Block[ @Type = 'obj' ]/h1:Field[@Type='bezsoz'][@Value='Verwaltung']/h1:Field[@Type='4564']/@Value}/{ancestor::h1:Block[ @Type = 'obj' ]/h1:Field[@Type='bezsoz'][@Value='Verwaltung']/h1:Field[@Type='4600']/@Value}/{ancestor::h1:Block[ @Type = 'obj' ]/h1:Field[ @Type = '5000' ]/@Value}{if (parent::h1:Block[@Type != 'obj' ]) then concat('/', parent::h1:Block/h1:Field[(@Type = '5001') or (@Type = '5002') or (@Type = '5003') or (@Type = '5004')]/@Value, '_') else '/'}{@Type}.rtf" encoding="UTF-8" method="text">
                <xsl:value-of select="@Value"/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>