<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs tei marc"
    version="3.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="tei:TEI">
        <xsl:element name="record" namespace="http://www.loc.gov/MARC21/slim">
            <xsl:attribute name="type" select=" 'Authority' "/>
            <xsl:element name="leader" namespace="http://www.loc.gov/MARC21/slim">00000nz  a2200000nc 4500</xsl:element>
            <xsl:element name="controlfield" namespace="http://www.loc.gov/MARC21/slim">
                <xsl:attribute name="tag" select=" '003' "/>
                <xsl:text>DE-629</xsl:text>
            </xsl:element>
            <xsl:call-template name="write_035"/>
            <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_textLang']/tei:term[@type = 'textLang-ID'][. != '']">
                <xsl:call-template name="write_041"/>
            </xsl:if>
            <xsl:call-template name="write_245"/>
            <xsl:call-template name="write_264"/>
            <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_measure']/tei:term[@type = 'measure'][. != '']
                or descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_format']/tei:term[@type = 'format'][. != '']
                or descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_decoration']/tei:term[@type = 'decoration'][. = 'yes']
                or descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_dimensions']/tei:term[@type = 'dimensions'][. != '']">
                <xsl:call-template name="write_300"/>
            </xsl:if>
            <xsl:call-template name="write_655"/>
            <xsl:call-template name="write_980"/>
        </xsl:element>
    </xsl:template>

    <!-- HSP-ID -->
    <xsl:template name="write_035">
        <xsl:element name="controlfield" namespace="http://www.loc.gov/MARC21/slim">
            <xsl:attribute name="tag" select=" '035' "/>
            <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
                <xsl:attribute name="code" select=" 'a' "/>
                <xsl:text>(DE-629)</xsl:text>
                <xsl:value-of select="descendant::tei:msDesc/@xml:id"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- Sprache -->
    <xsl:template name="write_041">
        <xsl:for-each select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_textLang']/tei:term[@type = 'textLang-ID']">
            <xsl:element name="controlfield" namespace="http://www.loc.gov/MARC21/slim">
                <xsl:attribute name="tag" select=" '041' "/>
                <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
                    <xsl:attribute name="code" select=" 'a' "/>
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
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <!-- Identifikation -->
    <xsl:template name="write_245">
        <xsl:element name="controlfield" namespace="http://www.loc.gov/MARC21/slim">
            <xsl:attribute name="tag" select=" '245' "/>
            <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
                <xsl:attribute name="code" select=" 'a' "/>
                <xsl:value-of select="descendant::tei:msDesc/tei:msIdentifier/concat(tei:settlement, ', ', tei:repository, ', ', tei:idno)"/>            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- Entstehungsdatum -->
    <xsl:template name="write_264">
        <xsl:element name="controlfield" namespace="http://www.loc.gov/MARC21/slim">
            <xsl:attribute name="tag" select=" '264' "/>
            <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
                <xsl:attribute name="code" select=" 'c' "/>
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
                    <xsl:when test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_origDate'][1][tei:term[@type = 'origDate'] != '']">
                        <xsl:text>abc</xsl:text>
                        <xsl:apply-templates select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_origDate'][1][. != '']"/>
                    </xsl:when>
                    <xsl:otherwise>1xxx</xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- Maße, Format, Buchschmuck, Größe -->
    <xsl:template name="write_300">
        <xsl:element name="controlfield" namespace="http://www.loc.gov/MARC21/slim">
            <xsl:attribute name="tag" select=" '300' "/>
            <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_measure']/tei:term[@type = 'measure'][. != '']
                or descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_format']/tei:term[@type = 'format'][. != '']">
                <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
                    <xsl:attribute name="code" select=" 'a' "/>
                    <xsl:value-of select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_measure']/tei:term[@type = 'measure']"/>
                    <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_measure']/tei:term[@type = 'measure'][. != '']
                        and descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_format']/tei:term[@type = 'format'][. != '']">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_format']/tei:term[@type = 'format']"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_decoration']/tei:term[@type = 'decoration'][. = 'yes']">
                <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
                    <xsl:attribute name="code" select=" 'b' "/>
                    <xsl:text>yes</xsl:text>
                </xsl:element>
            </xsl:if>
            <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_dimensions']/tei:term[@type = 'dimensions'][. != '']">
                <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
                    <xsl:attribute name="code" select=" 'c' "/>
                    <xsl:value-of select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_dimensions']/tei:term[@type = 'dimensions']"/>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <!-- Formtyp -->
    <xsl:template name="write_655">
        <xsl:element name="controlfield" namespace="http://www.loc.gov/MARC21/slim">
            <xsl:attribute name="tag" select=" '655' "/>
            <xsl:choose>
                <xsl:when test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_form']/tei:term[@type = 'form'][. = 'codex' ]">
                    <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
                        <xsl:attribute name="code" select=" 'a' "/>
                        <xsl:text>Handschrift</xsl:text>
                    </xsl:element>
                    <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
                        <xsl:attribute name="code" select=" '0' "/>
                        <xsl:text>(DE-588)4023287-6</xsl:text>
                    </xsl:element>
                    <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
                        <xsl:attribute name="code" select=" '0' "/>
                        <xsl:text>(DE-627)10457187X</xsl:text>
                    </xsl:element>
                    <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
                        <xsl:attribute name="code" select=" '0' "/>
                        <xsl:text>(DE-576)208948376</xsl:text>
                    </xsl:element>
                    <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
                        <xsl:attribute name="code" select=" '2' "/>
                        <xsl:text>gnd-content</xsl:text>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
                        <xsl:attribute name="code" select=" 'a' "/>
                        <xsl:value-of select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_form']/tei:term[@type = 'form']"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <!-- Exemplarebene -->
    <xsl:template name="write_980">
        <xsl:element name="controlfield" namespace="http://www.loc.gov/MARC21/slim">
            <xsl:attribute name="tag" select=" '980' "/>
            <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
                <xsl:attribute name="code" select=" 'f' "/>
                <xsl:text>1:HSM</xsl:text>
            </xsl:element>
            <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
                <xsl:attribute name="code" select=" 'd' "/>
                <xsl:value-of select="descendant::tei:msDesc/tei:msIdentifier/tei:idno"/>
            </xsl:element>
            <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
                <xsl:attribute name="code" select=" 'e' "/>
                <xsl:text>i</xsl:text>
            </xsl:element>
            <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
                <xsl:attribute name="code" select=" 'k' "/>
                <xsl:choose>
                    <xsl:when test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_status']/tei:term[@type = 'status'][. != '']">
                        <xsl:value-of select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_status']/tei:term[@type = 'status']"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>vorhanden</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_status']/tei:term[@type = 'status'][. != '']">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:element>
        </xsl:element>
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
