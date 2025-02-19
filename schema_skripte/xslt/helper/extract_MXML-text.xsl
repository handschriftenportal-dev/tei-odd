<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:ckm="http://handschriftenportal.de/ckm"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:h1="http://www.startext.de/HiDA/DefService/XMLSchema"
    xmlns:h2="katneu4-2009-12-richedit-illum-neu.xml"
    xmlns:rtftools="http://www.startext.de/rtftools"
    extension-element-prefixes="saxon"
    exclude-result-prefixes="#all">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:preserve-space elements="text"/>

    <xsl:variable name="crlf" select=" '&#x000A;' "/>

    <xsl:template match="h1:Block[ not(@Type = 'obj') ]"><xsl:apply-templates/></xsl:template>
    <xsl:template match="h1:Field[h1:Field]">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(ancestor::h1:Block[1]/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:value-of select="concat('_', @Type)"/>
                <xsl:value-of select="concat('[', count(preceding-sibling::h1:Field[@Type = current()/@Type]) +1, ']')"/>
            </xsl:attribute>
            <xsl:attribute name="indexName">
                <xsl:choose>
                    <xsl:when test="not(@Value) or (@Value = '')">unk</xsl:when>
                    <xsl:when test="@Value != '' ">
                        <xsl:value-of select="translate(replace(replace(replace(replace(normalize-space(@Value), ' &amp; ', '_'), ' &amp;', ''), ' / ', '-'), '\p{P}', ''), ' \(\)\[\]\?&lt;&gt;=', '-')"/>
                    </xsl:when>
                    <xsl:otherwise>unk</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[parent::h1:Field][not(@Type = '599e')]">
        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element>
    </xsl:template>

    <xsl:template match="/">
        <xsl:for-each select="//doc/@href">
            <xsl:variable name="contents" select="doc(.)"/>
            <xsl:result-document href="{concat('../nachweis_daten/_MXML-to-text/', substring-before(tokenize(., '/')[last()],'.xml'), '_text.xml')}">
                <xsl:element name="teiCorpus" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="teiHeader" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="fileDesc" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:element name="titleStmt" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:text>Extrahierter Volltext</xsl:text>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="publicationStmt" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:element name="publisher" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
                                        <xsl:attribute name="type" select=" 'org' "/>
                                        <xsl:text>Handschriftenportal</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="sourceDesc" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:text>Automatisch extrahierter Volltext aus einem MXML-Dokument.</xsl:text>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:for-each select="$contents/descendant::h1:Document">
                        <xsl:apply-templates select="descendant::h1:Block[ @Type = 'obj' ][h1:Field[ @Type = 'bezsoz' ][ @Value = 'Verwaltung' ]]"/>
                    </xsl:for-each>
                </xsl:element>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="h1:Block[ @Type = 'obj' ][h1:Field[ @Type = 'bezsoz' ][ @Value = 'Verwaltung' ]]">
        <xsl:element name="TEI" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="teiHeader" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="fileDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="titleStmt" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:text>Extrahierter Volltext</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="publicationStmt" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="publisher" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="type" select=" 'org' "/>
                                <xsl:text>Handschriftenportal</xsl:text>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="sourceDesc" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:text>Automatisch extrahierter Volltext aus einem MXML-Dokument.</xsl:text>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="text" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="body" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="div" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '599e' ]">
        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select="@Type"/>
            <xsl:choose>
                <xsl:when test="contains(@Value, '^^')">
                    <xsl:call-template name="processQuotes">
                        <xsl:with-param name="value" select="replace(replace(normalize-space(@Value), 'recto', 'r'), 'verso', 'v')"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace(replace(normalize-space(@Value), 'recto', 'r'), 'verso', 'v')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="h1:Field[ @Type = 'par01' ][ @Value != '' ]"><!-- Signatur -->
        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:variable name="content">
                <xsl:call-template name="processPar"/>
            </xsl:variable>
            <xsl:value-of select="replace($content, '&lt;lb/&gt;', ' ')"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par02' ][ @Value != '' ]"><!-- Überschrift -->
        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:variable name="content">
                <xsl:call-template name="processPar"/>
            </xsl:variable>
            <xsl:value-of select="replace($content, '&lt;lb/&gt;', ' ')"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par03' ][ @Value != '' ]"><!-- Schlagzeile -->
        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:variable name="content">
                <xsl:call-template name="processPar"/>
            </xsl:variable>
            <xsl:value-of select="replace($content, '&lt;lb/&gt;', ' ')"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par04' ][ @Value != '' ]"><!-- Äußeres -->
        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:text>-par04</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="processPar"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par05' ][ @Value != '' ]"><!-- Geschichte -->
        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:text>-par05</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="processPar"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par06' ][ @Value != '' ]"><!-- Literaturangaben -->
        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:call-template name="processPar"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par07' ][ @Value != '' ]"><!-- Einband -->
        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:text>-par07</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="processPar"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par08' ][ @Value != '' ]"><!-- Fragment -->
        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:text>-par08</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="processPar"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par09' ][ @Value != '' ]"><!-- Faszikel-Äußeres -->
        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:text>-par09</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="processPar"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par10' ][ @Value != '' ]"><!-- Faszikel-Geschichte -->
        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:text>-par10</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="processPar"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par11' ][ @Value != '' ][not(h1:Field[ @Type = '5230' ][ @Value = 'Faszikel' ])]"><!-- Text -->
        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:text>-par11</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="processPar"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par12' ][ @Value != '' ]"><!-- Stil u. Einordnung (illum.) -->
        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:text>-par12</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="processPar"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par13' ][ @Value != '' ]"><!-- Buchschmuck (illum.) -->
        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:text>-par13</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="processPar"/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="processPar">
        <xsl:param name="element"/>
        <xsl:param name="type"/>
        <xsl:choose>
            <xsl:when test="starts-with(@Value, '{\rtf')">
                <xsl:call-template name="processRTF">
                    <xsl:with-param name="value" select="@Value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains(@Value, '^^')">
                <xsl:call-template name="processQuotes">
                    <xsl:with-param name="value" select="@Value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="@Value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="processQuotes">
        <xsl:param name="value"/>
        <xsl:call-template name="convertGap">
            <xsl:with-param name="value" select="substring-before($value, '^^')"/>
        </xsl:call-template>
        <xsl:element name="quote" namespace="http://www.tei-c.org/ns/1.0">
            <!--<xsl:attribute name="type" select=" 'rubric' "/>-->
            <xsl:call-template name="convertGap">
                <xsl:with-param name="value" select="substring-before(substring-after($value, '^^'), '^^')"/>
            </xsl:call-template>
        </xsl:element>
        <xsl:choose>
            <xsl:when test="contains(substring-after(substring-after($value, '^^'), '^^'), '^^')">
                <xsl:call-template name="processQuotes">
                    <xsl:with-param name="value" select="substring-after(substring-after($value, '^^'), '^^')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="convertGap">
                    <xsl:with-param name="value" select="substring-after(substring-after($value, '^^'), '^^')"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="processRTF">
        <!-- look into https://stackoverflow.com/questions/75377978/what-are-some-methods-for-converting-rtf-text-nodes-in-xml-to-text-using-xslt-2 -->
        <xsl:param name="value"/>
        <xsl:param name="replace">&apos;</xsl:param>
        <xsl:param name="by">^</xsl:param>
        
        <!-- save brackets and backslashes -->
        <xsl:variable name="saveBrackets"        select="replace(replace(replace(
            $value, 
            '\\\\', '/BACKSLASH/'), 
            '\\\{', '/BRACKET_OPEN/'), 
            '\\\}', '/BRACKET_CLOSE/', 'i;j')"/>
        <xsl:variable name="convertWhitespace"        select="replace($saveBrackets,             '&#x0d;&#x0a;',                                                  ' ',           'i;j')"/>
        <!--<xsl:variable name="normalizeWhitespace"      select="replace($convertWhitespace,    '\s+',                                                           ' ',           'i;j')"/>-->
        <!-- remove Header markup --> 
        <xsl:variable name="removeRTFtag"        select="replace($convertWhitespace, '\{\\rtf.*?\} ',                                                             '',            'i;j')"/>
        <xsl:variable name="convertApos"         select="replace($removeRTFtag, $replace, $by)"/>
        <xsl:variable name="normalizeSpecialCharacters1"
            select="replace($convertApos,                 '\\u(\d+) \\\^[a-f0-9]{2}', '\\u$1')"/>
        <xsl:variable name="normalizeSpecialCharacters2"
            select="replace($normalizeSpecialCharacters1, '\\u(\d+) \?', '\\u$1')"/>
        <xsl:variable name="convertSpecialCharacters3">
            <xsl:call-template name="decodeSpecialCharacters3">
                <xsl:with-param name="value" select="$normalizeSpecialCharacters2"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="convertSpecialCharacters2">
            <xsl:call-template name="decodeSpecialCharacters2">
                <xsl:with-param name="value" select="$convertSpecialCharacters3"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="convertSpecialCharacters1">
            <xsl:call-template name="decodeSpecialCharacters1">
                <xsl:with-param name="value" select="$convertSpecialCharacters2"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="convertSpecialCharacters4">
            <xsl:call-template name="decodeSpecialCharacters4">
                <xsl:with-param name="value" select="$convertSpecialCharacters1"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="removeFormatting"    select="replace($convertSpecialCharacters4, '(\\(f\d+|b|ul|fs|lang|cbpat|chcbpat|cf|expndtw)\d*)+ ?',                         '')"/>
        <xsl:variable name="removePardStart"     select="replace($removeFormatting,          '\\uc1 \\pard(\\(keepn?|fi\-?|tx|li\-?|q[cjlr]|ri\-?|sb|sa|tq[cr]|itap|tap|sl|slmult|jclisttab)\d*)+ ',   '',            'i;j')"/>
        <xsl:variable name="convertPar"          select="replace($removePardStart,           ' *\\par \\pard(\\(keepn?|fi\-?|tx|li\-?|q[cjlr]|ri\-?|sb|sa|tq[cr]|itap|tap|sl|slmult|jclisttab)\d*)+ ', '&lt;lb/&gt;&lt;lb/&gt;', 'i;j')"/>
        <xsl:variable name="convertLine"         select="replace($convertPar,                ' \\line',                                                                    '&lt;lb/&gt;',           'i;j')"/>
        <xsl:variable name="removeParEnd"        select="replace($convertLine,               ' *\\par}',                                                                    '}',           'i;j')"/>
        <xsl:variable name="removeLBEnd"         select="replace($removeParEnd,              '(&lt;lb/&gt;)+( *\\plain)?}',                                                 '}',           'i;j')"/>
        <xsl:variable name="removeList"          select="replace($removeLBEnd,               '\{(\\(listlevel|levelnfc|leveljc|li\d+|fi\-?\d+|jclisttab|tx)\d*)+',             '',            'i;j')"/>
        <xsl:variable name="removeListParts"     select="replace($removeList,                '(\{?(\\\*?\\?(leveltext.*?\;|levelnumbers.*?\;|levelstartat\d+|listoverridetable|listoverridecount\d+|listoverride|listtemplateid\d+|listid\d+|listtext|list|pard|ls\d+|ilvl\d+))+)+', '',            'i;j')"/>
        <xsl:variable name="convertHyperlinks"   select="if (self::h1:Field[ @Type = 'par01' ] or self::h1:Field[ @Type = 'par02' ] or self::h1:Field[ @Type = 'par03' ]) 
            then replace($removeListParts, '\{\\field\{\\\*\\fldinst HYPERLINK &quot;hida://([a-z0-9\[\]\.?]+)/?\??u?&quot;\}\{\\fldrslt \\plain (.*?)\}\}', '$2', 'i;j') 
            else replace($removeListParts, '\{\\field\{\\\*\\fldinst HYPERLINK &quot;hida://([a-z0-9\[\]\.?]+)/?\??u?&quot;\}\{\\fldrslt \\plain (.*?)\}\}', '&lt;ref target=&quot;#$1&quot;&gt;$2&lt;/ref&gt;', 'i;j')"/>
        
        <!--
        <xsl:variable name="convert_1802"        select="replace($convertHyperlinks,   'type=&quot;1802&quot;',               'type=&quot;initium&quot; xml:lang=&quot;de&quot;')"/>
        <xsl:variable name="convert_4665"        select="replace($convert_1802,        'type=&quot;4665&quot;',               'type=&quot;locus&quot;')"/>
        <xsl:variable name="convert_5007"        select="replace($convert_4665,        'type=&quot;5007&quot;',               'type=&quot;relationType&quot;')"/>
        <xsl:variable name="convert_5007.501k"   select="replace($convert_5007,        'type=&quot;5007\[\d+\].501k&quot;',   'type=&quot;repository&quot;')"/>
        <xsl:variable name="convert_5007.501m"   select="replace($convert_5007.501k,   'type=&quot;5007\[\d+\].501m&quot;',   'type=&quot;shelfmark&quot;')"/>
        <xsl:variable name="convert_5007.5010"   select="replace($convert_5007.501m,   'type=&quot;5007\[\d+\].5010&quot;',   'type=&quot;relationTerm&quot;')"/>
        <xsl:variable name="convert_5060.5064"   select="replace($convert_5007.5010,   'type=&quot;5060\[\d+\].5064&quot;',   'type=&quot;origDate&quot;')"/>
        <xsl:variable name="convert_5060"        select="replace($convert_5060.5064,   'type=&quot;5060&quot;',               'type=&quot;datingMethod&quot;')"/>
        <xsl:variable name="convert_5140.5145"   select="replace($convert_5060,        'type=&quot;5140\[\d+\].5145&quot;',   'type=&quot;place&quot;')"/>
        <xsl:variable name="convert_5209"        select="replace($convert_5140.5145,   'type=&quot;5209&quot;',               'type=&quot;msTitle&quot;')"/>
        <xsl:variable name="convert_5270"        select="replace($convert_5209,        'type=&quot;5270&quot;',               'type=&quot;decoNote&quot;')"/>
        <xsl:variable name="convert_5500"        select="replace($convert_5270,        'type=&quot;5500&quot;',               'type=&quot;iconography&quot;')"/>
        <xsl:variable name="convert_5650"        select="replace($convert_5500,        'type=&quot;5650&quot;',               'type=&quot;textType&quot;')"/>
        <xsl:variable name="convert_5650.5666d"  select="replace($convert_5650,        'type=&quot;5650\[\d+\].5666d&quot;',  'type=&quot;initium&quot; xml:lang=&quot;de&quot;')"/>
        <xsl:variable name="convert_5650.5666g"  select="replace($convert_5650.5666d,  'type=&quot;5650\[\d+\].5666g&quot;',  'type=&quot;initium&quot; xml:lang=&quot;el&quot;')"/>
        <xsl:variable name="convert_5650.5666l"  select="replace($convert_5650.5666g,  'type=&quot;5650\[\d+\].5666l&quot;',  'type=&quot;initium&quot; xml:lang=&quot;la&quot;')"/>
        <xsl:variable name="convert_5650.5666v"  select="replace($convert_5650.5666l,  'type=&quot;5650\[\d+\].5666v&quot;',  'type=&quot;initium&quot;')"/>
        <xsl:variable name="convert_5704"        select="replace($convert_5650.5666v,  'type=&quot;5704\[?\d*\]?&quot;',      'type=&quot;script&quot;')"/>
        <xsl:variable name="convert_5705"        select="replace($convert_5704,        'type=&quot;5705&quot;',               'type=&quot;musicNotation&quot;')"/>
        <xsl:variable name="convert_5710"        select="replace($convert_5705,        'type=&quot;5710\[?\d*\]?&quot;',      'type=&quot;textLang&quot;')"/>
        <xsl:variable name="convert_6560.6770"   select="replace($convert_5710,        'type=&quot;6560\[\d+\].6770&quot;',   'type=&quot;biblRepertorium&quot;')"/>
        <xsl:variable name="convert_8350"        select="replace($convert_6560.6770,   'type=&quot;8350\[?\d*\]?&quot;',      'type=&quot;bibl&quot;')"/>
        <xsl:variable name="convert_bezlit.8330" select="replace($convert_8350,        'type=&quot;bezlit\[\d+\].8330&quot;', 'type=&quot;bibl&quot; subtype=&quot;short&quot;')"/>
        <xsl:variable name="convert_bezper.4100" select="replace($convert_bezlit.8330, 'type=&quot;bezper\[\d+\].4100&quot;', 'type=&quot;persName&quot;')"/>
        <xsl:variable name="convert_bezsoz.4600" select="replace($convert_bezper.4100, 'type=&quot;bezsoz\[\d+\].4600&quot;', 'type=&quot;orgName&quot;')"/>
        <xsl:variable name="convert_bezwrk.6930" select="replace($convert_bezsoz.4600, 'type=&quot;bezwrk\[\d+\].6930&quot;', 'type=&quot;workTitle&quot;')"/>
        <xsl:variable name="moveWhitespace"      select="replace($convert_bezwrk.6930, '&lt;ref(.*?)&gt; ',                   ' &lt;ref$1&gt;')"/>
        
        <xsl:variable name="removeIFromInitium"   select="replace($moveWhitespace,     '&lt;ref type=&quot;initium&quot; xml:lang=&quot;(\w+)&quot;&gt;\\i(.*?)&lt;/ref&gt;\\plain \\i', '&lt;ref type=&quot;initium&quot; xml:lang=&quot;$1&quot;&gt;$2&lt;/ref&gt;')"/>
        -->
        <xsl:variable name="removeIFromInitium"   select="replace($convertHyperlinks,     '&lt;ref type=&quot;initium&quot; xml:lang=&quot;(\w+)&quot;&gt;\\i(.*?)&lt;/ref&gt;\\plain \\i', '&lt;ref type=&quot;initium&quot; xml:lang=&quot;$1&quot;&gt;$2&lt;/ref&gt;')"/>
        
        <!-- to do:
\i.i.aniso\plain
        -->
        
        <xsl:variable name="convertFormattingISup"   select="replace($removeIFromInitium,      '\\i\\super ?([\p{L}\d \^/\(\)\[\]‘“’”›‹+,;\.:\-\-…]+)',     '&lt;quote&gt;&lt;hi rend=&quot;sup&quot;&gt;$1&lt;/hi&gt;&lt;/quote&gt;')"/>
        <xsl:variable name="convertFormattingIStr"   select="replace($convertFormattingISup,   '\\i\\strike ?([\p{L}\d \^/\(\)\[\]‘“’”›‹+,;\.:\-\-…]+)',    '&lt;quote rend=&quot;del&quot;&gt;$1&lt;/quote&gt;')"/>
        <xsl:variable name="convertFormattingI"      select="replace($convertFormattingIStr,   '\\i ?([\p{L}\d \^/\(\)\[\]‘“’”›‹+,;\.:\-\-…]+)',            '&lt;hi rend=&quot;italic&quot;&gt;$1&lt;/hi&gt;')"/>
        <xsl:variable name="convertFormattingSupSC"  select="replace($convertFormattingI,      '\\super\\scaps ?([\p{L}\d \^/\(\)\[\]‘“’”›‹+,;\.:\-\-…]+)', '&lt;hi rend=&quot;sup small-caps&quot;&gt;$1&lt;/hi&gt;')"/>
        <xsl:variable name="convertFormattingSup1"   select="replace($convertFormattingSupSC,  '\\super ?1(\\plain|\})',                                   '&#xB9;$1')"/>
        <xsl:variable name="convertFormattingSup2"   select="replace($convertFormattingSup1,   '\\super ?2(\\plain|\})',                                   '&#xB2;$1')"/>
        <xsl:variable name="convertFormattingSup3"   select="replace($convertFormattingSup2,   '\\super ?3(\\plain|\})',                                   '&#xB3;$1')"/>
        <xsl:variable name="convertFormattingSup4"   select="replace($convertFormattingSup3,   '\\super ?4(\\plain|\})',                                   '&#x2074;$1')"/>
        <xsl:variable name="convertFormattingSupR"   select="replace($convertFormattingSup4,   '\\super ?r(\\plain|\})',                                   '&#x02B3;$1')"/>
        <xsl:variable name="convertFormattingSupV"   select="replace($convertFormattingSupR,   '\\super ?v(\\plain|\})',                                   '&#x1D5B;$1')"/>
        <xsl:variable name="convertFormattingSupDot" select="replace($convertFormattingSupV,   '\\super ?\.(\\plain|\})',                                  '&#xB7;$1')"/>
        <xsl:variable name="convertFormattingSup"    select="replace($convertFormattingSupDot, '\\super ?([\p{L}\d \^/\(\)\[\]‘“’”›‹+,;\.:\-\-…]+)',        '&lt;hi rend=&quot;sup&quot;&gt;$1&lt;/hi&gt;')"/>
        <xsl:variable name="convertFormattingSC"     select="replace($convertFormattingSup,    '\\scaps ?([\p{L}\d \^/\(\)\[\]‘“’”›‹+,;\.:\-\-…]+)',        '&lt;hi rend=&quot;small-caps&quot;&gt;$1&lt;/hi&gt;')"/>
        <xsl:variable name="convertFormattingSub"    select="replace($convertFormattingSC,     '\\sub ?([\p{L}\d \^/\(\)\[\]‘“’”›‹+,;\.:\-\-…]+)',          '&lt;hi rend=&quot;sub&quot;&gt;$1&lt;/hi&gt;')"/>
        <xsl:variable name="removeEmptyHi"           select="replace($convertFormattingSub,    '&lt;hi rend=&quot;(sup|sup scaps|scaps|sup small-caps|small-caps)&quot;&gt;([ ,;\.:]*)&lt;/hi&gt;', '$2')"/>
        <xsl:variable name="removeEmptyQuote"        select="replace($removeEmptyHi,           '&lt;quote&gt;([ ,;\.:]*)&lt;/quote&gt;', '$1')"/>
        <xsl:variable name="mergeHis"                select="replace($removeEmptyQuote,        '&lt;/hi&gt;&lt;hi rend=&quot;\w+&quot;&gt;', '')"/>
        <xsl:variable name="mergeQuotes"             select="replace($mergeHis,                '&lt;/quote&gt;&lt;quote&gt;', '')"/>
        <xsl:variable name="removePlain"             select="replace($mergeQuotes,             '\\plain ?', '')"/>
        <xsl:variable name="removeFormattingRest"    select="replace($removePlain,             '&lt;lb/&gt;\\(i|scaps)&lt;lb/&gt;',                        '&lt;lb/&gt;&lt;lb/&gt;')"/>
        <xsl:variable name="removeEndBrackets"       select="replace($removeFormattingRest,    '\}',        '')"/>
        <xsl:variable name="reconvertApos"           select="replace($removeEndBrackets,       '\^',       $replace)"/>
        <xsl:variable name="removeRTFRest"           select="replace($reconvertApos,           '\\(i|caps|scaps|tab|par)', '')"/>
        <xsl:value-of select="normalize-space($removeRTFRest)" disable-output-escaping="yes"/>
    </xsl:template>

    <xsl:template name="convertGap">
        <xsl:param name="value"/>
        <xsl:value-of select="replace($value, '\. ?\. ?\.', '&#x2026;')"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersUC">
        <xsl:param name="value"/>
        <xsl:value-of select="
            replace(replace(replace(replace(
            $value,
            '\\uc2\\u176 \\\^81\\\^8b\\uc1 ', '&#176;'),
            '\\u-7368 \?', '&#58167;'),
            '\\u8226 \\bullet', '&#8226;'),
            '\\uc2\\u183 \\\^a1P\\uc1 ', '&#183;')"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU16">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u16')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u161', '&#161;'), '\\u163', '&#163;'), '\\u166', '&#166;'), '\\u167', '&#167;'), '\\u168', '&#168;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU17">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u17')) then
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u170', '&#170;'), '\\u171', '&#171;'), '\\u172', '&#172;'), '\\u175', '&#175;'), '\\u176', '&#176;'), '\\u177', '&#177;'), '\\u178', '&#178;'), '\\u179', '&#179;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU18">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u18')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u180', '&#180;'), '\\u181', '&#181;'), '\\u182', '&#182;'), '\\u183', '&#183;'), '\\u184', '&#184;'), '\\u185', '&#185;'), '\\u186', '&#186;'), '\\u187', '&#187;'), '\\u188', '&#188;'), '\\u189', '&#189;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU19">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u19')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u190', '&#190;'), '\\u191', '&#191;'), '\\u192', '&#192;'), '\\u193', '&#193;'), '\\u194', '&#194;'), '\\u195', '&#195;'), '\\u196', '&#196;'), '\\u197', '&#197;'), '\\u198', '&#198;'), '\\u199', '&#199;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU1">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u1')">
                <xsl:variable name="convertSpecialCharactersU16">
                    <xsl:call-template name="decodeSpecialCharactersU16">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU17">
                    <xsl:call-template name="decodeSpecialCharactersU17">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU16"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU18">
                    <xsl:call-template name="decodeSpecialCharactersU18">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU17"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU19">
                    <xsl:call-template name="decodeSpecialCharactersU19">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU18"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharactersU19"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU20">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u20')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u200', '&#200;'), '\\u201', '&#201;'), '\\u202', '&#202;'), '\\u203', '&#203;'), '\\u204', '&#204;'), '\\u205', '&#205;'), '\\u206', '&#206;'), '\\u207', '&#207;'), '\\u208', '&#208;'), '\\u209', '&#209;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU21">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u21')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u210', '&#210;'), '\\u211', '&#211;'), '\\u212', '&#212;'), '\\u213', '&#213;'), '\\u214', '&#214;'), '\\u215', '&#215;'), '\\u216', '&#216;'), '\\u217', '&#217;'), '\\u218', '&#218;'), '\\u219', '&#219;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU22">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u22')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u220', '&#220;'), '\\u221', '&#221;'), '\\u222', '&#222;'), '\\u223', '&#223;'), '\\u224', '&#224;'), '\\u225', '&#225;'), '\\u226', '&#226;'), '\\u227', '&#227;'), '\\u228', '&#228;'), '\\u229', '&#229;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU23">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u23')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u230', '&#230;'), '\\u231', '&#231;'), '\\u232', '&#232;'), '\\u233', '&#233;'), '\\u234', '&#234;'), '\\u235', '&#235;'), '\\u236', '&#236;'), '\\u237', '&#237;'), '\\u238', '&#238;'), '\\u239', '&#239;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU24">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u24')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u240', '&#240;'), '\\u241', '&#241;'), '\\u242', '&#242;'), '\\u243', '&#243;'), '\\u244', '&#244;'), '\\u245', '&#245;'), '\\u246', '&#246;'), '\\u247', '&#247;'), '\\u248', '&#248;'), '\\u249', '&#249;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU25">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u25')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u250', '&#250;'), '\\u251', '&#251;'), '\\u252', '&#252;'), '\\u253', '&#253;'), '\\u254', '&#254;'), '\\u255', '&#255;'), '\\u256', '&#256;'), '\\u257', '&#257;'), '\\u259', '&#259;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU26">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u26')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u261', '&#261;'), '\\u262', '&#262;'), '\\u263', '&#263;'), '\\u267', '&#267;'), '\\u268', '&#268;'), '\\u269', '&#269;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU27">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u27')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u271', '&#271;'), '\\u273', '&#273;'), '\\u275', '&#275;'), '\\u277', '&#277;'), '\\u278', '&#278;'), '\\u279', '&#279;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU28">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u28')) then
                replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u280', '&#280;'), '\\u281', '&#281;'), '\\u283', '&#283;'), '\\u286', '&#286;'), '\\u287', '&#287;'), '\\u288', '&#288;'), '\\u289', '&#289;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU29">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u29')) then
                replace(replace(replace(replace(
                $value,
                '\\u295', '&#295;'), '\\u297', '&#297;'), '\\u298', '&#298;'), '\\u299', '&#299;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU2">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u2')">
                <xsl:variable name="convertSpecialCharactersU20">
                    <xsl:call-template name="decodeSpecialCharactersU20">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU21">
                    <xsl:call-template name="decodeSpecialCharactersU21">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU20"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU22">
                    <xsl:call-template name="decodeSpecialCharactersU22">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU21"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU23">
                    <xsl:call-template name="decodeSpecialCharactersU23">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU22"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU24">
                    <xsl:call-template name="decodeSpecialCharactersU24">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU23"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU25">
                    <xsl:call-template name="decodeSpecialCharactersU25">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU24"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU26">
                    <xsl:call-template name="decodeSpecialCharactersU26">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU25"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU27">
                    <xsl:call-template name="decodeSpecialCharactersU27">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU26"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU28">
                    <xsl:call-template name="decodeSpecialCharactersU28">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU27"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU29">
                    <xsl:call-template name="decodeSpecialCharactersU29">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU28"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$convertSpecialCharactersU29"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU30">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u30')) then
                replace(replace(replace(replace(
                $value,
                '\\u301', '&#301;'), '\\u304', '&#304;'), '\\u305', '&#305;'), '\\u307', '&#307;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU32">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u32')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u321', '&#321;'), '\\u322', '&#322;'), '\\u323', '&#323;'), '\\u324', '&#324;'), '\\u326', '&#326;'), '\\u328', '&#328;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU33">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u33')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u332', '&#332;'), '\\u333', '&#333;'), '\\u334', '&#334;'), '\\u335', '&#335;'), '\\u338', '&#338;'), '\\u339', '&#339;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU34">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u34')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u341', '&#341;'), '\\u344', '&#344;'), '\\u345', '&#345;'), '\\u346', '&#346;'), '\\u347', '&#347;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU35">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u35')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u350', '&#350;'), '\\u351', '&#351;'), '\\u352', '&#352;'), '\\u353', '&#353;'), '\\u355', '&#355;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU36">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u36')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u361', '&#361;'), '\\u363', '&#363;'), '\\u365', '&#365;'), '\\u366', '&#366;'), '\\u367', '&#367;'), '\\u369', '&#369;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU37">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u37')) then
                replace(replace(replace(replace(
                $value,
                '\\u376', '&#376;'), '\\u377', '&#377;'), '\\u378', '&#378;'), '\\u379', '&#379;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU38">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u38')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u380', '&#380;'), '\\u381', '&#381;'), '\\u382', '&#382;'), '\\u383', '&#383;'), '\\u384', '&#384;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU39">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u39')) then
                replace(
                $value,
                '\\u390', '&#390;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU3">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u3')">
                <xsl:variable name="convertSpecialCharactersU30">
                    <xsl:call-template name="decodeSpecialCharactersU30">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU32">
                    <xsl:call-template name="decodeSpecialCharactersU32">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU30"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU33">
                    <xsl:call-template name="decodeSpecialCharactersU33">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU32"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU34">
                    <xsl:call-template name="decodeSpecialCharactersU34">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU33"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU35">
                    <xsl:call-template name="decodeSpecialCharactersU35">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU34"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU36">
                    <xsl:call-template name="decodeSpecialCharactersU36">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU35"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU37">
                    <xsl:call-template name="decodeSpecialCharactersU37">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU36"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU38">
                    <xsl:call-template name="decodeSpecialCharactersU38">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU37"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU39">
                    <xsl:call-template name="decodeSpecialCharactersU39">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU38"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$convertSpecialCharactersU39"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU41">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u41')) then
               replace(
               $value,
               '\\u410', '&#410;')
           else
               $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU43">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u43')) then
                replace(replace(
                $value,
                '\\u438', '&#438;'), '\\u439', '&#439;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU44">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u44')) then
                replace(
                $value,
                '\\u448', '&#448;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU46">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u46')) then
                replace(replace(replace(
                $value,
                '\\u465', '&#465;'), '\\u466', '&#466;'), '\\u468', '&#468;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU48">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u48')) then
                replace(replace(
                $value,
                '\\u486', '&#486;'), '\\u487', '&#487;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU4">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u4')">
                <xsl:variable name="convertSpecialCharactersU41">
                    <xsl:call-template name="decodeSpecialCharactersU41">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU43">
                    <xsl:call-template name="decodeSpecialCharactersU43">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU41"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU44">
                    <xsl:call-template name="decodeSpecialCharactersU44">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU43"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU46">
                    <xsl:call-template name="decodeSpecialCharactersU46">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU44"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU48">
                    <xsl:call-template name="decodeSpecialCharactersU48">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU46"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharactersU48"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU5">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u5')) then
                replace(replace(replace(replace(
                $value,
                '\\u531', '&#531;'),
                '\\u541', '&#541;'),
                '\\u553', '&#553;'),
                '\\u593', '&#593;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU60">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u60')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u601', '&#601;'),
                '\\u628', '&#628;'),
                '\\u643', '&#643;'),
                '\\u658', '&#658;'),
                '\\u664', '&#664;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU64">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u64')) then
                replace(
                $value,
                '\\u643', '&#643;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU65">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u65')) then
                replace(
                $value,
                '\\u658', '&#658;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU69">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u69')) then
                replace(replace(
                $value,
                '\\u697', '&#697;'), '\\u699', '&#699;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU6">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u6')">
                <xsl:variable name="convertSpecialCharactersU60">
                    <xsl:call-template name="decodeSpecialCharactersU60">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU64">
                    <xsl:call-template name="decodeSpecialCharactersU64">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU65">
                    <xsl:call-template name="decodeSpecialCharactersU65">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU69">
                    <xsl:call-template name="decodeSpecialCharactersU69">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU60"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharactersU69"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU70">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u70')) then
                replace(replace(replace(replace(
                $value,
                '\\u700', '&#700;'), '\\u701', '&#701;'), '\\u702', '&#702;'), '\\u703', '&#703;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU71">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u71')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u711', '&#711;'), '\\u712', '&#712;'), '\\u713', '&#713;'), '\\u714', '&#714;'), '\\u719', '&#719;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU72">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u72')) then
                replace(replace(replace(replace(
                $value,
                '\\u729', '&#729;'),
                '\\u730', '&#730;'),
                '\\u750', '&#750;'),
                '\\u796', '&#796;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU76">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u76')) then
                replace(replace(
                $value,
                '\\u768', '&#768;'), '\\u769', '&#769;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU77">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u77')) then
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u770', '&#770;'), '\\u771', '&#771;'), '\\u772', '&#772;'), '\\u773', '&#773;'), '\\u774', '&#774;'), '\\u775', '&#775;'), '\\u776', '&#776;'), '\\u778', '&#778;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU78">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u78')) then
                replace(replace(replace(
                $value,
                '\\u781', '&#781;'), '\\u787', '&#787;'), '\\u789', '&#789;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU7">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u7')">
                <xsl:variable name="convertSpecialCharactersU70">
                    <xsl:call-template name="decodeSpecialCharactersU70">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU71">
                    <xsl:call-template name="decodeSpecialCharactersU71">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU70"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU72">
                    <xsl:call-template name="decodeSpecialCharactersU72">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU71"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU76">
                    <xsl:call-template name="decodeSpecialCharactersU76">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU72"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU77">
                    <xsl:call-template name="decodeSpecialCharactersU77">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU76"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU78">
                    <xsl:call-template name="decodeSpecialCharactersU78">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU77"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$convertSpecialCharactersU78"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU80">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u80')) then
                replace(replace(replace(
                $value,
                '\\u803', '&#803;'), '\\u807', '&#807;'), '\\u808', '&#808;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU82">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u82')) then
                replace(
                $value,
                '\\u823', '&#823;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU83">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u83')) then
                replace(replace(replace(
                $value,
                '\\u834', '&#834;'), '\\u836', '&#836;'), '\\u837', '&#837;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU85">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u85')) then
                replace(
                $value,
                '\\u855', '&#855;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU86">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u86')) then
                replace(replace(replace(
                $value,
                '\\u864', '&#864;'), '\\u867', '&#867;'), '\\u868', '&#868;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU87">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u87')) then
                replace(replace(replace(
                $value,
                '\\u870', '&#870;'), '\\u871', '&#871;'), '\\u878', '&#878;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU88">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u88')) then
                replace(replace(
                $value,
                '\\u884', '&#884;'), '\\u885', '&#885;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU89">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u89')) then
                replace(
                $value,
                '\\u894', '&#894;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU8">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u8')">
                <xsl:variable name="convertSpecialCharactersU80">
                    <xsl:call-template name="decodeSpecialCharactersU80">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU82">
                    <xsl:call-template name="decodeSpecialCharactersU82">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU80"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU83">
                    <xsl:call-template name="decodeSpecialCharactersU83">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU82"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU85">
                    <xsl:call-template name="decodeSpecialCharactersU85">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU83"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU86">
                    <xsl:call-template name="decodeSpecialCharactersU86">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU85"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU87">
                    <xsl:call-template name="decodeSpecialCharactersU87">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU86"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU88">
                    <xsl:call-template name="decodeSpecialCharactersU88">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU87"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU89">
                    <xsl:call-template name="decodeSpecialCharactersU89">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU88"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharactersU89"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU90">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u90')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u900', '&#900;'), '\\u902', '&#902;'), '\\u903', '&#903;'), '\\u904', '&#904;'), '\\u906', '&#906;'), '\\u908', '&#908;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU91">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u91')) then
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u912', '&#912;'), '\\u913', '&#913;'), '\\u914', '&#914;'), '\\u915', '&#915;'), '\\u916', '&#916;'), '\\u917', '&#917;'), '\\u918', '&#918;'), '\\u919', '&#919;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU92">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u92')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u920', '&#920;'), '\\u921', '&#921;'), '\\u922', '&#922;'), '\\u923', '&#923;'), '\\u924', '&#924;'), '\\u925', '&#925;'), '\\u926', '&#926;'), '\\u927', '&#927;'), '\\u928', '&#928;'), '\\u929', '&#929;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU93">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u93')) then
                replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u931', '&#931;'), '\\u932', '&#932;'), '\\u933', '&#933;'), '\\u934', '&#934;'), '\\u935', '&#935;'), '\\u936', '&#936;'), '\\u937', '&#937;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU94">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u94')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u940', '&#940;'), '\\u941', '&#941;'), '\\u942', '&#942;'), '\\u943', '&#943;'), '\\u944', '&#944;'), '\\u945', '&#945;'), '\\u946', '&#946;'), '\\u947', '&#947;'), '\\u948', '&#948;'), '\\u949', '&#949;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU95">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u95')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u950', '&#950;'), '\\u951', '&#951;'), '\\u952', '&#952;'), '\\u953', '&#953;'), '\\u954', '&#954;'), '\\u955', '&#955;'), '\\u956', '&#956;'), '\\u957', '&#957;'), '\\u958', '&#958;'), '\\u959', '&#959;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU96">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u96')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u960', '&#960;'), '\\u961', '&#961;'), '\\u962', '&#962;'), '\\u963', '&#963;'), '\\u964', '&#964;'), '\\u965', '&#965;'), '\\u966', '&#966;'), '\\u967', '&#967;'), '\\u968', '&#968;'), '\\u969', '&#969;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU97">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u97')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u970', '&#970;'), '\\u971', '&#971;'), '\\u972', '&#972;'), '\\u973', '&#973;'), '\\u974', '&#974;'), '\\u977', '&#977;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU98">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u98')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u981', '&#981;'), '\\u985', '&#985;'), '\\u986', '&#986;'), '\\u987', '&#987;'), '\\u988', '&#988;'), '\\u989', '&#989;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU99">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u99')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u990', '&#990;'), '\\u991', '&#991;'), '\\u992', '&#992;'), '\\u993', '&#993;'), '\\u997', '&#997;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharactersU9">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u9')">
                <xsl:variable name="convertSpecialCharactersU90">
                    <xsl:call-template name="decodeSpecialCharactersU90">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU91">
                    <xsl:call-template name="decodeSpecialCharactersU91">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU90"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU92">
                    <xsl:call-template name="decodeSpecialCharactersU92">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU91"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU93">
                    <xsl:call-template name="decodeSpecialCharactersU93">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU92"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU94">
                    <xsl:call-template name="decodeSpecialCharactersU94">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU93"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU95">
                    <xsl:call-template name="decodeSpecialCharactersU95">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU94"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU96">
                    <xsl:call-template name="decodeSpecialCharactersU96">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU95"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU97">
                    <xsl:call-template name="decodeSpecialCharactersU97">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU96"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU98">
                    <xsl:call-template name="decodeSpecialCharactersU98">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU97"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU99">
                    <xsl:call-template name="decodeSpecialCharactersU99">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU98"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharactersU99"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1">
        <xsl:param name="value"/>

        <xsl:variable name="convertSpecialCharactersUC">
            <xsl:call-template name="decodeSpecialCharactersUC">
                <xsl:with-param name="value" select="$value"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($value, '\u')">
                <xsl:variable name="convertSpecialCharactersU1">
                    <xsl:call-template name="decodeSpecialCharactersU1">
                        <xsl:with-param name="value" select="$convertSpecialCharactersUC"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU2">
                    <xsl:call-template name="decodeSpecialCharactersU2">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU1"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU3">
                    <xsl:call-template name="decodeSpecialCharactersU3">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU4">
                    <xsl:call-template name="decodeSpecialCharactersU4">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU3"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU5">
                    <xsl:call-template name="decodeSpecialCharactersU5">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU4"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU6">
                    <xsl:call-template name="decodeSpecialCharactersU6">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU5"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU7">
                    <xsl:call-template name="decodeSpecialCharactersU7">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU6"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU8">
                    <xsl:call-template name="decodeSpecialCharactersU8">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU7"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharactersU9">
                    <xsl:call-template name="decodeSpecialCharactersU9">
                        <xsl:with-param name="value" select="$convertSpecialCharactersU8"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharactersU9"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$convertSpecialCharactersUC"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U100">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u100')) then
                replace(replace(replace(replace(
                $value,
                '\\u10003', '&#10003;'),
                '\\u10013', '&#10013;'),
                '\\u10056', '&#10056;'),
                '\\u1008', '&#1008;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U101">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u101')) then
                replace(
                $value,
                '\\u1010', '&#1010;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U102">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u102')) then
                replace(replace(
                $value,
                '\\u1024', '&#1024;'), '\\u1026', '&#1026;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U103">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u103')) then
                replace(replace(
                $value,
                '\\u1030', '&#1030;'), '\\u1034', '&#1034;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U104">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u104')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u1040', '&#1040;'), '\\u1042', '&#1042;'), '\\u1043', '&#1043;'), '\\u1046', '&#1046;'), '\\u1048', '&#1048;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U105">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u105')) then
                replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1050', '&#1050;'), '\\u1051', '&#1051;'), '\\u1052', '&#1052;'), '\\u1053', '&#1053;'), '\\u1054', '&#1054;'), '\\u1055', '&#1055;'), '\\u1056', '&#1056;'), '\\u1057', '&#1057;'), '\\u1058', '&#1058;'), '\\u1059', '&#1059;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U106">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u106')) then
                replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1060', '&#1060;'), '\\u1061', '&#1061;'), '\\u1062', '&#1062;'), '\\u1063', '&#1063;'), '\\u1064', '&#1064;'), '\\u1065', '&#1065;'), '\\u1066', '&#1066;'), '\\u1067', '&#1067;'), '\\u1068', '&#1068;'), '\\u1069', '&#1069;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U107">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u107')) then
                replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1070', '&#1070;'), '\\u1071', '&#1071;'), '\\u1072', '&#1072;'), '\\u1073', '&#1073;'), '\\u1074', '&#1074;'), '\\u1075', '&#1075;'), '\\u1076', '&#1076;'), '\\u1077', '&#1077;'), '\\u1078', '&#1078;'), '\\u1079', '&#1079;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U108">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u108')) then
                replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1080', '&#1080;'), '\\u1081', '&#1081;'), '\\u1082', '&#1082;'), '\\u1083', '&#1083;'), '\\u1084', '&#1084;'), '\\u1085', '&#1085;'), '\\u1086', '&#1086;'), '\\u1087', '&#1087;'), '\\u1088', '&#1088;'), '\\u1089', '&#1089;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U109">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u109')) then
                replace(
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1090', '&#1090;'), '\\u1091', '&#1091;'), '\\u1092', '&#1092;'), '\\u1093', '&#1093;'), '\\u1094', '&#1094;'), '\\u1095', '&#1095;'), '\\u1096', '&#1096;'), '\\u1098', '&#1098;'), '\\u1099', '&#1099;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U10">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u10')">
                <xsl:variable name="convertSpecialCharacters2U100">
                    <xsl:call-template name="decodeSpecialCharacters2U100">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U101">
                    <xsl:call-template name="decodeSpecialCharacters2U101">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U100"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U102">
                    <xsl:call-template name="decodeSpecialCharacters2U102">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U101"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U103">
                    <xsl:call-template name="decodeSpecialCharacters2U103">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U102"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U104">
                    <xsl:call-template name="decodeSpecialCharacters2U104">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U103"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U105">
                    <xsl:call-template name="decodeSpecialCharacters2U105">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U104"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U106">
                    <xsl:call-template name="decodeSpecialCharacters2U106">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U105"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U107">
                    <xsl:call-template name="decodeSpecialCharacters2U107">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U106"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U108">
                    <xsl:call-template name="decodeSpecialCharacters2U108">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U107"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U109">
                    <xsl:call-template name="decodeSpecialCharacters2U109">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U108"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters2U109"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U110">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u110')) then
                replace(replace(replace(
                $value,
                '\\u1100', '&#1100;'), '\\u1103', '&#1103;'), '\\u1105', '&#1105;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U111">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u111')) then
                replace(
                $value,
                '\\u1110', '&#1110;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U112">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u112')) then
                replace(replace(
                $value,
                '\\u1122', '&#1122;'), '\\u1123', '&#1123;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U11">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u110')">
                <xsl:variable name="convertSpecialCharacters2U110">
                    <xsl:call-template name="decodeSpecialCharacters2U110">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U111">
                    <xsl:call-template name="decodeSpecialCharacters2U111">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U110"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U112">
                    <xsl:call-template name="decodeSpecialCharacters2U112">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U111"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters2U112"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U12">
        <xsl:param name="value"/>
        <xsl:value-of select="
                replace(
                $value,
                '\\u1265', '&#1265;')
                "/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U145">
        <xsl:param name="value"/>
        <xsl:value-of select="
                replace(
                $value,
                '\\u1456', '&#1456;')
                "/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U146">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u146')) then
                replace(replace(replace(replace(
                $value,
                '\\u1460', '&#1460;'), '\\u1463', '&#1463;'), '\\u1465', '&#1465;'), '\\u1468', '&#1468;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U147">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u147')) then
                replace(replace(replace(
                $value,
                '\\u1472', '&#1472;'), '\\u1473', '&#1473;'), '\\u1476', '&#1476;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U148">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u148')) then
                replace(replace(
                $value,
                '\\u1488', '&#1488;'), '\\u1489', '&#1489;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U149">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u149')) then
                replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1490', '&#1490;'), '\\u1491', '&#1491;'), '\\u1492', '&#1492;'), '\\u1493', '&#1493;'), '\\u1494', '&#1494;'),
                '\\u1495', '&#1495;'), '\\u1496', '&#1496;'), '\\u1497', '&#1497;'), '\\u1498', '&#1498;'), '\\u1499', '&#1499;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U14">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u14')">
                <xsl:variable name="convertSpecialCharacters2U145">
                    <xsl:call-template name="decodeSpecialCharacters2U145">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U146">
                    <xsl:call-template name="decodeSpecialCharacters2U146">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U145"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U147">
                    <xsl:call-template name="decodeSpecialCharacters2U147">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U146"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U148">
                    <xsl:call-template name="decodeSpecialCharacters2U148">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U147"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U149">
                    <xsl:call-template name="decodeSpecialCharacters2U149">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U148"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters2U149"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U150">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u150')) then
                replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1500', '&#1500;'), '\\u1501', '&#1501;'), '\\u1502', '&#1502;'), '\\u1503', '&#1503;'), '\\u1504', '&#1504;'),
                '\\u1505', '&#1505;'), '\\u1506', '&#1506;'), '\\u1507', '&#1507;'), '\\u1508', '&#1508;'), '\\u1509', '&#1509;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U151">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u151')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u1510', '&#1510;'), '\\u1511', '&#1511;'), '\\u1512', '&#1512;'), '\\u1513', '&#1513;'), '\\u1514', '&#1514;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U156">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u156')) then
                replace(
                $value,
                '\\u1569', '&#1569;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U157">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u157')) then
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1570', '&#1570;'), '\\u1571', '&#1571;'), '\\u1573', '&#1573;'), '\\u1575', '&#1575;'),
                '\\u1576', '&#1576;'), '\\u1577', '&#1577;'), '\\u1578', '&#1578;'), '\\u1579', '&#1579;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U158">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u158')) then
                replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1580', '&#1580;'), '\\u1581', '&#1581;'), '\\u1582', '&#1582;'), '\\u1583', '&#1583;'), '\\u1584', '&#1584;'),
                '\\u1585', '&#1585;'), '\\u1586', '&#1586;'), '\\u1587', '&#1587;'), '\\u1588', '&#1588;'), '\\u1589', '&#1589;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U159">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u159')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u1590', '&#1590;'), '\\u1591', '&#1591;'), '\\u1592', '&#1592;'), '\\u1593', '&#1593;'), '\\u1594', '&#1594;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U15">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u15')">
                <xsl:variable name="convertSpecialCharacters2U150">
                    <xsl:call-template name="decodeSpecialCharacters2U150">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U151">
                    <xsl:call-template name="decodeSpecialCharacters2U151">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U150"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U156">
                    <xsl:call-template name="decodeSpecialCharacters2U156">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U151"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U157">
                    <xsl:call-template name="decodeSpecialCharacters2U157">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U156"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U158">
                    <xsl:call-template name="decodeSpecialCharacters2U158">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U157"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U159">
                    <xsl:call-template name="decodeSpecialCharacters2U159">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U158"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters2U159"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U160">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u160')) then
                replace(
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1601', '&#1601;'), '\\u1602', '&#1602;'), '\\u1603', '&#1603;'), '\\u1604', '&#1604;'), 
                '\\u1605', '&#1605;'), '\\u1606', '&#1606;'), '\\u1607', '&#1607;'), '\\u1608', '&#1608;'), '\\u1609', '&#1609;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U161">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u161')) then
                replace(replace(
                $value,
                '\\u1610', '&#1610;'), '\\u1615', '&#1615;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U16">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u16')">
                <xsl:variable name="convertSpecialCharacters2U160">
                    <xsl:call-template name="decodeSpecialCharacters2U160">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U161">
                    <xsl:call-template name="decodeSpecialCharacters2U161">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U160"/>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:value-of select="$convertSpecialCharacters2U161"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u1')">
                <xsl:variable name="convertSpecialCharacters2U10">
                    <xsl:call-template name="decodeSpecialCharacters2U10">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U11">
                    <xsl:call-template name="decodeSpecialCharacters2U11">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U10"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U12">
                    <xsl:call-template name="decodeSpecialCharacters2U12">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U11"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U14">
                    <xsl:call-template name="decodeSpecialCharacters2U14">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U12"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U15">
                    <xsl:call-template name="decodeSpecialCharacters2U15">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U14"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U16">
                    <xsl:call-template name="decodeSpecialCharacters2U16">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U15"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$convertSpecialCharacters2U16"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U76">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u76')) then
                replace(replace(
                $value,
                '\\u7694', '&#7694;'), '\\u7695', '&#7695;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U771">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u771')) then
                replace(replace(replace(
                $value,
                '\\u7712', '&#7712;'), '\\u7716', '&#7716;'), '\\u7717', '&#7717;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U773">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u773')) then
                replace(replace(replace(
                $value,
                '\\u7730', '&#7730;'), '\\u7731', '&#7731;'), '\\u7733', '&#7733;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U777">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u777')) then
                replace(replace(
                $value,
                '\\u7778', '&#7778;'), '\\u7779', '&#7779;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U778">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u778')) then
                replace(replace(
                $value,
                '\\u7788', '&#7788;'), '\\u7789', '&#7789;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U779">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u779')) then
                replace(replace(
                $value,
                '\\u7790', '&#7790;'), '\\u7791', '&#7791;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U77">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u77')">
                <xsl:variable name="convertSpecialCharacters3U771">
                    <xsl:call-template name="decodeSpecialCharacters3U771">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U773">
                    <xsl:call-template name="decodeSpecialCharacters3U773">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U771"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U777">
                    <xsl:call-template name="decodeSpecialCharacters3U777">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U773"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U778">
                    <xsl:call-template name="decodeSpecialCharacters3U778">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U777"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U779">
                    <xsl:call-template name="decodeSpecialCharacters3U779">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U778"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters3U779"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U780">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u780')) then
                replace(replace(
                $value,
                '\\u7804', '&#7804;'), '\\u7807', '&#7807;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U781">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u781')) then
                replace(replace(
                $value,
                '\\u7811', '&#7811;'), '\\u7813', '&#7813;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U783">
        <xsl:param name="value"/>
        <xsl:value-of select="
                replace(replace(
                $value,
                '\\u7832', '&#7832;'),
                '\\u7869', '&#7869;')
                "/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U78">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u78')">
                <xsl:variable name="convertSpecialCharacters3U780">
                    <xsl:call-template name="decodeSpecialCharacters3U780">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U781">
                    <xsl:call-template name="decodeSpecialCharacters3U781">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U780"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U783">
                    <xsl:call-template name="decodeSpecialCharacters3U783">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U781"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters3U783"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U79">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u79')) then
                replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(
                $value,
                '\\u7911', '&#7911;'),
                '\\u7923', '&#7923;'),
                '\\u7931', '&#7931;'), '\\u7936', '&#7936;'), '\\u7937', '&#7937;'), '\\u7938', '&#7938;'), '\\u7939', '&#7939;'),
                '\\u7940', '&#7940;'), '\\u7941', '&#7941;'), '\\u7942', '&#7942;'), '\\u7943', '&#7943;'), '\\u7944', '&#7944;'), '\\u7945', '&#7945;'), '\\u7946', '&#7946;'), '\\u7947', '&#7947;'), '\\u7948', '&#7948;'), '\\u7949', '&#7949;'),
                '\\u7950', '&#7950;'), '\\u7952', '&#7952;'), '\\u7953', '&#7953;'), '\\u7954', '&#7954;'), '\\u7955', '&#7955;'), '\\u7956', '&#7956;'), '\\u7957', '&#7957;'),
                '\\u7960', '&#7960;'), '\\u7961', '&#7961;'), '\\u7962', '&#7962;'), '\\u7963', '&#7963;'), '\\u7964', '&#7964;'), '\\u7965', '&#7965;'), '\\u7968', '&#7968;'), '\\u7969', '&#7969;'),
                '\\u7970', '&#7970;'), '\\u7971', '&#7971;'), '\\u7972', '&#7972;'), '\\u7973', '&#7973;'), '\\u7974', '&#7974;'), '\\u7975', '&#7975;'), '\\u7976', '&#7976;'), '\\u7977', '&#7977;'), '\\u7978', '&#7978;'), '\\u7979', '&#7979;'),
                '\\u7980', '&#7980;'), '\\u7981', '&#7981;'), '\\u7982', '&#7982;'), '\\u7983', '&#7983;'), '\\u7984', '&#7984;'), '\\u7985', '&#7985;'), '\\u7986', '&#7986;'), '\\u7987', '&#7987;'), '\\u7988', '&#7988;'), '\\u7989', '&#7989;'),
                '\\u7990', '&#7990;'), '\\u7991', '&#7991;'), '\\u7992', '&#7992;'), '\\u7993', '&#7993;'), '\\u7996', '&#7996;'), '\\u7997', '&#7997;'), '\\u7998', '&#7998;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U7">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u7')">
                <xsl:variable name="convertSpecialCharacters3U76">
                    <xsl:call-template name="decodeSpecialCharacters3U76">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U77">
                    <xsl:call-template name="decodeSpecialCharacters3U77">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U76"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U78">
                    <xsl:call-template name="decodeSpecialCharacters3U78">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U77"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U79">
                    <xsl:call-template name="decodeSpecialCharacters3U79">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U78"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$convertSpecialCharacters3U79"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U80">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u80')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(
                $value,
                '\\u8000', '&#8000;'), '\\u8001', '&#8001;'), '\\u8002', '&#8002;'), '\\u8003', '&#8003;'), '\\u8004', '&#8004;'), '\\u8005', '&#8005;'), '\\u8008', '&#8008;'), '\\u8009', '&#8009;'),
                '\\u8011', '&#8011;'), '\\u8012', '&#8012;'), '\\u8013', '&#8013;'), '\\u8016', '&#8016;'), '\\u8017', '&#8017;'), '\\u8019', '&#8019;'),
                '\\u8020', '&#8020;'), '\\u8021', '&#8021;'), '\\u8022', '&#8022;'), '\\u8023', '&#8023;'), '\\u8025', '&#8025;'), '\\u8029', '&#8029;'),
                '\\u8032', '&#8032;'), '\\u8033', '&#8033;'), '\\u8034', '&#8034;'), '\\u8035', '&#8035;'), '\\u8036', '&#8036;'), '\\u8037', '&#8037;'), '\\u8038', '&#8038;'), '\\u8039', '&#8039;'),
                '\\u8040', '&#8040;'), '\\u8041', '&#8041;'), '\\u8042', '&#8042;'), '\\u8044', '&#8044;'), '\\u8045', '&#8045;'), '\\u8046', '&#8046;'), '\\u8047', '&#8047;'), '\\u8048', '&#8048;'), '\\u8049', '&#8049;'),
                '\\u8050', '&#8050;'), '\\u8051', '&#8051;'), '\\u8052', '&#8052;'), '\\u8053', '&#8053;'), '\\u8054', '&#8054;'), '\\u8055', '&#8055;'), '\\u8056', '&#8056;'), '\\u8057', '&#8057;'), '\\u8058', '&#8058;'), '\\u8059', '&#8059;'),
                '\\u8060', '&#8060;'), '\\u8061', '&#8061;'), '\\u8064', '&#8064;'), '\\u8068', '&#8068;'), '\\u8069', '&#8069;'),
                '\\u8070', '&#8070;'), '\\u8077', '&#8077;'),
                '\\u8080', '&#8080;'), '\\u8081', '&#8081;'), '\\u8082', '&#8082;'), '\\u8084', '&#8084;'), '\\u8085', '&#8085;'), '\\u8086', '&#8086;'), '\\u8087', '&#8087;'),
                '\\u8096', '&#8096;'), '\\u8099', '&#8099;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U81">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u81')) then
                replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(
                $value,
                '\\u8100', '&#8100;'), '\\u8102', '&#8102;'), '\\u8103', '&#8103;'), '\\u8104', '&#8104;'),
                '\\u8115', '&#8115;'), '\\u8116', '&#8116;'), '\\u8118', '&#8118;'), '\\u8119', '&#8119;'),
                '\\u8125', '&#8125;'), '\\u8127', '&#8127;'), '\\u8128', '&#8128;'),
                '\\u8131', '&#8131;'), '\\u8132', '&#8132;'), '\\u8134', '&#8134;'), '\\u8135', '&#8135;'),
                '\\u8141', '&#8141;'), '\\u8142', '&#8142;'), '\\u8143', '&#8143;'), '\\u8145', '&#8145;'), '\\u8146', '&#8146;'), '\\u8147', '&#8147;'),
                '\\u8150', '&#8150;'), '\\u8157', '&#8157;'), '\\u8158', '&#8158;'), '\\u8159', '&#8159;'),
                '\\u8160', '&#8160;'), '\\u8161', '&#8161;'), '\\u8162', '&#8162;'), '\\u8163', '&#8163;'), '\\u8164', '&#8164;'), '\\u8165', '&#8165;'), '\\u8166', '&#8166;'),
                '\\u8172', '&#8172;'), '\\u8174', '&#8174;'), '\\u8175', '&#8175;'), '\\u8178', '&#8178;'), '\\u8179', '&#8179;'),
                '\\u8180', '&#8180;'), '\\u8182', '&#8182;'), '\\u8183', '&#8183;'), '\\u8185', '&#8185;'), '\\u8188', '&#8188;'), '\\u8189', '&#8189;'),
                '\\u8190', '&#8190;'), '\\u8193', '&#8193;'), '\\u8194', '&#8194;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U82">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u82')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u8202', '&#8202;'), '\\u8203', '&#8203;'), '\\u8204', '&#8204;'), '\\u8206', '&#8206;'),
                '\\u8210', '&#8210;'), '\\u8213', '&#8213;'), '\\u8214', '&#8214;'), '\\u8218', '&#8218;'), '\\u8219', '&#8219;'),
                '\\u8222', '&#8222;'), '\\u8223', '&#8223;'), '\\u8224', '&#8224;'), '\\u8225', '&#8225;'),
                '\\u8230', '&#8230;'), '\\u8239', '&#8239;'),
                '\\u8242', '&#8242;'), '\\u8249', '&#8249;'),
                '\\u8250', '&#8250;'), '\\u8251', '&#8251;'), '\\u8254', '&#8254;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U83">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u83')) then
                replace(replace(
                $value,
                '\\u8356', '&#8356;'),
                '\\u8364', '&#8364;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U84">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u84')) then
                replace(replace(replace(replace(
                replace(replace(replace(
                $value,
                '\\u8452', '&#8452;'),
                '\\u8464', '&#8464;'), '\\u8466', '&#8466;'), '\\u8468', '&#8468;'),
                '\\u8470', '&#8470;'), '\\u8478', '&#8478;'),
                '\\u8482', '&#8482;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U85">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u85')) then
                replace(replace(replace(
                replace(replace(replace(
                $value,
                '\\u8531', '&#8531;'), '\\u8532', '&#8532;'), '\\u8533', '&#8533;'),
                '\\u8544', '&#8544;'),
                '\\u8592', '&#8592;'), '\\u8594', '&#8594;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U86">
        <xsl:param name="value"/>
        <xsl:value-of select="
            replace(
            $value,
            '\\u8670', '&#8670;')"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U87">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u87')) then
                replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(
                $value,
                '\\u8709', '&#8709;'),
                '\\u8710', '&#8710;'), '\\u8711', '&#8711;'),
                '\\u8722', '&#8722;'), '\\u8729', '&#8729;'),
                '\\u8734', '&#8734;'),
                '\\u8741', '&#8741;'), '\\u8747', '&#8747;'),
                '\\u8756', '&#8756;'), '\\u8759', '&#8759;'),
                '\\u8776', '&#8776;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U88">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u88')) then
                replace(replace(
                $value,
                '\\u8805', '&#8805;'),
                '\\u8857', '&#8857;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U890">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u890')) then
                replace(replace(replace(
                $value,
                '\\u8901', '&#8901;'), '\\u8902', '&#8902;'), '\\u8904', '&#8904;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U899">
        <xsl:param name="value"/>
        <xsl:value-of select="
            replace(
            $value,
            '\\u8992', '&#8992;')"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U89">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u89')">
                <xsl:variable name="convertSpecialCharacters3U890">
                    <xsl:call-template name="decodeSpecialCharacters3U890">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U899">
                    <xsl:call-template name="decodeSpecialCharacters3U899">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U890"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters3U899"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U8">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u8')">
                <xsl:variable name="convertSpecialCharacters3U80">
                    <xsl:call-template name="decodeSpecialCharacters3U80">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U81">
                    <xsl:call-template name="decodeSpecialCharacters3U81">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U80"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U82">
                    <xsl:call-template name="decodeSpecialCharacters3U82">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U81"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U83">
                    <xsl:call-template name="decodeSpecialCharacters3U83">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U82"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U84">
                    <xsl:call-template name="decodeSpecialCharacters3U84">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U83"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U85">
                    <xsl:call-template name="decodeSpecialCharacters3U85">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U84"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U86">
                    <xsl:call-template name="decodeSpecialCharacters3U86">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U85"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U87">
                    <xsl:call-template name="decodeSpecialCharacters3U87">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U86"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U88">
                    <xsl:call-template name="decodeSpecialCharacters3U88">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U87"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U89">
                    <xsl:call-template name="decodeSpecialCharacters3U89">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U88"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters3U89"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U90">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u900')) then
                replace(replace(
                $value,
                '\\u9001', '&#9001;'), '\\u9002', '&#9002;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U95">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u95')) then
                replace(
                $value,
                '\\u9553', '&#9553;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U96">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u96')) then
                replace(replace(replace(replace(
                $value,
                '\\u9660', '&#9660;'),'\\u9674', '&#9674;'), '\\u9675', '&#9675;'), '\\u9679', '&#9679;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U970">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u97')) then
                replace(replace(replace(replace(
                $value,
                '\\u9702', '&#9702;'),
                '\\u9737', '&#9737;'),
                '\\u9769', '&#9769;'),
                '\\u9789', '&#9789;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U979">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u979')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u9790', '&#9790;'), '\\u9791', '&#9791;'), '\\u9792', '&#9792;'), '\\u9793', '&#9793;'), '\\u9794', '&#9794;'), '\\u9797', '&#9797;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U97">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u97')">
                <xsl:variable name="convertSpecialCharacters3U970">
                    <xsl:call-template name="decodeSpecialCharacters3U970">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U979">
                    <xsl:call-template name="decodeSpecialCharacters3U979">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U970"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters3U979"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U98">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u98')) then
                replace(
                $value,
                '\\u9830', '&#9830;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U99">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u99')) then
                replace(
                $value,
                '\\u9991', '&#9991;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U9">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u9')">
                <xsl:variable name="convertSpecialCharacters3U90">
                    <xsl:call-template name="decodeSpecialCharacters3U90">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U95">
                    <xsl:call-template name="decodeSpecialCharacters3U95">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U90"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U96">
                    <xsl:call-template name="decodeSpecialCharacters3U96">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U95"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U97">
                    <xsl:call-template name="decodeSpecialCharacters3U97">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U96"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U98">
                    <xsl:call-template name="decodeSpecialCharacters3U98">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U97"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U99">
                    <xsl:call-template name="decodeSpecialCharacters3U99">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U98"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$convertSpecialCharacters3U99"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3">
        <xsl:param name="value"/>

        <xsl:variable name="convertSpecialCharacters3U7">
            <xsl:call-template name="decodeSpecialCharacters3U7">
                <xsl:with-param name="value" select="$value"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="convertSpecialCharacters3U8">
            <xsl:call-template name="decodeSpecialCharacters3U8">
                <xsl:with-param name="value" select="$convertSpecialCharacters3U7"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="convertSpecialCharacters3U9">
            <xsl:call-template name="decodeSpecialCharacters3U9">
                <xsl:with-param name="value" select="$convertSpecialCharacters3U8"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:value-of select="$convertSpecialCharacters3U9"/>

    </xsl:template>
    <xsl:template name="decodeSpecialCharacters40">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\^')">
                <xsl:value-of select="
                    replace(replace(replace(replace(replace(replace(replace(replace(
                    replace(replace(replace(replace(replace(replace(replace(replace(
                    $value,
                    '\\\^96', '&#x96;'),
                    '\\\^9c', '&#x153;'),
                    '\\\^92', '’'),
                    '\\\^ab', '&#xab;'),
                    '\\\^b0', '&#xb0;'),
                    '\\\^b7', '&#xb7;'),
                    '\\\^bb', '&#xbb;'),
                    '\\\^c9', '&#xc9;'),
                    '\\\^e0', '&#xe0;'),
                    '\\\^e4', '&#xe4;'),
                    '\\\^e8', '&#xe8;'),
                    '\\\^e9', '&#xe9;'),
                    '\\\^ea', '&#xea;'),
                    '\\\^d6', '&#xd6;'),
                    '\\\^f4', '&#xf4;'),
                    '\\\^fc', '&#xfc;')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters41">
        <xsl:param name="value"/>
        <xsl:value-of select="
            replace(replace(replace(
            $value,
            '&lt;',             '&#x2039;'),
            '&gt;',             '&#x203A;'),
            '&amp;',            '&amp;amp;')"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters42">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\')">
                <xsl:value-of select="
                    replace(replace(replace(replace(replace(replace(replace(replace(replace(
                    $value,
                    '\\emdash', '&#x2014;'),
                    '\\endash ', '&#x2013;'),
                    ' ?\\lquote ',   '‘'),
                    '\\ldblquote ',  '“'),
                    '\\rquote ',     '’'),
                    ' ?\\rdblquote', '”'),
                    '\. ?\. ?\.',    '&#x2026;'),
                    '\\~',           '&#x00A0;'),
                    '\\\-',          '')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters4">
        <xsl:param name="value"/>
        <xsl:variable name="convertSpecialCharacters40">
            <xsl:call-template name="decodeSpecialCharacters40">
                <xsl:with-param name="value" select="$value"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="convertSpecialCharacters41">
            <xsl:call-template name="decodeSpecialCharacters41">
                <xsl:with-param name="value" select="$convertSpecialCharacters40"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="convertSpecialCharacters42">
            <xsl:call-template name="decodeSpecialCharacters42">
                <xsl:with-param name="value" select="$convertSpecialCharacters41"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:value-of select="$convertSpecialCharacters42"/>
    </xsl:template>

</xsl:stylesheet>
