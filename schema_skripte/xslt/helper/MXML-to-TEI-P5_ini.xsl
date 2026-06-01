<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:ckm="http://handschriftenportal.de/ckm"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:h1="http://www.startext.de/HiDA/DefService/XMLSchema"
    xmlns:h2="katneu4-2009-12-richedit-illum-neu.xml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:rtftools="http://www.startext.de/rtftools"
    xmlns:sbbfunc="http://dev.sbb.berlin/sbb"
    exclude-result-prefixes="#all"
    version="3.0">

    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:variable name="crlf" select=" '&#x000A;' "/>
    <xsl:param name="toBeReplaced">&apos;&quot;</xsl:param>
    <xsl:param name="replacedBy">&apos;&apos;</xsl:param>
    <xsl:variable name="initien">
        <xsl:for-each select="collection('../../../nachweis_daten/3_0_Produktion?select=^02_*.xml;recurse=yes')">
            <xsl:copy-of select="//h1:Field[ @Type = '5650' ][ @Value = 'Initium' ][h1:Field[ 
                (@Type = '5666d') or 
                (@Type = '5666l') or 
                (@Type = '5666g') or 
                (@Type = '5666v' and following-sibling::h1:Field[ @Type = '5680' ][ (@Value != 'polabisch') and (@Value != 'Geheimsprache') ]) or
                (@Type = '5686' and following-sibling::h1:Field[ @Type = '5680' ])
                ]]"/>
            <xsl:copy-of select="//h1:Field[ @Type = '1800' ]"/>
            <xsl:copy-of select="//h1:Field[ @Type = '1802' ]"/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:call-template name="writeTTLfile"/>
        <!-- write csv-Datei mit Initien ohne Sprache -->
        <xsl:result-document href="../../../nachweis_daten/1_0_Normdaten/1_4_Themenbereiche/Initien_ohneSprache.csv">
            <xsl:for-each select="collection('../../../nachweis_daten/3_0_Produktion?select=^02_*.xml;recurse=yes')//h1:Field[
                (@Type = '5666v' and not(following-sibling::h1:Field[ @Type = '5680' ])) or
                (@Type = '5666v' and preceding-sibling::h1:Field[starts-with(@Type, '5666')] and not(following-sibling::h1:Field[ @Type = '5680' ])) or
                (@Type = '1804')
                ]">
                <xsl:sort select="@Value"/>
                <xsl:value-of select="concat('&quot;', @Type, '&quot;;&quot;', @Value, '&quot;', $crlf)"/>
            </xsl:for-each>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="selectEntries">
        <xsl:for-each-group select="$initien//h1:Field[ 
            (@Type = '5666l') or (@Type = '1800') or 
            (@Type = '5666d') or (@Type = '1802') or 
            (@Type = '5666g') or 
            ((@Type = '5666v') and not(preceding-sibling::h1:Field[starts-with(@Type, '5666')])) or  
            ((@Type = '5686') and not(preceding-sibling::h1:Field[starts-with(@Type, '5666')]))
            ][ 
            (@Value != '') and 
            (@Value != '*') and 
            (@Value != '-') and 
            (@Value != '.') and 
            not(contains(@Value, '(')) and 
            not(contains(@Value, ')')) and 
            not(contains(@Value, '[')) and 
            not(contains(@Value, ']')) and 
            not(contains(@Value, ' - ')) and 
            not(contains(@Value, ' – ')) and 
            not(contains(@Value, ' — ')) and 
            not(contains(@Value, '&amp;')) and 
            not(matches(@Value, '^\p{L}+, [\p{L} ]+ [\.\-&#x2013;&#x2026;]+ [A-Z]')) and 
            not(matches(@Value, '^\s*\.[. ]+')) and 
            not(matches(@Value, '^\s*&#x2026;')) and 
            not(matches(@Value, '\s*\.[. ]+\s*-?\s*$')) and 
            not(matches(@Value, '\s*&#x2026;\s*$'))
            ]" 
            group-by="normalize-space(
            translate(
            replace(
            replace(
            replace(
            translate(@Value, $toBeReplaced, ''),
            '\s*\.(\s*\.\s*)+', ' &#x2026; '),
            '\s*/s*', ' '),
            '-/-', '&#x2013;'),
            '/()[]+*‛’‚‘&lt;&gt;-∥', '')
            )">
            <xsl:sort select="current-grouping-key()"/>
            <xsl:call-template name="writeEntries"/>
        </xsl:for-each-group>
        
        <xsl:for-each-group select="$initien//h1:Field[ 
            (@Type = '5666l') or (@Type = '1800') or 
            (@Type = '5666d') or (@Type = '1802') or 
            (@Type = '5666g') or 
            ((@Type = '5666v') and not(preceding-sibling::h1:Field[starts-with(@Type, '5666')])) or  
            ((@Type = '5686') and not(preceding-sibling::h1:Field[starts-with(@Type, '5666')]))
            ][ 
            (@Value != '') and 
            (@Value != '*') and 
            (@Value != '-') and 
            (@Value != '.') and 
            not(contains(@Value, '(')) and 
            not(contains(@Value, ')')) and 
            not(contains(@Value, '[')) and 
            not(contains(@Value, ']')) and 
            not(contains(@Value, ' - ')) and 
            not(contains(@Value, ' – ')) and 
            not(contains(@Value, ' — ')) and 
            not(contains(@Value, '&amp;')) and 
            not(matches(@Value, '^\p{L}+, [\p{L} ]+ [\.\-&#x2013;&#x2026;]+ [A-Z]')) and 
            not(matches(@Value, '^\s*\.[. ]+')) and 
            not(matches(@Value, '^\s*&#x2026;')) and 
            (
            matches(@Value, '\s*\.[. ]+\s*-?\s*$') or 
            matches(@Value, '\s*&#x2026;\s*$')
            )
            ][ 
            not(matches(@Value, '\s*\.[. ]+\s*-?\s*.*?\s*\.[. ]+\s*-?\s*$')) and 
            not(matches(@Value, '\s*&#x2026;\s*.*?\s*&#x2026;\s*$'))
            ]" 
            group-by="normalize-space(
            translate(
            replace(
            replace(
            replace(
            translate(@Value, $toBeReplaced, ''),
            '\s*\.(\s*\.\s*)+', ' &#x2026; '),
            '\s*/s*', ' '),
            '--', '&#x2013;'),
            '()[]+*‛’‚‘&lt;&gt;-∥&#x2026;', '')
            )">
            <xsl:sort select="current-grouping-key()"/>
            <xsl:call-template name="writeEntries"/>
        </xsl:for-each-group>
    </xsl:template>

    <xsl:template name="writeEntries">
        <!-- write UUID -->
        <xsl:value-of select="concat('hspi:', sbbfunc:generate-guid('NORM-', current-grouping-key()), ' a hspo:Initium ;', $crlf)"/>
        <!-- write text -->
        <xsl:value-of select="concat('schema:text &quot;', current-grouping-key(), '&quot; ;', $crlf)"/>
        <!-- write alternativeText -->
        <xsl:if test="normalize-space(@Value) != current-grouping-key()">
            <xsl:value-of select="concat('hspo:alternativeText &quot;', 
                normalize-space(
                translate(
                translate(@Value, $toBeReplaced, $replacedBy),
                '&lt;&gt;', '&#x2039;&#x203A;')
                )
                , '&quot; ;', $crlf)"/>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="(@Type = '5666l') or (@Type = '1800')">
                <xsl:call-template name="writeLanguage"><xsl:with-param name="value" select="'lateinisch'"/></xsl:call-template>
                <xsl:text> .</xsl:text>
            </xsl:when>
            <xsl:when test="(@Type = '5666d') or (@Type = '1802')">
                <xsl:call-template name="writeLanguage"><xsl:with-param name="value" select="'deutsch'"/></xsl:call-template>
                <xsl:text> .</xsl:text>
            </xsl:when>
            <xsl:when test="(@Type = '5666g')">
                <xsl:call-template name="writeLanguage"><xsl:with-param name="value" select="'griechisch'"/></xsl:call-template>
                <xsl:text> .</xsl:text>
            </xsl:when>
            <xsl:when test="((@Type = '5666v') or (@Type = '5686')) and not(contains(following-sibling::h1:Field[ @Type = '5680']/@Value, ' '))">
                <xsl:call-template name="writeLanguage"><xsl:with-param name="value" select="lower-case(following-sibling::h1:Field[ @Type = '5680']/@Value)"/></xsl:call-template>
                <xsl:text> .</xsl:text>
            </xsl:when>
            <xsl:when test="((@Type = '5666v') or (@Type = '5686')) and contains(following-sibling::h1:Field[ @Type = '5680']/@Value, ' ')">
                <xsl:for-each select="tokenize(following-sibling::h1:Field[ @Type = '5680']/@Value, ' ')[ends-with(normalize-space(.), 'isch')]">
                    <xsl:call-template name="writeLanguage"><xsl:with-param name="value" select="normalize-space(.)"/></xsl:call-template>
                    <xsl:if test="not(position() = last())">
                        <xsl:text> ;</xsl:text>
                        <xsl:value-of select="$crlf"/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:text> .</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>Initium "<xsl:value-of select="@Value"/>" wird nicht verarbeitet</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$crlf"/>
        <xsl:value-of select="$crlf"/>
    </xsl:template>

    <xsl:template name="writeLanguage">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, 'arabisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-c582dec9-43ff-3b74-baa0-691df291cea6' "/></xsl:when>
            <xsl:when test="contains($value, 'dänisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-5ca2aa84-5c8c-35ac-a6b0-16841f100d82' "/></xsl:when>
            <xsl:when test="contains($value, 'deutsch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-5f02f088-9301-3d7b-a1ac-972c11bf3e7d' "/></xsl:when>
            <xsl:when test="contains($value, 'englisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-9cfefed8-fb94-37ba-a5cd-519d7d2bb5d7' "/></xsl:when>
            <xsl:when test="contains($value, 'französisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-82a9e4d2-6595-387a-b6e4-42391d8c5bba' "/></xsl:when>
            <xsl:when test="contains($value, 'griechisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-124c5435-5f39-3f0d-9b0f-653d105340b3' "/></xsl:when>
            <xsl:when test="contains($value, 'hebräisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-6f96cfdf-e5cc-3627-8adf-24b41725caa4' "/></xsl:when>
            <xsl:when test="contains($value, 'italienisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-0d149b90-e739-3297-b01c-90191ae775f0' "/></xsl:when>
            <xsl:when test="contains($value, 'katalanisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-5435c69e-d3bc-35b2-a4d5-80e393e373d3' "/></xsl:when>
            <xsl:when test="contains($value, 'kirchenslawisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-a4dbfd6a-ef3b-3045-be61-aa0146debdf8' "/></xsl:when>
            <xsl:when test="contains($value, 'kroatisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-12f367df-b34d-38dd-820d-530e29b6c89c' "/></xsl:when>
            <xsl:when test="contains($value, 'lateinisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-c9089f3c-9ada-3018-af6f-fb1ee8d6501c' "/></xsl:when>
            <xsl:when test="contains($value, 'niederländisch') or contains($value, 'holländisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-1a13105b-7e4e-35fb-ae7c-9515ac06aa48' "/></xsl:when>
            <xsl:when test="contains($value, 'niederrheinisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-5f02f088-9301-3d7b-a1ac-972c11bf3e7d' "/></xsl:when>
            <xsl:when test="contains($value, 'polnisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-28840420-4e3d-3522-a930-8317344a285d' "/></xsl:when>
            <xsl:when test="contains($value, 'portugiesisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-fc9fdf08-4e29-3f26-a270-390dc49061a2' "/></xsl:when>
            <xsl:when test="contains($value, 'rheinmaasländisch')"><xsl:value-of select="concat('dct:language hspnorm:NORM-5f02f088-9301-3d7b-a1ac-972c11bf3e7d', 
                    ' ;', $crlf, 'dct:language hspnorm:NORM-1a13105b-7e4e-35fb-ae7c-9515ac06aa48')"/></xsl:when>
            <xsl:when test="contains($value, 'rumänisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-3605c251-087b-3821-ac9b-ca890e07ad9c' "/></xsl:when>
            <xsl:when test="contains($value, 'russisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-89484b14-b36a-3d53-a942-6a3d944d2983' "/></xsl:when>
            <xsl:when test="contains($value, 'serbokroatisch')"><xsl:value-of select=" concat('dct:language hspnorm:NORM-62a165d5-9f8d-3f42-a2df-5f3c5aed8a2f', 
                    ' ;', $crlf, 'dct:language hspnorm:NORM-12f367df-b34d-38dd-820d-530e29b6c89c')"/></xsl:when>
            <xsl:when test="contains($value, 'schwedisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-74354112-1c12-3113-af80-7d1582c74bea' "/></xsl:when>
            <xsl:when test="contains($value, 'slowenisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-06a9ad3b-b612-3f43-8d91-f827a3ac1f90' "/></xsl:when>
            <xsl:when test="contains($value, 'spanisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-12470fe4-06d4-3017-996e-ab37dd65fc14' "/></xsl:when>
            <xsl:when test="contains($value, 'tschechisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-95cc64dd-2825-39df-93ec-4ad683ecf339' "/></xsl:when>
            <xsl:when test="contains($value, 'türkisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-e7d707a2-6e7f-3b6f-b52c-489c60e429b1' "/></xsl:when>
            <xsl:when test="contains($value, 'ukrainisch')"><xsl:value-of select=" 'dct:language hspnorm:NORM-18bd9197-cb1d-333b-8352-f47535c00320' "/></xsl:when>
            <xsl:otherwise><xsl:message>Sprachangabe "<xsl:value-of select="$value"/>" wird nicht verarbeitet</xsl:message></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="writeTTLfile">
        <xsl:result-document href="../../../nachweis_daten/1_0_Normdaten/1_4_Themenbereiche/Initien.ttl">
            <xsl:text disable-output-escaping="yes">@prefix rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt; .
@prefix xsd: &lt;http://www.w3.org/2001/XMLSchema#&gt; .
@prefix owl: &lt;http://www.w3.org/2002/07/owl#&gt; .
@prefix rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt; .
@prefix dct: &lt;http://purl.org/dc/terms/&gt; .
@prefix schema: &lt;https://schema.org/&gt; .
@prefix hspi: &lt;https://normdaten.staatsbibliothek-berlin.de/hsp/initia/&gt; .
@prefix hspv: &lt;https://normdaten.staatsbibliothek-berlin.de/hsp/vocabulary/&gt; .
@prefix hspo: &lt;https://normdaten.staatsbibliothek-berlin.de/hsp/ontology/&gt; .
@prefix hspnorm: &lt;https://normdaten.staatsbibliothek-berlin.de/hsp/authority-file/&gt; .

</xsl:text>
            <xsl:call-template name="selectEntries"/>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>