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
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:rtftools="http://www.startext.de/rtftools"
    xmlns:sbbfunc="http://dev.sbb.berlin/sbb"
    extension-element-prefixes="saxon"
    exclude-result-prefixes="#all">

    <!-- 
    script for transforming MXML-encoded documents into the HSP-TEI dialect / 2022 / schassan@hab.de
    offene Fragen:
    - wohin mit 4670="Derzeitiger Aufbewahrungsort: Jagiellonen-Bibliothek, Krakau"
    -->

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:preserve-space elements="text"/>

    <xsl:param name="TEI-schema">@parsedVersion.majorVersion@.@parsedVersion.minorVersion@.@parsedVersion.incrementalVersion@</xsl:param>
    <xsl:param name="availabilityLicence">http://rightsstatements.org/vocab/InC/1.0/</xsl:param>
    <xsl:param name="mode"/><!-- kann auf 'test' gesetzt werden für Kommentare -->
    <xsl:param name="separator" select=" ' · ' "/>
    <xsl:variable name="crlf" select=" '&#x000A;' "/>
    <xsl:param name="toBeReplaced">&apos;&quot;</xsl:param>
    <xsl:param name="replacedBy">&apos;&apos;</xsl:param>
    

    <xsl:template match="/">
        <xsl:variable name="format" select="h1:DocumentSet/h1:ContentInfo/h1:Format"/>
        <xsl:variable name="creationDate" select="h1:DocumentSet/h1:ContentInfo/h1:CreationDate"/>
        <xsl:value-of select="$crlf"/>
        <xsl:element name="teiCorpus" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="version" select="$TEI-schema"/>
            <xsl:element name="teiHeader" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="fileDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="titleStmt" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:text>Automatisch generierter Handschriftenkatalog</xsl:text>
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
                            <xsl:text>Automatisch generierter Handschriftenkatalog aus einem </xsl:text>
                            <xsl:if test="$format != '' "><xsl:value-of select="concat('im ', $format, '-Format ')"/></xsl:if>
                            <xsl:if test="$creationDate != '' "><xsl:value-of select="concat('am ', $creationDate, ' erstellten ')"/></xsl:if>
                            <xsl:text>MXML-Dokument.</xsl:text>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:apply-templates select="descendant::h1:Block[ @Type = 'obj' ][h1:Field[ @Type = 'bezsoz' ][ @Value = 'Verwaltung' ]]">
                <xsl:with-param name="format" select="$format"/>
                <xsl:with-param name="creationDate" select="$creationDate"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>

    <xsl:template match="h1:Block[ @Type = 'obj' ][h1:Field[ @Type = 'bezsoz' ][ @Value = 'Verwaltung' ]]">
        <xsl:param name="creationDate"/>
        <xsl:param name="format"/>
        <xsl:variable name="xmlid">
            <xsl:value-of select="translate(normalize-space(substring-after(ancestor-or-self::h1:Document/@DocKey, 'obj')), ', ','-')"/>
        </xsl:variable>
        
        <xsl:element name="TEI" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="version" select="$TEI-schema"/>
            <xsl:attribute name="xml:lang" select=" 'de' "/>
            <xsl:element name="teiHeader" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="fileDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:call-template name="titleStmt"/>
                    <xsl:call-template name="editionStmt">
                        <xsl:with-param name="creationDate" select="$creationDate"/>
                        <xsl:with-param name="format" select="$format"/>
                    </xsl:call-template>
                    <xsl:call-template name="publicationStmt"/>
                    <xsl:element name="sourceDesc" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="bibl" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:if test="h1:Field[ @Type = '8450' ][ @Value = 'RETROKatalog' ]">
                                <xsl:attribute name="n" select="h1:Field[ @Type = '8450' ][ @Value = 'RETROKatalog' ]/h1:Field[ @Type = '8540' ]/@Value"/>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when test="h1:Field[ @Type = '8265' ]">
                                    <xsl:value-of select="h1:Field[ @Type = '8265' ]/@Value"/>
                                </xsl:when>
                                <xsl:when test="h1:Field[ @Type = '1903' ]">
                                    <xsl:value-of select="h1:Field[ @Type = '1903' ]/@Value"/>
                                </xsl:when>
                                <xsl:when test="h1:Field[ @Type = '9904' ]">
                                    <xsl:value-of select="h1:Field[ @Type = '9904' ]/@Value"/>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="h1:Field[ @Type = '8440norm' ][h1:Field]">
                                    <xsl:text> S. </xsl:text>
                                    <xsl:element name="biblScope" namespace="http://www.tei-c.org/ns/1.0">
                                        <xsl:attribute name="from">
                                            <xsl:choose>
                                                <xsl:when test="h1:Field[ @Type = '8440norm' ][ @Value = 'Anfang' ][h1:Field[ @Type = '8443norm' ]]">
                                                    <xsl:value-of select="h1:Field[ @Type = '8440norm' ][ @Value = 'Anfang' ]/h1:Field[ @Type = '8443norm' ]/@Value"/>
                                                </xsl:when>
                                                <xsl:when test="h1:Field[ @Type = '8440norm' ][ @Value = 'Ende' ][h1:Field[ @Type = '8443norm' ]]">
                                                    <xsl:value-of select="h1:Field[ @Type = '8440norm' ][ @Value = 'Ende' ]/h1:Field[ @Type = '8443norm' ]/@Value"/>
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:attribute name="to">
                                            <xsl:choose>
                                                <xsl:when test="h1:Field[ @Type = '8440norm' ][ @Value = 'Ende' ][h1:Field[ @Type = '8443norm' ]]">
                                                    <xsl:value-of select="h1:Field[ @Type = '8440norm' ][ @Value = 'Ende' ]/h1:Field[ @Type = '8443norm' ]/@Value"/>
                                                </xsl:when>
                                                <xsl:when test="h1:Field[ @Type = '8440norm' ][ @Value = 'Anfang' ][h1:Field[ @Type = '8443norm' ]]">
                                                    <xsl:value-of select="h1:Field[ @Type = '8440norm' ][ @Value = 'Anfang' ]/h1:Field[ @Type = '8443norm' ]/@Value"/>
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:for-each select="h1:Field[ @Type = '8440norm' ][h1:Field]">
                                            <xsl:if test="preceding-sibling::h1:Field[ @Type = '8440norm' ][h1:Field]"><xsl:text>&#x2013;</xsl:text></xsl:if>
                                            <xsl:value-of select="h1:Field[ @Type = '8441norm' ]/@Value"/>
                                        </xsl:for-each>
                                    </xsl:element>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:if test="h1:Field[ @Type = '599a' ][ @Value = 'KOMM_SAMMELBESCHRBG' ]">
                                <xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:value-of select="h1:Field[ @Type = '599a' ][ @Value = 'KOMM_SAMMELBESCHRBG' ]/h1:Field[ @Type = '599e' ]/@Value"/>
                                </xsl:element>
                            </xsl:if>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="profileDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="creation" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="when" select="concat(substring(@CreationDate, 7, 4), '-', substring(@CreationDate, 4, 2), '-', substring(@CreationDate, 1, 2))"/>
                            <xsl:value-of select="concat(substring(@CreationDate, 1, 2), '.', substring(@CreationDate, 4, 2), '.', substring(@CreationDate, 7, 4))"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="revisionDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="change" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="when" select="concat(substring(@ChangeDate, 7, 4), '-', substring(@ChangeDate, 4, 2), '-', substring(@ChangeDate, 1, 2))"/>
                            <xsl:value-of select="concat(substring(@ChangeDate, 1, 2), '.', substring(@ChangeDate, 4, 2), '.', substring(@ChangeDate, 7, 4))"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="text" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="body" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="msDesc" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="xml:id" select="concat('MXML-', $xmlid)"/>
                        <xsl:attribute name="xml:lang" select=" 'de' "/>
                        <xsl:attribute name="type">
                            <xsl:choose>
                                <xsl:when test="h1:Field[ @Type = '8450' ][ @Value = 'RETROKatalog' ]"><xsl:text>hsp:description_retro</xsl:text></xsl:when>
                                <xsl:otherwise>hsp:description</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="subtype">
                            <xsl:choose>
                                <xsl:when test="@type = 'illum' ">illum</xsl:when>
                                <xsl:otherwise>medieval</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="status" select=" 'extern' "/>
                        <xsl:element name="msIdentifier" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:apply-templates select="h1:Field[ @Type = 'bezsoz' ][ normalize-space(@Value) = 'Verwaltung' ]"/>
                        </xsl:element>
                        <xsl:call-template name="head"><xsl:with-param name="calledFrom" select=" 'obj' "/></xsl:call-template>
                        <xsl:choose>
                            <xsl:when test="h1:Field[ @Type = '8450' ][ @Value = 'RETROKatalog' ]">
                                <xsl:call-template name="writeIndexFields">
                                    <xsl:with-param name="field" select=" 'msPart' "/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="physDesc"/>
                                <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Einband') ]]"/>
                                <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Fragment') ]]"/>
                                <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Handschrift') ]]
                                    [h1:Field[ @Type = '5210' ][ @Value = 'Fragment' ]]"/>
                                <xsl:call-template name="history"/>
                                <xsl:call-template name="additional"/>
                                <xsl:call-template name="msContents"/>
                                <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Faszikel') ]]"/><!--  and not(h1:Field[ @Type = '5210' ][ @Value = 'Fragment' ]) -->
                                <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Text') ]][(h1:Field[ @Type = 'par09'] or h1:Field[ @Type = 'par10']) and h1:Field[ @Type = 'bezper'][ @Value = 'Vorbesitz' ]]"/>
                                <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Beilage') ]]"/><!--  and not(h1:Field[ @Type = '5210' ][ @Value = 'Fragment' ]) -->
                                <xsl:call-template name="writeIndexFields">
                                    <xsl:with-param name="field" select=" 'msPart' "/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="h1:Block[not(@Type = 'obj')]
        [h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Text') ]]
        [not(h1:Field[ @Type = 'par09'] or h1:Field[ @Type = 'par10']) and not(h1:Field[ @Type = 'bezper'][ @Value = 'Vorbesitz' ])]">
        <xsl:apply-templates select="h1:Field[ @Type = 'par11' ][ @Value != '' ]"/>
        <xsl:call-template name="writeIndexFields">
            <xsl:with-param name="field" select=" 'note' "/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Einband') ]]">
        <xsl:element name="msPart" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="xml:id">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
            </xsl:attribute>
            <xsl:attribute name="type" select=" 'binding' "/>
            <xsl:element name="msIdentifier" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:text>Einband</xsl:text>
                </xsl:element>
            </xsl:element>
            <xsl:call-template name="head"><xsl:with-param name="calledFrom" select=" 'binding' "/></xsl:call-template>
            <xsl:apply-templates select="h1:Field[ @Type = 'par07' ][ @Value != '' ]"/>
            <xsl:if test="$mode = 'test' "><xsl:comment>Block/Einband</xsl:comment></xsl:if>
            <xsl:call-template name="history"/>
            <xsl:call-template name="additional"/>
            <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Fragment') ]]"/>
            <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Handschrift') ]]
                [
                h1:Field[ @Type = '5210' ][ @Value = 'Fragment' ] or 
                h1:Field[ @Type = '5240' ][ @Value = 'Fragment' ]
                ]"/>
            <xsl:call-template name="msContents"/>
            <xsl:call-template name="writeIndexFields">
                <xsl:with-param name="field" select=" 'msPart' "/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Beilage') ] and 
        not(h1:Field[ @Type = '5210' ][ @Value = 'Fragment' ])
        ]">
        <xsl:element name="msPart" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="xml:id">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
            </xsl:attribute>
            <xsl:attribute name="type" select=" 'accMat' "/>
            <xsl:element name="msIdentifier" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:choose>
                    <xsl:when test="h1:Field[ @Type = 'par01' ][ @Value != '' ]">
                        <xsl:apply-templates select="h1:Field[ @Type = 'par01' ][ @Value != '' ]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:text>Beilage </xsl:text>
                            <xsl:value-of select="count(preceding-sibling::h1:Block[
                                h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Beilage') ] and 
                                not(h1:Field[ @Type = '5210' ][ @Value = 'Fragment' ])
                                ]) + 1"/>
                            <xsl:if test="h1:Field[ @Type = '4665' ][ @Value != '' ]">
                                <xsl:value-of select="concat(' (', replace(replace(h1:Field[ @Type = '4665' ]/@Value, 'recto', 'r'), 'verso', 'v'), ')')"/>
                            </xsl:if>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:call-template name="head"><xsl:with-param name="calledFrom" select=" 'accMat' "/></xsl:call-template>
            <xsl:call-template name="physDesc"/>
            <xsl:if test="$mode = 'test' "><xsl:comment>Block/Beilage</xsl:comment></xsl:if>
            <xsl:call-template name="history"/>
            <xsl:call-template name="additional"/>
            <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Fragment') ]]"/>
            <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Handschrift') ]]
                [
                h1:Field[ @Type = '5210' ][ @Value = 'Fragment' ] or 
                h1:Field[ @Type = '5240' ][ @Value = 'Fragment' ]
                ]"/>
            <xsl:call-template name="msContents"/>
            <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Faszikel') ]]"/>
            <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Beilage') ] and 
                not(h1:Field[ @Type = '5210' ][ @Value = 'Fragment' ])]"/>
            <xsl:call-template name="writeIndexFields">
                <xsl:with-param name="field" select=" 'msPart' "/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Faszikel') ]] | 
        h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Text') ]][(h1:Field[ @Type = 'par09'] or h1:Field[ @Type = 'par10']) and h1:Field[ @Type = 'bezper'][ @Value = 'Vorbesitz' ]]">
        <xsl:element name="msPart" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="xml:id">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
            </xsl:attribute>
            <xsl:attribute name="type" select=" 'booklet' "/>
            <xsl:element name="msIdentifier" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:choose>
                    <xsl:when test="h1:Field[ @Type = 'par01' ][ @Value != '' ]">
                        <xsl:apply-templates select="h1:Field[ @Type = 'par01' ][ @Value != '' ]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:choose>
                                <xsl:when test="h1:Field[ @Type = 'par11' ][exists(following-sibling::h1:Field[ @Type = '4665' ])][contains(@Value, following-sibling::h1:Field[ @Type = '4665' ])]">
                                    <xsl:if test="$mode = 'test' "><xsl:comment>choose 1</xsl:comment></xsl:if>
                                    <xsl:text>Faszikel </xsl:text>
                                    <xsl:value-of select="replace(replace(h1:Field[ @Type = '4665' ]/@Value, 'recto', 'r'), 'verso', 'v')"/>
                                </xsl:when>
                                <xsl:when test="h1:Field[ @Type = 'par11' ][ @Value != '' ][following-sibling::h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Faszikel') ]]">
                                    <xsl:variable name="content">
                                        <xsl:apply-templates select="h1:Field[ @Type = 'par11' ][ @Value != '' ][following-sibling::h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Faszikel') ]]"/>
                                    </xsl:variable>
                                    <xsl:if test="$mode = 'test' "><xsl:comment>choose 2</xsl:comment></xsl:if>
                                    <xsl:text>Faszikel </xsl:text>
                                    <xsl:value-of select="$content/tei:note"/>
                                </xsl:when>
                                <xsl:when test="h1:Field[ @Type = 'par09' ][exists(following-sibling::h1:Field[ @Type = '4665' ])][contains(@Value, following-sibling::h1:Field[ @Type = '4665' ])]">
                                    <xsl:if test="$mode = 'test' "><xsl:comment>choose 3</xsl:comment></xsl:if>
                                    <xsl:text>Faszikel </xsl:text>
                                    <xsl:value-of select="replace(replace(h1:Field[ @Type = '4665' ]/@Value, 'recto', 'r'), 'verso', 'v')"/>
                                </xsl:when>
                                <xsl:when test="h1:Field[ @Type = 'par09' ]">
                                    <xsl:if test="$mode = 'test' "><xsl:comment>choose 4</xsl:comment></xsl:if>
                                    <xsl:value-of select="h1:Field[ @Type = '5230' ]/@Value"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="$mode = 'test' "><xsl:comment>choose 5</xsl:comment></xsl:if>
                                    <xsl:number count="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Faszikel') ]]" format="I"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:call-template name="head"><xsl:with-param name="calledFrom" select=" 'booklet' "/></xsl:call-template>
            <xsl:call-template name="physDesc"/>
            <xsl:if test="$mode = 'test' "><xsl:comment>Block/Faszikel</xsl:comment></xsl:if>
            <xsl:call-template name="history"/>
            <xsl:call-template name="additional"/>
            <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Fragment') ]]"/>
            <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Handschrift') ]]
                [
                h1:Field[ @Type = '5210' ][ @Value = 'Fragment' ] or 
                h1:Field[ @Type = '5240' ][ @Value = 'Fragment' ]
                ]"/>
            <xsl:call-template name="msContents"/>
            <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Faszikel') ]]"/>
            <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Beilage') ] and 
                not(h1:Field[ @Type = '5210' ][ @Value = 'Fragment' ])]"/>
            <xsl:call-template name="writeIndexFields">
                <xsl:with-param name="field" select=" 'msPart' "/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Fragment') ]]
        | h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Handschrift') ]]
        [
        h1:Field[ @Type = '5210' ][ @Value = 'Fragment' ] or 
        h1:Field[ @Type = '5240' ][ @Value = 'Fragment' ]
        ]
        [not(@Type = 'obj')]">
        <xsl:element name="msPart" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="xml:id">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
            </xsl:attribute>
            <xsl:attribute name="type" select=" 'fragment' "/>
            <xsl:element name="msIdentifier" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:choose>
                    <xsl:when test="h1:Field[ @Type = 'par01' ][ @Value != '' ]">
                        <xsl:apply-templates select="h1:Field[ @Type = 'par01' ][ @Value != '' ]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:text>Fragment </xsl:text>
                            <xsl:value-of select="count(preceding-sibling::h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Fragment') ]]) 
                                + count(preceding-sibling::h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Handschrift') ]]
                                [
                                h1:Field[ @Type = '5210' ][ @Value = 'Fragment' ] or 
                                h1:Field[ @Type = '5240' ][ @Value = 'Fragment' ]
                                ]
                                ) + 1"/>
                            <xsl:if test="h1:Field[ @Type = '4665' ][ @Value != '' ]">
                                <xsl:value-of select="concat(' (', replace(replace(h1:Field[ @Type = '4665' ]/@Value, 'recto', 'r'), 'verso', 'v'), ')')"/>
                            </xsl:if>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:call-template name="head"><xsl:with-param name="calledFrom" select=" 'fragment' "/></xsl:call-template>
            <xsl:call-template name="physDesc"/>
            <xsl:if test="$mode = 'test' "><xsl:comment>Block/Fragment</xsl:comment></xsl:if>
            <xsl:call-template name="history"/>
            <!--<xsl:call-template name="additional"/>-->
            <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Fragment') ]]"/>
            <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Handschrift') ]]
                [
                h1:Field[ @Type = '5210' ][ @Value = 'Fragment' ] or 
                h1:Field[ @Type = '5240' ][ @Value = 'Fragment' ]
                ]"/>
            <xsl:call-template name="msContents"/>
            <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Faszikel') ]]"/><!-- and not(h1:Field[ @Type = '5210' ][ @Value = 'Fragment' ]) -->
            <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Beilage') ] and 
                not(h1:Field[ @Type = '5210' ][ @Value = 'Fragment' ])]"/>
            <xsl:call-template name="writeIndexFields">
                <xsl:with-param name="field" select=" 'msPart' "/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="h1:Block[h1:Field[ @Type = '5230' ][ contains(@Value, 'Registereintrag') ]]" mode="index">
        <xsl:choose>
            <xsl:when test="contains(@Value, 'Initiale')">
                <xsl:apply-templates select="h1:Field[ @Type = '5240' ]" mode="index"/>
            </xsl:when>
            <xsl:when test="h1:Field[ @Type = 'bezper' ][ @Value = 'Autorschaft' ]">
                <xsl:apply-templates select="h1:Field[ @Type = 'bezper' ][ @Value = 'Autorschaft' ]" mode="index"/>
            </xsl:when>
            <xsl:when test="h1:Field[ @Type = 'bezwrk' ][ @Value = 'Abschrift' ][ h1:Field[ (@Type = '6930') or (@Type = '6930gi') or (@Type = '6922') or (@Type = '6923') ]]">
                <xsl:apply-templates select="h1:Field[ @Type = 'bezwrk' ][ @Value = 'Abschrift' ][ h1:Field[ (@Type = '6930') or (@Type = '6930gi') or (@Type = '6922') or (@Type = '6923') ]]" mode="index"/>
            </xsl:when>
            <xsl:when test="h1:Field[ @Type = '5007' ]">
                <xsl:apply-templates select="h1:Field[ @Type = '5007' ]" mode="index"/>
            </xsl:when>
            <xsl:when test="h1:Field[ @Type = '5500' ]">
                <xsl:apply-templates select="h1:Field[ @Type = '5500' ]" mode="index"/>
            </xsl:when>
            <xsl:when test="h1:Field[ @Type = '1200gi' ]">
                <xsl:apply-templates select="h1:Field[ @Type = '1200gi' ]" mode="index"/>
            </xsl:when>
            <xsl:when test="h1:Field[ @Type = '1200' ]">
                <xsl:apply-templates select="h1:Field[ @Type = '1200' ]" mode="index"/>
            </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="
              h1:Field[ @Type = '1202gi' ]
            | h1:Field[ @Type = '1204gi' ]
            | h1:Field[ @Type = '1212gi' ]
            | h1:Field[ @Type = '1800' ]
            | h1:Field[ @Type = '1802' ]
            | h1:Field[ @Type = '1804' ]
            | h1:Field[ @Type = '5650' ]
            | h1:Field[ @Type = '5704' ]
            | h1:Field[ @Type = 'bezper' ][ @Value != 'Autorschaft' ]
            | h1:Field[ @Type = 'bezsoz' ]
            | h1:Field[ @Type = 'bezwrk' ][ @Value != 'Abschrift' ][ h1:Field ]" mode="index"/>
    </xsl:template>

    <xsl:template match="h1:Field[ @Type = '1200' ]" mode="index">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:value-of select="concat('_', @Type)"/>
                <xsl:value-of select="concat('[', count(preceding-sibling::h1:Field[@Type = current()/@Type]), ']')"/>
            </xsl:attribute>
            <xsl:attribute name="indexName">
                <xsl:choose>
                    <xsl:when test="@Value != '' ">
                        <xsl:value-of select="translate(replace(replace(replace(replace(normalize-space(parent::h1:Block/h1:Field[ @Type = '5230' ]/@Value), ' &amp; ', '_'), ' &amp;', ''), ' / ', '-'), ' \(\?\)', ''), ' &amp;?(),', '-')"/>
                    </xsl:when>
                    <xsl:otherwise>unk</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
            <xsl:apply-templates select="following-sibling::h1:Field[ @Type = '1210' ]" mode="index"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '1200gi' ]" mode="index">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:value-of select="concat('_', @Type)"/>
                <xsl:value-of select="concat('[', count(preceding-sibling::h1:Field[@Type = current()/@Type]), ']')"/>
            </xsl:attribute>
            <xsl:attribute name="indexName">
                <xsl:choose>
                    <xsl:when test="@Value != '' ">
                        <xsl:value-of select="translate(replace(replace(replace(replace(normalize-space(parent::h1:Block/h1:Field[ @Type = '5230' ]/@Value), ' &amp; ', '_'), ' &amp;', ''), ' / ', '-'), ' \(\?\)', ''), ' &amp;?(),', '-')"/>
                    </xsl:when>
                    <xsl:otherwise>unk</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
            <xsl:apply-templates select="following-sibling::h1:Field[ @Type = '1210gi' ]" mode="index"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '1202gi' ]" mode="index">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
        <xsl:if test="preceding-sibling::h1:Field[ @Type = '1200gi' ][ @Value = 'Ikonographie' ]
                and preceding-sibling::h1:Field[ @Type = '5500' ]">
                <xsl:apply-templates select="preceding-sibling::h1:Field[ @Type = '5500' ]" mode="index"/>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '1204gi' ]" mode="index">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '1210' ]" mode="index">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
            <xsl:apply-templates select="following-sibling::h1:Field[ @Type = '1220' ]" mode="index"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '1210gi' ]" mode="index">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:choose>
                    <xsl:when test="preceding-sibling::h1:Field[ @Type = '1200gi' ][ (@Value = 'Einband') or (@Value = 'Einbände, bemerkenswerte') ]
                        and preceding-sibling::h1:Field[ @Type = '5240' ]">
                        <xsl:call-template name="writeThesaurusFields">
                            <xsl:with-param name="field" select=" 'BNDG-5240' "/>
                            <xsl:with-param name="value" select="preceding-sibling::h1:Field[ @Type = '5240' ]/@Value"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
            <xsl:apply-templates select="following-sibling::h1:Field[ @Type = '1220gi' ]" mode="index"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '1212gi' ]" mode="index">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '1220' ]" mode="index">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '1220gi' ]" mode="index">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
            <xsl:apply-templates select="following-sibling::h1:Field[ @Type = '1230gi' ]" mode="index"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '1230gi' ]" mode="index">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
            <xsl:apply-templates select="following-sibling::h1:Field[ @Type = '1240gi' ]" mode="index"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '1240gi' ]" mode="index">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '1800' ]" mode="index"><!-- Initium lateinisch -->
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="indexName" select=" 'Initium' "/>
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:call-template name="writeInitiumRef"/>
                <xsl:call-template name="writeInitium">
                    <xsl:with-param name="value" select="@Value"/>
                </xsl:call-template>
            </xsl:element>
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select=" 'textLang-ID'"/>
                <xsl:call-template name="writeLangRef">
                    <xsl:with-param name="value">lateinisch</xsl:with-param>
                </xsl:call-template>
            </xsl:element>
            <xsl:apply-templates select="parent::h1:Block/h1:Field[ @Type = '1950' ]/h1:Field[ @Type = '1961' ]" mode="index"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '1802' ]" mode="index"><!-- Initium deutsch -->
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="indexName" select=" 'Initium' "/>
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:call-template name="writeInitiumRef"/>
                <xsl:call-template name="writeInitium">
                    <xsl:with-param name="value" select="@Value"/>
                </xsl:call-template>
                <!--<xsl:value-of select="normalize-space(@Value)"/>-->
            </xsl:element>
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select=" 'textLang-ID'"/>
                <xsl:call-template name="writeLangRef">
                    <xsl:with-param name="value">deutsch</xsl:with-param>
                </xsl:call-template>
            </xsl:element>
            <xsl:apply-templates select="parent::h1:Block/h1:Field[ @Type = '1950' ]/h1:Field[ @Type = '1961' ]" mode="index"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '1802a' ]" mode="index"><!-- Grundwort Lexer -->
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="indexName" select=" 'Grundwort-Lexer' "/>
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:attribute name="xml:lang" select=" 'de' "/>
                <xsl:call-template name="writeInitium">
                    <xsl:with-param name="value" select="@Value"/>
                </xsl:call-template>
                <!--<xsl:value-of select="normalize-space(@Value)"/>-->
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '1802b' ]" mode="index"><!-- Grundwort Lübben -->
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="indexName" select=" 'Grundwort-Luebben' "/>
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:attribute name="xml:lang" select=" 'de' "/>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '1804' ]" mode="index"><!-- Initium variaspr. -->
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="indexName" select=" 'Initium' "/>
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:call-template name="writeInitium">
                    <xsl:with-param name="value" select="@Value"/>
                </xsl:call-template>
                <!--<xsl:value-of select="normalize-space(@Value)"/>-->
            </xsl:element>
            <xsl:apply-templates select="parent::h1:Block/h1:Field[ @Type = '1950' ]/h1:Field[ @Type = '1961' ]" mode="index"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '1961' ]" mode="index"><!-- GI-Folio-Nr. -->
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:choose>
                    <xsl:when test="contains(@Value, 'recto')">
                        <xsl:value-of select="number(substring-before(normalize-space(@Value), 'recto'))"/>
                        <xsl:text>r</xsl:text>
                        <xsl:value-of select="substring-after(normalize-space(@Value), 'recto')"/>
                    </xsl:when>
                    <xsl:when test="contains(@Value, 'verso')">
                        <xsl:value-of select="number(substring-before(normalize-space(@Value), 'verso'))"/>
                        <xsl:text>r</xsl:text>
                        <xsl:value-of select="substring-after(normalize-space(@Value), 'verso')"/>
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of select="normalize-space(@Value)"/></xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '4100' ] | h1:Field[ @Type = '4100gi' ]" mode="index"><!-- Personensname -->
        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select="@Type"/>
            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:if test="following-sibling::h1:Field[ @Type = '4475' ][@Value != '']">
                    <xsl:attribute name="role">
                        <xsl:call-template name="writeRole">
                            <xsl:with-param name="value" select="following-sibling::h1:Field[ @Type = '4475' ]/@Value"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="parent::h1:Field/h1:Field[ @Type = 'z001' ][starts-with(@Value, 'http://d-nb.info/gnd/') and matches(@Value, '\d+')]">
                        <xsl:attribute name="ref" select="parent::h1:Field/h1:Field[ @Type = 'z001' ]/@Value"/>
                    </xsl:when>
                    <xsl:when test="parent::h1:Field/h1:Field[ @Type = 'z001' ][contains(lower-case(@Value), 'gnd') and matches(@Value, '\d+')]">
                        <xsl:attribute name="ref" select="concat('https://d-nb.info/gnd/', translate(lower-case(parent::h1:Field/h1:Field[ @Type = 'z001' ]/@Value), 'gndeiu/:_ ', ''))"/>
                    </xsl:when>
                    <xsl:when test="contains(lower-case(parent::h1:Field/h1:Field[ @Type = 'z001' ]/@Value), '(DE-588)')">
                        <xsl:attribute name="ref" select="concat('https://d-nb.info/gnd/', substring-after(parent::h1:Field/h1:Field[ @Type = 'z001' ]/@Value, '(DE-588)'))"/>
                    </xsl:when>
                    <xsl:when test="parent::h1:Field/h1:Field[ @Type = 'z001' ][matches(@Value, '\d+')]">
                        <xsl:attribute name="ref" select="concat('https://d-nb.info/gnd/', translate(lower-case(parent::h1:Field/h1:Field[ @Type = 'z001' ]/@Value), 'gndeiu/:_ ', ''))"/>
                    </xsl:when>
                    <xsl:when test="following-sibling::h1:Field[ @Type = '4498' ][contains(@Value, 'GND:')][contains(substring-after(@Value, 'GND:'), ',') or contains(substring-after(@Value, 'GND:'), ';') or contains(substring-after(@Value, 'GND:'), '&amp;')]">
                        <xsl:attribute name="ref">
                            <xsl:value-of select="concat('https://d-nb.info/gnd/', following-sibling::h1:Field[ @Type = '4498' ]/normalize-space(tokenize(substring-after(@Value, 'GND:'), '(,)|(;)|(&amp;)')[1]))"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="following-sibling::h1:Field[ @Type = '4498' ][contains(@Value, 'GND:')]">
                        <xsl:attribute name="ref">
                            <xsl:value-of select="concat('https://d-nb.info/gnd/', following-sibling::h1:Field[ @Type = '4498' ]/normalize-space(substring-after(@Value, 'GND:')))"/>
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
            <xsl:choose>
                <xsl:when test="parent::h1:Field[ @Type = 'bezper' ][ @Value = 'Autorschaft' ]/following-sibling::h1:Field[ @Type = 'bezwrk' ][ h1:Field[ (@Type = '6930') or (@Type = '6930gi') or (@Type = '6922') or (@Type = '6923') ]]">
                    <xsl:apply-templates select="parent::h1:Field[ @Type = 'bezper' ][ @Value = 'Autorschaft' ]/following-sibling::h1:Field[ @Type = 'bezwrk' ][ h1:Field[ (@Type = '6930') or (@Type = '6930gi') or (@Type = '6922') or (@Type = '6923') ]]" mode="index"/>
                </xsl:when>
                <xsl:when test="parent::h1:Field[ @Type = 'bezper' ][ @Value = 'Autorschaft' ]/following-sibling::h1:Field[ @Type = '1950' ]/h1:Field[ @Type = '1961' ]">
                    <xsl:apply-templates select="parent::h1:Field[ @Type = 'bezper' ][ @Value = 'Autorschaft' ]/following-sibling::h1:Field[ @Type = '1950' ]/h1:Field[ @Type = '1961' ]" mode="index"/>
                </xsl:when>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '4470' ]" mode="index"><!-- Authentizität --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '4475' ]" mode="index"><!-- Tätigkeit --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '4496' ]" mode="index"><!-- Geltungsdauer --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '4498' ]" mode="index"><!-- Person-Komm. --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '4564' ]" mode="Verwaltung"><!-- Ort -->
        <xsl:element name="settlement" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:value-of select="normalize-space(@Value)"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '4564' ]" mode="index">
        <xsl:if test="$mode = 'test'"><xsl:comment><xsl:value-of select="translate(ancestor::h1:Block[1]/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/></xsl:comment></xsl:if>
        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select="@Type"/>
            <xsl:element name="settlement" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '4590' ]" mode="index"><!-- Sozietätsart --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '4594' ]" mode="index"><!-- Träger --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '4596' ]" mode="index"><!-- Patrozinium --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '4600' ]" mode="Verwaltung"><!-- Sozietätsname -->
        <xsl:element name="repository" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:choose>
                <xsl:when test="parent::h1:Field/h1:Field[ @Type = '4502norm' ]">
                    <xsl:attribute name="ref" select="concat('https://d-nb.info/gnd/', parent::h1:Field/h1:Field[ @Type = '4502norm' ]/@Value)"/>
                </xsl:when>
                <xsl:when test="following-sibling::h1:Field[ @Type = '4998' ][starts-with(@Value, 'GND: ')]">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('https://d-nb.info/gnd/', following-sibling::h1:Field[ @Type = '4998' ]/substring-before(substring-before(substring-after(@Value, 'GND: '), ','), ';'))"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="parent::h1:Field/h1:Field[ @Type = '4503norm' ]">
                    <xsl:attribute name="ref" select="concat('https://isil.staatsbibliothek-berlin.de/isil/', parent::h1:Field/h1:Field[ @Type = '4503norm' ]/@Value)"/>
                </xsl:when>
                <xsl:when test="parent::h1:Field/h1:Field[ @Type = '4500' ]">
                    <xsl:attribute name="key">
                        <xsl:value-of select="concat('soz_', parent::h1:Field/h1:Field[ @Type = '4500' ]/@Value)"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="parent::h1:Field/h1:Field[ @Type = '4604' ]">
                <xsl:attribute name="rend">
                    <xsl:value-of select="parent::h1:Field/h1:Field[ @Type = '4604' ]/@Value"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="normalize-space(@Value)"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '4600' ]" mode="index">
        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select="@Type"/>
            <xsl:element name="orgName" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:choose>
                    <xsl:when test="parent::h1:Field/h1:Field[ @Type = '4502norm' ]">
                        <xsl:attribute name="ref" select="concat('https://d-nb.info/gnd/', parent::h1:Field/h1:Field[ @Type = '4502norm' ]/@Value)"/>
                    </xsl:when>
                    <xsl:when test="following-sibling::h1:Field[ @Type = '4998' ][contains(@Value, 'GND:')][contains(substring-after(@Value, 'GND:'), ',') or contains(substring-after(@Value, 'GND:'), ';') or contains(substring-after(@Value, 'GND:'), '&amp;')]">
                        <xsl:attribute name="ref">
                            <xsl:value-of select="concat('https://d-nb.info/gnd/', following-sibling::h1:Field[ @Type = '4998' ]/normalize-space(tokenize(substring-after(@Value, 'GND:'), '(,)|(;)|(&amp;)')[1]))"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="following-sibling::h1:Field[ @Type = '4998' ][contains(@Value, 'GND:')]">
                        <xsl:attribute name="ref">
                            <xsl:value-of select="concat('https://d-nb.info/gnd/', following-sibling::h1:Field[ @Type = '4998' ]/normalize-space(substring-after(@Value, 'GND:')))"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="parent::h1:Field/h1:Field[ @Type = '4503norm' ]">
                        <xsl:attribute name="ref" select="concat('https://isil.staatsbibliothek-berlin.de/isil/', parent::h1:Field/h1:Field[ @Type = '4503norm' ]/@Value)"/>
                    </xsl:when>
                    <xsl:when test="parent::h1:Field/h1:Field[ @Type = '4500' ]">
                        <xsl:attribute name="key">
                            <xsl:value-of select="concat('soz_', parent::h1:Field/h1:Field[ @Type = '4500' ]/@Value)"/>
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '4610' ]" mode="index"><!-- Person --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '4614' ]" mode="index"><!-- Titel --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '4630' ]" mode="index"><!-- Abteilung --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '4643' ]"><!-- Sammlung -->
        <xsl:element name="collection" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:value-of select="normalize-space(@Value)"/><xsl:apply-templates select="h1:Field"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '4645' ]"><!-- Grundsignatur -->
        <xsl:element name="collection" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type">baseShelfmarkGroup</xsl:attribute>
            <xsl:value-of select="normalize-space(@Value)"/><xsl:apply-templates select="h1:Field"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '4650' ]" mode="Verwaltung"><!-- Signatur -->
        <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:value-of select="normalize-space(@Value)"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '4650' ]" mode="index">
        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select="@Type"/>
            <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '4652' ]" mode="index">
        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select="@Type"/>
            <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select=" 'former' "/>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '4656' ]" mode="index"><!-- Akzess-Nr. -->
        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select="@Type"/>
            <xsl:value-of select="normalize-space(@Value)"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '4665' ]"><!-- Folio-Nr. -->
        <xsl:value-of select="replace(replace(@Value, 'recto', 'r'), 'verso', 'v')"/>
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '4970' ]" mode="index"><!-- Authentizität --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '4975' ]" mode="index"><!-- Tätigkeit --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '4996' ]" mode="index"><!-- Geltungsdauer -->
        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select="@Type"/>
            <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '4998' ]" mode="index"><!-- Sozietäts-Komm.* -->
        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select="@Type"/>
            <xsl:choose>
                <xsl:when test="matches(@Value, 'EBDB [srp]\d{6}$')">
                    <xsl:attribute name="ref" select="concat('http://www.hist-einband.de/?wz=', substring-after(@Value, 'EBDB '))"/>
                </xsl:when>
                <xsl:when test="matches(@Value, 'EBDB w\d{6}$')">
                    <xsl:attribute name="ref" select="concat('http://www.hist-einband.de/?ws=', substring-after(@Value, 'EBDB '))"/>
                </xsl:when>
                <xsl:when test="matches(@Value, 'EBDB m\d{6}$')">
                    <xsl:attribute name="ref" select="concat('http://www.hist-einband.de/?wm=', substring-after(@Value, 'EBDB '))"/>
                </xsl:when>
                <xsl:when test="matches(@Value, 'EBDB m\d{7}')"><xsl:message>EBDB-Nummer zu lang: <xsl:value-of select="@Value"/></xsl:message></xsl:when>
            </xsl:choose>
            <xsl:value-of select="normalize-space(@Value)"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5007' ]" mode="index">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:value-of select="concat('_', @Type)"/>
                <xsl:value-of select="concat('[', count(preceding-sibling::h1:Field[@Type = current()/@Type]), ']')"/>
            </xsl:attribute>
            <xsl:attribute name="indexName">
                <xsl:choose>
                    <xsl:when test="@Value and (@Value != '') and (@Value != 'x') and (@Value != 'xxx') and (@Value != '-') and (@Value != '---') and (@Value != '--- x')">
                        <xsl:value-of select="replace(translate(replace(replace(normalize-space(@Value), '\p{P}', ''), ' / ', '-'), ' \(\)\[\]\?&lt;&gt;=', '-'), '--', '_')"/>
                    </xsl:when>
                    <xsl:otherwise>unk</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="h1:Field[ @Type = '501k' ]">
                    <xsl:apply-templates select="h1:Field[ @Type = '501k' ]" mode="index"/>
                </xsl:when>
                <xsl:when test="h1:Field[ @Type = '501m' ]">
                    <xsl:apply-templates select="h1:Field[ @Type = '501m' ]" mode="index"/>
                </xsl:when>
                <xsl:when test="h1:Field[ @Type = '501p' ]">
                    <xsl:apply-templates select="h1:Field[ @Type = '501p' ]" mode="index"/>
                </xsl:when>
                <xsl:when test="h1:Field[ @Type = '501t' ]">
                    <xsl:apply-templates select="h1:Field[ @Type = '501t' ]" mode="index"/>
                </xsl:when>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <!--<xsl:template match="h1:Field[ @Type = '501k' ]" mode="index"><!-\- Bez-Verwalter -\-><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>-->
    <xsl:template match="h1:Field[ @Type = '501m' ]" mode="index"><!-- Bez-Signatur -->
        <xsl:variable name="type" select="@Type"/>
        <xsl:variable name="field501x"><xsl:copy-of select="following-sibling::h1:Field[starts-with(@Type, '501')]"/></xsl:variable>
        <xsl:for-each select="tokenize(@Value, '&amp;')">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="$type"/>
                <xsl:value-of select="normalize-space(.)"/>
            <xsl:choose>
                    <xsl:when test="$field501x//h1:Field[ @Type = '501p' ]">
                        <xsl:element namespace="http://www.tei-c.org/ns/1.0" name="index">
                            <xsl:apply-templates mode="index" select="$field501x//h1:Field[ @Type = '501p' ]"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="$field501x//h1:Field[ @Type = '501t' ]">
                        <xsl:element namespace="http://www.tei-c.org/ns/1.0" name="index">
                            <xsl:apply-templates mode="index" select="$field501x//h1:Field[ @Type = '501t' ]"/>
                        </xsl:element>
                    </xsl:when>
                </xsl:choose>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '501p' ]" mode="index"><!-- Bez-Folio-Nr. -->
        <xsl:variable name="type" select="@Type"/>
        <xsl:variable name="field501x"><xsl:copy-of select="following-sibling::h1:Field[starts-with(@Type, '501')]"/></xsl:variable>
        <xsl:for-each select="tokenize(@Value, '&amp;')">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="$type"/>
                <xsl:value-of select="normalize-space(replace(replace(., 'recto', 'r'), 'verso', 'v'))"/>
            <xsl:choose>
                    <xsl:when test="$field501x//h1:Field[ @Type = '501t' ]">
                        <xsl:element namespace="http://www.tei-c.org/ns/1.0" name="index">
                            <xsl:apply-templates mode="index" select="$field501x//h1:Field[ @Type = '501t' ]"/>
                        </xsl:element>
                    </xsl:when>
                </xsl:choose>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '501t' ]" mode="index"><!-- Beschreibung* --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5060' ]" mode="index">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(ancestor::h1:Block[1]/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:value-of select="concat('_', @Type)"/>
                <xsl:value-of select="concat('[', count(preceding-sibling::h1:Field[@Type = current()/@Type]), ']')"/>
            </xsl:attribute>
            <xsl:attribute name="indexName">
                <xsl:choose>
                    <xsl:when test="@Value and (@Value != '') and (@Value != 'x') and (@Value != 'xxx') and (@Value != '-') and (@Value != '---') and (@Value != '--- x')">
                        <xsl:value-of select="translate(replace(replace(replace(replace(normalize-space(@Value), ' &amp; ', '_'), ' &amp;', ''), ' / ', '-'), '\p{P}', ''), ' \(\)\[\]\?&lt;&gt;=', '-')"/>
                    </xsl:when>
                    <xsl:otherwise>unk</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="h1:Field" mode="index"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5064' ]"><!-- Datierung (num.) -->
        <xsl:call-template name="writeNormalisedDate"/>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5064' ]" mode="index"><!-- Datierung (num.) --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:call-template name="writeNormalisedDate"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5064vt' ]"><!-- Datierung (num.) vt --><xsl:value-of select="normalize-space(@Value)"/><xsl:apply-templates select="h1:Field"/></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5130' ]"><!-- Entstehungsort --><xsl:value-of select="normalize-space(@Value)"/><xsl:apply-templates select="h1:Field"/></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5130' ]" mode="index"><!-- Entstehungsort --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:call-template name="writeNormalisedDate"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5130vt' ]"><!-- Entstehungsort vt --><xsl:value-of select="normalize-space(@Value)"/><xsl:apply-templates select="h1:Field"/></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5200' ]"><!-- Objekttitel* --><xsl:value-of select="normalize-space(@Value)"/><xsl:apply-templates select="h1:Field"/></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5200' ]" mode="index"><!-- Objekttitel* -->
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="indexName">Objekttitel</xsl:attribute>
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5209' ]"><!-- ÜBERSCHRIFT* --><xsl:value-of select="normalize-space(@Value)"/><xsl:apply-templates select="h1:Field"/></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5209vt' ]"><!-- ÜBERSCHRIFT_VT* --><xsl:value-of select="normalize-space(@Value)"/><xsl:apply-templates select="h1:Field"/></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5234' ]" mode="index"><!-- Sonderfunktion -->
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="indexName">Sonderfunktion</xsl:attribute>
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5240' ]" mode="index"><!-- Formtyp -->
        <xsl:choose>
            <xsl:when test="contains(@Value, '&amp;')">
                <xsl:for-each select="tokenize(@Value, '&amp;')">
                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="indexName">Formtyp</xsl:attribute>
                        <xsl:call-template name="writeThesaurusFields">
                            <xsl:with-param name="field" select=" 'BNDG-5240' "/>
                            <xsl:with-param name="value" select="normalize-space(.)"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="indexName">Formtyp</xsl:attribute>
                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="type" select=" 'form' "/>
                        <xsl:value-of select="normalize-space(@Value)"/>
                    </xsl:element>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5260' ]"><!-- Material -->
        <xsl:if test="preceding-sibling::h1:Field[ @Type = '5260' ]"><xsl:text>, </xsl:text></xsl:if>
        <xsl:value-of select="normalize-space(@Value)"/>
        <xsl:apply-templates select="h1:Field"/>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5260vt' ]"><!-- Material-VT* -->
        <xsl:if test="preceding-sibling::h1:Field[ @Type = '5260vt' ]"><xsl:text>, </xsl:text></xsl:if>
        <xsl:value-of select="normalize-space(@Value)"/>
        <xsl:apply-templates select="h1:Field"/>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5360' ]"><!-- Höhe x Breite (cm) --><xsl:value-of select="normalize-space(replace(@Value, '\s*x\s*', ' × '))"/></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5360vt' ]"><!-- Höhe x Breite (cm) vt --><xsl:value-of select="normalize-space(replace(@Value, '\s*x\s*', ' × '))"/></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5500' ]" mode="index"><!-- Ikonographie -->
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="indexName" select=" 'Notation' "/>
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:choose>
                    <xsl:when test="contains(@Value, '&amp;')">
                        <xsl:for-each select="tokenize(@Value, '&amp;')">
                            <xsl:call-template name="writeIconClass">
                                <xsl:with-param name="value" select="normalize-space(.)"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="writeIconClass">
                            <xsl:with-param name="value" select="@Value"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:for-each select="h1:Field[starts-with(@Type, '550')]">
                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:apply-templates select="self::h1:Field[starts-with(@Type, '550')]" mode="index"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5502' ]" mode="index"><!-- Erläuterung -->
        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select="@Type"/>
            <xsl:value-of select="normalize-space(@Value)"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5504' ]" mode="index"><!-- Schlagwort -->
        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select="@Type"/>
            <xsl:value-of select="normalize-space(@Value)"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5650' ]" mode="index">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(ancestor::h1:Block[1]/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:value-of select="concat('_', @Type)"/>
                <xsl:value-of select="concat('[', count(preceding-sibling::h1:Field[@Type = current()/@Type]), ']')"/>
            </xsl:attribute>
            <xsl:attribute name="indexName">
                <xsl:choose>
                    <xsl:when test="@Value and (@Value != '') and (@Value != 'x') and (@Value != 'xxx') and (@Value != '-') and (@Value != '---') and (@Value != '--- x')">
                        <xsl:value-of select="translate(replace(replace(replace(replace(normalize-space(@Value), ' &amp; ', '_'), ' &amp;', ''), ' / ', '-'), '\p{P}', ''), ' \(\)\[\]\?&lt;&gt;=', '-')"/>
                    </xsl:when>
                    <xsl:otherwise>unk</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="h1:Field" mode="index"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5664' ]" mode="index"><!-- Datierung --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[starts-with(@Type, '5666')]" mode="index">
        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select="@Type"/>
            <xsl:call-template name="writeInitiumRef"/>
            <xsl:call-template name="writeInitium">
                <xsl:with-param name="value" select="@Value"/>
            </xsl:call-template>
        </xsl:element>
        <xsl:if test="ends-with(@Type, 'd') or ends-with(@Type, 'g') or ends-with(@Type, 'l') or (
            ends-with(@Type, 'v') and (
                h1:Field[ @Type = '5680' ]/@Value = 'französisch' or 
                h1:Field[ @Type = '5680' ]/@Value = 'hebräisch' or 
                contains(h1:Field[ @Type = '5680' ]/@Value, 'niederländisch')
                )
            )">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select=" 'textLang-ID'"/>
                <xsl:call-template name="writeLangRef">
                    <xsl:with-param name="value">
                        <xsl:choose>
                            <xsl:when test="ends-with(@Type, 'd')">deutsch</xsl:when>
                            <xsl:when test="ends-with(@Type, 'g')">griechisch</xsl:when>
                            <xsl:when test="ends-with(@Type, 'l')">lateinisch</xsl:when>
                            <xsl:when test="ends-with(@Type, 'v') and h1:Field[ @Type = '5680' ]/@Value = 'französisch' ">französisch</xsl:when>
                            <xsl:when test="ends-with(@Type, 'v') and h1:Field[ @Type = '5680' ]/@Value = 'hebräisch' ">hebräisch</xsl:when>
                            <xsl:when test="ends-with(@Type, 'v') and h1:Field[ @Type = '5680' ]/@Value = 'italienisch' ">italienisch</xsl:when>
                            <xsl:when test="ends-with(@Type, 'v') and contains(h1:Field[ @Type = '5680' ]/@Value, 'niederländisch') ">niederländisch</xsl:when>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5684' ]" mode="index"><!-- Inhalt --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5686' ]" mode="index"><!-- Text --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5688' ]" mode="index"><!-- Übersetzung --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5694' ]" mode="index"><!-- Anbringungsort -->
        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select="@Type"/>
            <xsl:value-of select="replace(replace(@Value, 'recto', 'r'), 'verso', 'v')"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5704' ]" mode="index"><!-- Schriftart -->
        <xsl:call-template name="writeThesaurusFields"><xsl:with-param name="field" select=" 'SCRP-5704' "/><xsl:with-param name="value" select="@Value"/></xsl:call-template>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5705' ]"><!-- Notation -->
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="indexName">Notation</xsl:attribute>
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:value-of select="replace(replace(@Value, 'recto', 'r'), 'verso', 'v')"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5706' ]"><!-- Blattzahl --><xsl:value-of select="normalize-space(@Value)"/><xsl:apply-templates select="h1:Field"/></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5706vt' ]"><!-- Blattzahl_vt --><xsl:value-of select="normalize-space(@Value)"/><xsl:apply-templates select="h1:Field"/></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5707' ]"><!-- Zeilenzahl --><xsl:value-of select="normalize-space(@Value)"/><xsl:apply-templates select="h1:Field"/></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5708' ]"><!-- Spaltenzahl --><xsl:value-of select="normalize-space(@Value)"/><xsl:apply-templates select="h1:Field"/></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5710' ]">
        <xsl:choose>
            <xsl:when test="@Value = 'serbokroatisch' ">
                <xsl:call-template name="writeLangRef"><xsl:with-param name="value" select=" 'serbisch' "/></xsl:call-template>
                <xsl:call-template name="writeLangRef"><xsl:with-param name="value" select=" 'kroatisch' "/></xsl:call-template>
            </xsl:when>
            <xsl:when test="not(preceding-sibling::h1:Field[ @Type = '5710' ]) or 
                normalize-space(translate(lower-case(@Value), '(?)', '')) != preceding-sibling::h1:Field[ @Type = '5710' ]/normalize-space(translate(lower-case(@Value), '(?)', ''))">
                <xsl:call-template name="writeLangRef">
                    <xsl:with-param name="value" select="normalize-space(translate(lower-case(@Value), '(?)', ''))"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="preceding-sibling::h1:Field[ @Type = '5710' ] and following-sibling::h1:Field[ @Type = '5710' ]"><xsl:text> </xsl:text></xsl:if>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '599a' ][ 
           (@Value = 'Zeilen')
        or (@Value = 'Zeilenzahl')
        or (@Value = 'Spalten') 
        or (@Value = 'Spaltenzahl') 
        or (@Value = 'AUSSTATTUNG')
        or (@Value = 'INITIALEN')
        or (@Value = 'LAGEN')
        or (@Value = 'MINIATUREN') 
        or (@Value = 'Ornament') 
        or (@Value = 'Schrift') 
        or (@Value = 'Erhaltung') 
        ]
        | h1:Field[ @Value = 'Beschreibung' ][not(parent::h1:Field/h1:Field[ @Type = '1200gi' ])]">
        <xsl:apply-templates select="h1:Field[ @Type = '599e' ]"/>
        <xsl:if test=" @Value = 'Zeilenzahl' "><xsl:text> Zeilen.</xsl:text></xsl:if>
        <xsl:if test=" @Value = 'Spaltenzahl' "><xsl:text> Spalten.</xsl:text></xsl:if>
        <xsl:if test="following-sibling::h1:Field[ @Type = '599a' ][ 
               (@Value = 'Zeilen')
            or (@Value = 'Zeilenzahl')
            or (@Value = 'Spalten') 
            or (@Value = 'Spaltenzahl') 
            or (@Value = 'AUSSTATTUNG')
            or (@Value = 'INITIALEN')
            or (@Value = 'LAGEN')
            or (@Value = 'MINIATUREN') 
            or (@Value = 'Ornament') 
            or (@Value = 'Schrift') 
            or (@Value = 'Erhaltung') 
            ]
            or h1:Field[ @Value = 'Beschreibung' ][not(parent::h1:Field/h1:Field[ @Type = '1200gi' ])]">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '599e' ]">
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
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '6524' ]" mode="index"><!-- Datierung --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6560' ]" mode="index"><!-- Art des Zeichens -->
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:value-of select="concat('_', @Type)"/>
                <xsl:value-of select="concat('[', count(preceding-sibling::h1:Field[@Type = current()/@Type]), ']')"/>
            </xsl:attribute>
            <xsl:attribute name="indexName">
                <xsl:choose>
                    <xsl:when test="@Value and (@Value != '') and (@Value != 'x') and (@Value != 'xxx') and (@Value != '-') and (@Value != '---') and (@Value != '--- x')">
                        <xsl:value-of select="translate(replace(replace(replace(replace(normalize-space(@Value), ' &amp; ', '_'), ' &amp;', ''), ' / ', '-'), '\p{P}', ''), ' \(\)\[\]\?&lt;&gt;=', '-')"/>
                    </xsl:when>
                    <xsl:otherwise>unk</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="h1:Field" mode="index"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '6565' ]" mode="index"><!-- Zeichen-Kurztitel --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6568' ]" mode="index"><!-- Beschreibung* --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6694' ]" mode="index"><!-- Anbringungsort -->
        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select="@Type"/>
            <xsl:value-of select="replace(replace(@Value, 'recto', 'r'), 'verso', 'v')"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '6740' ]" mode="index"><!-- Lokalisierung --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6770' ]" mode="index"><!-- Repertorium -->
        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select="@Type"/>
            <xsl:choose>
                <xsl:when test="matches(@Value, 'EBDB [srp]\d{6}$')">
                    <xsl:attribute name="ref" select="concat('http://www.hist-einband.de/?wz=', substring-after(@Value, 'EBDB '))"/>
                </xsl:when>
                <xsl:when test="matches(@Value, 'EBDB w\d{6}$')">
                    <xsl:attribute name="ref" select="concat('http://www.hist-einband.de/?ws=', substring-after(@Value, 'EBDB '))"/>
                </xsl:when>
                <xsl:when test="matches(@Value, 'EBDB m\d{6}$')">
                    <xsl:attribute name="ref" select="concat('http://www.hist-einband.de/?wm=', substring-after(@Value, 'EBDB '))"/>
                </xsl:when>
                <xsl:when test="matches(@Value, 'EBDB m\d{7}')"><xsl:message>EBDB-Nummer zu lang: <xsl:value-of select="@Value"/></xsl:message></xsl:when>
            </xsl:choose>
            <xsl:value-of select="normalize-space(@Value)"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '6773' ]" mode="index"><!-- Identitätsgrad --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6807' ]" mode="index"><!-- Motiv --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6817' ]" mode="index"><!-- Motivzusatz --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6876' ]" mode="index"><!-- Transkription --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6920' ]" mode="index"><!-- Literaturgattung -->
        <xsl:for-each select="tokenize(@Value, '&amp;')">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select=" '6920' "/><xsl:value-of select="normalize-space(.)"/></xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '6922' ]" mode="index"><!-- Sacherschließung --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6923' ]" mode="index"><!-- Sacherschl.-Ort --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6930' ]" mode="index"><!-- Sachtitel --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6930gi' ]" mode="index"><!-- Sachtitel-GI --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6996' ]" mode="index"><!-- Textversion --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6998' ]" mode="index"><!-- Kommentar --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '8330' ]"><!-- Literat-Kurztitel -->
        <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type">short</xsl:attribute>
            <xsl:value-of select="normalize-space(@Value)"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '8330' ]" mode="index"><!-- Literat-Kurztitel --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '8334' ]"><!-- Stelle -->
        <!--<xsl:element name="biblScope" namespace="http://www.tei-c.org/ns/1.0">-->
            <xsl:value-of select="normalize-space(@Value)"/>
        <!--</xsl:element>-->
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '8334' ]" mode="index"><!-- Literat-Kurztitel --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    
    <xsl:template match="h1:Field[ @Type = 'bezlit' ][ @Value != 'Katalogtext' ]" mode="index"><!-- Bezieh @ Literatur -->
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:value-of select="concat('_', @Type)"/>
                <xsl:value-of select="concat('[', count(preceding-sibling::h1:Field[@Type = current()/@Type]), ']')"/>
            </xsl:attribute>
            <xsl:attribute name="indexName">
                <xsl:choose>
                    <xsl:when test="@Value != '' ">
                        <xsl:value-of select="translate(replace(replace(replace(replace(normalize-space(@Value), ' &amp; ', '_'), ' &amp;', ''), ' / ', '-'), '\p{P}', ''), ' \(\)\[\]\?&lt;&gt;=', '-')"/>
                    </xsl:when>
                    <xsl:otherwise>unk</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="h1:Field" mode="index"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'bezper' ]" mode="index"><!-- Bezieh @ Person -->
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:value-of select="concat('_', @Type)"/>
                <xsl:value-of select="concat('[', count(preceding-sibling::h1:Field[@Type = current()/@Type]), ']')"/>
            </xsl:attribute>
            <xsl:attribute name="indexName">
                <xsl:choose>
                    <xsl:when test="@Value and (@Value != '') and (@Value != 'x') and (@Value != 'xxx') and (@Value != '-') and (@Value != '---') and (@Value != '--- x')">
                        <xsl:value-of select="translate(replace(replace(replace(replace(normalize-space(@Value), ' &amp; ', '_'), ' &amp;', ''), ' / ', '-'), '\p{P}', ''), ' \(\)\[\]\?&lt;&gt;=', '-')"/>
                    </xsl:when>
                    <xsl:otherwise>unk</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="h1:Field[ @Type = '4100' ]">
                    <xsl:apply-templates select="h1:Field[not(@Type = '4475')]" mode="index"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="h1:Field" mode="index"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'bezsoz' ]"><!-- Bezieh @ Sozietät -->
        <xsl:choose>
            <xsl:when test=" @Value = 'Verwaltung' ">
                <xsl:apply-templates select="h1:Field[ @Type = '4564' ]" mode="Verwaltung"/>
                <xsl:apply-templates select="h1:Field[ @Type = '4600' ]" mode="Verwaltung"/>
                <xsl:apply-templates select="following-sibling::h1:Field[ @Type = '4643' ]"/>
                <xsl:apply-templates select="following-sibling::h1:Field[ @Type = '4645' ]"/>
                <xsl:choose>
                    <xsl:when test="h1:Field[ @Type = '4650' ]">
                        <xsl:apply-templates select="h1:Field[ @Type = '4650' ]" mode="Verwaltung"/>
                    </xsl:when>
                    <xsl:when test="h1:Field[ @Type = '4650vt' ]">
                        <xsl:apply-templates select="h1:Field[ @Type = '4650vt' ]" mode="Verwaltung"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test=" @Value = 'Betreuung' "/>
            <xsl:when test=" @Value != 'Verwaltung' ">
                <xsl:choose>
                    <xsl:when test="h1:Field[ @Type = '4564' ]">
                        <xsl:apply-templates select="h1:Field[ @Type = '4564' ]" mode="index"/>
                    </xsl:when>
                    <xsl:when test="h1:Field[ @Type = '4600' ]">
                        <xsl:apply-templates select="h1:Field[ @Type = '4600' ]" mode="index"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="h1:Field[ @Type = '4652' ]">
                <xsl:apply-templates select="h1:Field[ @Type = '4652' ]"/>
            </xsl:when>
            <xsl:when test=" @Value = 'Eigentum' ">
                <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="indexName" select=" 'Eigentum' "/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:value-of select="concat(normalize-space(@Value),': ')"/>
                    <xsl:element name="orgName" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:apply-templates select="h1:Field[ @Type &lt; '4665' ]"/>
                    </xsl:element>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'bezsoz' ]" mode="index">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:value-of select="concat('_', @Type)"/>
                <xsl:value-of select="concat('[', count(preceding-sibling::h1:Field[@Type = current()/@Type]), ']')"/>
            </xsl:attribute>
            <xsl:attribute name="indexName">
                <xsl:choose>
                    <xsl:when test="@Value and (@Value != '') and (@Value != 'x') and (@Value != 'xxx') and (@Value != '-') and (@Value != '---') and (@Value != '--- x')">
                        <xsl:value-of select="translate(replace(replace(replace(replace(normalize-space(@Value), ' &amp; ', '_'), ' &amp;', ''), ' / ', '-'), '\p{P}', ''), ' \(\)\[\]\?&lt;&gt;=', '-')"/>
                    </xsl:when>
                    <xsl:otherwise>unk</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="h1:Field" mode="index"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'bezwrk' ]" mode="index"><!-- Bezieh @ Werk -->
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:if test="not(preceding-sibling::h1:Field[ @Type = 'bezper'][ @Value = 'Autorschaft' ])">
                <xsl:attribute name="n">
                    <xsl:text>MXML-</xsl:text>
                    <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                    <xsl:value-of select="concat('_', @Type)"/>
                    <xsl:value-of select="concat('[', count(preceding-sibling::h1:Field[@Type = current()/@Type]), ']')"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="indexName">
                <xsl:choose>
                    <xsl:when test="(@Value != '') and (@Value != 'x') and (@Value != '---') ">
                        <xsl:value-of select="translate(replace(replace(replace(replace(normalize-space(@Value), ' &amp; ', '_'), ' &amp;', ''), ' / ', '-'), '\p{P}', ''), ' \(\)\[\]\?&lt;&gt;=', '-')"/>
                    </xsl:when>
                    <xsl:otherwise>unk</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="h1:Field" mode="index"/>
            <xsl:apply-templates select="following-sibling::h1:Field[ @Type = '1950' ]/h1:Field[ @Type = '1961' ]" mode="index"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par01' ][ @Value != '' ]"><!-- Signatur -->
        <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:variable name="content">
                <xsl:call-template name="processPar">
                    <xsl:with-param name="fields"><fields><xsl:copy-of select="following-sibling::h1:Field"/></fields></xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="replace($content, '&lt;lb/&gt;', ' ')"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par02' ][ @Value != '' ]"><!-- Überschrift -->
        <xsl:variable name="content">
            <xsl:call-template name="processPar">
                <xsl:with-param name="fields"><fields><xsl:copy-of select="following-sibling::h1:Field"/></fields></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="replace($content, '&lt;lb/&gt;', ' ')"/>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par03' ][ @Value != '' ]"><!-- Schlagzeile -->
        <xsl:call-template name="processPar"/>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par04' ][ @Value != '' ]"><!-- Äußeres -->
        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:text>-par04</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="processPar">
                <xsl:with-param name="fields"><fields><xsl:copy-of select="following-sibling::h1:Field"/></fields></xsl:with-param>
            </xsl:call-template>
        </xsl:element>
        <xsl:if test="following-sibling::h1:Block[h1:Field[ @Type = 'par13' ][ @Value != '' ]]">
            <xsl:element name="decoDesc" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:apply-templates select="following-sibling::h1:Block[h1:Field[ @Type = 'par13' ][ @Value != '' ]]/h1:Field[ @Type = 'par13' ]"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par05' ][ @Value != '' ]"><!-- Geschichte -->
        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:text>-par05</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="processPar">
                <xsl:with-param name="fields"><fields><xsl:copy-of select="following-sibling::h1:Field"/></fields></xsl:with-param>
            </xsl:call-template>
            <xsl:choose>
                <xsl:when test="following-sibling::h1:Field[ @Type = 'par12' ][ @Value != '' ]">
                    <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                    <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                    <xsl:apply-templates select="following-sibling::h1:Field[ @Type = 'par12' ][ @Value != '' ]"/>
                </xsl:when>
                <xsl:when test="h1:Block[h1:Field[ @Type = 'par12' ][ @Value != '' ]]">
                    <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                    <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                    <xsl:apply-templates select="h1:Block[h1:Field[ @Type = 'par12' ][ @Value != '' ]]/h1:Field[ @Type = 'par12' ]"/>
                </xsl:when>
                <xsl:when test="following-sibling::h1:Block[h1:Field[ @Type = 'par12' ][ @Value != '' ]]">
                    <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                    <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                    <xsl:apply-templates select="following-sibling::h1:Block[h1:Field[ @Type = 'par12' ][ @Value != '' ]]/h1:Field[ @Type = 'par12' ]"/>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="following-sibling::h1:Field[ @Type = 'bezsoz' ][contains(@Value, 'Eigentum')]">
                <xsl:value-of select="$crlf"/>
                <xsl:apply-templates select="following-sibling::h1:Field[ @Type = 'bezsoz' ][contains(@Value, 'Eigentum')]" mode="index"/>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par06' ][ @Value != '' ]"><!-- Literaturangaben -->
        <xsl:call-template name="processPar">
            <xsl:with-param name="element" select=" 'par06' "/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par07' ][ @Value != '' ]"><!-- Einband -->
        <xsl:element name="physDesc" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="n">
                    <xsl:text>MXML-</xsl:text>
                    <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                    <xsl:text>-par07</xsl:text>
                </xsl:attribute>
                <xsl:call-template name="processPar">
                    <xsl:with-param name="fields"><fields><xsl:copy-of select="following-sibling::h1:Field"/></fields></xsl:with-param>
                </xsl:call-template>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par08' ][ @Value != '' ]"><!-- Fragment -->
        <xsl:if test="$mode = 'test' "><xsl:comment>msContents/par08</xsl:comment></xsl:if>
        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:text>-par08</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="processPar">
                <xsl:with-param name="fields"><fields><xsl:copy-of select="following-sibling::h1:Field"/></fields></xsl:with-param>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par09' ][ @Value != '' ]"><!-- Faszikel-Äußeres -->
        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:text>-par09</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="processPar">
                <xsl:with-param name="fields"><fields><xsl:copy-of select="following-sibling::h1:Field"/></fields></xsl:with-param>
            </xsl:call-template>
        </xsl:element>
        <xsl:choose>
            <xsl:when test="h1:Block[h1:Field[ @Type = 'par13' ][ @Value != '' ]]">
                <xsl:element name="decoDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates select="h1:Block[h1:Field[ @Type = 'par13' ][ @Value != '' ]]/h1:Field[ @Type = 'par13' ]"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="following-sibling::h1:Block[h1:Field[ @Type = 'par13' ][ @Value != '' ]]">
                <xsl:element name="decoDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates select="following-sibling::h1:Block[h1:Field[ @Type = 'par13' ][ @Value != '' ]]/h1:Field[ @Type = 'par13' ]"/>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par10' ][ @Value != '' ]"><!-- Faszikel-Geschichte -->
        <xsl:param name="writeP"/>
        <xsl:choose>
            <xsl:when test="$writeP = 'no' ">
                <xsl:call-template name="processPar">
                    <xsl:with-param name="fields"><fields><xsl:copy-of select="following-sibling::h1:Field"/></fields></xsl:with-param>
                </xsl:call-template>
                <xsl:if test="parent::h1:Block/following-sibling::h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Text') ]][h1:Field[ @Type = 'par10'] and h1:Field[ @Type = 'bezper'][ @Value = 'Vorbesitz' ]]">
                    <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                    <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="following-sibling::h1:Field[ @Type = 'par12' ][ @Value != '' ]">
                        <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                        <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                        <xsl:apply-templates select="following-sibling::h1:Field[ @Type = 'par12' ][ @Value != '' ]"/>
                    </xsl:when>
                    <xsl:when test="h1:Block[h1:Field[ @Type = 'par12' ][ @Value != '' ]]">
                        <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                        <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                        <xsl:apply-templates select="h1:Block[h1:Field[ @Type = 'par12' ][ @Value != '' ]]/h1:Field[ @Type = 'par12' ]"/>
                    </xsl:when>
                    <xsl:when test="following-sibling::h1:Block[h1:Field[ @Type = 'par12' ][ @Value != '' ]]">
                        <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                        <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                        <xsl:apply-templates select="following-sibling::h1:Block[h1:Field[ @Type = 'par12' ][ @Value != '' ]]/h1:Field[ @Type = 'par12' ]"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="n">
                        <xsl:text>MXML-</xsl:text>
                        <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                        <xsl:text>-par10</xsl:text>
                    </xsl:attribute>
                    <xsl:call-template name="processPar">
                        <xsl:with-param name="fields"><fields><xsl:copy-of select="following-sibling::h1:Field"/></fields></xsl:with-param>
                    </xsl:call-template>
                    <xsl:choose>
                        <xsl:when test="following-sibling::h1:Field[ @Type = 'par12' ][ @Value != '' ]">
                            <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                            <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                            <xsl:apply-templates select="following-sibling::h1:Field[ @Type = 'par12' ][ @Value != '' ]"/>
                        </xsl:when>
                        <xsl:when test="h1:Block[h1:Field[ @Type = 'par12' ][ @Value != '' ]]">
                            <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                            <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                            <xsl:apply-templates select="h1:Block[h1:Field[ @Type = 'par12' ][ @Value != '' ]]/h1:Field[ @Type = 'par12' ]"/>
                        </xsl:when>
                        <xsl:when test="following-sibling::h1:Block[h1:Field[ @Type = 'par12' ][ @Value != '' ]]">
                            <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                            <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                            <xsl:apply-templates select="following-sibling::h1:Block[h1:Field[ @Type = 'par12' ][ @Value != '' ]]/h1:Field[ @Type = 'par12' ]"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par11' ][ @Value != '' ][not(h1:Field[ @Type = '5230' ][ @Value = 'Faszikel' ])]"><!-- Text -->
        <xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select=" 'text' "/>
            <xsl:if test="$mode = 'test' "><xsl:comment>par11</xsl:comment></xsl:if>
            <xsl:call-template name="processPar">
                <xsl:with-param name="fields"><fields><xsl:copy-of select="following-sibling::h1:Field"/></fields></xsl:with-param>
            </xsl:call-template>
            <xsl:if test="following-sibling::h1:Field[ @Type = '5710' ][ @Value != 'polyglott' ][ @Value != 'Runen' ]">
                <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="indexName" select=" 'textLang' "/>
                    <xsl:for-each select="following-sibling::h1:Field[ @Type = '5710' ][ @Value != 'polyglott' ][ @Value != 'Runen' ][
                        not(preceding-sibling::h1:Field[ @Type = '5710' ]) or 
                        normalize-space(translate(lower-case(@Value), '(?)', '')) != preceding-sibling::h1:Field[ @Type = '5710' ]/normalize-space(translate(lower-case(@Value), '(?)', ''))]">
                        <xsl:choose>
                            <xsl:when test="@Value = 'serbokroatisch' ">
                                <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="type" select=" 'textLang-ID' "/>
                                    <xsl:call-template name="writeLangRef">
                                        <xsl:with-param name="value" select=" 'serbisch' "/>
                                    </xsl:call-template>
                                    <xsl:value-of select=" 'serbisch' "/>
                                </xsl:element>
                                <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="type" select=" 'textLang-ID' "/>
                                    <xsl:call-template name="writeLangRef">
                                        <xsl:with-param name="value" select=" 'kroatisch' "/>
                                    </xsl:call-template>
                                    <xsl:value-of select=" 'kroatisch' "/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="type" select=" 'textLang-ID' "/>
                                    <xsl:call-template name="writeLangRef">
                                        <xsl:with-param name="value" select="replace(replace(normalize-space(translate(lower-case(@Value), '(?)', '')), 'polyglott', ''), 'Runen', '')"/>
                                    </xsl:call-template>
                                    <xsl:value-of select="."/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>
        </xsl:element>
        <xsl:apply-templates select="following-sibling::h1:Block[h1:Field[ @Type = 'par13' ][ @Value != '' ]]/h1:Field[ @Type = 'par13' ][ @Value != '' ]"/>
        <xsl:for-each select="following-sibling::h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Text') ]][h1:Field[ @Type = 'par11' ][ @Value != '' ]]">
            <xsl:if test="$mode = 'test' "><xsl:comment>par11</xsl:comment></xsl:if>
            <xsl:element name="msItem" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="n">
                    <xsl:text>MXML-</xsl:text>
                    <xsl:value-of select="translate(h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                </xsl:attribute>
                <xsl:apply-templates select="h1:Field[ @Type = 'par11' ][ @Value != '' ]"/>
                <xsl:call-template name="writeIndexFields">
                    <xsl:with-param name="field" select=" 'note' "/>
                </xsl:call-template>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par12' ][ @Value != '' ]"><!-- Stil u. Einordnung (illum.) -->
        <!--<xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">-->
            <!--<xsl:attribute name="type" select=" 'content' "/>-->
            <xsl:call-template name="processPar">
            <xsl:with-param name="fields"><fields><xsl:copy-of select="following-sibling::h1:Field"/></fields></xsl:with-param>
        </xsl:call-template>
        <!--</xsl:element>-->
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par13' ][ @Value != '' ]"><!-- Buchschmuck (illum.) -->
        <xsl:element name="decoNote" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:text>-par13</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="type" select=" 'form' "/>
            <xsl:call-template name="processPar">
                <xsl:with-param name="fields"><fields><xsl:copy-of select="following-sibling::h1:Field"/></fields></xsl:with-param>
            </xsl:call-template>
            <xsl:for-each select="parent::h1:Block/h1:Block[h1:Field[ @Type = 'par13' ][ @Value != '' ]]/h1:Field[ @Type = 'par13' ][ @Value != '' ]">
                <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="n">
                        <xsl:text>MXML-</xsl:text>
                        <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                    </xsl:attribute>
                </xsl:element>
                <xsl:if test="$mode = 'test' "><xsl:comment>par13</xsl:comment></xsl:if>
                <xsl:call-template name="processPar">
                    <xsl:with-param name="fields"><fields><xsl:copy-of select="following-sibling::h1:Field"/></fields></xsl:with-param>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template mode="index" match="h1:Field[ 
        (@Type = '5209') or
        (@Type = '5210') or
        (@Type = '5260') or
        (@Type = '5270') or
        (@Type = '5300') or
        (@Type = '5382') or
        (@Type = '5710')
        ]">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type">
                    <xsl:choose>
                        <xsl:when test=" @Type = '5209' "><xsl:text>title</xsl:text></xsl:when>
                        <xsl:when test=" @Type = '5210' "><xsl:text>status</xsl:text></xsl:when>
                        <xsl:when test=" @Type = '5260' "><xsl:text>material</xsl:text></xsl:when>
                        <xsl:when test=" @Type = '5270' "><xsl:text>decoration</xsl:text></xsl:when>
                        <xsl:when test=" @Type = '5300' "><xsl:text>technique</xsl:text></xsl:when>
                        <xsl:when test=" @Type = '5382' "><xsl:text>format</xsl:text></xsl:when>
                        <xsl:when test=" @Type = '5710' "><xsl:text>textLang</xsl:text></xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test=" @Type = '5210' ">
                        <xsl:call-template name="writeThesaurusFields"><xsl:with-param name="field" select=" 'FORM-5210' "/><xsl:with-param name="value" select="@Value"/></xsl:call-template>
                    </xsl:when>
                    <xsl:when test=" @Type = '5260' ">
                        <xsl:call-template name="writeThesaurusFields"><xsl:with-param name="field" select=" 'BNDG-5260' "/><xsl:with-param name="value" select="@Value"/></xsl:call-template>
                    </xsl:when>
                    <xsl:when test=" @Type = '5300' ">
                        <xsl:call-template name="writeThesaurusFields"><xsl:with-param name="field" select=" 'BNDG-5300' "/><xsl:with-param name="value" select="@Value"/></xsl:call-template>
                    </xsl:when>
                    <xsl:when test=" @Type = '5382' ">
                        <xsl:call-template name="writeThesaurusFields"><xsl:with-param name="field" select=" 'CODC-5382' "/><xsl:with-param name="value" select="@Value"/></xsl:call-template>
                    </xsl:when>
                </xsl:choose>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
            <xsl:choose>
                <xsl:when test="(@Type = '5710') and contains(@Value, ',')">
                    <xsl:for-each select="tokenize(@Value, ',')">
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'textLang-ID' "/>
                            <xsl:call-template name="writeLangRef">
                                <xsl:with-param name="value" select="normalize-space(translate(lower-case(.), '(?)', ''))"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="(@Type = '5710') and contains(@Value, 'u.')">
                    <xsl:for-each select="tokenize(@Value, 'u.')">
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'textLang-ID' "/>
                            <xsl:call-template name="writeLangRef">
                                <xsl:with-param name="value" select="normalize-space(translate(lower-case(.), '(?)', ''))"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="(@Type = '5710') and contains(@Value, '&amp;')">
                    <xsl:for-each select="tokenize(@Value, '&amp;')">
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'textLang-ID' "/>
                            <xsl:call-template name="writeLangRef">
                                <xsl:with-param name="value" select="normalize-space(translate(lower-case(.), '(?)', ''))"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test=" @Type = '5710' ">
                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="type" select=" 'textLang-ID' "/>
                        <xsl:call-template name="writeLangRef">
                            <xsl:with-param name="value" select="normalize-space(translate(lower-case(.), '(?)', ''))"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    

    <!-- ========== Kerndatenfelder ========== -->
    <!-- ========== einfache Felder ========== -->
    <xsl:template match="h1:Field[ @Type = '5240norm' ]">
        <xsl:param name="calledFrom"/>
        <xsl:call-template name="writeThesaurusFields"><xsl:with-param name="field" select=" 'FORM-5240' "/><xsl:with-param name="value" select="@Value"/></xsl:call-template>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5382norm' ]">
        <xsl:param name="calledFrom"/>
        <xsl:call-template name="writeThesaurusFields"><xsl:with-param name="field" select=" 'CODC-5382' "/><xsl:with-param name="value" select="@Value"/></xsl:call-template>
    </xsl:template>
    <xsl:template match="h1:Field[ 
        (@Type = '5209norm') or
        (@Type = '5210norm') or
        (@Type = '5270norm') or
        (@Type = '5705norm') or
        (@Type = '5706norm')
        ]">
        <xsl:param name="calledFrom"/>
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="indexName">
                <xsl:choose>
                    <xsl:when test=" @Type = '5209norm' "><xsl:text>norm_title</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '5210norm' "><xsl:text>norm_status</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '5240norm' "><xsl:text>norm_form</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '5270norm' "><xsl:text>norm_decoration</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '5705norm' "><xsl:text>norm_musicNotation</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '5706norm' "><xsl:text>norm_measure</xsl:text></xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type">
                    <xsl:choose>
                        <xsl:when test=" @Type = '5209norm' "><xsl:text>title</xsl:text></xsl:when>
                        <xsl:when test=" @Type = '5210norm' "><xsl:text>status</xsl:text></xsl:when>
                        <xsl:when test=" @Type = '5240norm' "><xsl:text>form</xsl:text></xsl:when>
                        <xsl:when test=" @Type = '5270norm' "><xsl:text>decoration</xsl:text></xsl:when>
                        <xsl:when test=" @Type = '5705norm' "><xsl:text>musicNotation</xsl:text></xsl:when>
                        <xsl:when test=" @Type = '5706norm' "><xsl:text>measure</xsl:text></xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test=" @Type = '5210norm' ">
                        <xsl:call-template name="writeThesaurusFields"><xsl:with-param name="field" select=" 'FORM-5210' "/><xsl:with-param name="value" select="@Value"/></xsl:call-template>
                        <xsl:choose>
                            <xsl:when test=" @Value = 'disloziert' "><xsl:text>displaced</xsl:text></xsl:when>
                            <xsl:when test=" @Value = 'unbekannt' "><xsl:text>unknown</xsl:text></xsl:when>
                            <xsl:when test=" @Value = 'verschollen' "><xsl:text>missing</xsl:text></xsl:when>
                            <xsl:when test=" @Value = 'vorhanden' "><xsl:text>existent</xsl:text></xsl:when>
                            <xsl:when test=" @Value = 'zerstört' "><xsl:text>destroyed</xsl:text></xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test=" @Type = '5240norm' ">
                        <xsl:choose>
                            <xsl:when test="$calledFrom = 'binding' ">
                                <xsl:call-template name="writeThesaurusFields"><xsl:with-param name="field" select=" 'BNDG-5240' "/><xsl:with-param name="value" select="@Value"/></xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="writeThesaurusFields"><xsl:with-param name="field" select=" 'FORM-5240' "/><xsl:with-param name="value" select="@Value"/></xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test=" @Value = 'Codex' "><xsl:text>codex</xsl:text></xsl:when>
                            <xsl:when test=" @Value = 'DruckHslAntl' "><xsl:text>printWithManuscriptParts</xsl:text></xsl:when>
                            <xsl:when test=" @Value = 'DruckTrgbd' "><xsl:text>hostVolume</xsl:text></xsl:when>
                            <xsl:when test=" @Value = 'Einzelblatthandschrift' "><xsl:text>singleSheet</xsl:text></xsl:when>
                            <xsl:when test=" @Value = 'Fragment' "><xsl:text>fragment</xsl:text></xsl:when>
                            <xsl:when test=" @Value = 'Gegenstand' "><xsl:text>other</xsl:text></xsl:when>
                            <xsl:when test=" @Value = 'Rolle' "><xsl:text>scroll</xsl:text></xsl:when>
                            <xsl:when test=" @Value = 'Sammelband' "><xsl:text>sammelband</xsl:text></xsl:when>
                            <xsl:when test=" @Value = 'Sammlung' "><xsl:text>collection</xsl:text></xsl:when>
                            <xsl:when test=" @Value = 'Sonstiges' "><xsl:text>other</xsl:text></xsl:when>
                            <xsl:when test=" @Value = 'zusammengesetzteHs' "><xsl:text>composite</xsl:text></xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test=" (@Type = '5270norm') or (@Type = '5705norm') ">
                        <xsl:choose>
                            <xsl:when test=" @Value = 'vorhanden' ">yes</xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(@Value)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:if test="@Type = '5706norm'">
                <xsl:choose>
                    <xsl:when test="following-sibling::h1:Field[ @Type = '5706rech' ]">
                        <xsl:apply-templates select="following-sibling::h1:Field[ @Type = '5706rech' ][position() = count(current()/preceding-sibling::h1:Field[ @Type = '5706norm' ]) + 1 ]"/>
                    </xsl:when>
                    <xsl:when test="parent::node()/h1:Field[ @Type = '5706rech' ]">
                        <xsl:apply-templates select="parent::node()/h1:Field[ @Type = '5706rech' ]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'measure_noOfLeaves' "/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:element>
    </xsl:template>

    <!-- ========== Wiederholgruppen Container-Elemente ========== -->
    <xsl:template match="h1:Field[ @Type = '5064norm' ]"><xsl:value-of select="normalize-space(@Value)"/></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5130norm' ]"><xsl:value-of select="normalize-space(@Value)"/></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5260norm' ]">
        <xsl:call-template name="writeThesaurusFields">
            <xsl:with-param name="field" select=" 'CODC-5260' "/>
            <xsl:with-param name="value" select="@Value"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5360norm' ]"><xsl:value-of select="normalize-space(@Value)"/></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5710norm' ]"><xsl:value-of select="normalize-space(@Value)"/></xsl:template>
    <!-- ========== Subfelder ========== -->
    <xsl:template match="h1:Field[ 
        (@Type = '5060norm') or
        (@Type = '5071norm') or
        (@Type = '5077norm') or
        (@Type = '5131norm') or
        (@Type = '5132norm') or
        (@Type = '5133norm') or
        (@Type = '5361norm') or
        (@Type = '5362norm') or
        (@Type = '5363norm') or
        (@Type = '5364norm') or
        (@Type = '5706rech') or
        (@Type = '8441norm') or
        (@Type = '8442norm') or
        (@Type = '8443norm') or
        (@Type = '9952norm') or
        (@Type = '9953norm') or
        (@Type = '9954norm')
        ]">
        <xsl:if test=" (@Type = '5060norm') and not(h1:Field[ (@Type = '5071norm') ]) ">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select=" 'origDate_notBefore' "/>
                <xsl:value-of select="h1:Field[ (@Type = '5064norm') ]/@Value"/>
                <xsl:if test="number(h1:Field[ (@Type = '5064norm') ]/@Value) gt 2030"><xsl:message>5064norm wahrscheinlich fehlerhaft</xsl:message></xsl:if>
            </xsl:element>
        </xsl:if>
        <xsl:if test=" (@Type = '5060norm') and not(h1:Field[ (@Type = '5077norm') ]) ">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select=" 'origDate_notAfter' "/>
                <xsl:value-of select="h1:Field[ (@Type = '5064norm') ]/@Value"/>
                <xsl:if test="number(h1:Field[ (@Type = '5064norm') ]/@Value) gt 2030"><xsl:message>5064norm wahrscheinlich fehlerhaft</xsl:message></xsl:if>
            </xsl:element>
        </xsl:if>
        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test=" @Type = '5060norm' "><xsl:text>origDate_type</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '5071norm' "><xsl:text>origDate_notBefore</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '5077norm' "><xsl:text>origDate_notAfter</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '5131norm' "><xsl:text>origPlace_norm</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '5132norm' "><xsl:text>origPlace_norm</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '5133norm' "><xsl:text>origPlace_norm</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '5361norm' "><xsl:text>height</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '5362norm' "><xsl:text>width</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '5363norm' "><xsl:text>depth</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '5364norm' "><xsl:text>dimensions_typeOfInformation</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '5706rech' "><xsl:text>measure_noOfLeaves</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '8441norm' "><xsl:text>biblScope_page</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '8442norm' "><xsl:text>biblScope_line</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '8443norm' "><xsl:text>biblScope_Alto-Element-ID</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '9952norm' "><xsl:text>publicationStmt_author</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '9953norm' "><xsl:text>publicationStmt_date_published</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '9954norm' "><xsl:text>publicationStmt_editor</xsl:text></xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test=" (@Type = '5060norm') and (@Value = 'Datierung') "><xsl:text>datable</xsl:text></xsl:when>
                <xsl:when test=" (@Type = '5060norm') and (@Value = 'datiert') "><xsl:text>dated</xsl:text></xsl:when>
                <xsl:when test=" (@Type = '5060norm') "/>
                <xsl:when test=" (@Type = '5361norm') and contains(@Value, '/')"/>
                <xsl:when test=" (@Type = '5361norm') and contains(@Value, '-')"/>
                <xsl:when test=" (@Type = '5361norm') and contains(@Value, '–')"/>
                <xsl:when test=" (@Type = '5361norm') and contains(@Value, ',') and number(substring-after(@Value, ',')) &lt; 5 "><xsl:value-of select="substring-before(@Value, ',')"/></xsl:when>
                <xsl:when test=" (@Type = '5361norm') and contains(@Value, ',') and number(substring-after(@Value, ',')) &gt; 5 "><xsl:value-of select="number(substring-before(@Value, ',')) + 1"/></xsl:when>
                <xsl:when test=" (@Type = '5361norm') and (@Value != '') and not(matches(@Value, '\d+'))"/>
                <xsl:when test=" (@Type = '5362norm') and contains(@Value, '/')"/>
                <xsl:when test=" (@Type = '5362norm') and contains(@Value, '-')"/>
                <xsl:when test=" (@Type = '5362norm') and contains(@Value, '–')"/>
                <xsl:when test=" (@Type = '5362norm') and contains(@Value, ',') and number(substring-after(@Value, ',')) &lt; 3 "><xsl:value-of select="substring-before(@Value, ',')"/></xsl:when>
                <xsl:when test=" (@Type = '5362norm') and contains(@Value, ',') and number(substring-after(@Value, ',')) &gt; 2 and number(substring-after(@Value, ',')) &lt; 8 "><xsl:value-of select="concat(substring-before(@Value, ','), ',5')"/></xsl:when>
                <xsl:when test=" (@Type = '5362norm') and contains(@Value, ',') and number(substring-after(@Value, ',')) &gt; 7 "><xsl:value-of select="number(substring-before(@Value, ',')) + 1"/></xsl:when>
                <xsl:when test=" (@Type = '5362norm') and (@Value != '') and not(matches(@Value, '\d+'))"/>
                <xsl:when test=" (@Type = '5363norm') and contains(@Value, '/')"/>
                <xsl:when test=" (@Type = '5363norm') and contains(@Value, '-')"/>
                <xsl:when test=" (@Type = '5363norm') and contains(@Value, '–')"/>
                <xsl:when test=" (@Type = '5363norm') and contains(@Value, ',') and number(substring-after(@Value, ',')) &lt; 3 "><xsl:value-of select="substring-before(@Value, ',')"/></xsl:when>
                <xsl:when test=" (@Type = '5363norm') and contains(@Value, ',') and number(substring-after(@Value, ',')) &gt; 2 and number(substring-after(@Value, ',')) &lt; 8 "><xsl:value-of select="concat(substring-before(@Value, ','), ',5')"/></xsl:when>
                <xsl:when test=" (@Type = '5363norm') and contains(@Value, ',') and number(substring-after(@Value, ',')) &gt; 7 "><xsl:value-of select="number(substring-before(@Value, ',')) + 1"/></xsl:when>
                <xsl:when test=" (@Type = '5363norm') and (@Value != '') and not(matches(@Value, '\d+'))"/>
                <xsl:when test=" (@Type = '5364norm') and (@Value = 'real') "><xsl:text>factual</xsl:text></xsl:when>
                <xsl:when test=" (@Type = '5364norm') and (@Value = 'erschlossen') "><xsl:text>deduced</xsl:text></xsl:when>
                <xsl:when test=" (@Type = '5364norm') "/>
                <xsl:when test=" (@Type = '5071norm') ">
                    <xsl:choose>
                        <xsl:when test="string-length(@Value) = 3"><xsl:value-of select="concat('0', @Value) "/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="normalize-space(@Value)"/></xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="number(h1:Field[ (@Type = '5071norm') ]/@Value) gt 2030"><xsl:message>5071norm wahrscheinlich fehlerhaft</xsl:message></xsl:if>
                </xsl:when>
                <xsl:when test=" (@Type = '5077norm') ">
                    <xsl:choose>
                        <xsl:when test="string-length(@Value) = 3"><xsl:value-of select="concat('0', @Value) "/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="normalize-space(@Value)"/></xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="number(h1:Field[ (@Type = '5077norm') ]/@Value) gt 2030"><xsl:message>5077norm wahrscheinlich fehlerhaft</xsl:message></xsl:if>
                </xsl:when>
                <xsl:when test=" (@Type = '5131norm') or (@Type = '5132norm') or (@Type = '5133norm') ">
                    <xsl:choose>
                        <xsl:when test=" (@Type = '5131norm') ">
                            <xsl:attribute name="ref" select="concat('http://d-nb.info/gnd/', @Value)"/>
                        </xsl:when>
                        <xsl:when test=" (@Type = '5132norm') ">
                            <xsl:attribute name="ref" select="concat('https://www.geonames.org/', @Value)"/>
                        </xsl:when>
                        <xsl:when test=" (@Type = '5133norm') ">
                            <xsl:attribute name="ref" select="concat('http://vocab.getty.edu/page/tgn/', @Value)"/>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="contains(parent::h1:Field[@Type = '5130norm']/@Value, '(')">
                            <xsl:value-of select="substring-before(parent::h1:Field[@Type = '5130norm']/@Value, ' (')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="parent::h1:Field[@Type = '5130norm']/@Value"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(@Value)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    

    <!-- ===== named templates -->
    <xsl:template name="additional">
        <xsl:choose>
            <xsl:when test="h1:Field[ @Type = 'par06' ][ @Value != '' ] or h1:Field[@ Type = 'bezlit' ][ @Value = 'Repertoriumseintrag' ]">
                <xsl:element name="additional" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="listBibl" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="bibl" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:apply-templates select="h1:Field[ @Type = 'par06' ]"/>
                            <xsl:apply-templates select="h1:Field[ @Type = 'bezlit' ][ @Value = 'Repertoriumseintrag' ]" mode="additional"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:when test="h1:Field[ @Type = 'bezlit' ][ 
                   (@Value = 'Katalogtext') 
                or (@Value = 'Sekundärliteratur') 
                ]">
                <xsl:element name="additional" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="listBibl" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="bibl" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:for-each select="h1:Field[ @Type = 'bezlit' ][ (@Value = 'Katalogtext') or (@Value = 'Sekundärliteratur')]">
                                <xsl:value-of select="h1:Field[ @Type = '8330' ]/@Value"/>
                                <xsl:if test="h1:Field[ @Type = '8330' ] and h1:Field[ @Type = '8334' ] and not(ends-with(h1:Field[ @Type = '8330' ]/@Value, '.'))">
                                    <xsl:text>. </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="h1:Field[ @Type = '8334' ]/@Value"/>
                                <xsl:if test="following-sibling::h1:Field[ @Type = 'bezlit' ][
                                       (@Value = 'Katalogtext') 
                                    or (@Value = 'Sekundärliteratur') 
                                    ]"><xsl:value-of select=" ' &#x2014; ' "/></xsl:if>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="editionStmt">
        <xsl:param name="creationDate"/>
        <xsl:param name="format"/>
        <xsl:element name="editionStmt" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="edition" namespace="http://www.tei-c.org/ns/1.0">Elektronische Ausgabe nach TEI P5</xsl:element>
            <xsl:element name="respStmt" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="resp" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:text>Diese Datei wurde unter Anwendung des MXML-to-TEI-P5-Stylesheets, welches an der Herzog August Bibliothek Wolfenbüttel im Rahmen des Projektes "Handschriftenportal" gepflegt wird aus einem</xsl:text>
                    <xsl:if test="$creationDate != '' "><xsl:value-of select="concat(' am ', $creationDate, ' erstellten')"/></xsl:if>
                    <xsl:if test="$format != '' "><xsl:value-of select="concat(' ', $format, '-Dokument erstellt.')"/></xsl:if>
                    <xsl:if test="h1:Field[ @Type = '99hs' ][ @Value = 'Retrokonversionsdokument' ]">
                        <xsl:text> Grundlage ist ein Retrokonversionsdokument.</xsl:text>
                    </xsl:if>
                </xsl:element>
                <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="type">org</xsl:attribute>
                    <xsl:text>Handschriftenportal</xsl:text>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="head">
        <xsl:param name="calledFrom"/>
        <xsl:element name="head" namespace="http://www.tei-c.org/ns/1.0">
            <!-- ========== Kerndatenfeld title (5209norm) ========== -->
            <xsl:choose>
                <xsl:when test="h1:Field[ @Type = '5209norm' ]">
                    <xsl:apply-templates select="h1:Field[ @Type = '5209norm' ]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="indexName" select=" 'norm_title' "/>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'title' "/>
                        </xsl:element>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:choose>
                    <xsl:when test="h1:Field[ @Type = 'par02' ][ @Value != '' ]">
                        <xsl:apply-templates select="h1:Field[ @Type = 'par02' ]"/>
                    </xsl:when>
                    <xsl:when test="h1:Field[ @Type = '5209' ]">
                        <xsl:apply-templates select="h1:Field[ @Type = '5209' ]"/>
                    </xsl:when>
                    <xsl:when test="h1:Field[ @Type = '5209vt' ]">
                        <xsl:apply-templates select="h1:Field[ @Type = '5209vt' ]"/>
                    </xsl:when>
                    <xsl:when test="h1:Field[ @Type = '5200' ]">
                        <xsl:apply-templates select="h1:Field[ @Type = '5200' ]"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:element>
            <!-- ========== Schlagzeile ========== -->
            <xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type">headline</xsl:attribute>
                <xsl:choose>
                    <xsl:when test="h1:Field[ @Type = 'par03' ][ @Value != '' ]">
                        <xsl:apply-templates select="h1:Field[ @Type = 'par03' ]"/>
                    </xsl:when>
                    <!-- Schlagzeile nicht befüllen, wenn Einband -->
                    <xsl:when test="h1:Field[ @Type = 'par03' ][ @Value != '' ]"/>
                    <xsl:otherwise>
                        <!-- Material -->
                        <xsl:choose>
                            <xsl:when test="h1:Field[ @Type = '5260vt' ]">
                                <xsl:apply-templates select="h1:Field[ @Type = '5260vt' ]"/>
                            </xsl:when>
                            <xsl:when test="h1:Field[ @Type = '5260' ]">
                                <xsl:apply-templates select="h1:Field[ @Type = '5260' ]"/>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:if test="(
                            h1:Field[ @Type = '5260vt' ] or h1:Field[ @Type = '5260' ]
                            ) and (
                            h1:Field[ @Type = '5706vt' ] or h1:Field[ @Type = '5706' ] or
                            h1:Field[ @Type = '5360vt' ] or h1:Field[ @Type = '5360' ] or
                            h1:Field[ @Type = '5130vt' ] or h1:Field[ @Type = '5130' ] or
                            h1:Field[ @Type = '5060vt' ] or h1:Field[ @Type = '5060' ]
                            )"><xsl:value-of select="$separator"/>
                        </xsl:if>
                        <!-- Umfang -->
                        <xsl:choose>
                            <xsl:when test="h1:Field[ @Type = '5706vt' ]">
                                <xsl:apply-templates select="h1:Field[ @Type = '5706vt' ]"/>
                            </xsl:when>
                            <xsl:when test="h1:Field[ @Type = '5706' ]">
                                <xsl:apply-templates select="h1:Field[ @Type = '5706' ]"/>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:if test="(
                            h1:Field[ @Type = '5706vt' ] or h1:Field[ @Type = '5706' ]
                            ) and (
                            h1:Field[ @Type = '5360vt' ] or h1:Field[ @Type = '5360' ] or
                            h1:Field[ @Type = '5130vt' ] or h1:Field[ @Type = '5130' ] or
                            h1:Field[ @Type = '5060vt' ] or h1:Field[ @Type = '5060' ]
                            )"><xsl:value-of select="$separator"/>
                        </xsl:if>
                        <!-- Größe -->
                        <xsl:choose>
                            <xsl:when test="h1:Field[ @Type = '5360vt' ]">
                                <xsl:apply-templates select="h1:Field[ @Type = '5360vt' ]"/>
                            </xsl:when>
                            <xsl:when test="h1:Field[ @Type = '5360' ]">
                                <xsl:apply-templates select="h1:Field[ @Type = '5360' ]"/>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:if test="(
                            h1:Field[ @Type = '5360vt' ] or h1:Field[ @Type = '5360' ]
                            ) and (
                            h1:Field[ @Type = '5130vt' ] or h1:Field[ @Type = '5130' ] or
                            h1:Field[ @Type = '5060vt' ] or h1:Field[ @Type = '5060' ]
                            )"><xsl:value-of select="$separator"/>
                        </xsl:if>
                        <!-- Entstehungsort -->
                        <xsl:choose>
                            <xsl:when test="h1:Field[ @Type = '5130vt' ]">
                                <xsl:for-each select="h1:Field[ @Type = '5130vt' ]">
                                    <xsl:if test="preceding-sibling::h1:Field[ @Type = '5130vt' ]"><xsl:text> / </xsl:text></xsl:if>
                                    <xsl:apply-templates select="self::h1:Field[ @Type = '5130vt' ]"/>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="h1:Field[ @Type = '5130' ]">
                                <xsl:for-each select="h1:Field[ @Type = '5130' ]">
                                    <xsl:if test="preceding-sibling::h1:Field[ @Type = '5130' ]"><xsl:text> / </xsl:text></xsl:if>
                                    <xsl:apply-templates select="self::h1:Field[ @Type = '5130' ]"/>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:if test="(
                            h1:Field[ @Type = '5130vt' ] or h1:Field[ @Type = '5130' ]
                            ) and (
                            h1:Field[ @Type = '5060vt' ] or h1:Field[ @Type = '5060' ]
                            )"><xsl:value-of select="$separator"/>
                        </xsl:if>
                        <!-- Entstehungszeit -->
                        <xsl:choose>
                            <xsl:when test="h1:Field[ @Type = '5060vt' ]">
                                <xsl:for-each select="h1:Field[ @Type = '5060vt' ]">
                                    <xsl:if test="preceding-sibling::h1:Field[ @Type = '5060vt' ]"><xsl:text> / </xsl:text></xsl:if>
                                    <xsl:apply-templates select="h1:Field[ @Type = '5064vt' ]"/>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="h1:Field[ @Type = '5060' ]">
                                <xsl:for-each select="h1:Field[ @Type = '5060' ]">
                                    <xsl:if test="preceding-sibling::h1:Field[ @Type = '5060' ]"><xsl:text> / </xsl:text></xsl:if>
                                    <xsl:apply-templates select="h1:Field[ @Type = '5064' ]"/>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <!-- ========== Kerndatenfeld material (5260norm) ========== -->
            <xsl:choose>
                <xsl:when test="h1:Field[ @Type = '5260norm' ]">
                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="indexName" select=" 'norm_material' "/>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'material' "/>
                            <xsl:for-each select="h1:Field[ @Type = '5260norm' ]">
                                <xsl:if test="preceding-sibling::h1:Field[ @Type = '5260norm' ]"><xsl:text> / </xsl:text></xsl:if>
                                <xsl:value-of select="normalize-space(@Value)"/>
                            </xsl:for-each>
                        </xsl:element>
                        <xsl:for-each select="h1:Field[ @Type = '5260norm' ]">
                            <xsl:apply-templates select="self::h1:Field[ @Type = '5260norm' ]"/>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="indexName" select=" 'norm_material' "/>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'material' "/>
                        </xsl:element>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'material_type' "/>
                        </xsl:element>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <!-- ========== Kerndatenfeld measure (5706norm) ========== -->
            <xsl:choose>
                <xsl:when test="h1:Field[ @Type = '5706norm' ]">
                    <xsl:apply-templates select="h1:Field[ @Type = '5706norm' ]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="indexName" select=" 'norm_measure' "/>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'measure' "/>
                        </xsl:element>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'measure_noOfLeaves' "/>
                        </xsl:element>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <!-- ========== Kerndatenfeld dimensions (5360norm) ========== -->
            <xsl:choose>
                <xsl:when test="h1:Field[ @Type = '5360norm' ]">
                    <xsl:for-each select="h1:Field[ @Type = '5360norm' ]">
                        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="indexName" select=" 'norm_dimensions' "/>
                            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="type" select=" 'dimensions' "/>
                                <xsl:apply-templates select="self::h1:Field[ @Type = '5360norm' ]"/>
                            </xsl:element>
                            <xsl:choose>
                                <xsl:when test="h1:Field[ @Type = '5361norm' ]">
                                    <xsl:apply-templates select="h1:Field[ @Type = '5361norm' ]"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                        <xsl:attribute name="type" select=" 'height' "/>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="h1:Field[ @Type = '5362norm' ]">
                                    <xsl:apply-templates select="h1:Field[ @Type = '5362norm' ]"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                        <xsl:attribute name="type" select=" 'width' "/>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="h1:Field[ @Type = '5363norm' ]">
                                    <xsl:apply-templates select="h1:Field[ @Type = '5363norm' ]"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                        <xsl:attribute name="type" select=" 'depth' "/>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="h1:Field[ @Type = '5364norm' ]">
                                    <xsl:apply-templates select="h1:Field[ @Type = '5364norm' ]"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                        <xsl:attribute name="type" select=" 'dimensions_typeOfInformation' "/>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="indexName" select=" 'norm_dimensions' "/>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'dimensions' "/>
                        </xsl:element>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'height' "/>
                        </xsl:element>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'width' "/>
                        </xsl:element>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'depth' "/>
                        </xsl:element>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'dimensions_typeOfInformation' "/>
                        </xsl:element>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <!-- ========== Kerndatenfeld format (5382norm) ========== -->
            <xsl:choose>
                <xsl:when test="h1:Field[ @Type = '5382norm' ]">
                    <xsl:apply-templates select="h1:Field[ @Type = '5382norm' ]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="indexName" select=" 'norm_format' "/>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'format' "/>
                        </xsl:element>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'format_typeOfInformation' "/>
                        </xsl:element>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <!-- ========== Kerndatenfeld origPlace (5130norm) ========== -->
            <xsl:choose>
                <xsl:when test="h1:Field[ @Type = '5130norm' ]">
                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="indexName" select=" 'norm_origPlace' "/>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'origPlace' "/>
                            <xsl:for-each select="h1:Field[ @Type = '5130norm' ]">
                                <xsl:if test="preceding-sibling::h1:Field[ @Type = '5130norm' ]"><xsl:text> / </xsl:text></xsl:if>
                                <xsl:apply-templates select="self::h1:Field[ @Type = '5130norm' ]"/>
                            </xsl:for-each>
                        </xsl:element>
                        <xsl:choose>
                            <xsl:when test="h1:Field[ @Type = '5130norm' ]/h1:Field[ @Type = '5131norm' ]">
                                <xsl:for-each select="h1:Field[ @Type = '5130norm' ]">
                                    <xsl:apply-templates select="h1:Field[ @Type = '5131norm' ]"/>
                                    <!--<xsl:apply-templates select="h1:Field[ @Type = '5132norm' ]"/>-->
                                    <!--<xsl:apply-templates select="h1:Field[ @Type = '5133norm' ]"/>-->
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="type" select=" 'origPlace_norm' "/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="indexName" select=" 'norm_origPlace' "/>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'origPlace' "/>
                        </xsl:element>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'origPlace_norm' "/>
                        </xsl:element>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <!-- ========== Kerndatenfeld origDate (5060norm) ========== -->
            <xsl:choose>
                <xsl:when test="h1:Field[ @Type = '5060norm' ]">
                    <xsl:for-each select="h1:Field[ @Type = '5060norm' ]">
                        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="indexName" select=" 'norm_origDate' "/>
                            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="type" select=" 'origDate' "/>
                                <xsl:apply-templates select="h1:Field[ @Type = '5064norm' ]"/>
                            </xsl:element>
                            <xsl:apply-templates select="h1:Field[ @Type = '5071norm' ]"/>
                            <xsl:apply-templates select="h1:Field[ @Type = '5077norm' ]"/>
                            <xsl:apply-templates select="self::h1:Field[ @Type = '5060norm' ]"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="indexName" select=" 'norm_origDate' "/>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'origDate' "/>
                        </xsl:element>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'origDate_notBefore' "/>
                        </xsl:element>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'origDate_notAfter' "/>
                        </xsl:element>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'origDate_type' "/>
                        </xsl:element>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <!-- ========== Kerndatenfeld textLang (5710norm) ========== -->
            <xsl:choose>
                <xsl:when test="h1:Field[ @Type = '5710norm' ][ @Value != 'polyglott' ][ @Value != 'Runen' ]">
                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="indexName" select=" 'norm_textLang' "/>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'textLang' "/>
                            <xsl:for-each select="h1:Field[ @Type = '5710norm' ][ @Value != 'polyglott' ][ @Value != 'Runen' ]">
                                <xsl:if test="preceding-sibling::h1:Field[ @Type = '5710norm' ][ @Value != 'polyglott' ][ @Value != 'Runen' ]"><xsl:text>, </xsl:text></xsl:if>
                                <xsl:apply-templates select="self::h1:Field[ @Type = '5710norm' ]"/>
                            </xsl:for-each>
                        </xsl:element>
                        <xsl:for-each select="h1:Field[ @Type = '5710norm' ][ @Value != 'polyglott' ][ @Value != 'Runen' ][
                            not(preceding-sibling::h1:Field[ @Type = '5710norm' ]) or 
                            normalize-space(translate(lower-case(@Value), '(?)', '')) != preceding-sibling::h1:Field[ @Type = '5710norm' ]/normalize-space(translate(lower-case(@Value), '(?)', ''))]">
                            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="type" select=" 'textLang-ID' "/>
                                <xsl:call-template name="writeLangRef">
                                    <xsl:with-param name="value" select="normalize-space(translate(lower-case(@Value), '(?)', ''))"/>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="indexName" select=" 'norm_textLang' "/>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'textLang' "/>
                        </xsl:element>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'textLang-ID' "/>
                        </xsl:element>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <!-- ========== Kerndatenfeld form (5240norm) ========== -->
            <xsl:choose>
                <xsl:when test="h1:Field[ @Type = '5230' ][ @Value = 'Einband' ]">
                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="indexName" select=" 'norm_form' "/>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'form' "/>
                            <xsl:text>binding</xsl:text>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="h1:Field[ @Type = '5240norm' ]">
                    <xsl:apply-templates select="h1:Field[ @Type = '5240norm' ]">
                        <xsl:with-param name="calledFrom" select="$calledFrom"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="indexName" select=" 'norm_form' "/>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'form' "/>
                        </xsl:element>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <!-- ========== Kerndatenfeld status (5210norm) ========== -->
            <xsl:choose>
                <xsl:when test="h1:Field[ @Type = '5210norm' ]">
                    <xsl:apply-templates select="h1:Field[ @Type = '5210norm' ]">
                        <xsl:with-param name="calledFrom" select="$calledFrom"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="indexName" select=" 'norm_status' "/>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'status' "/>
                        </xsl:element>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <!-- ========== Kerndatenfeld decoration (5270norm) ========== -->
            <xsl:choose>
                <xsl:when test="h1:Field[ @Type = '5270norm' ]">
                    <xsl:apply-templates select="h1:Field[ @Type = '5270norm' ]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="indexName" select=" 'norm_decoration' "/>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'decoration' "/>
                        </xsl:element>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <!-- ========== Kerndatenfeld musicNotation (5705norm) ========== -->
            <xsl:choose>
                <xsl:when test="h1:Field[ @Type = '5705norm' ]">
                    <xsl:apply-templates select="h1:Field[ @Type = '5705norm' ]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="indexName" select=" 'norm_musicNotation' "/>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'musicNotation' "/>
                        </xsl:element>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="
                h1:Field[ @Type = '4502norm' ] |
                h1:Field[ @Type = '4503norm' ]"/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="history">
        <xsl:choose>
            <xsl:when test="h1:Field[ @Type = 'par05' ][ @Value != '' ]">
                <xsl:element name="history" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates select="h1:Field[ @Type = 'par05' ]"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="h1:Field[ @Type = 'par10' ][ @Value != '' ]">
                <xsl:if test="$mode = 'test' "><xsl:comment>history > par10</xsl:comment></xsl:if>
                <xsl:element name="history" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates select="h1:Field[ @Type = 'par10' ][ @Value != '' ]"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="h1:Block[not(h1:Field[ @Type = '5230' ][ @Value = 'Faszikel' ])][not(h1:Field[ @Type = '5230' ][ @Value = 'Text' ])]/h1:Field[ @Type = 'par10' ][ @Value != '' ]">
                <xsl:if test="$mode = 'test' "><xsl:comment>history > Block/par10</xsl:comment></xsl:if>
                <xsl:element name="history" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates select="h1:Block/h1:Field[ @Type = 'par10' ][ @Value != '' ]"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Text') ]][h1:Field[ @Type = 'par10'] and not(h1:Field[ @Type = 'bezper'][ @Value = 'Vorbesitz' ])]">
                <xsl:if test="$mode = 'test' "><xsl:comment>Block/Text > physDesc > par10</xsl:comment></xsl:if>
                <xsl:element name="history" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Text') ]][h1:Field[ @Type = 'par10'] and not(h1:Field[ @Type = 'bezper'][ @Value = 'Vorbesitz' ])]/h1:Field[ @Type = 'par10' ]">
                            <xsl:with-param name="writeP" select=" 'no' "/>
                        </xsl:apply-templates>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:when test="h1:Field[ @Type = '599a' ][contains(@Value, 'Geschichte') or contains(@Value, 'Provenienz')]">
                <xsl:element name="history" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:for-each select="h1:Field[ @Type = '599a' ][contains(@Value, 'Geschichte') or contains(@Value, 'Provenienz')]">
                            <xsl:apply-templates select="h1:Field[ @Type = '599e' ]"/>
                            <xsl:if test="following-sibling::h1:Field[ @Type = '599a' ][ contains(@Value, 'Provenienz') ]"><xsl:text> </xsl:text></xsl:if>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:when test="h1:Field[ @Type = 'bezsoz' ][contains(@Value, 'Eigentum')]">
                <xsl:element name="history" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:apply-templates select="h1:Field[ @Type = 'bezsoz' ][contains(@Value, 'Eigentum')]" mode="index"/>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="msContents">
        <xsl:choose>
            <xsl:when test="h1:Field[ @Type = 'par11' ][ @Value != '' ]
                [
                    not(h1:Field[ @Type = 'par09' ]) and not(h1:Field[ @Type = 'par09' ][ @Value != '' ]) 
                and not(h1:Field[ @Type = 'par10' ]) and not(h1:Field[ @Type = 'par10' ][ @Value != '' ])
                ]">
                
                <xsl:element name="msContents" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:if test="$mode = 'test' "><xsl:comment>msContents/when-1</xsl:comment></xsl:if>
                    <xsl:for-each select="h1:Field[ @Type = 'par11' ][ @Value != '' ]">
                        <xsl:element name="msItem" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="n">
                                <xsl:text>MXML-</xsl:text>
                                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="self::h1:Field[ @Type = 'par11' ][ @Value != '' ]"/>
                            <xsl:call-template name="writeIndexFields">
                                <xsl:with-param name="field" select=" 'note' "/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:for-each>
                    <xsl:for-each select="h1:Block[h1:Field[ @Type = 'par11' ][ @Value != '' ]]">
                        <xsl:element name="msItem" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="n">
                                <xsl:text>MXML-</xsl:text>
                                <xsl:value-of select="translate(h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="h1:Field[ @Type = 'par11' ][ @Value != '' ]"/>
                            <xsl:call-template name="writeIndexFields">
                                <xsl:with-param name="field" select=" 'note' "/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:when>
            <xsl:when test="h1:Block[h1:Field[ @Type = 'par11' ][ @Value != '' ]][not(h1:Field[ @Type = '5230' ][ @Value = 'Faszikel' ])]
                [not(h1:Field[ @Type = '5230' ][ @Value = 'Text' ]) 
                and not(h1:Field[ @Type = 'par09' ]) and not(h1:Field[ @Type = 'par09' ][ @Value != '' ]) 
                and not(h1:Field[ @Type = 'par10' ]) and not(h1:Field[ @Type = 'par10' ][ @Value != '' ])]">
                <xsl:element name="msContents" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:if test="$mode = 'test' "><xsl:comment>msContents/when-2</xsl:comment></xsl:if>
                    <xsl:for-each select="h1:Block[h1:Field[ @Type = 'par11' ][ @Value != '' ]][not(h1:Field[ @Type = '5230' ][ @Value = 'Faszikel' ])]">
                        <xsl:element name="msItem" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="n">
                                <xsl:text>MXML-</xsl:text>
                                <xsl:value-of select="translate(h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="h1:Field[ @Type = 'par11' ][ @Value != '' ]"/>
                            <xsl:call-template name="writeIndexFields">
                                <xsl:with-param name="field" select=" 'note' "/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:when>
            <xsl:when test="h1:Block[h1:Field[ @Type = 'par11' ][ @Value != '' ]][h1:Field[ @Type = '5230' ][ @Value = 'Text' ]]">
                <xsl:element name="msContents" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:if test="$mode = 'test' "><xsl:comment>msContents/when-3</xsl:comment></xsl:if>
                    <xsl:for-each select="h1:Block[h1:Field[ @Type = 'par11' ][ @Value != '' ]][h1:Field[ @Type = '5230' ][ @Value = 'Text' ]]">
                        <xsl:element name="msItem" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="n">
                                <xsl:text>MXML-</xsl:text>
                                <xsl:value-of select="translate(h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="h1:Field[ @Type = 'par11' ][ @Value != '' ]"/>
                            <xsl:call-template name="writeIndexFields">
                                <xsl:with-param name="field" select=" 'note' "/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:when>
            <xsl:when test="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Text') ]]
                [h1:Field[ @Type = '599a' ][@Value = 'AUTOR/SACHTITEL' or @Value = 'Textautopsie' or @Value = 'TEXTAUTOPSIE' or @Value = 'INHALT'][h1:Field[ @Type = '599e' ]]]">
                <xsl:element name="msContents" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:if test="$mode = 'test' "><xsl:comment>msContents/when-4</xsl:comment></xsl:if>
                    <xsl:for-each select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Text') ]]
                        [h1:Field[ @Type = '599a' ][@Value = 'AUTOR/SACHTITEL' or @Value = 'Textautopsie' or @Value = 'TEXTAUTOPSIE' or @Value = 'INHALT']]">
                        <xsl:element name="msItem" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="type" select=" 'text' "/>
                                <xsl:if test="$mode = 'test' "><xsl:comment>msContents/599a</xsl:comment></xsl:if>
                                <xsl:apply-templates select="h1:Field[ @Type = '4665' ]"/>
                                <xsl:for-each select="h1:Field[ @Type = '599a' ][@Value = 'AUTOR/SACHTITEL' or @Value = 'Textautopsie' or @Value = 'TEXTAUTOPSIE' or @Value = 'INHALT']">
                                    <xsl:apply-templates select="h1:Field[ @Type = '599e' ]"/>
                                    <xsl:if test="following-sibling::h1:Field[ @Type = '599a' ][@Value = 'AUTOR/SACHTITEL' or @Value = 'Textautopsie' or @Value = 'TEXTAUTOPSIE' or @Value = 'INHALT']">
                                        <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                                        <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:if test="h1:Field[ @Type = '5710' ][ @Value != 'polyglott' ][ @Value != 'Runen' ]">
                                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                                        <xsl:attribute name="indexName" select=" 'textLang' "/>
                                        <xsl:for-each select="h1:Field[ @Type = '5710' ][ @Value != 'polyglott' ][ @Value != 'Runen' ][
                                            not(preceding-sibling::h1:Field[ @Type = '5710' ]) or 
                                            normalize-space(translate(lower-case(@Value), '(?)', '')) != preceding-sibling::h1:Field[ @Type = '5710' ]/normalize-space(translate(lower-case(@Value), '(?)', ''))]">
                                            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="type" select=" 'textLang-ID' "/>
                                                <xsl:call-template name="writeLangRef">
                                                    <xsl:with-param name="value" select="replace(replace(normalize-space(translate(lower-case(@Value), '(?)', '')), 'polyglott', ''), 'Runen', '')"/>
                                                </xsl:call-template>
                                                <xsl:value-of select="."/>
                                            </xsl:element>
                                        </xsl:for-each>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:element>
                            <xsl:call-template name="writeIndexFields">
                                <xsl:with-param name="field" select=" 'note' "/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:when>
            <xsl:when test="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Text') ]][h1:Field[ @Type = '5209' ]]">
                <xsl:element name="msContents" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:if test="$mode = 'test' "><xsl:comment>msContents/when-5</xsl:comment></xsl:if>
                    <xsl:for-each select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Text') ]][h1:Field[ @Type = '5209' ]]">
                        <xsl:element name="msItem" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="type" select=" 'text' "/>
                                <xsl:if test="$mode = 'test' "><xsl:comment>msContents/5209</xsl:comment></xsl:if>
                                <xsl:apply-templates select="h1:Field[ @Type = '4665' ]"/>
                                <xsl:if test="h1:Field[ @Type = '4665' ] and h1:Field[ @Type = '5209' ]">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="h1:Field[ @Type = '5209' ]/@Value"/>
                                <xsl:if test="h1:Field[ @Type = '5710' ][ @Value != 'polyglott' ][ @Value != 'Runen' ]">
                                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                                        <xsl:attribute name="indexName" select=" 'textLang' "/>
                                        <xsl:for-each select="h1:Field[ @Type = '5710' ][ @Value != 'polyglott' ][ @Value != 'Runen' ][
                                            not(preceding-sibling::h1:Field[ @Type = '5710' ]) or 
                                            normalize-space(translate(lower-case(@Value), '(?)', '')) != preceding-sibling::h1:Field[ @Type = '5710' ]/normalize-space(translate(lower-case(@Value), '(?)', ''))]">
                                            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="type" select=" 'textLang-ID' "/>
                                                <xsl:call-template name="writeLangRef">
                                                    <xsl:with-param name="value" select="replace(replace(normalize-space(translate(lower-case(@Value), '(?)', '')), 'polyglott', ''), 'Runen', '')"/>
                                                </xsl:call-template>
                                                <xsl:value-of select="."/>
                                            </xsl:element>
                                        </xsl:for-each>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:element>
                            <xsl:call-template name="writeIndexFields">
                                <xsl:with-param name="field" select=" 'note' "/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="physDesc">
        <xsl:choose>
            <xsl:when test="h1:Field[ @Type = 'par04' ][ @Value != '' ]">
                <xsl:if test="$mode = 'test' "><xsl:comment>physDesc > par04</xsl:comment></xsl:if>
                <xsl:element name="physDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates select="h1:Field[ @Type = 'par04' ]"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="h1:Field[ @Type = 'par08' ][ @Value != '' ]">
                <xsl:if test="$mode = 'test' "><xsl:comment>physDesc > par08</xsl:comment></xsl:if>
                <xsl:element name="physDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates select="h1:Field[ @Type = 'par08' ][ @Value != '' ]"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="h1:Field[ @Type = 'par09' ][ @Value != '' ]">
                <xsl:if test="$mode = 'test' "><xsl:comment>physDesc > par09</xsl:comment></xsl:if>
                <xsl:element name="physDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates select="h1:Field[ @Type = 'par09' ]"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="h1:Field[ @Type = 'par13' ][ @Value != '' ]">
                <xsl:if test="$mode = 'test' "><xsl:comment>physDesc > par13</xsl:comment></xsl:if>
                <xsl:element name="physDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="decoDesc" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:apply-templates select="h1:Field[ @Type = 'par13' ]"/>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:when test="h1:Field[ @Type = '5707' ]
                or h1:Field[ @Type = '5708' ]
                or h1:Field[ @Type = '599a' ][
                   (@Value = 'Zeilen') 
                or (@Value = 'Zeilenzahl') 
                or (@Value = 'Spalten') 
                or (@Value = 'Spaltenzahl') 
                or (@Value = 'AUSSTATTUNG')
                or (@Value = 'INITIALEN')
                or (@Value = 'LAGEN') 
                or (@Value = 'MINIATUREN') 
                or (@Value = 'Ornament') 
                or (@Value = 'Schrift') 
                or (@Value = 'Erhaltung') 
                ]">
                <xsl:element name="physDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:apply-templates select="h1:Field[ @Type = '5707' ]"/>
                        <xsl:apply-templates select="h1:Field[ @Type = '5708' ]"/>
                        <xsl:apply-templates select="h1:Field[ @Type = '599a' ][ 
                               (@Value = 'Zeilen')
                            or (@Value = 'Zeilenzahl')
                            or (@Value = 'Spalten') 
                            or (@Value = 'Spaltenzahl') 
                            or (@Value = 'AUSSTATTUNG')
                            or (@Value = 'INITIALEN')
                            or (@Value = 'LAGEN')
                            or (@Value = 'MINIATUREN') 
                            or (@Value = 'Ornament') 
                            or (@Value = 'Schrift') 
                            or (@Value = 'Erhaltung') 
                            ]"/>
                        <xsl:apply-templates select="h1:Field[ @Type = '599a' ][ @Value = 'Beschreibung' ][not(parent::h1:Field/h1:Field[ @Type = '1200gi' ])]"/>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:when test="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Text') ]][h1:Field[ @Type = 'par09' ]] 
                and h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Text') ]][h1:Field[ @Type = 'par11' ][ @Value != '' ]]">
                <xsl:if test="$mode = 'test' "><xsl:comment>Block/Text > physDesc > par09</xsl:comment></xsl:if>
                <xsl:element name="physDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Text') ]][h1:Field[ @Type = 'par09' ]]/h1:Field[ @Type = 'par09' ]"/>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="processPar">
        <xsl:param name="element"/>
        <xsl:param name="type"/>
        <xsl:param name="fields"/>
        <!-- vorgefundene Linkziele:
1800
1802
205a
4665
5007
5007.5010
5007.501k
5007.501m
5007.501n
5007.501p
5007.501t
5060
5060.5064
5060norm.5064norm
5060vt.5064vt
5130
5130vt
5140.5145
5200
5209
5210
5230
5234
5240
5260
5270
5270norm
5300
5360
5360norm
5360norm.5361norm
5360vt
5382
5382norm
5500
5500.5504
550b
55hs
5650
5650.5664
5650.5666d
5650.5666g
5650.5666l
5650.5666v
5650.5684
5650.5686
5650.5694
5704
5705
5705vt
5706
5706norm
5706vt
5710
599a
599a.599e
6560
6560.6524
6560.6565
6560.6740
6560.6770
6560.6807
8350
8450
8450.8540
bezlit
bezlit.8330
bezlit.8334
bezper
bezper.4100
bezper.4100gi
bezper.4470
bezper.4475
bezper.z001
bezsoz
bezsoz.4564
bezsoz.4590
bezsoz.4594
bezsoz.4600
bezsoz.4604
bezsoz.4610
bezsoz.4630
bezsoz.4650
bezsoz.4652
bezsoz.4656
bezsoz.4996
bezsoz.4998
bezwrk
bezwrk.6920
bezwrk.6922
bezwrk.6923
bezwrk.6930
bezwrk.6930gi
bezwrk.6996
bezwrk.6998
        -->
        <xsl:choose>
            <xsl:when test="starts-with(@Value, '{\rtf') and (self::h1:Field[ @Type = 'par01' ] or self::h1:Field[ @Type = 'par02' ] or self::h1:Field[ @Type = 'par03' ])">
                <xsl:variable name="rtf-content" select="parse-xml(sbbfunc:rtf-to-html(@Value, 'false', '1'))"/>
                
                <xsl:variable name="first-pass"><xsl:apply-templates select="$rtf-content" mode="reduceSpan"/></xsl:variable>
                <xsl:variable name="second-pass">
                    <xsl:apply-templates select="$first-pass//html:body/html:p" mode="html">
                        <xsl:with-param name="apply" select=" 'no' "/>
                        <xsl:with-param name="fields" select="$fields"/>
                    </xsl:apply-templates>
                </xsl:variable>
                <xsl:copy-of select="normalize-space($second-pass)"/>
            </xsl:when>
            <xsl:when test="starts-with(@Value, '{\rtf') and self::h1:Field[ @Type = 'par06' ]">
                <xsl:variable name="rtf-content" select="parse-xml(sbbfunc:rtf-to-html(@Value, '1'))"/>
                <xsl:variable name="first-pass"><xsl:apply-templates select="$rtf-content" mode="reduceSpan"/></xsl:variable>
                <xsl:variable name="second-pass">
                    <xsl:apply-templates select="$first-pass//html:body/html:p" mode="html">
                        <xsl:with-param name="apply" select=" 'par06' "/>
                        <xsl:with-param name="fields" select="$fields"/>
                    </xsl:apply-templates>
                </xsl:variable>
                <xsl:copy-of select="$second-pass"/>
            </xsl:when>
            <xsl:when test="starts-with(@Value, '{\rtf')">
                <xsl:variable name="rtf-content" select="parse-xml(sbbfunc:rtf-to-html(@Value, '1'))"/>
                <xsl:variable name="first-pass"><xsl:apply-templates select="$rtf-content" mode="reduceSpan"/></xsl:variable>
                <xsl:variable name="second-pass">
                    <xsl:apply-templates select="$first-pass//html:body/html:p" mode="html">
                        <xsl:with-param name="fields" select="$fields"/>
                    </xsl:apply-templates>
                </xsl:variable>
                <xsl:copy-of select="$second-pass"/>
            </xsl:when>
            
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
    <xsl:template match="node()" mode="reduceSpan">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="reduceSpan"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="html:span" mode="reduceSpan">
        <xsl:choose>
            <xsl:when test="contains(@style, 'font-family: Arial')
                or contains(@style, 'font-family: Arial Unicode MS')
                or contains(@style, 'font-family: @Arial Unicode MS')
                or contains(@style, 'font-family: @Arial')
                or contains(@style, 'font-family: Calibri')
                or contains(@style, 'font-family: Courier New')
                or contains(@style, 'font-family: Garamond')
                or contains(@style, 'font-family: Junicode')
                or contains(@style, 'font-family: Palatino Linotype')
                or contains(@style, 'font-family: Times New Roman')
                or contains(@style, 'font-family: Verdana')">
                <xsl:apply-templates mode="#current"/>
            </xsl:when>
            <xsl:when test="contains(@style, 'font-family: Symbol')">
                <xsl:value-of select="replace(replace(replace(replace(replace(., 
                    '\[', '['), 
                    '\]', ']'), 
                    '&#180;', '&#xD7;'), 
                    'á', '&#x2329;'), 
                    'ñ', '&#x232A;')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$mode = 'test' "><xsl:comment>genutzter Font: <xsl:copy-of select="@style"/></xsl:comment></xsl:if>
                <xsl:apply-templates mode="reduceSpan"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="text()" mode="html">
        <xsl:variable name="cleanText" select="replace(replace(replace(normalize-space(.), 
            '&#xD;', ''), 
            '\. ?\. ?\.', '&#x2026;'), 
            ' ,', ',')"/>
        <xsl:variable name="markupLinks">
            <xsl:analyze-string select="$cleanText" regex="https?://[\w\d&amp;/=\?#\.:\-_]+">
                <xsl:matching-substring>
                    <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="target" select="."/>
                        <xsl:value-of select="."/>
                    </xsl:element>
                </xsl:matching-substring>
                <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:copy-of select="$markupLinks"/>
    </xsl:template>
    <xsl:template match="html:p[. != '']" mode="html">
        <xsl:param name="apply"/>
        <xsl:param name="fields"/>
        <xsl:apply-templates mode="html">
            <xsl:with-param name="apply" select="$apply"/>
            <xsl:with-param name="fields" select="$fields"/>
        </xsl:apply-templates>
        <xsl:if test="following-sibling::html:p[. != '']">
            <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
            <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="html:a" mode="html">
        <xsl:param name="apply"/>
        <xsl:param name="fields"/>
        <xsl:call-template name="writeLeadingWhitespace"/>
        <xsl:choose>
            <xsl:when test="$apply = 'no' ">
                <xsl:apply-templates mode="html"/>
            </xsl:when>
            <xsl:when test="starts-with(@href, 'hida://bezper')">
                <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:choose>
                        <xsl:when test="($fields != '') and $fields//h1:Field[ @Type = 'bezper' ]">
                            <xsl:attribute name="ref">
                                <xsl:value-of select="concat('https://d-nb.info/gnd/', 
                                    $fields//h1:Field[ @Type = 'bezper' ][count(preceding-sibling::h1:Field[ @Type = 'bezper' ]) = number(substring-before(substring-after(current()/@href, '['), ']'))]/h1:Field[ @Type = 'z001' ]/@Value)"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="ref">
                                <xsl:value-of select="replace(replace(@href, 'hida://', '#'), '/\?u', '')"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:apply-templates mode="html"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="target">
                        <xsl:value-of select="replace(replace(@href, 'hida://', '#'), '/\?u', '')"/>
                    </xsl:attribute>
                    <xsl:apply-templates mode="html">
                        <xsl:with-param name="apply" select="$apply"/>
                    </xsl:apply-templates>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="writeTrailingWhitespace"/>
    </xsl:template>
    <xsl:template match="html:b" mode="html">
        <xsl:param name="apply"/>
        <xsl:call-template name="writeLeadingWhitespace"/>
        <xsl:apply-templates mode="html">
            <xsl:with-param name="apply" select="$apply"/>
        </xsl:apply-templates>
        <xsl:call-template name="writeTrailingWhitespace"/>
    </xsl:template>
    <xsl:template match="html:i" mode="html">
        <xsl:param name="apply"/>
        <xsl:call-template name="writeLeadingWhitespace"/>
        <xsl:choose>
            <xsl:when test="$apply = 'no' ">
                <xsl:apply-templates mode="html">
                    <xsl:with-param name="apply" select="$apply"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$apply = 'par06' ">
                <xsl:element name="hi" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="rend" select=" 'italic' "/>
                    <xsl:apply-templates mode="html">
                        <xsl:with-param name="apply" select="$apply"/>
                    </xsl:apply-templates>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="quote" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates mode="html">
                        <xsl:with-param name="apply" select="$apply"/>
                    </xsl:apply-templates>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="writeTrailingWhitespace"/>
    </xsl:template>
    <xsl:template match="html:h6" mode="html">
        <xsl:param name="apply"/>
        <xsl:call-template name="writeLeadingWhitespace"/>
        <xsl:choose>
            <xsl:when test="$apply = 'no' ">
                <xsl:apply-templates mode="html">
                    <xsl:with-param name="apply" select="$apply"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="hi" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="rend">small-caps</xsl:attribute>
                    <xsl:apply-templates mode="html">
                        <xsl:with-param name="apply" select="$apply"/>
                    </xsl:apply-templates>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="writeTrailingWhitespace"/>
    </xsl:template>
    <xsl:template match="html:span" mode="html">
        <xsl:param name="apply"/>
        <xsl:choose>
            <xsl:when test="$apply = 'no' ">
                <xsl:call-template name="writeLeadingWhitespace"/>
                <xsl:apply-templates mode="html">
                    <xsl:with-param name="apply" select="$apply"/>
                </xsl:apply-templates>
                <xsl:call-template name="writeTrailingWhitespace"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="writeLeadingWhitespace"/>
                <xsl:element name="hi" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="rend"><xsl:value-of select="substring-after(@style, 'font-family: ')"/></xsl:attribute>
                    <xsl:apply-templates mode="html">
                        <xsl:with-param name="apply" select="$apply"/>
                    </xsl:apply-templates>
                </xsl:element>
                <xsl:call-template name="writeTrailingWhitespace"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="html:sup" mode="html">
        <xsl:element name="hi" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="rend">sup</xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
        <!--
        <xsl:value-of select="replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
            replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
            replace(replace(replace(replace(., 
            'a', '&#x1D43;'),
            'b', '&#x1D47;'),
            'd', '&#x1D48;'),
            'e', '&#x1D49;'),
            'm', '&#x1D50;'),
            'o', '&#x1D52;'),
            'r', '&#x02B3;'),
            's', '&#x02E2;'),
            't', '&#x1D57;'),
            'u', '&#x1D58;'),
            'v', '&#x2C7D;'),
            'I', '&#x1D35;'),
            '.', '&#xB7;'),
            '-', '&#x2078;'),
            '0', '&#x2070;'),
            '1', '&#xB9;'),
            '2', '&#xB2;'),
            '3', '&#xB3;'),
            '4', '&#x2074;'),
            '5', '&#x2075;'),
            '6', '&#x2076;'),
            '7', '&#x2077;'),
            '8', '&#x2078;'),
            '9', '&#x2079;')"/>
            -->
    </xsl:template>
    <xsl:template match="html:sub" mode="html">
        <xsl:value-of select="replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(., 
            '-', '&#x208B;'),
            '0', '&#x2080;'),
            '1', '&#x2081;'),
            '2', '&#x2082;'),
            '3', '&#x2083;'),
            '4', '&#x2084;'),
            '5', '&#x2085;'),
            '6', '&#x2086;'),
            '7', '&#x2087;'),
            '8', '&#x2088;'),
            '9', '&#x2089;')"/>
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
        <xsl:variable name="convertWhitespace"           select="replace($saveBrackets,             '&#x0d;&#x0a;',                                                  ' ',           'i;j')"/>
        <!--<xsl:variable name="normalizeWhitespace"     select="replace($convertWhitespace,    '\s+',                                                           ' ',           'i;j')"/>-->
        <!-- remove Header markup --> 
        <xsl:variable name="removeRTFtag"                select="replace($convertWhitespace, '\{\\rtf.*?\} ',                                                             '',            'i;j')"/>
        <xsl:variable name="convertApos"                 select="replace($removeRTFtag, $replace, $by)"/>
        <xsl:variable name="normalizeSpecialCharacters1" select="replace($convertApos,                 '\\u(\d+) \\\^[a-f0-9]{2}', '\\u$1')"/>
        <xsl:variable name="normalizeSpecialCharacters2" select="replace($normalizeSpecialCharacters1, '\\u(\d+) \?', '\\u$1')"/>
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

        <xsl:variable name="removeFormatting"    select="replace($convertSpecialCharacters4, '(\\(f\d+|b|ul|fs|lang|cbpat|chcbpat|cf|expndtw)\d*)+ ?',                                                 '')"/>
        <xsl:variable name="removePardStart"     select="replace($removeFormatting,          '\\uc1 \\pard(\\(keepn?|fi\-?|tx|li\-?|q[cjlr]|ri\-?|sb|sa|tq[cr]|itap|tap|sl|slmult|jclisttab)\d*)+ ',   '',                       'i;j')"/>
        <xsl:variable name="convertPar"          select="replace($removePardStart,           ' *\\par \\pard(\\(keepn?|fi\-?|tx|li\-?|q[cjlr]|ri\-?|sb|sa|tq[cr]|itap|tap|sl|slmult|jclisttab)\d*)+ ', '&lt;lb/&gt;&lt;lb/&gt;', 'i;j')"/>
        <xsl:variable name="convertLine"         select="replace($convertPar,                ' \\line',                                                                                                '&lt;lb/&gt;',            'i;j')"/>
        <xsl:variable name="removeParEnd"        select="replace($convertLine,               ' *\\par}',                                                                                               '}',                      'i;j')"/>
        <xsl:variable name="removeLBEnd"         select="replace($removeParEnd,              '(&lt;lb/&gt;)+( *\\plain)?}',                                                                            '}',                      'i;j')"/>
        <xsl:variable name="removeList"          select="replace($removeLBEnd,               '\{(\\(listlevel|levelnfc|leveljc|li\d+|fi\-?\d+|jclisttab|tx)\d*)+',                                     '',                       'i;j')"/>
        <xsl:variable name="removeListParts"     select="replace($removeList,                '(\{?(\\\*?\\?(leveltext.*?\;|levelnumbers.*?\;|levelstartat\d+|listoverridetable|listoverridecount\d+|listoverride|listtemplateid\d+|listid\d+|listtext|list|pard|ls\d+|ilvl\d+))+)+', '',            'i;j')"/>
        <xsl:variable name="convertHidaLinks"    select="if (self::h1:Field[ @Type = 'par01' ] or self::h1:Field[ @Type = 'par02' ] or self::h1:Field[ @Type = 'par03' ]) 
            then replace($removeListParts, '\{\\field\{\\\*\\fldinst HYPERLINK &quot;hida://([a-z0-9\[\]\.?]+)/?\??u?&quot;\}\{\\fldrslt \\plain (.*?)\}\}', '$2', 'i;j') 
            else replace($removeListParts, '\{\\field\{\\\*\\fldinst HYPERLINK &quot;hida://([a-z0-9\[\]\.?]+)/?\??u?&quot;\}\{\\fldrslt \\plain (.*?)\}\}', '&lt;ref target=&quot;#$1&quot;&gt;$2&lt;/ref&gt;', 'i;j')"/>
        <xsl:variable name="convertHyperlinks"   select="if (self::h1:Field[ @Type = 'par01' ] or self::h1:Field[ @Type = 'par02' ] or self::h1:Field[ @Type = 'par03' ]) 
            then replace($convertHidaLinks, '\{\\field\{\\\*\\fldinst HYPERLINK &quot;http(s)?://([\p{L}\d/=\?\.:\-]+)&quot;\}\{\\fldrslt \\plain (.*?)\}\}', '$3', 'i;j') 
            else replace($convertHidaLinks, '\{\\field\{\\\*\\fldinst HYPERLINK &quot;http(s)?://([\p{L}\d/=\?\.:\-]+)&quot;\}\{\\fldrslt \\plain (.*?)\}\}', '&lt;ref target=&quot;http$1://$2&quot;&gt;$3&lt;/ref&gt;', 'i;j')"/>
        
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
        -->
        <xsl:variable name="moveWhitespace"      select="replace($convertHyperlinks,   '&lt;ref(.*?)&gt; ',                   ' &lt;ref$1&gt;')"/>
        
        <xsl:variable name="removeIFromInitium"   select="replace($moveWhitespace,     '&lt;ref type=&quot;initium&quot; xml:lang=&quot;(\w+)&quot;&gt;\\i(.*?)&lt;/ref&gt;\\plain \\i', '&lt;ref type=&quot;initium&quot; xml:lang=&quot;$1&quot;&gt;$2&lt;/ref&gt;')"/>
        <!--
        <xsl:variable name="removeIFromInitium"   select="replace($convertHyperlinks,     '&lt;ref type=&quot;initium&quot; xml:lang=&quot;(\w+)&quot;&gt;\\i(.*?)&lt;/ref&gt;\\plain \\i', '&lt;ref type=&quot;initium&quot; xml:lang=&quot;$1&quot;&gt;$2&lt;/ref&gt;')"/>
        -->
        
        <!-- to do:
\i.i.aniso\plain
        -->
        
        <xsl:variable name="convertFormattingISup"  select="replace($removeIFromInitium,     '\\i\\super ?([\p{L}\d \^/\(\)\[\]‘“’”›‹+,;\.:\-\-…]+)',     '&lt;hi rend=&quot;italic sup&quot;&gt;$1&lt;/hi&gt;')"/>
        <xsl:variable name="convertFormattingIStr"  select="replace($convertFormattingISup,  '\\i\\strike ?([\p{L}\d \^/\(\)\[\]‘“’”›‹+,;\.:\-\-…]+)',    '&lt;hi rend=&quot;italic del&quot;&gt;$1&lt;/hi&gt;')"/>
        <xsl:variable name="convertFormattingI"     select="replace($convertFormattingIStr,  '\\i ?([\p{L}\d \^/\(\)\[\]‘“’”›‹+,;\.:\-\-…&#785;]+)',      '&lt;hi rend=&quot;italic&quot;&gt;$1&lt;/hi&gt;')"/>
        <xsl:variable name="convertFormattingSupSC" select="replace($convertFormattingI,     '\\super\\scaps ?([\p{L}\d \^/\(\)\[\]‘“’”›‹+,;\.:\-\-…]+)', '&lt;hi rend=&quot;sup small-caps&quot;&gt;$1&lt;/hi&gt;')"/>
        <xsl:variable name="convertFormattingSup"   select="replace($convertFormattingSupSC, '\\super ?([\p{L}\d \^/\(\)\[\]‘“’”›‹+,;\.:\-\-…]+)',        '&lt;hi rend=&quot;sup&quot;&gt;$1&lt;/hi&gt;')"/>
        <xsl:variable name="convertFormattingSC"    select="replace($convertFormattingSup,   '\\scaps ?([\p{L}\d \^/\(\)\[\]‘“’”›‹+,;\.:\-\-…]+)',        '&lt;hi rend=&quot;small-caps&quot;&gt;$1&lt;/hi&gt;')"/>
        <xsl:variable name="convertFormattingSub"   select="replace($convertFormattingSC,    '\\sub ?([\p{L}\d \^/\(\)\[\]‘“’”›‹+,;\.:\-\-…]+)',          '&lt;hi rend=&quot;sub&quot;&gt;$1&lt;/hi&gt;')"/>
        <xsl:variable name="removeEmptyHi"          select="replace($convertFormattingSub,   '&lt;hi rend=&quot;(italic|sup|sup scaps|scaps|sup small-caps|small-caps)&quot;&gt;([ ,;\.:]*)&lt;/hi&gt;', '$2')"/>
        <xsl:variable name="removeEmptyQuote"       select="replace($removeEmptyHi,          '&lt;quote&gt;([ ,;\.:]*)&lt;/quote&gt;',                   '$1')"/>
        <xsl:variable name="mergeHis"               select="replace($removeEmptyQuote,       '&lt;/hi&gt;&lt;hi rend=&quot;\w+&quot;&gt;',               '')"/>
        <xsl:variable name="mergeQuotes"            select="replace($mergeHis,               '&lt;/quote&gt;&lt;quote&gt;',                              '')"/>
        <xsl:variable name="convertSuperscriptR"    select="replace($mergeQuotes,            '&lt;hi rend=&quot;sup&quot;&gt;r(\s*)&lt;/hi&gt;',         '&amp;#x02B3;$1')"/><!-- spacing modifier letters -->
        <xsl:variable name="convertSuperscriptV"    select="replace($convertSuperscriptR,    '&lt;hi rend=&quot;sup&quot;&gt;v(\s*)&lt;/hi&gt;',         '&amp;#x2C7D;$1')"/><!-- oder besser 1D5B von phonetic extensions? -->
        <xsl:variable name="convertSuperscriptRV"   select="replace($convertSuperscriptV,    '&lt;hi rend=&quot;sup&quot;&gt;rv&lt;/hi&gt;',             '&amp;#x02B3;&amp;#x2C7D;')"/>
        <xsl:variable name="convertSuperscriptRA"   select="replace($convertSuperscriptRV,   '&lt;hi rend=&quot;sup&quot;&gt;ra&lt;/hi&gt;',             '&amp;#x02B3;&amp;#x1D43;')"/>
        <xsl:variable name="convertSuperscriptRB"   select="replace($convertSuperscriptRA,   '&lt;hi rend=&quot;sup&quot;&gt;rb&lt;/hi&gt;',             '&amp;#x02B3;&amp;#x1D47;')"/>
        <xsl:variable name="convertSuperscriptVA"   select="replace($convertSuperscriptRB,   '&lt;hi rend=&quot;sup&quot;&gt;va&lt;/hi&gt;',             '&amp;#x2C7D;&amp;#x1D43;')"/>
        <xsl:variable name="convertSuperscriptVB"   select="replace($convertSuperscriptVA,   '&lt;hi rend=&quot;sup&quot;&gt;vb&lt;/hi&gt;',             '&amp;#x2C7D;&amp;#x1D47;')"/>
        <xsl:variable name="convertSuperscriptA"    select="replace($convertSuperscriptVB,   '&lt;hi rend=&quot;sup&quot;&gt;a&lt;/hi&gt;',              '&amp;#x1D43;')"/>
        <xsl:variable name="convertSuperscriptE"    select="replace($convertSuperscriptA,    '&lt;hi rend=&quot;sup&quot;&gt;e&lt;/hi&gt;',              '&amp;#x1D49;')"/>
        <xsl:variable name="convertSuperscriptO"    select="replace($convertSuperscriptE,    '&lt;hi rend=&quot;sup&quot;&gt;o&lt;/hi&gt;',              '&amp;#x1D52;')"/>
        <xsl:variable name="convertSuperscriptTO"   select="replace($convertSuperscriptO,    '&lt;hi rend=&quot;sup&quot;&gt;to&lt;/hi&gt;',             '&amp;#x1D57;&amp;#x1D52;')"/>
        <xsl:variable name="convertSuperscriptUS"   select="replace($convertSuperscriptTO,   '&lt;hi rend=&quot;sup&quot;&gt;us&lt;/hi&gt;',             '&amp;#x1D58;&amp;#x02E2;')"/>
        <xsl:variable name="convertSuperscript1"    select="replace($convertSuperscriptUS,   '&lt;hi rend=&quot;sup&quot;&gt;1&lt;/hi&gt;',              '&amp;#xB9;')"/>
        <xsl:variable name="convertSuperscript2"    select="replace($convertSuperscript1,    '&lt;hi rend=&quot;sup&quot;&gt;2&lt;/hi&gt;',              '&amp;#xB2;')"/>
        <xsl:variable name="convertSuperscript3"    select="replace($convertSuperscript2,    '&lt;hi rend=&quot;sup&quot;&gt;3&lt;/hi&gt;',              '&amp;#xB3;')"/>
        <xsl:variable name="convertSuperscript4"    select="replace($convertSuperscript3,    '&lt;hi rend=&quot;sup&quot;&gt;4&lt;/hi&gt;',              '&amp;#x2074;')"/>
        <xsl:variable name="moveWhitespace"         select="replace($convertSuperscript4,    '\s+&lt;/hi&gt;',                                           '&lt;/hi&gt; ')"/>
        <xsl:variable name="removePlain"            select="replace($moveWhitespace,         '\\plain ?',                                                '')"/>
        <xsl:variable name="removeFormattingRest"   select="replace($removePlain,            '&lt;lb/&gt;\\(i|scaps)&lt;lb/&gt;',                        '&lt;lb/&gt;&lt;lb/&gt;')"/>
        <xsl:variable name="removeEndBrackets"      select="replace($removeFormattingRest,   '\}',                                                       '')"/>
        <xsl:variable name="reconvertApos"          select="replace($removeEndBrackets,      '\^',                                                       $replace)"/>
        <xsl:variable name="removeRTFRest"          select="replace($reconvertApos,          '\\(i|caps|scaps|tab|par)',                                 '')"/>
        <xsl:variable name="wrapLinks"              select="replace($removeRTFRest,          ' http(s)?://([\p{L}\d/=\?\#\.:\-]+)([\) ,;])',             ' &lt;ref target=&quot;http$1://$2&quot;&gt;http$1://$2&lt;/ref&gt;$3', 'i;j')"/>
        <xsl:variable name="removeDotFromTarget"    select="replace($wrapLinks,              '&lt;ref target=&quot;(.*?)\.&quot;&gt;',                   '&lt;ref target=&quot;$1&quot;&gt;', 'i;j')"/>
        <xsl:variable name="moveDotFromRef"         select="replace($removeDotFromTarget,    '\.&lt;/ref&gt;',                                           '&lt;/ref&gt;.', 'i;j')"/>
        <xsl:value-of select="normalize-space($moveDotFromRef)" disable-output-escaping="yes"/>
    </xsl:template>

    <xsl:template name="publicationStmt">
        <xsl:element name="publicationStmt" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="publisher" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="type">org</xsl:attribute>
                    <xsl:text>Handschriftenportal</xsl:text>
                </xsl:element>
            </xsl:element>
            <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type">primary</xsl:attribute>
                <xsl:attribute name="when">
                    <xsl:choose>
                        <xsl:when test="h1:Field[ @Type = '9951norm'][ @Value = 'Überarbeitung'][h1:Field[ @Type = '9953norm'][contains(@Value, '–')]]">
                            <xsl:value-of select="h1:Field[ @Type = '9951norm'][ @Value = 'Überarbeitung'][1]/h1:Field[ @Type = '9953norm']/substring-before(@Value, '–')"/>
                        </xsl:when>
                        <xsl:when test="h1:Field[ @Type = '9951norm'][ @Value = 'Überarbeitung'][h1:Field[ @Type = '9953norm'][contains(@Value, '-')]]">
                            <xsl:value-of select="h1:Field[ @Type = '9951norm'][ @Value = 'Überarbeitung'][1]/h1:Field[ @Type = '9953norm']/substring-before(@Value, '-')"/>
                        </xsl:when>
                        <xsl:when test="h1:Field[ @Type = '9951norm'][ @Value = 'Überarbeitung'][h1:Field[ @Type = '9953norm'][contains(@Value, '/')]]">
                            <xsl:value-of select="h1:Field[ @Type = '9951norm'][ @Value = 'Überarbeitung'][1]/h1:Field[ @Type = '9953norm']/substring-after(@Value, '/')"/>
                        </xsl:when>
                        <xsl:when test="h1:Field[ @Type = '9951norm'][ @Value = 'Überarbeitung'][h1:Field[ @Type = '9953norm'][contains(@Value, 'er Jahre')]]">
                            <xsl:value-of select="h1:Field[ @Type = '9951norm'][ @Value = 'Überarbeitung'][1]/h1:Field[ @Type = '9953norm']/substring-before(@Value, 'er Jahre')"/>
                        </xsl:when>
                        <xsl:when test="h1:Field[ @Type = '9951norm'][ @Value = 'Überarbeitung'][h1:Field[ @Type = '9953norm']]">
                            <xsl:value-of select="h1:Field[ @Type = '9951norm'][ @Value = 'Überarbeitung'][1]/h1:Field[ @Type = '9953norm']/@Value"/>
                        </xsl:when>
                        <xsl:when test="h1:Field[ @Type = '9951norm'][ @Value = 'Beschreibung'][h1:Field[ @Type = '9953norm'][contains(@Value, '–')]]">
                            <xsl:value-of select="h1:Field[ @Type = '9951norm'][ @Value = 'Beschreibung'][1]/h1:Field[ @Type = '9953norm']/substring-before(@Value, '–')"/>
                        </xsl:when>
                        <xsl:when test="h1:Field[ @Type = '9951norm'][ @Value = 'Beschreibung'][h1:Field[ @Type = '9953norm'][contains(@Value, '-')]]">
                            <xsl:value-of select="h1:Field[ @Type = '9951norm'][ @Value = 'Beschreibung'][1]/h1:Field[ @Type = '9953norm']/substring-before(@Value, '-')"/>
                        </xsl:when>
                        <xsl:when test="h1:Field[ @Type = '9951norm'][ @Value = 'Beschreibung'][h1:Field[ @Type = '9953norm'][contains(@Value, '/')]]">
                            <xsl:value-of select="h1:Field[ @Type = '9951norm'][ @Value = 'Beschreibung'][1]/h1:Field[ @Type = '9953norm']/substring-after(@Value, '/')"/>
                        </xsl:when>
                        <xsl:when test="h1:Field[ @Type = '9951norm'][ @Value = 'Beschreibung'][h1:Field[ @Type = '9953norm'][contains(@Value, 'er Jahre')]]">
                            <xsl:value-of select="h1:Field[ @Type = '9951norm'][ @Value = 'Beschreibung'][1]/h1:Field[ @Type = '9953norm']/substring-before(@Value, 'er Jahre')"/>
                        </xsl:when>
                        <xsl:when test="h1:Field[ @Type = '9951norm'][ @Value = 'Beschreibung'][h1:Field[ @Type = '9953norm']]">
                            <xsl:value-of select="h1:Field[ @Type = '9951norm'][ @Value = 'Beschreibung'][1]/h1:Field[ @Type = '9953norm']/@Value"/>
                        </xsl:when>
                        <xsl:when test="h1:Field[ @Type = '599a' ][ normalize-space(@Value) = 'BESCHREIBUNGSJAHR' ]">
                            <xsl:value-of select="h1:Field[ @Type = '599a' ][ normalize-space(@Value) = 'BESCHREIBUNGSJAHR' ][1]/h1:Field[ @Type = '599e' ]/@Value"/>
                        </xsl:when>
                        <xsl:otherwise><xsl:value-of select="substring(@CreationDate, 7, 4)"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="h1:Field[ @Type = '9951norm'][ @Value = 'Überarbeitung'][h1:Field[ @Type = '9953norm']]">
                        <xsl:value-of select="h1:Field[ @Type = '9951norm'][ @Value = 'Überarbeitung'][1]/h1:Field[ @Type = '9953norm']/@Value"/>
                    </xsl:when>
                    <xsl:when test="h1:Field[ @Type = '9951norm'][ @Value = 'Beschreibung'][h1:Field[ @Type = '9953norm']]">
                        <xsl:value-of select="h1:Field[ @Type = '9951norm'][ @Value = 'Beschreibung'][1]/h1:Field[ @Type = '9953norm']/@Value"/>
                    </xsl:when>
                    <xsl:when test="h1:Field[ @Type = '599a' ][ normalize-space(@Value) = 'BESCHREIBUNGSJAHR' ]">
                        <xsl:value-of select="h1:Field[ @Type = '599a' ][ normalize-space(@Value) = 'BESCHREIBUNGSJAHR' ][1]/h1:Field[ @Type = '599e' ]/@Value"/>
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of select="substring(@CreationDate, 7, 4)"/></xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:element name="availability" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="status" select=" 'restricted' "/>
                <xsl:element name="licence" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="target">
                        <xsl:choose>
                            <xsl:when test="h1:Field[ @Type = '9951norm'][ @Value = 'Beschreibung'][
                                   h1:Field[ @Type = '9952norm' ][ @Value = 'Alfred Holder']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Arthur Zacharias Schwarz']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Benedikt Gottwald']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Eduard Ippel']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Emil Jacobs']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Friedrich Keinz']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Friedrich Leitschuh']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Georg Laubmann']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Georg Thomas']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Gottfried Kentenich']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Gottfried Zedler']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Gustav Flügel']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Gustav Milchsack']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Hans Fischer']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Hermann Degering']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Jakob Marx']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Johann Andreas Schmeller']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Johann Conrad Irmischer']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Johann Nepomuk Cosmas Michael Denis']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Karl August Barack']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Karl Bartsch']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Karl Halm']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Leopold Cohn']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Max Keuffer']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Otto Stählin']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Otto von Heinemann']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Paul Buberl']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Rudolf Helssig']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Wilhelm Meyer']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Wilhelm Schum']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Wilhelm Studemund']
                                ] and not(h1:Field[ @Type = '9951norm'][ @Value = 'Überarbeitung'])">
                                <xsl:text>https://creativecommons.org/publicdomain/mark/1.0/</xsl:text>
                            </xsl:when>
                            <xsl:otherwise><xsl:value-of select="$availabilityLicence"/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:choose>
                            <xsl:when test="h1:Field[ @Type = '9951norm'][ @Value = 'Beschreibung'][
                                   h1:Field[ @Type = '9952norm' ][ @Value = 'Alfred Holder']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Arthur Zacharias Schwarz']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Benedikt Gottwald']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Eduard Ippel']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Emil Jacobs']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Friedrich Keinz']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Friedrich Leitschuh']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Georg Laubmann']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Georg Thomas']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Gottfried Kentenich']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Gottfried Zedler']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Gustav Flügel']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Gustav Milchsack']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Hans Fischer']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Hermann Degering']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Jakob Marx']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Johann Andreas Schmeller']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Johann Conrad Irmischer']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Johann Nepomuk Cosmas Michael Denis']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Karl August Barack']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Karl Bartsch']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Karl Halm']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Leopold Cohn']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Max Keuffer']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Otto Stählin']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Otto von Heinemann']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Paul Buberl']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Rudolf Helssig']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Wilhelm Meyer']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Wilhelm Schum']
                                or h1:Field[ @Type = '9952norm' ][ @Value = 'Wilhelm Studemund']
                                ] and not(h1:Field[ @Type = '9951norm'][ @Value = 'Überarbeitung'])">
                                <xsl:text>https://creativecommons.org/publicdomain/mark/1.0/</xsl:text>
                            </xsl:when>
                            <xsl:otherwise><xsl:value-of select="$availabilityLicence"/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:if test="h1:Field[ @Type = '1903' ]">
                <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="type" select=" 'hsk' "/>
                    <xsl:value-of select="h1:Field[ @Type = '1903' ]/@Value"/>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template name="titleStmt">
        <xsl:element name="titleStmt" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:text>Beschreibung von </xsl:text>
                <xsl:value-of select="normalize-space(h1:Field[ @Type = 'bezsoz' ][ normalize-space(@Value) = 'Verwaltung' ]/h1:Field[ @Type = '4564' ]/@Value)"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="normalize-space(h1:Field[ @Type = 'bezsoz' ][ normalize-space(@Value) = 'Verwaltung' ]/h1:Field[ @Type = '4600' ]/@Value)"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="normalize-space(h1:Field[ @Type = 'bezsoz' ][ normalize-space(@Value) = 'Verwaltung' ]/h1:Field[ @Type = '4650' ]/@Value)"/>
                <xsl:choose>
                    <xsl:when test="h1:Field[ @Type = '8265' ]">
                        <xsl:value-of select="concat(' (', h1:Field[ @Type = '8265' ]/@Value, ')')"/>
                    </xsl:when>
                    <xsl:when test="h1:Field[ @Type = '1903' ]">
                        <xsl:value-of select="concat(' (', h1:Field[ @Type = '1903' ]/@Value, ')')"/>
                    </xsl:when>
                    <xsl:when test="h1:Field[ @Type = '9904' ]">
                        <xsl:value-of select="concat(' (', h1:Field[ @Type = '9904' ]/@Value, ')')"/>
                    </xsl:when>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="h1:Field[ @Type = '8440norm' ][h1:Field]">
                        <xsl:text>S. </xsl:text>
                        <xsl:for-each select="h1:Field[ @Type = '8440norm' ][h1:Field]">
                            <xsl:if test="preceding-sibling::h1:Field[ @Type = '8440norm' ][h1:Field]"><xsl:text>&#x2013;</xsl:text></xsl:if>
                            <xsl:value-of select="h1:Field[ @Type = '8441norm' ]/@Value"/>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:element>
            <xsl:if test="h1:Field[@Type='9951norm'][@Value='Beschreibung']/h1:Field[@Type='9952norm'] or h1:Field[@Type='9904']">
                <xsl:element name="respStmt" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="resp" namespace="http://www.tei-c.org/ns/1.0">Beschrieben von</xsl:element>
                    <xsl:choose>
                        <xsl:when test="h1:Field[@Type='9951norm'][@Value='Beschreibung'][2][h1:Field[@Type='9952norm']]
                            or h1:Field[@Type='9951norm'][@Value='Beschreibung'][h1:Field[@Type='9952norm'][2]]">
                            <xsl:for-each select="h1:Field[@Type='9951norm'][@Value='Beschreibung']/h1:Field[@Type='9952norm']">
                                <xsl:choose>
                                    <xsl:when test="contains(@Value, '/')">
                                        <xsl:for-each select="tokenize(@Value, '/')">
                                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="role" select=" 'author' "/>
                                                <xsl:call-template name="writeCatAuthorRef">
                                                    <xsl:with-param name="value" select="normalize-space(.)"/>
                                                </xsl:call-template>
                                                <!--<xsl:value-of select="normalize-space(.)"/>-->
                                            </xsl:element>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:when test="contains(@Value, ',')">
                                        <xsl:for-each select="tokenize(@Value, ',')">
                                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="role" select=" 'author' "/>
                                                <xsl:call-template name="writeCatAuthorRef">
                                                    <xsl:with-param name="value" select="normalize-space(.)"/>
                                                </xsl:call-template>
                                                <!--<xsl:value-of select="normalize-space(.)"/>-->
                                            </xsl:element>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                            <xsl:attribute name="role" select=" 'author' "/>
                                            <xsl:call-template name="writeCatAuthorRef">
                                                <xsl:with-param name="value" select="normalize-space(@Value)"/>
                                            </xsl:call-template>
                                            <!--<xsl:value-of select="normalize-space(@Value)"/>-->
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="contains(h1:Field[@Type='9951norm'][@Value='Beschreibung']/h1:Field[@Type='9952norm']/@Value, '/')">
                            <xsl:for-each select="tokenize(h1:Field[@Type='9951norm'][@Value='Beschreibung']/h1:Field[@Type='9952norm']/@Value, '/')">
                                <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="role" select=" 'author' "/>
                                    <xsl:call-template name="writeCatAuthorRef">
                                        <xsl:with-param name="value" select="normalize-space(.)"/>
                                    </xsl:call-template>
                                    <!--<xsl:value-of select="normalize-space(.)"/>-->
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="contains(h1:Field[@Type='9951norm'][@Value='Beschreibung']/h1:Field[@Type='9952norm']/@Value, ',')">
                            <xsl:for-each select="tokenize(h1:Field[@Type='9951norm'][@Value='Beschreibung']/h1:Field[@Type='9952norm']/@Value, ',')">
                                <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="role" select=" 'author' "/>
                                    <xsl:call-template name="writeCatAuthorRef">
                                        <xsl:with-param name="value" select="normalize-space(.)"/>
                                    </xsl:call-template>
                                    <!--<xsl:value-of select="normalize-space(.)"/>-->
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="h1:Field[@Type='9951norm'][@Value='Beschreibung']/h1:Field[@Type='9952norm']">
                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="role" select=" 'author' "/>
                                <xsl:call-template name="writeCatAuthorRef">
                                    <xsl:with-param name="value" select="normalize-space(h1:Field[@Type='9951norm'][@Value='Beschreibung']/h1:Field[@Type='9952norm']/@Value)"/>
                                </xsl:call-template>
                                <!--<xsl:value-of select="h1:Field[@Type='9951norm'][@Value='Beschreibung']/h1:Field[@Type='9952norm']/@Value"/>-->
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="contains(h1:Field[@Type='9904']/@Value, ' &amp; ')">
                            <xsl:for-each select="tokenize(h1:Field[@Type='9904']/@Value, ' &amp; ')">
                                <xsl:choose>
                                    <xsl:when test="contains(., '(Beschreibung)')">
                                        <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                            <xsl:attribute name="role" select=" 'author' "/>
                                            <xsl:call-template name="writeCatAuthorRef">
                                                <xsl:with-param name="value" select="normalize-space(substring-before(., '(Beschreibung)'))"/>
                                            </xsl:call-template>
                                            <!--<xsl:value-of select="normalize-space(substring-before(., '(Beschreibung)'))"/>-->
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains(., '(')"/>
                                    <xsl:otherwise>
                                        <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                            <xsl:attribute name="role" select=" 'author' "/>
                                            <xsl:call-template name="writeCatAuthorRef">
                                                <xsl:with-param name="value" select="normalize-space(.)"/>
                                            </xsl:call-template>
                                            <!--<xsl:value-of select="normalize-space(.)"/>-->
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="contains(h1:Field[@Type='9904']/@Value, ' unter Mitarbeit von')">
                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="role" select=" 'author' "/>
                                <xsl:call-template name="writeCatAuthorRef">
                                    <xsl:with-param name="value" select="normalize-space(substring-before(h1:Field[@Type='9904']/@Value, ' unter Mitarbeit von'))"/>
                                </xsl:call-template>
                                <!--<xsl:value-of select="normalize-space(substring-before(h1:Field[@Type='9904']/@Value, ' unter Mitarbeit von'))"/>-->
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="contains(h1:Field[@Type='9904']/@Value, '(Beschreibung)')">
                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="role" select=" 'author' "/>
                                <xsl:call-template name="writeCatAuthorRef">
                                    <xsl:with-param name="value" select="normalize-space(substring-before(h1:Field[@Type='9904']/@Value, '(Beschreibung)'))"/>
                                </xsl:call-template>
                                <!--<xsl:value-of select="normalize-space(substring-before(h1:Field[@Type='9904']/@Value, '(Beschreibung)'))"/>-->
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="contains(h1:Field[@Type='9904']/@Value, '(')">
                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="role" select=" 'author' "/>
                                <xsl:call-template name="writeCatAuthorRef">
                                    <xsl:with-param name="value" select="normalize-space(substring-before(h1:Field[@Type='9904']/@Value, '('))"/>
                                </xsl:call-template>
                                <!--<xsl:value-of select="normalize-space(substring-before(h1:Field[@Type='9904']/@Value, '('))"/>-->
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="h1:Field[@Type='9904']">
                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="role" select=" 'author' "/>
                                <xsl:call-template name="writeCatAuthorRef">
                                    <xsl:with-param name="value" select="h1:Field[@Type='9904']/@Value"/>
                                </xsl:call-template>
                                <!--<xsl:value-of select="h1:Field[@Type='9904']/@Value"/>-->
                            </xsl:element>
                        </xsl:when>
                    </xsl:choose>
                    <!--
                    <xsl:if test="h1:Field[@Type='9951norm'][@Value='Bearbeitung']/h1:Field[@Type='9953norm']">
                        <xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:value-of select="h1:Field[@Type='9951norm'][@Value='Bearbeitung']/h1:Field[@Type='9953norm']/@Value"/>
                        </xsl:element>
                    </xsl:if>
                    -->
                </xsl:element>
            </xsl:if>
            <xsl:if test="h1:Field[@Type='9951norm'][@Value='Überarbeitung']/h1:Field[@Type='9952norm']">
                <xsl:element name="respStmt" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="resp" namespace="http://www.tei-c.org/ns/1.0">Überarbeitet von</xsl:element>
                    <xsl:choose>
                        <xsl:when test="h1:Field[@Type='9951norm'][@Value='Überarbeitung'][2]">
                            <xsl:for-each select="h1:Field[@Type='9951norm'][@Value='Überarbeitung']">
                                <xsl:choose>
                                    <xsl:when test="contains(h1:Field[@Type='9952norm']/@Value, '/')">
                                        <xsl:for-each select="tokenize(h1:Field[@Type='9952norm']/@Value, '/')">
                                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="role" select=" 'author' "/>
                                                <xsl:call-template name="writeCatAuthorRef">
                                                    <xsl:with-param name="value" select="normalize-space(.)"/>
                                                </xsl:call-template>
                                                <!--<xsl:value-of select="normalize-space(.)"/>-->
                                            </xsl:element>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:when test="contains(h1:Field[@Type='9952norm']/@Value, ',')">
                                        <xsl:for-each select="tokenize(h1:Field[@Type='9952norm']/@Value, ',')">
                                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="role" select=" 'author' "/>
                                                <xsl:call-template name="writeCatAuthorRef">
                                                    <xsl:with-param name="value" select="normalize-space(.)"/>
                                                </xsl:call-template>
                                                <!--<xsl:value-of select="normalize-space(.)"/>-->
                                            </xsl:element>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                            <xsl:attribute name="role" select=" 'author' "/>
                                            <xsl:call-template name="writeCatAuthorRef">
                                                <xsl:with-param name="value" select="h1:Field[@Type='9952norm']/@Value"/>
                                            </xsl:call-template>
                                            <!--<xsl:value-of select="h1:Field[@Type='9952norm']/@Value"/>-->
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="h1:Field[@Type='9951norm'][@Value='Überarbeitung'][h1:Field[@Type='9952norm'][2]]">
                            <xsl:for-each select="h1:Field[@Type='9951norm'][@Value='Überarbeitung']/h1:Field[@Type='9952norm']">
                                <xsl:choose>
                                    <xsl:when test="contains(@Value, '/')">
                                        <xsl:for-each select="tokenize(@Value, '/')">
                                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="role" select=" 'author' "/>
                                                <xsl:call-template name="writeCatAuthorRef">
                                                    <xsl:with-param name="value" select="normalize-space(.)"/>
                                                </xsl:call-template>
                                                <!--<xsl:value-of select="normalize-space(.)"/>-->
                                            </xsl:element>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:when test="contains(@Value, ',')">
                                        <xsl:for-each select="tokenize(@Value, ',')">
                                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="role" select=" 'author' "/>
                                                <xsl:call-template name="writeCatAuthorRef">
                                                    <xsl:with-param name="value" select="normalize-space(.)"/>
                                                </xsl:call-template>
                                                <!--<xsl:value-of select="normalize-space(.)"/>-->
                                            </xsl:element>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                            <xsl:attribute name="role" select=" 'author' "/>
                                            <xsl:call-template name="writeCatAuthorRef">
                                                <xsl:with-param name="value" select="normalize-space(@Value)"/>
                                            </xsl:call-template>
                                            <!--<xsl:value-of select="normalize-space(@Value)"/>-->
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="contains(h1:Field[@Type='9951norm'][@Value='Überarbeitung']/h1:Field[@Type='9952norm']/@Value, '/')">
                            <xsl:for-each select="tokenize(h1:Field[@Type='9951norm'][@Value='Überarbeitung']/h1:Field[@Type='9952norm']/@Value, '/')">
                                <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="role" select=" 'author' "/>
                                    <xsl:call-template name="writeCatAuthorRef">
                                        <xsl:with-param name="value" select="normalize-space(.)"/>
                                    </xsl:call-template>
                                    <!--<xsl:value-of select="normalize-space(.)"/>-->
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="contains(h1:Field[@Type='9951norm'][@Value='Überarbeitung']/h1:Field[@Type='9952norm']/@Value, ',')">
                            <xsl:for-each select="tokenize(h1:Field[@Type='9951norm'][@Value='Überarbeitung']/h1:Field[@Type='9952norm']/@Value, ',')">
                                <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="role" select=" 'author' "/>
                                    <xsl:call-template name="writeCatAuthorRef">
                                        <xsl:with-param name="value" select="normalize-space(.)"/>
                                    </xsl:call-template>
                                    <!--<xsl:value-of select="normalize-space(.)"/>-->
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="h1:Field[@Type='9951norm'][@Value='Überarbeitung']/h1:Field[@Type='9952norm']">
                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="role" select=" 'author' "/>
                                <xsl:call-template name="writeCatAuthorRef">
                                    <xsl:with-param name="value" select="h1:Field[@Type='9951norm'][@Value='Überarbeitung']/h1:Field[@Type='9952norm']/@Value"/>
                                </xsl:call-template>
                                <!--<xsl:value-of select="h1:Field[@Type='9951norm'][@Value='Überarbeitung']/h1:Field[@Type='9952norm']/@Value"/>-->
                            </xsl:element>
                        </xsl:when>
                    </xsl:choose>
                    <!--
                    <xsl:if test="h1:Field[@Type='9951norm'][@Value='Bearbeitung']/h1:Field[@Type='9953norm']">
                        <xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:value-of select="h1:Field[@Type='9951norm'][@Value='Bearbeitung']/h1:Field[@Type='9953norm']/@Value"/>
                        </xsl:element>
                    </xsl:if>
                    -->
                </xsl:element>
            </xsl:if>
            <xsl:if test="h1:Field[@Type='9951norm'][@Value='Bearbeitung']/h1:Field[@Type='9954norm']">
                <xsl:element name="respStmt" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="resp" namespace="http://www.tei-c.org/ns/1.0">Erfasst von</xsl:element>
                    <xsl:choose>
                        <xsl:when test="contains(h1:Field[@Type='9951norm'][@Value='Bearbeitung']/h1:Field[@Type='9954norm']/@Value, '/')">
                            <xsl:for-each select="tokenize(h1:Field[@Type='9951norm'][@Value='Bearbeitung']/h1:Field[@Type='9954norm']/@Value, '/')">
                                <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="role" select=" 'editor' "/>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="contains(h1:Field[@Type='9951norm'][@Value='Bearbeitung']/h1:Field[@Type='9954norm']/@Value, ',')">
                            <xsl:for-each select="tokenize(h1:Field[@Type='9951norm'][@Value='Bearbeitung']/h1:Field[@Type='9954norm']/@Value, ',')">
                                <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="role" select=" 'editor' "/>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="h1:Field[@Type='9951norm'][@Value='Bearbeitung']/h1:Field[@Type='9954norm']">
                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="role" select=" 'editor' "/>
                                <xsl:value-of select="h1:Field[@Type='9951norm'][@Value='Bearbeitung']/h1:Field[@Type='9954norm']/@Value"/>
                            </xsl:element>
                        </xsl:when>
                    </xsl:choose>
                    <!--
                    <xsl:if test="h1:Field[@Type='9951norm'][@Value='Bearbeitung']/h1:Field[@Type='9953norm']">
                        <xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:value-of select="h1:Field[@Type='9951norm'][@Value='Bearbeitung']/h1:Field[@Type='9953norm']/@Value"/>
                        </xsl:element>
                    </xsl:if>
                    -->
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template name="writeRole">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '&amp;')">
                <xsl:call-template name="writeRole">
                    <xsl:with-param name="value" select="normalize-space(substring-before($value, '&amp;'))"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:call-template name="writeRole">
                    <xsl:with-param name="value" select="normalize-space(substring-after($value, '&amp;'))"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains($value, 'Auftraggeber')"><xsl:text>commissionedBy</xsl:text></xsl:when>
            <xsl:when test="contains($value, 'Autor')
                         or contains($value, 'Autorschaft')"><xsl:text>author</xsl:text></xsl:when>
            <xsl:when test="contains($value, 'Buchbinder')"><xsl:text>bookbinder</xsl:text></xsl:when>
            <xsl:when test="contains($value, 'Schreiber')"><xsl:text>scribe</xsl:text></xsl:when>
            <xsl:when test="contains($value, 'Vertragspartner')"><xsl:text>signatory</xsl:text></xsl:when>
            <xsl:when test="contains($value, 'Vorbesitzer')"><xsl:text>previousOwner</xsl:text></xsl:when>
            <xsl:when test="contains($value, 'Zeichner')"><xsl:text>drawer</xsl:text></xsl:when>
            <xsl:otherwise><xsl:value-of select="$value"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="writeNormalisedDate">
        <xsl:choose>
            <!-- Jh. -->
            <xsl:when test=" (normalize-space(@Value) = '0601/0700') ">7. Jh.</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0701/0800') ">8. Jh.</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0801/0900') ">9. Jh.</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0901/1000') ">10. Jh.</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1001/1100') ">11. Jh.</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1101/1200') ">12. Jh.</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1201/1300') ">13. Jh.</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1301/1400') ">14. Jh.</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1401/1500') ">15. Jh.</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1501/1600') ">16. Jh.</xsl:when>
            <!-- Jh., 1. Hälfte -->
            <xsl:when test=" (normalize-space(@Value) = '0601/0650') ">7. Jh., 1. Hälfte</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0701/0750') ">8. Jh., 1. Hälfte</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0801/0850') ">9. Jh., 1. Hälfte</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0901/0950') ">10. Jh., 1. Hälfte</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1001/1050') ">11. Jh., 1. Hälfte</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1101/1150') ">12. Jh., 1. Hälfte</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1201/1250') ">13. Jh., 1. Hälfte</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1301/1350') ">14. Jh., 1. Hälfte</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1401/1450') ">15. Jh., 1. Hälfte</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1501/1550') ">16. Jh., 1. Hälfte</xsl:when>
            <!-- Jh., 2. Hälfte -->
            <xsl:when test=" (normalize-space(@Value) = '0651/0700') ">7. Jh., 2. Hälfte</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0751/0800') ">8. Jh., 2. Hälfte</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0851/0900') ">9. Jh., 2. Hälfte</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0951/1000') ">10. Jh., 2. Hälfte</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1051/1100') ">11. Jh., 2. Hälfte</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1151/1200') ">12. Jh., 2. Hälfte</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1251/1300') ">13. Jh., 2. Hälfte</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1351/1400') ">14. Jh., 2. Hälfte</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1451/1500') ">15. Jh., 2. Hälfte</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1551/1600') ">16. Jh., 2. Hälfte</xsl:when>
            <!-- Jh., 1. Drittel -->
            <xsl:when test=" (normalize-space(@Value) = '0601/0633') ">7. Jh., 1. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0701/0733') ">8. Jh., 1. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0801/0833') ">9. Jh., 1. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0901/0933') ">10. Jh., 1. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1001/1033') ">11. Jh., 1. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1101/1133') ">12. Jh., 1. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1201/1233') ">13. Jh., 1. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1301/1333') ">14. Jh., 1. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1401/1433') ">15. Jh., 1. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1501/1533') ">16. Jh., 1. Drittel</xsl:when>
            <!-- Jh., 2. Drittel -->
            <xsl:when test=" (normalize-space(@Value) = '0634/0666') ">7. Jh., 2. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0734/0766') ">8. Jh., 2. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0834/0866') ">9. Jh., 2. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0934/0966') ">10. Jh., 2. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1034/1066') ">11. Jh., 2. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1134/1166') ">12. Jh., 2. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1234/1266') ">13. Jh., 2. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1334/1366') ">14. Jh., 2. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1434/1466') ">15. Jh., 2. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1534/1566') ">16. Jh., 2. Drittel</xsl:when>
            <!-- Jh., 3. Drittel -->
            <xsl:when test=" (normalize-space(@Value) = '0667/0700') ">7. Jh., 3. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0767/0800') ">8. Jh., 3. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0867/0900') ">9. Jh., 3. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0967/1000') ">10. Jh., 3. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1067/1100') ">11. Jh., 3. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1167/1200') ">12. Jh., 3. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1267/1300') ">13. Jh., 3. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1367/1400') ">14. Jh., 3. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1467/1500') ">15. Jh., 3. Drittel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1567/1600') ">16. Jh., 3. Drittel</xsl:when>
            <!-- Jh., 1. Viertel -->
            <xsl:when test=" (normalize-space(@Value) = '0601/0625') ">7. Jh., 1. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0701/0725') ">8. Jh., 1. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0801/0825') ">9. Jh., 1. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0901/0925') ">10. Jh., 1. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1001/1025') ">11. Jh., 1. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1101/1125') ">12. Jh., 1. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1201/1225') ">13. Jh., 1. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1301/1325') ">14. Jh., 1. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1401/1425') ">15. Jh., 1. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1501/1525') ">16. Jh., 1. Viertel</xsl:when>
            <!-- Jh., 2. Viertel -->
            <xsl:when test=" (normalize-space(@Value) = '0626/0650') ">7. Jh., 2. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0726/0750') ">8. Jh., 2. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0826/0850') ">9. Jh., 2. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0926/0950') ">10. Jh., 2. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1026/1050') ">11. Jh., 2. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1126/1150') ">12. Jh., 2. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1226/1250') ">13. Jh., 2. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1326/1350') ">14. Jh., 2. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1426/1450') ">15. Jh., 2. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1526/1550') ">16. Jh., 2. Viertel</xsl:when>
            <!-- Jh., 3. Viertel -->
            <xsl:when test=" (normalize-space(@Value) = '0651/0775') ">7. Jh., 3. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0751/0875') ">8. Jh., 3. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0851/0975') ">9. Jh., 3. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0951/1075') ">10. Jh., 3. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1051/1175') ">11. Jh., 3. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1151/1275') ">12. Jh., 3. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1251/1375') ">13. Jh., 3. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1351/1475') ">14. Jh., 3. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1451/1575') ">15. Jh., 3. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1551/1675') ">16. Jh., 3. Viertel</xsl:when>
            <!-- Jh., 4. Viertel -->
            <xsl:when test=" (normalize-space(@Value) = '0676/0700') ">7. Jh., 4. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0776/0800') ">8. Jh., 4. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0876/0900') ">9. Jh., 4. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '0976/1000') ">10. Jh., 4. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1076/1100') ">11. Jh., 4. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1176/1200') ">12. Jh., 4. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1276/1300') ">13. Jh., 4. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1376/1400') ">14. Jh., 4. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1476/1500') ">15. Jh., 4. Viertel</xsl:when>
            <xsl:when test=" (normalize-space(@Value) = '1576/1600') ">16. Jh., 4. Viertel</xsl:when>
            <xsl:otherwise><xsl:value-of select="normalize-space(@Value)"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="writeIconClass">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains(substring-after($value, '(+'), '+')">
                <xsl:for-each select="tokenize(substring-before(substring-after($value, '(+'), ')'), '\+')">
                    <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="target">
                            <xsl:text>https://iconclass.org/de/</xsl:text>
                            <xsl:if test="$mode = 'test' ">a/</xsl:if>
                            <xsl:value-of select="replace(translate(substring-before($value, '(+'), '&lt;&gt;[]?, ', ''), '\+', '%2B')"/>
                            <xsl:value-of select="concat('(%2B', translate(., '&lt;&gt;[]?, ', ''), ')')"/>
                        </xsl:attribute>
                        <xsl:value-of select="normalize-space($value)"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($value, '(')">
                <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="target">
                        <xsl:text>https://iconclass.org/de/</xsl:text>
                        <xsl:if test="$mode = 'test' ">b/</xsl:if>
                        <xsl:value-of select="translate(substring-before($value, '('), ' ', '')"/>
                        <xsl:text>(</xsl:text>
                        <xsl:value-of select="replace(translate(substring-after($value, '('), '&lt;&gt;[]?,', ''), '\+', '%2B')"/>
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space($value)"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="target">
                        <xsl:if test="$mode = 'test' ">c/</xsl:if>
                        <xsl:text>https://iconclass.org/de/</xsl:text>
                        <xsl:value-of select="replace(translate($value, '&lt;&gt;[]?, ', ''), '\+', '%2B')"/>
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space($value)"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="writeIndexFields">
        <xsl:param name="field"/>
        <!-- Restliche Indexfelder etc ablegen -->
        <xsl:if test="
               h1:Field[ @Type = 'bezper' ]
            or h1:Field[ @Type = 'bezsoz' ][ @Value != 'Verwaltung']
            or h1:Field[ @Type = 'bezwrk' ][ h1:Field[ (@Type = '6930') or (@Type = '6930gi') or (@Type = '6922') or (@Type = '6923') ]]
            or h1:Field[ @Type = 'bezlit' ][ @Value = 'Repertoriumseintrag' ]
            or h1:Field[ @Type = '5007' ]
            or h1:Field[ @Type = '5060' ]
            or h1:Field[ @Type = '5200' ]
            or h1:Field[ @Type = '5210' ]
            or h1:Field[ @Type = '5234' ]
            or h1:Field[ @Type = '5240' ]
            or h1:Field[ @Type = '5260' ]
            or h1:Field[ @Type = '5270' ][ @Value != 'vorhanden' ]
            or h1:Field[ @Type = '5360' ]
            or h1:Field[ @Type = '5382' ]
            or h1:Field[ @Type = '5650' ]
            or h1:Field[ @Type = '5500' ]
            or h1:Field[ @Type = '5704' ]
            or h1:Field[ @Type = '5710' ]
            or h1:Field[ @Type = '6560' ]
            or h1:Block[h1:Field[ @Type = '5230' ][contains(@Value, 'Registereintrag')]]
            or h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = 'bezper' ]
            or h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = 'bezsoz' ]
            or h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = 'bezwrk' ]
            or h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = 'bezlit' ][ @Value = 'Repertoriumseintrag' ]
            or h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = '5007' ]
            or h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = '5200' ]
            or h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = '5234' ]
            or h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = '5240' ]
            or h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = '5270' ][ @Value != 'vorhanden' ]
            or h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = '5382' ]
            or h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = '5650' ]
            or h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = '5704' ]
            or h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = '6560' ]
            or (
            self::h1:Field[ @Type = 'par08' ][
               following-sibling::h1:Field[ @Type = 'bezper' ]
            or following-sibling::h1:Field[ @Type = 'bezsoz' ][ @Value != 'Verwaltung']
            or following-sibling::h1:Field[ @Type = 'bezwrk' ]
            or following-sibling::h1:Field[ @Type = 'bezlit' ][ @Value = 'Repertoriumseintrag' ]
            or following-sibling::h1:Field[ @Type = '5007' ]
            or following-sibling::h1:Field[ @Type = '5060' ]
            or following-sibling::h1:Field[ @Type = '5200' ]
            or following-sibling::h1:Field[ @Type = '5210' ]
            or following-sibling::h1:Field[ @Type = '5234' ]
            or following-sibling::h1:Field[ @Type = '5240' ]
            or following-sibling::h1:Field[ @Type = '5260' ]
            or following-sibling::h1:Field[ @Type = '5270' ][ @Value != 'vorhanden' ]
            or following-sibling::h1:Field[ @Type = '5360' ]
            or following-sibling::h1:Field[ @Type = '5382' ]
            or following-sibling::h1:Field[ @Type = '5650' ]
            or following-sibling::h1:Field[ @Type = '5704' ]
            or following-sibling::h1:Field[ @Type = '5710' ]
            or following-sibling::h1:Field[ @Type = '6560' ]
            ]
            )
            ">
            <xsl:choose>
                <xsl:when test="$field = 'index' ">
                    <xsl:apply-templates select="
                          following-sibling::h1:Field[ @Type = 'bezper' ]
                        | following-sibling::h1:Field[ @Type = 'bezsoz' ][ @Value != 'Verwaltung']
                        | following-sibling::h1:Field[ @Type = 'bezwrk' ][ h1:Field[ (@Type = '6930') or (@Type = '6930gi') or (@Type = '6922') or (@Type = '6923') ]]
                        | following-sibling::h1:Field[ @Type = 'bezlit' ][ @Value = 'Repertoriumseintrag' ]
                        | following-sibling::h1:Field[ @Type = '5007' ]
                        | following-sibling::h1:Field[ @Type = '5060' ]
                        | following-sibling::h1:Field[ @Type = '5200' ]
                        | following-sibling::h1:Field[ @Type = '5234' ]
                        | following-sibling::h1:Field[ @Type = '5270' ][ @Value != 'vorhanden' ]
                        | following-sibling::h1:Field[ @Type = '5382' ]
                        | following-sibling::h1:Field[ @Type = '5500' ]
                        | following-sibling::h1:Field[ @Type = '5650' ]
                        | following-sibling::h1:Field[ @Type = '6560' ]
                        " mode="index"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="{$field}" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:choose>
                            <xsl:when test="$field = 'note' ">
                                <xsl:attribute name="type" select=" 'register' "/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="type" select=" 'other' "/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test=" $field = 'msPart' ">
                            <xsl:element name="msIdentifier" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:text>Sonstiges</xsl:text>
                                </xsl:element>
                            </xsl:element>
                        </xsl:if>
                        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:choose>
                                <xsl:when test="self::h1:Field[ @Type = 'par08' ]">
                                    <xsl:apply-templates select="
                                          following-sibling::h1:Field[ @Type = 'bezper' ]
                                        | following-sibling::h1:Field[ @Type = 'bezsoz' ][ @Value != 'Verwaltung']
                                        | following-sibling::h1:Field[ @Type = 'bezwrk' ][ h1:Field[ (@Type = '6930') or (@Type = '6930gi') or (@Type = '6922') or (@Type = '6923') ]]
                                        | following-sibling::h1:Field[ @Type = 'bezlit' ][ @Value = 'Repertoriumseintrag' ]
                                        | following-sibling::h1:Field[ @Type = '5007' ]
                                        | following-sibling::h1:Field[ @Type = '5060' ]
                                        | following-sibling::h1:Field[ @Type = '5200' ]
                                        | following-sibling::h1:Field[ @Type = '5210' ]
                                        | following-sibling::h1:Field[ @Type = '5234' ]
                                        | following-sibling::h1:Field[ @Type = '5260' ]
                                        | following-sibling::h1:Field[ @Type = '5270' ][ @Value != 'vorhanden' ]
                                        | following-sibling::h1:Field[ @Type = '5360' ]
                                        | following-sibling::h1:Field[ @Type = '5382' ]
                                        | following-sibling::h1:Field[ @Type = '5500' ]
                                        | following-sibling::h1:Field[ @Type = '5650' ]
                                        | following-sibling::h1:Field[ @Type = '5704' ]
                                        | following-sibling::h1:Field[ @Type = '5710' ]
                                        | following-sibling::h1:Field[ @Type = '6560' ]
                                        " mode="index"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="
                                          h1:Field[ @Type = 'bezper' ]
                                        | h1:Field[ @Type = 'bezsoz' ][ @Value != 'Verwaltung']
                                        | h1:Field[ @Type = 'bezwrk' ][ h1:Field[ (@Type = '6930') or (@Type = '6930gi') or (@Type = '6922') or (@Type = '6923') ]]
                                        | h1:Field[ @Type = 'bezlit' ][ @Value = 'Repertoriumseintrag' ]
                                        | h1:Field[ @Type = '5007' ]
                                        | h1:Field[ @Type = '5060' ]
                                        | h1:Field[ @Type = '5200' ]
                                        | h1:Field[ @Type = '5210' ]
                                        | h1:Field[ @Type = '5234' ]
                                        | h1:Field[ @Type = '5240' ]
                                        | h1:Field[ @Type = '5260' ]
                                        | h1:Field[ @Type = '5270' ][ @Value != 'vorhanden' ]
                                        | h1:Field[ @Type = '5360' ]
                                        | h1:Field[ @Type = '5382' ]
                                        | h1:Field[ @Type = '5500' ]
                                        | h1:Field[ @Type = '5650' ]
                                        | h1:Field[ @Type = '5704' ]
                                        | h1:Field[ @Type = '5710' ]
                                        | h1:Field[ @Type = '6560' ]
                                        | h1:Block[h1:Field[ @Type = '5230' ][contains(@Value, 'Registereintrag')]]
                                        | h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = 'bezper' ]
                                        | h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = 'bezsoz' ]
                                        | h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = 'bezwrk' ]
                                        | h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = 'bezlit' ][ @Value = 'Repertoriumseintrag' ]
                                        | h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = '5007' ]
                                        | h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = '5200' ]
                                        | h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = '5234' ]
                                        | h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = '5240' ]
                                        | h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = '5270' ][ @Value != 'vorhanden' ]
                                        | h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = '5382' ]
                                        | h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = '5650' ]
                                        | h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = '5704' ]
                                        | h1:Block[(h1:Field[ @Type = 'par09' ][ @Value != '' ] or h1:Field[ @Type = 'par10' ][ @Value != '' ]) and not(h1:Field[ @Type = 'par11' ][ @Value != '' ])]/h1:Field[ @Type = '6560' ]
                                        " mode="index"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template name="writeInitium">
        <xsl:param name="value"/>
        <xsl:param name="replace">&apos;</xsl:param>
        <xsl:param name="replaceBy">^</xsl:param>
        
        <xsl:variable name="removeStar"        select="replace($value,      '^\*\s*', '', 'i;j')"/>
        <xsl:variable name="replaceAmpersands" select="replace($removeStar, '&amp;', '&amp;amp;', 'i;j')"/>
        
        
        <xsl:value-of select="normalize-space(translate($replaceAmpersands, '&lt;&gt;', '[]'))" disable-output-escaping="yes"/>
    </xsl:template>
    <xsl:template name="writeInitiumRef">
        <xsl:choose>
            <xsl:when test=" 
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
                ">
                <xsl:variable name="uuid">
                    <xsl:value-of select="sbbfunc:generate-guid('NORM-', normalize-space(
                        translate(
                        replace(
                        replace(
                        replace(
                        translate(@Value, $toBeReplaced, ''),
                        '\s*\.(\s*\.\s*)+', ' &#x2026; '),
                        '\s*/s*', ' '),
                        '--', '&#x2013;'),
                        '()[]+*‛’‚‘&lt;&gt;-∥&#x2026;', '')
                        ))"/>
                </xsl:variable>
                <xsl:attribute name="ref">
                    <xsl:value-of select="concat('https://normdaten.staatsbibliothek-berlin.de/hsp/initia/', $uuid)"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="
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
                ) and
                not(matches(@Value, '\s*\.[. ]+\s*-?\s*.*?\s*\.[. ]+\s*-?\s*$')) and 
                not(matches(@Value, '\s*&#x2026;\s*.*?\s*&#x2026;\s*$'))
                ">
                <xsl:variable name="uuid">
                    <xsl:value-of select="sbbfunc:generate-guid('NORM-', normalize-space(
                        translate(
                        replace(
                        replace(
                        replace(
                        translate(@Value, $toBeReplaced, ''),
                        '\s*\.(\s*\.\s*)+', ' &#x2026; '),
                        '\s*/s*', ' '),
                        '--', '&#x2013;'),
                        '()[]+*‛’‚‘&lt;&gt;-∥&#x2026;', '')
                        ))"/>
                </xsl:variable>
                <xsl:attribute name="key">
                    <xsl:value-of select="$uuid"/>
                </xsl:attribute>
                <xsl:attribute name="ref">
                    <xsl:value-of select="concat('https://normdaten.staatsbibliothek-berlin.de/hsp/initia/', $uuid)"/>
                </xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="writeLeadingWhitespace">
        <xsl:if test="not(
               preceding::text()[1][ends-with(normalize-space(.), ' ')]
               or preceding::text()[1][ends-with(normalize-space(.), '(')]
               or preceding::text()[1][ends-with(normalize-space(.), '[')]
               or preceding::text()[1][ends-with(normalize-space(.), '›')]
           )">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template name="writeTrailingWhitespace">
        <xsl:if test="not(
               following::text()[1][starts-with(normalize-space(.), ')')]
            or following::text()[1][starts-with(normalize-space(.), ']')]
            or following::text()[1][starts-with(normalize-space(.), ',')]
            or following::text()[1][starts-with(normalize-space(.), ';')]
            or following::text()[1][starts-with(normalize-space(.), '.')]
            or following::text()[1][starts-with(normalize-space(.), ':')]
            or following::text()[1][starts-with(normalize-space(.), '‹')]
            )">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template name="convertGap">
        <xsl:param name="value"/>
        <xsl:value-of select="replace($value, '\. ?\. ?\.', '&#x2026;')"/>
    </xsl:template>
    <xsl:include href="process_Field501k.xsl"/>
    <xsl:include href="../helper/writeLangRef.xsl"/>
    <xsl:include href="../helper/writeCatAuthorRef.xsl"/>
    <xsl:include href="../helper/writeSpecialCharacters.xsl"/>
    <xsl:include href="../helper/writeThesaurusFields.xsl"/>

</xsl:stylesheet>
