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
        <xsl:call-template name="write_0000"/>
        <xsl:call-template name="write_0500"/>
        <xsl:choose>
            <xsl:when test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_origDate']/tei:term[@type = 'origDate'][. != '']">
                <xsl:call-template name="write_1100"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>1100 1XXX$n[s.a.]</xsl:text>
                <xsl:value-of select="$crlf"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="write_1131"/>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_textLang']/tei:term[@type = 'textLang-ID'][. != '']">
            <xsl:call-template name="write_1500"/>
        </xsl:if>
        <xsl:call-template name="write_2113"/>
        <xsl:call-template name="write_4000"/>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_measure']/tei:term[@type = 'measure'][. != '']">
            <xsl:call-template name="write_4060"/>
        </xsl:if>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_decoration']/tei:term[@type = 'decoration'][. != '']">
            <xsl:call-template name="write_4061"/>
        </xsl:if>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_dimensions']/tei:term[@type = 'dimensions'][. != '']">
            <xsl:call-template name="write_4062"/>
        </xsl:if>
        <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_material']/tei:term[@type = 'material'][. != '']
            or descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_form']/tei:term[@type = 'form'][. != '']
            or descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_origPlace']/tei:term[@type = 'origPlace'][. != '']">
            <xsl:call-template name="write_4277"/>
        </xsl:if>
        <xsl:call-template name="write_4961"/>
        <xsl:call-template name="write_E001"/>
        <xsl:value-of select="$crlf"/>
    </xsl:template>

    <xsl:template name="write_0000">
        <xsl:text>000K utf8</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_0500">
        <xsl:text>0500 Har</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_1100">
        <xsl:text>1100 </xsl:text>
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
    <xsl:template name="write_1131">
        <xsl:text>1131 !10457187X!</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_1500">
        <xsl:text>1500 </xsl:text>
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
    <xsl:template name="write_2113">
        <xsl:text>2113 HSP: </xsl:text>
        <xsl:value-of select="descendant::tei:ptr[@type = 'purl'][@subtype = 'hsp']/@xml:id"/>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_4000">
        <xsl:text>4000 </xsl:text>
        <xsl:value-of select="descendant::tei:msDesc/tei:msIdentifier/concat(tei:settlement, ', ', tei:repository, ', ', tei:idno)"/>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_4060">
        <xsl:text>4060 </xsl:text>
        <xsl:value-of select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_measure']/tei:term[@type = 'measure']"/>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_4061">
        <xsl:text>4061 [Buchschmuck vorhanden]</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_4062">
        <xsl:text>4062 </xsl:text>
        <xsl:value-of select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_dimensions']/tei:term[@type = 'dimensions']"/>
        <xsl:text> cm</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_4277">
        <xsl:text>4277 </xsl:text>
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
    <xsl:template name="write_4801">
        <!-- write status -->
        <xsl:text>4801 </xsl:text>
        <xsl:choose>
            <xsl:when test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_status']/tei:term[@type = 'status'][. != '']">
                <xsl:value-of select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_status']/tei:term[@type = 'status']"/>
            </xsl:when>
            <xsl:otherwise>existent</xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$crlf"/>
        <!-- write RecordLastModified -->
        <xsl:text>4801 RecordLastModified-HSP:</xsl:text>
        <xsl:choose>
            <xsl:when test="descendant::tei:revisionDesc/tei:change/tei:date">
                <xsl:value-of select="descendant::tei:revisionDesc/tei:change/tei:date"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="format-date(current-date(),'[Y]-[M]-[D]')"/></xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_4961">
        <xsl:text>4961 </xsl:text>
        <xsl:value-of select="descendant::tei:ptr[@type = 'purl'][@subtype = 'hsp']/@target"/>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    <xsl:template name="write_7100">
        <xsl:text>7100 $f1:HSM$a</xsl:text>
        <xsl:value-of select="descendant::tei:msDesc/tei:msIdentifier/tei:idno"/>
        <xsl:text>$di</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>
    
    <xsl:template name="write_E001">
        <xsl:text>E001 </xsl:text>
        <xsl:value-of select="format-date(current-date(),'[D]-[M]-[Y, 2-2]')"/>
        <xsl:text> : r</xsl:text>
        <xsl:value-of select="$crlf"/>
        <xsl:call-template name="write_4801"/>
        <xsl:call-template name="write_7100"/>
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
