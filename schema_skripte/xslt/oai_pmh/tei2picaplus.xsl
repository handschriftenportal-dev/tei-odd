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
        <xsl:call-template name="write_000U"/>
        <xsl:call-template name="write_002at"/>
        <xsl:call-template name="write_006X"/>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_textLang']/tei:term[@type = 'textLang-ID'][. != '']">
            <xsl:call-template name="write_010at"/>
        </xsl:if>
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
        <xsl:call-template name="write_017H"/>
        <xsl:call-template name="write_021A"/>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_measure']/tei:term[@type = 'measure'][. != '']">
            <xsl:call-template name="write_034D"/>
        </xsl:if>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_dimensions']/tei:term[@type = 'dimensions'][. != '']">
            <xsl:call-template name="write_034I"/>
        </xsl:if>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_decoration']/tei:term[@type = 'decoration'][. != '']">
            <xsl:call-template name="write_034M"/>
        </xsl:if>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_musicNotation']/tei:term[@type = 'musicNotation'][. != '']">
            <xsl:call-template name="write_037A"/>
        </xsl:if>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_material']/tei:term[@type = 'material'][. != '']
            or descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_form']/tei:term[@type = 'form'][. != '']
            or descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_origPlace']/tei:term[@type = 'origPlace'][. != '']">
            <xsl:call-template name="write_037P"/>
        </xsl:if>
        <xsl:if test="descendant::tei:orgName[@type='digitizing'] = 'Staatsbibliothek zu Berlin' ">
            <xsl:call-template name="write_039D"/>
        </xsl:if>
        <xsl:call-template name="write_208at"/>
        <xsl:value-of select="$crlf"/>
    </xsl:template>

    <xsl:template name="write_000U">
        <xsl:text>000U $0utf8</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_002at">
        <xsl:text>002@ $0Har</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_006X">
        <xsl:text>006X $iHSP$0</xsl:text>
        <xsl:value-of select="descendant::tei:msDesc/@xml:id"/>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_010at">
        <xsl:text>010@ $a</xsl:text>
        <xsl:for-each select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_textLang']/tei:term[@type = 'textLang-ID']">
            <xsl:if test="preceding-sibling::tei:term[@type = 'textLang-ID']">
                <xsl:text>$a</xsl:text>
            </xsl:if>
            <xsl:choose>
                <xsl:when test=". = 'de' ">ger</xsl:when>
                <xsl:when test=". = 'el' ">ell</xsl:when>
                <xsl:when test=". = 'en' ">eng</xsl:when>
                <xsl:when test=". = 'es' ">spa</xsl:when>
                <xsl:when test=". = 'fr' ">fre</xsl:when>
                <xsl:when test=". = 'gr' ">grc</xsl:when>
                <xsl:when test=". = 'he' ">heb</xsl:when>
                <xsl:when test=". = 'it' ">ita</xsl:when>
                <xsl:when test=". = 'la' ">lat</xsl:when>
                <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_011at">
        <xsl:text>011@ $a</xsl:text>
        <xsl:choose>
            <xsl:when test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_origDate'][tei:term[@type = 'origDate_type'] = 'dated']">
                <xsl:value-of select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_origDate']"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="m">
                    <xsl:for-each-group select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_origDate']/tei:term[@type = 'origDate_notBefore'][. != '']" group-by="substring(., 1, 1)">
                        <xsl:value-of select="current-grouping-key()"/>
                    </xsl:for-each-group>
                </xsl:variable>
                <xsl:variable name="c">
                    <xsl:for-each-group select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_origDate']/tei:term[@type = 'origDate_notBefore'][. != '']" group-by="substring(., 1, 2)">
                        <xsl:value-of select="current-grouping-key()"/>
                    </xsl:for-each-group>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="string-length($m) = 1 and string-length($c) gt 2">
                        <xsl:value-of select="substring(descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_origDate'][1][. != '']/tei:term[@type = 'origDate_notBefore'], 1, 1)"/>
                        <xsl:text>XXX</xsl:text>
                    </xsl:when>
                    <xsl:when test="string-length($m) = 1 and string-length($c) = 2">
                        <xsl:value-of select="substring(descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_origDate'][1][. != '']/tei:term[@type = 'origDate_notBefore'], 1, 2)"/>
                        <xsl:text>XX</xsl:text>
                    </xsl:when>
                    <xsl:when test="string-length($m) gt 1 and contains($m, '0')"><xsl:text>0XXX</xsl:text></xsl:when>
                    <xsl:when test="string-length($m) gt 1 and contains($m, '1')"><xsl:text>1XXX</xsl:text></xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_origDate']"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>$n[Entstehungsdatum nicht ermittelbar]</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_013D">
        <xsl:text>013D $910457187X</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_017H">
        <xsl:text>017H $u</xsl:text>
        <xsl:value-of select="descendant::tei:ptr[@type = 'purl'][@subtype = 'hsp']/@target"/>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_021A">
        <xsl:text>021A $a</xsl:text>
        <xsl:value-of select="descendant::tei:msDesc/tei:msIdentifier/concat(tei:settlement, ', ', tei:repository, ', ', tei:idno)"/>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_034D">
        <xsl:text>034D $a</xsl:text>
        <xsl:value-of select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_measure']/tei:term[@type = 'measure']"/>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_034I">
        <xsl:text>034I $a</xsl:text>
        <xsl:value-of select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_dimensions']/tei:term[@type = 'dimensions']"/>
        <xsl:text> cm</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_034M">
        <xsl:text>034M $a[Buchschmuck vorhanden]</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_037A">
        <xsl:text>037A $a[Enthält Musiknotation]</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_037P">
        <xsl:text>037P </xsl:text>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_form']/tei:term[@type = 'form'][. != '']">
            <xsl:text>$eTypus: </xsl:text>
            <xsl:value-of select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_form']/tei:term[@type = 'form']"/>
        </xsl:if>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_material']/tei:term[@type = 'material'][. != '']">
            <xsl:text>$mZustand: </xsl:text>
            <xsl:value-of select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_material']/tei:term[@type = 'material']"/>
        </xsl:if>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_origPlace']/tei:term[@type = 'origPlace'][. != '']">
            <xsl:text>$pProvenienz: </xsl:text>
            <xsl:value-of select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_origPlace']/tei:term[@type = 'origPlace']"/>
        </xsl:if>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_039D">
        <xsl:text>039D $iErscheint auch als$nDigitalisierte Ausg.$9</xsl:text>
        <xsl:value-of select="tokenize(descendant::tei:ref[@type='manifest']/@target, '/')[5]"/>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_209A">
        <xsl:choose>
            <xsl:when test="contains(descendant::tei:msDesc/tei:msIdentifier/tei:idno, 'Aufbewahrungsort: Krakau, Jagiellonen-Bibliothek')">
                <xsl:text>209A/01 $aKriegsbedingt verlagert</xsl:text>
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
