<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:h1="http://www.startext.de/HiDA/DefService/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="h1 tei xs"
    version="2.0">
    
    <xsl:variable name="crlf" select=" '&#x0A;' "/>
    <xsl:variable name="listKOD" select="doc('file:///Users/schassan/Documents/_GitHub-clones/HSP/tei-odd/nachweis_daten/catalog_KOD.xml')"/>
    <xsl:variable name="listDSC" select="doc('file:///Users/schassan/Documents/_GitHub-clones/HSP/tei-odd/nachweis_daten/catalog_DSC.xml')"/>
    <xsl:variable name="listTEI" select="doc('file:///Users/schassan/Documents/_GitHub-clones/HSP/tei-odd/nachweis_daten/catalog_DSC-TEI.xml')"/>
    <xsl:variable name="listDIG" select="doc('file:///Users/schassan/Documents/_GitHub-clones/HSP/tei-odd/nachweis_daten/catalog_DIG.xml')"/>
    <xsl:output method="text" encoding="UTF-8" indent="no"/>
    
    <xsl:template match="/">
        <xsl:result-document href="_count_KOD.csv" method="text" encoding="utf-8">
            <xsl:value-of select="concat('&quot;Datei&quot;$&quot;Ort&quot;$&quot;Institution&quot;$&quot;Anzahl KODs&quot;', $crlf)"/>
            <xsl:for-each select="$listKOD//doc[not(contains(@href, '1_Neue_KODs'))]">
                <xsl:value-of select="concat('&quot;', tokenize(@href, '/')[13], '&quot;')"/>
                <xsl:value-of select="concat('$&quot;', tokenize(tokenize(@href, '/')[13], '_')[2], '&quot;')"/>
                <xsl:value-of select="concat('$&quot;', if (contains(tokenize(tokenize(@href, '/')[13], '_')[3], '.csv')) then substring-before(tokenize(tokenize(@href, '/')[13], '_')[3], '.csv') else tokenize(tokenize(@href, '/')[13], '_')[3], '&quot;')"/>
                <xsl:value-of select="concat('$&quot;', count(document(replace(@href, '.csv', '.xml'))//tei:msDesc), '&quot;', $crlf)"/>
            </xsl:for-each>
            <xsl:value-of select="concat($crlf, $crlf, $crlf, '$$$=SUMME(D2:D', count($listKOD//doc[not(contains(@href, '1_Neue_KODs'))]) + 1, ')', $crlf)"/>
        </xsl:result-document>
        <xsl:result-document href="_count_DSC.csv" method="text" encoding="utf-8">
            <xsl:value-of select="concat('&quot;Datei&quot;$&quot;Ort&quot;$&quot;Institution&quot;$&quot;SEL-Datei&quot;$&quot;Anzahl Beschreibungen&quot;', $crlf)"/>
            <xsl:for-each select="$listDSC//doc">
                <xsl:value-of select="concat('&quot;', tokenize(@href, '/')[13], '&quot;')"/>
                <xsl:value-of select="concat('$&quot;', tokenize(tokenize(@href, '/')[13], '_')[2], '&quot;')"/>
                <xsl:value-of select="concat('$&quot;', 
                         if (contains(tokenize(@href, '/')[13], 'Paket')) then substring-before(substring-after(substring-after(tokenize(@href, '/')[13], '_'), '_'), '_Paket') 
                    else if (contains(tokenize(@href, '/')[13], 'HSK'))   then substring-before(substring-after(substring-after(tokenize(@href, '/')[13], '_'), '_'), '_HSK')
                    else tokenize(tokenize(@href, '/')[13], '_')[3], 
                    '&quot;')"/>
                <xsl:value-of select="concat('$&quot;', 
                         if (contains(tokenize(@href, '/')[13], 'Paket')) then concat('Paket', substring-before(substring-after(tokenize(@href, '/')[13], 'Paket'), '_EXT')) 
                    else if (contains(tokenize(@href, '/')[13], 'HSK'))   then concat('HSK',   substring-before(substring-after(tokenize(@href, '/')[13], 'HSK'),   '_EXT'))
                    else tokenize(tokenize(@href, '/')[13], '_')[4], 
                    '&quot;')"/>
                <xsl:value-of select="concat('$&quot;', count(document(@href)//h1:Document), '&quot;', $crlf)"/>
            </xsl:for-each>
            <xsl:for-each select="$listTEI//doc">
                <xsl:value-of select="concat('&quot;', tokenize(@href, '/')[13], '&quot;')"/>
                <xsl:value-of select="concat('$&quot;', tokenize(tokenize(@href, '/')[13], '_')[2], '&quot;')"/>
                <xsl:value-of select="concat('$&quot;', tokenize(tokenize(@href, '/')[13], '_')[3], '&quot;')"/>
                <xsl:value-of select="concat('$&quot;', tokenize(tokenize(@href, '/')[13], '_')[4], '&quot;')"/>
                <xsl:value-of select="concat('$&quot;', count(document(@href)//tei:msDesc), '&quot;', $crlf)"/>
            </xsl:for-each>
            <xsl:value-of select="concat($crlf, $crlf, $crlf, '$$$=SUMME(E2:E', count($listDSC//doc) + count($listTEI//doc) + 1, ')', $crlf)"/>
        </xsl:result-document>
        <xsl:result-document href="_count_DIG.csv" method="text" encoding="utf-8">
            <xsl:value-of select="concat('&quot;Datei&quot;$&quot;Ort&quot;$&quot;Institution&quot;$&quot;Anzahl Digitalisate&quot;', $crlf)"/>
            <xsl:for-each select="$listDIG//doc">
                <xsl:value-of select="concat('&quot;', tokenize(@href, '/')[13], '&quot;')"/>
                <xsl:value-of select="concat('$&quot;', tokenize(tokenize(@href, '/')[13], '_')[2], '&quot;')"/>
                <xsl:value-of select="concat('$&quot;', if (contains(tokenize(tokenize(@href, '/')[13], '_')[3], '.csv')) then substring-before(tokenize(tokenize(@href, '/')[13], '_')[3], '.csv') else tokenize(tokenize(@href, '/')[13], '_')[3], '&quot;')"/>
                <xsl:value-of select="concat('$&quot;', count(document(replace(@href, '.csv', '.xml'))//tei:msDesc), '&quot;', $crlf)"/>
            </xsl:for-each>
            <xsl:value-of select="concat($crlf, $crlf, $crlf, '$$$=SUMME(D2:D', count($listDIG//doc) + 1, ')', $crlf)"/>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>
