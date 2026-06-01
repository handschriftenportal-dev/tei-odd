<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">

    <xsl:template name="writeLangRef">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="(lower-case($value) = 'äthiopisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4133282-9</xsl:attribute><xsl:value-of select="$value"/></xsl:when>
            <!--<xsl:when test="(lower-case($value) = 'alemannisch') or ($value = 'al')"><xsl:attribute name="ref">http://d-nb.info/gnd/4112483-2</xsl:attribute>alemannisch</xsl:when>-->
            <xsl:when test="(lower-case($value) = 'althebräisch') or ($value = 'hbo')"><xsl:attribute name="ref">http://d-nb.info/gnd/4023922-6</xsl:attribute>althebräisch</xsl:when>
            <!--<xsl:when test="(lower-case($value) = 'amharisch') or ($value = 'am') or ($value = 'amh')"><xsl:attribute name="ref">http://d-nb.info/gnd/4001701-1</xsl:attribute>amharisch</xsl:when>-->
            <xsl:when test="(lower-case($value) = 'arabisch') or ($value = 'ar') or ($value = 'ara')"><xsl:attribute name="ref">http://d-nb.info/gnd/4241223-7</xsl:attribute>arabisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'aramäisch') or ($value = 'arc')"><xsl:attribute name="ref">http://d-nb.info/gnd/4085880-7</xsl:attribute>aramäisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'armenisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120142-5</xsl:attribute><xsl:value-of select="$value"/></xsl:when>
            <xsl:when test="(lower-case($value) = 'aromunisch') or ($value = 'rup')"><xsl:attribute name="ref">http://d-nb.info/gnd/4112594-0</xsl:attribute>aromunisch</xsl:when>
            <!--<xsl:when test="(lower-case($value) = 'bairisch') or ($value = 'ba')"><xsl:attribute name="ref">http://d-nb.info/gnd/4112659-2</xsl:attribute>bairisch</xsl:when>-->
            <xsl:when test="(lower-case($value) = 'baskisch') or ($value = 'eu') or ($value = 'eus')"><xsl:attribute name="ref">http://d-nb.info/gnd/4088809-5</xsl:attribute>baskisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'bulgarisch') or ($value = 'bg')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120165-6</xsl:attribute>bulgarisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'bretonisch') or ($value = 'br') or ($value = 'bre')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120162-0</xsl:attribute>bretonisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'chinesisch') or ($value = 'zh')"><xsl:attribute name="ref">http://d-nb.info/gnd/4113214-2</xsl:attribute>chinesisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'dänisch') or ($value = 'da')"><xsl:attribute name="ref">http://d-nb.info/gnd/4113262-2</xsl:attribute>dänisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'dalmatisch') or ($value = 'roa')"><xsl:attribute name="ref">http://d-nb.info/gnd/4268548-5</xsl:attribute>dalmatisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'deutsch') or ($value = 'de') or ($value = 'deu') or ($value = 'ger')"><xsl:attribute name="ref">http://d-nb.info/gnd/4113292-0</xsl:attribute>deutsch</xsl:when>
            <xsl:when test="(lower-case($value) = 'englisch') or ($value = 'en') or ($value = 'eng')"><xsl:attribute name="ref">http://d-nb.info/gnd/4014777-0</xsl:attribute>englisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'estnisch') or ($value = 'et') or ($value = 'est')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120175-9</xsl:attribute>estnisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'finnisch') or ($value = 'fi') or ($value = 'fin')"><xsl:attribute name="ref">http://d-nb.info/gnd/4124978-1</xsl:attribute>finnisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'fränkisch') or ($value = 'gem')"><xsl:attribute name="ref">http://d-nb.info/gnd/4123221-5</xsl:attribute>fränkisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'französisch') or ($value = 'fr') or ($value = 'fre') or ($value = 'fra')"><xsl:attribute name="ref">http://d-nb.info/gnd/4113615-9</xsl:attribute>französisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'friesisch') or ($value = 'fy') or ($value = 'fry')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120183-8</xsl:attribute>friesisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'friulanisch') or ($value = 'fur')"><xsl:attribute name="ref">http://d-nb.info/gnd/4155474-7</xsl:attribute>friulanisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'georgisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4124679-2</xsl:attribute><xsl:value-of select="$value"/></xsl:when>
            <xsl:when test="(lower-case($value) = 'gotisch') or ($value = 'got')"><xsl:attribute name="ref">http://d-nb.info/gnd/4123303-7</xsl:attribute>gotisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'griechisch') or ($value = 'grc') or ($value = 'gre')"><xsl:attribute name="ref">http://d-nb.info/gnd/4113791-7</xsl:attribute>griechisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'hebräisch') or ($value = 'he') or ($value = 'heb')"><xsl:attribute name="ref">http://d-nb.info/gnd/4023922-6</xsl:attribute>hebräisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'indisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4133531-4</xsl:attribute><xsl:value-of select="$value"/></xsl:when>
            <xsl:when test="(lower-case($value) = 'irisch') or ($value = 'ga') or ($value = 'gle')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120207-7</xsl:attribute>irisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'illyrisch') or ($value = 'ine')"><xsl:attribute name="ref">http://d-nb.info/gnd/4161281-4</xsl:attribute>illyrisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'isländisch') or ($value = 'is')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120209-0</xsl:attribute>isländisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'italienisch') or ($value = 'it') or ($value = 'ita')"><xsl:attribute name="ref">http://d-nb.info/gnd/4114056-4</xsl:attribute>italienisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'javanisch') or ($value = 'ja')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120210-7</xsl:attribute>javanisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'jiddisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4028614-9</xsl:attribute><xsl:value-of select="$value"/></xsl:when>
            <xsl:when test="(lower-case($value) = 'katalanisch') or ($value = 'ca')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120218-1</xsl:attribute>katalanisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'kirchenslawisch') or ($value = 'cu') or ($value = 'chu')"><xsl:attribute name="ref">http://d-nb.info/gnd/4132167-4</xsl:attribute>kirchenslawisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'kroatisch') or ($value = 'hr')"><xsl:attribute name="ref">http://d-nb.info/gnd/4033245-7</xsl:attribute>kroatisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'lateinisch') or ($value = 'la') or ($value = 'lat')"><xsl:attribute name="ref">http://d-nb.info/gnd/4114364-4</xsl:attribute>lateinisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'litauisch') or ($value = 'lit')"><xsl:attribute name="ref">http://d-nb.info/gnd/4133373-1</xsl:attribute>litauisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'livisch') or ($value = 'fiu')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120240-5</xsl:attribute>livisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'maduresisch') or ($value = 'mad')"><xsl:attribute name="ref">http://d-nb.info/gnd/4458737-5</xsl:attribute>maduresisch</xsl:when>
            <!--<xsl:when test="(lower-case($value) = 'malagasy') or ($value = 'mg') or ($value = 'mlg')"><xsl:attribute name="ref">http://d-nb.info/gnd/4100041-9</xsl:attribute>malagasy</xsl:when>-->
            <xsl:when test="(lower-case($value) = 'malaiisch') or ($value = 'ms') or ($value = 'msa') or ($value = 'may')"><xsl:attribute name="ref">http://d-nb.info/gnd/4037194-3</xsl:attribute>malaiisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'maltesisch') or ($value = 'mt') or ($value = 'mlt')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120245-4</xsl:attribute>maltesisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'mandschurisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4119929-7</xsl:attribute><xsl:value-of select="$value"/></xsl:when>
            <xsl:when test="(lower-case($value) = 'maya-sprache')"><xsl:attribute name="ref">http://d-nb.info/gnd/4220899-3</xsl:attribute><xsl:value-of select="$value"/></xsl:when>
            <xsl:when test="(lower-case($value) = 'mongolisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4114622-0</xsl:attribute><xsl:value-of select="$value"/></xsl:when>
            <xsl:when test="(lower-case($value) = 'niederländisch') or ($value = 'nl') or ($value = 'dut')"><xsl:attribute name="ref">http://d-nb.info/gnd/4122614-8</xsl:attribute>niederländisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'norwegisch') or ($value = 'no') or ($value = 'nor')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120291-0</xsl:attribute>norwegisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'okzitanisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4043439-4</xsl:attribute><xsl:value-of select="$value"/></xsl:when>
            <xsl:when test="(lower-case($value) = 'persisch') or ($value = 'per')"><xsl:attribute name="ref">http://d-nb.info/gnd/4065403-5</xsl:attribute>persisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'polnisch') or ($value = 'pl') or ($value = 'pol')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120314-8</xsl:attribute>polnisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'portugiesisch') or ($value = 'pt') or ($value = 'por')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120316-1</xsl:attribute>portugiesisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'quechua')"><xsl:attribute name="ref">http://d-nb.info/gnd/4133214-3</xsl:attribute><xsl:value-of select="$value"/></xsl:when>
            <xsl:when test="(lower-case($value) = 'rätoromanisch') or ($value = 'rm') or ($value = 'roh')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120321-5</xsl:attribute>rätoromanisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'russisch') or ($value = 'ru')"><xsl:attribute name="ref">http://d-nb.info/gnd/4051038-4</xsl:attribute>russisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'sardisch') or ($value = 'sc') or ($value = 'srd')"><xsl:attribute name="ref">http://d-nb.info/gnd/4134397-9</xsl:attribute>sardisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'schottisch') or ($value = 'sco')"><xsl:attribute name="ref">http://d-nb.info/gnd/4127854-9</xsl:attribute>schottisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'schwedisch') or ($value = 'sv') or ($value = 'swe')"><xsl:attribute name="ref">http://d-nb.info/gnd/4116437-4</xsl:attribute>schwedisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'serbisch') or ($value = 'sr') or ($value = 'srp')"><xsl:attribute name="ref">http://d-nb.info/gnd/4133301-9</xsl:attribute>serbisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'singhalesisch') or ($value = 'sin')"><xsl:attribute name="ref">http://d-nb.info/gnd/4107780-5</xsl:attribute>singhalesisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'slawisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120036-6</xsl:attribute><xsl:value-of select="$value"/></xsl:when>
            <xsl:when test="(lower-case($value) = 'slowenisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120336-7</xsl:attribute><xsl:value-of select="$value"/></xsl:when>
            <xsl:when test="(lower-case($value) = 'sorbisch') or ($value = 'wen')"><xsl:attribute name="ref">http://d-nb.info/gnd/4116533-0</xsl:attribute>sorbisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'spanisch') or ($value = 'es') or ($value = 'spa')"><xsl:attribute name="ref">http://d-nb.info/gnd/4077640-2</xsl:attribute>spanisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'syrisch') or ($value = 'syc')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120349-5</xsl:attribute>syrisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'tagalog')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120352-5</xsl:attribute><xsl:value-of select="$value"/></xsl:when>
            <xsl:when test="(lower-case($value) = 'tamil') or ($value = 'tam')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120353-7</xsl:attribute>tamil</xsl:when>
            <xsl:when test="(lower-case($value) = 'tatarisch') or ($value = 'tt') or ($value = 'tat')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120354-9</xsl:attribute>tatarisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'tibetisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4117212-7</xsl:attribute><xsl:value-of select="$value"/></xsl:when>
            <xsl:when test="(lower-case($value) = 'tschechisch') or ($value = 'cs') or ($value = 'ces') or ($value = 'cze')"><xsl:attribute name="ref">http://d-nb.info/gnd/4061084-6</xsl:attribute>tschechisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'türkisch') or ($value = 'tur')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120079-2</xsl:attribute>türkisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'ukrainisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120373-2</xsl:attribute><xsl:value-of select="$value"/></xsl:when>
            <xsl:when test="(lower-case($value) = 'ungarisch') or ($value = 'hu')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120374-4</xsl:attribute>ungarisch</xsl:when>
            
            <!-- Umleitungen -->
            <xsl:when test="(lower-case($value) = 'althochdeutsch') or ($value = 'goh')"><xsl:attribute name="ref">http://d-nb.info/gnd/4113292-0</xsl:attribute>deutsch</xsl:when><!-- war: 4001523-3 -->
            <xsl:when test="(lower-case($value) = 'altkirchenslawisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4132167-4</xsl:attribute>kirchenslawisch</xsl:when><!-- war: 4085065-1 -->
            <xsl:when test="(lower-case($value) = 'chaldäisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4085880-7</xsl:attribute>aramäisch</xsl:when><!-- war: 4120389-6 -->
            <xsl:when test="(lower-case($value) = 'kumanisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120111-5</xsl:attribute>Altaische Sprachen</xsl:when><!-- war: 4120231-4 -->
            <xsl:when test="(lower-case($value) = 'langobardisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4113292-0</xsl:attribute>deutsch</xsl:when><!-- war: 4123614-2 -->
            <xsl:when test="(lower-case($value) = 'latein')"><xsl:attribute name="ref">http://d-nb.info/gnd/4114364-4</xsl:attribute>lateinisch</xsl:when>
            <xsl:when test="(lower-case($value) = 'mittelenglisch') or ($value = 'enm')"><xsl:attribute name="ref">http://d-nb.info/gnd/4014777-0</xsl:attribute>englisch</xsl:when><!-- war: 4039676-9 -->
            <xsl:when test="(lower-case($value) = 'mittelfranzösisch') or ($value = 'frm')"><xsl:attribute name="ref">http://d-nb.info/gnd/4113615-9</xsl:attribute>französisch</xsl:when><!-- war: 4120259-4 -->
            <xsl:when test="(lower-case($value) = 'mittelhochdeutsch') or ($value = 'gmh')"><xsl:attribute name="ref">http://d-nb.info/gnd/4113292-0</xsl:attribute>deutsch</xsl:when><!-- war: 4039687-3 -->
            <xsl:when test="(lower-case($value) = 'mittelniederdeutsch') or ($value = 'gml')"><xsl:attribute name="ref">http://d-nb.info/gnd/4113292-0</xsl:attribute>deutsch</xsl:when><!-- war: 4039698-8 -->
            <xsl:when test="(lower-case($value) = 'niederdeutsch') or ($value = 'nds')"><xsl:attribute name="ref">http://d-nb.info/gnd/4113292-0</xsl:attribute>deutsch</xsl:when><!-- war: 4042178-8 -->
            <xsl:when test="(lower-case($value) = 'neugriechisch') or ($value = 'el')"><xsl:attribute name="ref">http://d-nb.info/gnd/4113791-7</xsl:attribute>griechisch</xsl:when><!-- war: 4120278-8 -->
            <xsl:when test="(lower-case($value) = 'nordisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120209-0</xsl:attribute>isländisch</xsl:when><!-- war: 4120035-4 -->
            <xsl:when test="(lower-case($value) = 'pali')"><xsl:attribute name="ref">http://d-nb.info/gnd/4133531-4</xsl:attribute>indisch</xsl:when><!-- war: 4044406-5 -->
            <xsl:when test="(lower-case($value) = 'polabisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120036-6</xsl:attribute>slawisch</xsl:when><!-- war: 4120313-6 -->
            <xsl:when test="(lower-case($value) = 'schwäbisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4113292-0</xsl:attribute><xsl:value-of select="$value"/></xsl:when><!-- 4120327-6 -->
            <!--<xsl:when test="(lower-case($value) = 'serbokroatisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4054599-4</xsl:attribute><xsl:value-of select="$value"/></xsl:when>-->
            <xsl:when test="(lower-case($value) = 'südslawisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4120036-6</xsl:attribute>slawisch</xsl:when><!-- war: 4120345-8 -->
            <xsl:when test="(lower-case($value) = 'russisch-kirchenslawisch')"><xsl:attribute name="ref">http://d-nb.info/gnd/4132167-4</xsl:attribute>kirchenslawisch</xsl:when><!-- war: 4132166-2 -->
            <xsl:when test="(lower-case($value) = 'tigre')"><xsl:attribute name="ref">http://d-nb.info/gnd/4133282-9</xsl:attribute>äthiopisch</xsl:when><!-- war: 4461778-1 -->
            
            <xsl:otherwise><xsl:value-of select="$value"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>