<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs tei"
    version="3.0">
    
    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:variable name="crlf" select=" '&#x0A;' "/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="descendant-or-self::tei:TEI"/>
    </xsl:template>
    
    <xsl:template match="tei:TEI">
        <xsl:call-template name="write_001U"/>
        <xsl:call-template name="write_002at"/>
        <xsl:call-template name="write_002C"/>
        <xsl:call-template name="write_002D"/>
        <xsl:call-template name="write_006X"/>
        <xsl:call-template name="write_010at"/>
        <xsl:choose>
            <xsl:when test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_origDate']/tei:term[@type = 'origDate'][. != '']">
                <xsl:call-template name="write_011at"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>011@ $a1XXX$n[s.a.]</xsl:text>
                <xsl:value-of select="$crlf"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="write_013D"/>
        <xsl:call-template name="write_017G"/>
        <xsl:call-template name="write_021A"/>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_measure']/tei:term[@type = 'measure'][. != '']">
            <xsl:call-template name="write_034D"/>
        </xsl:if>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_dimensions'][tei:term[@type = 'dimensions'][. != ''] and tei:term[@type = 'height'][. != '']]">
            <xsl:call-template name="write_034I"/>
        </xsl:if>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_decoration']/tei:term[@type = 'decoration'][. != '']">
            <xsl:call-template name="write_034M"/>
        </xsl:if>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_musicNotation']/tei:term[@type = 'musicNotation'][. = 'yes']">
            <xsl:call-template name="write_037A"/>
        </xsl:if>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_material']/tei:term[@type = 'material'][. != '']">
            <xsl:call-template name="write_037N"/>
        </xsl:if>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_form']/tei:term[@type = 'form'][. != '']
            or descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_origPlace']/tei:term[@type = 'origPlace'][. != '']">
            <xsl:call-template name="write_037P"/>
        </xsl:if>
        <xsl:if test="descendant::tei:orgName[@type='digitizing'][normalize-space(.) = 'Staatsbibliothek zu Berlin']">
            <xsl:call-template name="write_039I"/>
        </xsl:if>
        <xsl:call-template name="write_208at"/>
        <xsl:value-of select="$crlf"/>
    </xsl:template>

    <xsl:template name="write_001U">
        <xsl:text>001U $0utf8</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_002at">
        <xsl:text>002@ $0Han</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_002C">
        <xsl:text>002C $aText$btxt</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_002D">
        <xsl:text>002D $aohne Hilfsmittel zu benutzen$bn</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_006X">
        <xsl:text>006X $iHSP$0</xsl:text>
        <xsl:value-of select="descendant::tei:msDesc/@xml:id"/>
        <xsl:text>-001-v001</xsl:text>
        <xsl:value-of select="$crlf"/>
        <xsl:text>007Y $iHSP$0</xsl:text>
        <xsl:value-of select="descendant::tei:msDesc/@xml:id"/>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_010at">
        <xsl:text>010@ $a</xsl:text>
        <xsl:for-each select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_textLang']/tei:term[@type = 'textLang-ID'][not(. = preceding-sibling::tei:term[@type = 'textLang-ID'])]">
            <xsl:if test="preceding-sibling::tei:term[@type = 'textLang-ID']">
                <xsl:text>$a</xsl:text>
            </xsl:if>
            <xsl:choose>
                <xsl:when test=". = 'bar' ">bar</xsl:when>
                <xsl:when test=". = 'gsw' ">gsw</xsl:when>
                <xsl:when test=". = 'nds' ">nds</xsl:when>
                <xsl:when test="(. = 'ara') or (. = 'ar') or (lower-case(.) = 'arabisch') ">ara</xsl:when>
                <xsl:when test="(. = 'arc') or               (lower-case(.) = 'aramäisch') ">arc</xsl:when>
                <xsl:when test="(. = 'bul') or (. = 'bg') or (lower-case(.) = 'bulgarisch') ">bul</xsl:when>
                <xsl:when test="(. = 'bre') or (. = 'br') or (lower-case(.) = 'bretonisch') ">bre</xsl:when>
                <xsl:when test="(. = 'chu') or (. = 'cu') or (lower-case(.) = 'kirchenslawisch') ">chu</xsl:when>
                <xsl:when test="(. = 'ces') or (. = 'cs') or (. = 'cze') or (lower-case(.) = 'tschechisch') ">cze</xsl:when>
                <xsl:when test="(. = 'dan') or (. = 'da') or (lower-case(.) = 'dänisch') ">dan</xsl:when>
                <xsl:when test="(. = 'deu') or (. = 'de') or (. = 'ger') or (lower-case(.) = 'deutsch') ">ger</xsl:when>
                <xsl:when test="(. = 'eng') or (. = 'en') or (lower-case(.) = 'englisch') ">eng</xsl:when>
                <xsl:when test="(. = 'spa') or (. = 'es') or (lower-case(.) = 'spanisch') ">spa</xsl:when>
                <xsl:when test="(. = 'est') or (. = 'et') or (lower-case(.) = 'estnisch') ">est</xsl:when>
                <xsl:when test="(. = 'eus') or (. = 'eu') or (lower-case(.) = 'baskisch') ">eus</xsl:when>
                <xsl:when test="(. = 'fin') or (. = 'fi') or (lower-case(.) = 'finnisch') ">fin</xsl:when>
                <xsl:when test="(. = 'fiu') or               (lower-case(.) = 'livisch') ">fiu</xsl:when>
                <xsl:when test="(. = 'fre') or (. = 'fr') or (. = 'fra') or (lower-case(.) = 'französisch') ">fre</xsl:when>
                <xsl:when test="(. = 'fur') or               (lower-case(.) = 'friulanisch') ">fur</xsl:when>
                <xsl:when test="(. = 'fry') or (. = 'fy') or (lower-case(.) = 'friesisch') ">fry</xsl:when>
                <xsl:when test="(. = 'gre') or (. = 'el') or (. = 'grc') or (lower-case(.) = 'griechisch') ">gre</xsl:when>
                <xsl:when test="(. = 'heb') or (. = 'he') or (lower-case(.) = 'hebräisch') ">heb</xsl:when>
                <xsl:when test="(. = 'hrv') or (. = 'hr') or (lower-case(.) = 'kroatisch') ">hrv</xsl:when>
                <xsl:when test="(. = 'gle') or (. = 'ga') or (lower-case(.) = 'irisch') ">gle</xsl:when>
                <xsl:when test="(. = 'got') or               (lower-case(.) = 'gotisch') ">got</xsl:when>
                <xsl:when test="(. = 'hun') or (. = 'hu') or (lower-case(.) = 'ungarisch') ">hun</xsl:when>
                <xsl:when test="(. = 'ine') or               (lower-case(.) = 'illyrisch') ">ine</xsl:when>
                <xsl:when test="(. = 'ice') or (. = 'is') or (lower-case(.) = 'isländisch') ">ice</xsl:when>
                <xsl:when test="(. = 'ita') or (. = 'it') or (lower-case(.) = 'italienisch') ">ita</xsl:when>
                <xsl:when test="(. = 'jav') or (. = 'ja') or (lower-case(.) = 'javanisch') ">jav</xsl:when>
                <xsl:when test="(. = 'cat') or (. = 'ca') or (lower-case(.) = 'katalanisch') ">cat</xsl:when>
                <xsl:when test="(. = 'lat') or (. = 'la') or (lower-case(.) = 'lateinisch') ">lat</xsl:when>
                <xsl:when test="(. = 'lit') or (. = 'lt') or (lower-case(.) = 'litauisch') ">lit</xsl:when>
                <xsl:when test="(. = 'mad') or               (lower-case(.) = 'maduresisch') ">mad</xsl:when>
                <!--<xsl:when test="(. = 'mg') or (. = 'mlg') or (lower-case(.) = 'malagasy') ">malagasy</xsl:when>-->
                <xsl:when test="(. = 'may') or (. = 'ms') or (. = 'msa') or (lower-case(.) = 'malaiisch') ">may</xsl:when>
                <xsl:when test="(. = 'mlt') or (. = 'mt') or (lower-case(.) = 'maltesisch') ">mlt</xsl:when>
                <xsl:when test="(. = 'dut') or (. = 'nl') or (lower-case(.) = 'niederländisch') ">dut</xsl:when>
                <xsl:when test="(. = 'nor') or (. = 'no') or (lower-case(.) = 'norwegisch') ">nor</xsl:when>
                <xsl:when test="(. = 'per') or (. = 'fa') or (lower-case(.) = 'persisch') ">per</xsl:when>
                <xsl:when test="(. = 'pol') or (. = 'pl') or (lower-case(.) = 'polnisch') ">pol</xsl:when>
                <xsl:when test="(. = 'por') or (. = 'pt') or (lower-case(.) = 'portugiesisch') ">por</xsl:when>
                <xsl:when test="(. = 'roh') or (. = 'rm') or (lower-case(.) = 'rätoromanisch') ">roh</xsl:when>
                <!--<xsl:when test="(. = 'roa') or (lower-case(.) = 'dalmatisch') ">dalmatisch</xsl:when>-->
                <xsl:when test="(. = 'rus') or (. = 'ru') or (lower-case(.) = 'russisch') ">rus</xsl:when>
                <xsl:when test="(. = 'rup') or               (lower-case(.) = 'aromunisch') ">rup</xsl:when>
                <xsl:when test="(. = 'srd') or (. = 'sc') or (lower-case(.) = 'sardisch') ">srd</xsl:when>
                <xsl:when test="(. = 'sco') or               (lower-case(.) = 'schottisch') ">sco</xsl:when>
                <xsl:when test="(. = 'sin') or (. = 'si') or (lower-case(.) = 'singhalesisch') ">sin</xsl:when>
                <xsl:when test="(. = 'srp') or (. = 'sr') or (lower-case(.) = 'serbisch') ">srp</xsl:when>
                <xsl:when test="(. = 'swe') or (. = 'sv') or (lower-case(.) = 'schwedisch') ">swe</xsl:when>
                <xsl:when test="(. = 'wen') or               (lower-case(.) = 'sorbisch') ">wen</xsl:when>
                <xsl:when test="(. = 'syr') or (. = 'syc') or (lower-case(.) = 'syrisch') ">syr</xsl:when>
                <xsl:when test="(. = 'tam') or (. = 'ta') or (lower-case(.) = 'tamil') ">tam</xsl:when>
                <xsl:when test="(. = 'tat') or (. = 'tt') or (lower-case(.) = 'tatarisch') ">tat</xsl:when>
                <xsl:when test="(. = 'tur') or (. = 'tr') or (lower-case(.) = 'türkisch') ">tur</xsl:when>
                <xsl:when test="(. = 'chi') or (. = 'zh') or (. = 'zho') or (lower-case(.) = 'chinesisch') ">chi</xsl:when>

                <!-- Umleitungen -->
                <xsl:when test="(. = 'frm') or (lower-case(.) = 'mittelfranzösisch') ">fre</xsl:when>
                <xsl:when test="(. = 'nds') or (lower-case(.) = 'niederdeutsch') ">deu</xsl:when>
                <xsl:otherwise>und</xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_011at">
        <xsl:text>011@ $a</xsl:text>
        <xsl:variable name="norm_origDate">
            <xsl:copy-of select="descendant-or-self::tei:msDesc/tei:head/tei:index[@indexName = 'norm_origDate'][tei:term[@type = 'origDate'][. != '']]"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$norm_origDate[not(tei:index[2])]">
                <xsl:choose>
                    <xsl:when test="$norm_origDate[descendant::tei:term[@type = 'origDate_notBefore'] = descendant::tei:term[@type = 'origDate_notAfter']]">
                        <xsl:value-of select="$norm_origDate/descendant::tei:term[@type = 'origDate_notBefore']"/>
                    </xsl:when>
                    <xsl:when test="$norm_origDate[descendant::tei:term[@type = 'origDate_notBefore']/substring(., 1, 3) = descendant::tei:term[@type = 'origDate_notAfter']/substring(., 1, 3)]">
                        <xsl:value-of select="$norm_origDate/descendant::tei:term[@type = 'origDate_notBefore']/substring(., 1, 3)"/>
                        <xsl:text>X</xsl:text>
                    </xsl:when>
                    <xsl:when test="$norm_origDate[number(descendant::tei:term[@type = 'origDate_notBefore']/substring(., 1, 2)) = number(descendant::tei:term[@type = 'origDate_notAfter']/substring(., 1, 2)) - 1]">
                        <xsl:value-of select="$norm_origDate/descendant::tei:term[@type = 'origDate_notBefore']/substring(., 1, 2)"/>
                        <xsl:text>XX</xsl:text>
                    </xsl:when>
                    <xsl:when test="$norm_origDate[descendant::tei:term[@type = 'origDate_notBefore']/substring(., 1, 2) = descendant::tei:term[@type = 'origDate_notAfter']/substring(., 1, 2)]">
                        <xsl:value-of select="$norm_origDate/descendant::tei:term[@type = 'origDate_notBefore']/substring(., 1, 2)"/>
                        <xsl:text>XX</xsl:text>
                    </xsl:when>
                    <xsl:when test="$norm_origDate[descendant::tei:term[@type = 'origDate_notBefore']/substring(., 1, 1) = descendant::tei:term[@type = 'origDate_notAfter']/substring(., 1, 1)]">
                        <xsl:value-of select="$norm_origDate/descendant::tei:term[@type = 'origDate_notBefore']/substring(., 1, 1)"/>
                        <xsl:text>XXX</xsl:text>
                    </xsl:when>
                    <xsl:when test="$norm_origDate[descendant::tei:term[@type = 'origDate_notBefore']/substring(., 1, 1) = '0'
                        and descendant::tei:term[@type = 'origDate_notAfter']/substring(., 1, 1) = '1']">
                        <xsl:text>1XXX</xsl:text>
                    </xsl:when>
                    <xsl:when test="$norm_origDate[descendant::tei:term[@type = 'origDate_notBefore']/substring(., 1, 1) = '1'
                        and descendant::tei:term[@type = 'origDate_notAfter']/substring(., 1, 1) = '2']">
                        <xsl:text>1XXX</xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:text>$n</xsl:text>
                <xsl:value-of select="$norm_origDate/descendant::tei:term[@type='origDate']"/>
            </xsl:when>
            <xsl:when test="$norm_origDate != ''">
                <xsl:choose>
                    <xsl:when test="$norm_origDate/tei:index[
                        tei:term[@type='origDate_notBefore'][starts-with(., '0')]
                        and tei:term[@type='origDate_notAfter'][starts-with(., '0')]]">
                        <xsl:text>0XXX</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>1XXX</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>$n</xsl:text>
                <xsl:for-each select="$norm_origDate/descendant::tei:term[@type='origDate']">
                    <xsl:if test="ancestor::tei:index/preceding-sibling::tei:index"><xsl:text>, </xsl:text></xsl:if>
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>$a1XXX$n[Entstehungsdatum nicht ermittelbar]</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$crlf"/>
        
    </xsl:template>
    <xsl:template name="write_013D">
        <xsl:text>013D $910457187X</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_017G">
        <xsl:text>017G $u</xsl:text>
        <xsl:value-of select="descendant::tei:ptr[@type = 'purl'][@subtype = 'hsp']/@target"/>
        <xsl:text>$3Ausführliche Beschreibung</xsl:text>
        <xsl:text>$503</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_021A">
        <xsl:text>021A $a</xsl:text>
        <xsl:value-of select="descendant::tei:msDesc/tei:msIdentifier/concat(tei:settlement, ', ', tei:repository, ', ', normalize-space(tei:idno))"/>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName='norm_title']/tei:term[@type='title'][. != '']">
            <xsl:text>$d</xsl:text>
            <xsl:value-of select="descendant::tei:msDesc/tei:head/tei:index[@indexName='norm_title']/tei:term[@type='title']"/>
        </xsl:if>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_034D">
        <xsl:text>034D $a</xsl:text>
        <xsl:value-of select="translate(descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_measure']/tei:term[@type = 'measure'], '*', '')"/>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_034I">
        <xsl:text>034I $a</xsl:text>
        <xsl:choose>
            <xsl:when test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_dimensions']/tei:term[@type = 'dimensions'][not(starts-with(., '\d'))]">
                <xsl:for-each select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_dimensions']">
                    <xsl:value-of select="tei:term[@type = 'height']"/>
                    <xsl:text> × </xsl:text>
                    <xsl:value-of select="tei:term[@type = 'width']"/>
                    <xsl:text> cm</xsl:text>
                    <xsl:if test="following-sibling::tei:index[@indexName = 'norm_dimensions']"><xsl:text>, </xsl:text></xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_dimensions']/tei:term[@type = 'dimensions']"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_034M">
        <xsl:text>034M $aBuchschmuck</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_037A">
        <xsl:text>037A $aEnthält Musiknotation</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_037N">
        <xsl:text>037N </xsl:text>
        <xsl:text>$a</xsl:text>
        <xsl:value-of select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_material']/tei:term[@type = 'material']"/>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_037P">
        <xsl:text>037P </xsl:text>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_form']/tei:term[@type = 'form'][. != '']">
            <xsl:text>$eTypus: </xsl:text>
            <xsl:value-of select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_form']/tei:term[@type = 'form']"/>
        </xsl:if>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_origPlace']/tei:term[@type = 'origPlace'][. != '']">
            <xsl:text>$pProvenienz: </xsl:text>
            <xsl:value-of select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_origPlace']/tei:term[@type = 'origPlace']"/>
        </xsl:if>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_039I">
        <xsl:for-each select="descendant::tei:ref[@type='manifest']">
            <xsl:text>039I $iElektronische Reproduktion$9</xsl:text>
            <xsl:value-of select="tokenize(@target, '/')[5]"/>
            <xsl:value-of select="$crlf"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="write_209A">
        <xsl:choose>
            <xsl:when test="contains(normalize-space(descendant::tei:msDesc/tei:msIdentifier/tei:idno), 'Aufbewahrungsort: Krakau, Jagiellonen-Bibliothek')">
                <xsl:text>209A/01 $f8$a</xsl:text>
                <xsl:value-of select="normalize-space(descendant::tei:msDesc/tei:msIdentifier/tei:idno)"/>
                <xsl:text>$dz$x00</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>209A/01 $f1:HSM$a</xsl:text>
                <xsl:value-of select="descendant::tei:msDesc/tei:msIdentifier/tei:idno"/>
                <xsl:text>$di</xsl:text>
                <xsl:text>$x00</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_237A">
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_status']/tei:term[@type = 'status'][. != '' and . != 'existent']">
            <xsl:text>237A/01 $a</xsl:text>
            <xsl:choose>
                <xsl:when test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_status']/tei:term[@type = 'status'][. = 'missing']">
                    <xsl:text>verschollen</xsl:text>
                </xsl:when>
                <xsl:when test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_status']/tei:term[@type = 'status'][. = 'destroyed']">
                    <xsl:text>zerstört</xsl:text>
                </xsl:when>
                <xsl:when test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_status']/tei:term[@type = 'status'][. = 'dismembered']">
                    <xsl:text>zerteilt</xsl:text>
                </xsl:when>
                <xsl:when test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_status']/tei:term[@type = 'status'][. = 'displaced']">
                    <xsl:text>disloziert</xsl:text>
                </xsl:when>
                <xsl:when test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_status']/tei:term[@type = 'status'][. = 'unknown']">
                    <xsl:text>unbekannt</xsl:text>
                </xsl:when>
            </xsl:choose>
            <xsl:value-of select="$crlf"/>
        </xsl:if>
    </xsl:template>
    <xsl:template name="write_220B">
        <xsl:text>220B/01 $aRecordLastModified-HSP:</xsl:text>
        <xsl:choose>
            <xsl:when test="descendant::tei:revisionDesc/tei:change/tei:date">
                <xsl:value-of select="descendant::tei:revisionDesc/tei:change/tei:date"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/></xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    
    <xsl:template name="write_208at">
        <xsl:text>208@/01 $br</xsl:text>
        <xsl:value-of select="$crlf"/>
        <xsl:call-template name="write_209A"/>
        <xsl:call-template name="write_237A"/>
        <xsl:call-template name="write_220B"/>
    </xsl:template>
    
    <xsl:template match="tei:index[@indexName = 'norm_origDate']">
        <xsl:choose>
            <xsl:when test="tei:term[@type = 'origDate_type'] = 'dated' ">
                <xsl:value-of select="tei:term[@type = 'origDate_notBefore']"/>
                <xsl:text>$b</xsl:text>
                <xsl:value-of select="tei:term[@type = 'origDate_notAfter']"/>
                <xsl:text>$n</xsl:text>
                <xsl:value-of select="tei:term[@type = 'origDate']"/>
            </xsl:when>
            <xsl:when test="tei:term[@type = 'origDate_notBefore'] = tei:term[@type = 'origDate_notAfter']">
                <xsl:value-of select="tei:term[@type = 'origDate_notBefore']"/>
            </xsl:when>
            <xsl:when test="substring(tei:term[@type = 'origDate_notBefore'], 1, 2) = substring(tei:term[@type = 'origDate_notAfter'], 1, 2)">
                <xsl:value-of select="concat(substring(tei:term[@type = 'origDate_notBefore'], 1, 2), 'XX$n[', tei:term[@type = 'origDate'], ']')"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
