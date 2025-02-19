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
                        <xsl:call-template name="head"/>
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
                                <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Text') ]][h1:Field[ @Type = 'par09'] or h1:Field[ @Type = 'par10']]"/>
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
        [not(h1:Field[ @Type = '5210' ][ @Value = 'Fragment' ])]
        [not(h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Text') ]) and not(h1:Field[ @Type = 'par09'] or h1:Field[ @Type = 'par10'])]">
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
            <xsl:call-template name="head"/>
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
            <xsl:call-template name="head"/>
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
            <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Faszikel') ]]"/><!-- and not(h1:Field[ @Type = '5210' ][ @Value = 'Fragment' ]) -->
            <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Beilage') ] and 
                not(h1:Field[ @Type = '5210' ][ @Value = 'Fragment' ])]"/>
            <xsl:call-template name="writeIndexFields">
                <xsl:with-param name="field" select=" 'msPart' "/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Faszikel') ]] | 
                         h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Text') ]][h1:Field[ @Type = 'par09'] or h1:Field[ @Type = 'par10']]"><!--  and not(h1:Field[ @Type = '5210' ][ @Value = 'Fragment' ]) -->
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
                            <xsl:text>Faszikel </xsl:text>
                            <xsl:choose>
                                <xsl:when test="h1:Field[ @Type = 'par11' ][exists(following-sibling::h1:Field[ @Type = '4665' ])][contains(@Value, following-sibling::h1:Field[ @Type = '4665' ])]">
                                    <xsl:if test="$mode = 'test' "><xsl:comment>choose 1</xsl:comment></xsl:if>
                                    <xsl:value-of select="h1:Field[ @Type = '4665' ]/@Value"/>
                                </xsl:when>
                                <xsl:when test="h1:Field[ @Type = 'par11' ][ @Value != '' ][following-sibling::h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Faszikel') ]]">
                                    <xsl:variable name="content">
                                        <xsl:apply-templates select="h1:Field[ @Type = 'par11' ][ @Value != '' ][following-sibling::h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Faszikel') ]]"/>
                                    </xsl:variable>
                                    <xsl:if test="$mode = 'test' "><xsl:comment>choose 2</xsl:comment></xsl:if>
                                    <xsl:value-of select="$content/tei:note"/>
                                </xsl:when>
                                <xsl:when test="h1:Field[ @Type = 'par09' ][exists(following-sibling::h1:Field[ @Type = '4665' ])][contains(@Value, following-sibling::h1:Field[ @Type = '4665' ])]">
                                    <xsl:if test="$mode = 'test' "><xsl:comment>choose 3</xsl:comment></xsl:if>
                                    <xsl:value-of select="h1:Field[ @Type = '4665' ]/@Value"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="$mode = 'test' "><xsl:comment>choose 4</xsl:comment></xsl:if>
                                    <xsl:number count="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Faszikel') ]]" format="I"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:call-template name="head"/>
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
            <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Faszikel') ]]"/><!-- and not(h1:Field[ @Type = '5210' ][ @Value = 'Fragment' ]) -->
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
            <xsl:call-template name="head"/>
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
            | h1:Field[ @Type = 'bezper' ]
            | h1:Field[ @Type = 'bezsoz' ]
            | h1:Field[ @Type = 'bezwrk' ]" mode="index"/>
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
                <xsl:attribute name="xml:lang" select=" 'la' "/>
                <!--<xsl:value-of select="normalize-space(@Value)"/>-->
                <xsl:call-template name="writeInitium">
                    <xsl:with-param name="value" select="@Value"/>
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
                <xsl:attribute name="xml:lang" select=" 'de' "/>
                <xsl:value-of select="normalize-space(@Value)"/>
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
                <xsl:value-of select="normalize-space(@Value)"/>
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
                <xsl:attribute name="xml:lang" select=" 'unk' "/>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
            <xsl:apply-templates select="parent::h1:Block/h1:Field[ @Type = '1950' ]/h1:Field[ @Type = '1961' ]" mode="index"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '1961' ]" mode="index"><!-- GI-Folio-Nr. -->
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="@Type"/>
                <xsl:value-of select="normalize-space(@Value)"/>
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
                <xsl:if test="parent::h1:Field/h1:Field[(@Type = 'z001') or (@Type = '4000')]">
                    <xsl:attribute name="key">
                        <xsl:if test="parent::h1:Field/h1:Field[ @Type = 'z001' ]">
                            <xsl:choose>
                                <xsl:when test="starts-with(parent::h1:Field/h1:Field[ @Type = 'z001' ]/@Value, '300')">
                                    <xsl:text>MXML-</xsl:text>
                                </xsl:when>
                                <xsl:when test="starts-with(parent::h1:Field/h1:Field[ @Type = 'z001' ]/@Value, '118')">
                                    <xsl:text>GND_</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>z001_</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:value-of select="parent::h1:Field/h1:Field[ @Type = 'z001' ]/@Value"/>
                        </xsl:if>
                        <xsl:if test="parent::h1:Field/h1:Field[ @Type = '4000' ]">
                            <xsl:if test="parent::h1:Field/h1:Field[ @Type = 'z001' ]"><xsl:text> </xsl:text></xsl:if>
                            <xsl:value-of select="concat('MXML-', parent::h1:Field/h1:Field[ @Type = '4000' ]/@Value)"/>
                        </xsl:if>
                    </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
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
                <xsl:if test="parent::h1:Field/h1:Field[ @Type = 'z001' ]">
                    <xsl:attribute name="key" select="parent::h1:Field/h1:Field[ @Type = 'z001' ]/@Value"/>
                </xsl:if>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '4590' ]" mode="index"><!-- Sozietätsart --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '4594' ]" mode="index"><!-- Träger --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '4596' ]" mode="index"><!-- Patrozinium --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '4600' ]" mode="Verwaltung"><!-- Sozietätsname -->
        <xsl:element name="repository" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:if test="parent::h1:Field/h1:Field[ @Type = '4500' ]">
                <xsl:attribute name="key">
                    <xsl:value-of select="concat('soz_', parent::h1:Field/h1:Field[ @Type = '4500' ]/@Value)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="parent::h1:Field/h1:Field[ (@Type = '4502norm') or (@Type = '4503norm') ]">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('http://d-nb.info/gnd/', parent::h1:Field/h1:Field[ @Type = '4502norm' ]/@Value)"/>
                        <xsl:if test="parent::h1:Field/h1:Field[ @Type = '4502norm' ] and parent::h1:Field/h1:Field[ @Type = '4503norm' ]">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:if test="parent::h1:Field/h1:Field[ @Type = '4503norm' ]">
                            <xsl:value-of select="concat('https://sigel.staatsbibliothek-berlin.de/suche/?isil=', parent::h1:Field/h1:Field[ @Type = '4503norm' ]/@Value)"/>
                        </xsl:if>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="following-sibling::h1:Field[ @Type = '4998' ][starts-with(@Value, 'GND: ')]">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('http://d-nb.info/gnd/', following-sibling::h1:Field[ @Type = '4998' ]/substring-after(@Value, 'GND: '))"/>
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
                <xsl:if test="parent::h1:Field/h1:Field[(@Type = 'y001') or (@Type = '4500')]">
                    <xsl:attribute name="key">
                        <xsl:if test="parent::h1:Field/h1:Field[ @Type = 'y001' ]">
                            <xsl:choose>
                                <xsl:when test="starts-with(parent::h1:Field/h1:Field[ @Type = 'y001' ]/@Value, '116')
                                             or starts-with(parent::h1:Field/h1:Field[ @Type = 'y001' ]/@Value, '118')">
                                    <xsl:text>GND_</xsl:text>
                                    <xsl:value-of select="parent::h1:Field/h1:Field[ @Type = 'y001' ]/@Value"/>
                                </xsl:when>
                                <xsl:when test="starts-with(parent::h1:Field/h1:Field[ @Type = 'y001' ]/@Value, 'GND: ')">
                                    <xsl:text>GND_</xsl:text>
                                    <xsl:value-of select="substring-after(parent::h1:Field/h1:Field[ @Type = 'y001' ]/@Value, 'GND: ')"/>
                                </xsl:when>
                                <xsl:when test="starts-with(parent::h1:Field/h1:Field[ @Type = 'y001' ]/@Value, '9')">
                                    <xsl:text>MXML-</xsl:text>
                                    <xsl:value-of select="parent::h1:Field/h1:Field[ @Type = 'y001' ]/@Value"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>y001_</xsl:text>
                                    <xsl:value-of select="parent::h1:Field/h1:Field[ @Type = 'y001' ]/@Value"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                        <xsl:if test="parent::h1:Field/h1:Field[ @Type = '4500' ]">
                            <xsl:if test="parent::h1:Field/h1:Field[ @Type = 'y001' ]"><xsl:text> </xsl:text></xsl:if>
                            <xsl:value-of select="concat('MXML-', parent::h1:Field/h1:Field[ @Type = '4500' ]/@Value)"/>
                        </xsl:if>
                    </xsl:attribute>
                </xsl:if>
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
    <xsl:template match="h1:Field[ @Type = '4998' ]" mode="index"><!-- Sozietäts-Komm.* --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
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
                    <xsl:when test="@Value != '' ">
                        <xsl:value-of select="translate(replace(replace(replace(replace(normalize-space(@Value), ' &amp; ', '_'), ' &amp;', ''), ' / ', '-'), '\p{P}', ''), ' \(\)\[\]\?&lt;&gt;=', '-')"/>
                    </xsl:when>
                    <xsl:otherwise>unk</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="h1:Field" mode="index"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '501k' ]" mode="index"><!-- Bez-Verwalter --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '501m' ]" mode="index"><!-- Bez-Signatur -->
        <xsl:variable name="type" select="@Type"/>
        <xsl:for-each select="tokenize(@Value, '&amp;')">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="$type"/>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '501p' ]" mode="index"><!-- Bez-Folio-Nr. -->
        <xsl:variable name="type" select="@Type"/>
        <xsl:for-each select="tokenize(@Value, '&amp;')">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type" select="$type"/>
                <xsl:value-of select="normalize-space(.)"/>
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
                    <xsl:when test="not(@Value) or (@Value = '')">unk</xsl:when>
                    <xsl:when test="@Value != '' ">
                        <xsl:value-of select="translate(replace(replace(replace(replace(normalize-space(@Value), ' &amp; ', '_'), ' &amp;', ''), ' / ', '-'), '\p{P}', ''), ' \(\)\[\]\?&lt;&gt;=', '-')"/>
                    </xsl:when>
                    <xsl:otherwise>unk</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="h1:Field" mode="index"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5064' ]" mode="index"><!-- Datierung (num.) --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:call-template name="writeNormalisedDate"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5064' ]"><!-- Datierung (num.) -->
        <xsl:call-template name="writeNormalisedDate"/>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5064vt' ]"><!-- Datierung (num.) vt --><xsl:value-of select="normalize-space(@Value)"/><xsl:apply-templates select="h1:Field"/></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5130' ]"><!-- Entstehungsort --><xsl:value-of select="normalize-space(@Value)"/><xsl:apply-templates select="h1:Field"/></xsl:template>
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
    <xsl:template match="h1:Field[ @Type = '5360' ]"><!-- Höhe x Breite (cm) --><xsl:value-of select="normalize-space(@Value)"/><xsl:apply-templates select="h1:Field"/></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5360vt' ]"><!-- Höhe x Breite (cm) vt --><xsl:value-of select="normalize-space(@Value)"/><xsl:apply-templates select="h1:Field"/></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5500' ]" mode="index"><!-- Ikonographie --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
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
                    <xsl:when test="not(@Value) or (@Value = '')">unk</xsl:when>
                    <xsl:when test="@Value != '' ">
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
            <xsl:attribute name="xml:lang">
                <xsl:choose>
                    <xsl:when test="ends-with(@Type, 'd')">de</xsl:when>
                    <xsl:when test="ends-with(@Type, 'g')">grc</xsl:when>
                    <xsl:when test="ends-with(@Type, 'l')">la</xsl:when>
                    <xsl:when test="ends-with(@Type, 'v') and h1:Field[ @Type = '5680' ]/@Value = 'französisch' ">fr</xsl:when>
                    <xsl:when test="ends-with(@Type, 'v') and h1:Field[ @Type = '5680' ]/@Value = 'hebräisch' ">he</xsl:when>
                    <xsl:when test="ends-with(@Type, 'v') and h1:Field[ @Type = '5680' ]/@Value = 'italienisch' ">it</xsl:when>
                    <xsl:when test="ends-with(@Type, 'v') and contains(h1:Field[ @Type = '5680' ]/@Value, 'niederländisch') ">nl</xsl:when>
                    <xsl:when test="ends-with(@Type, 'v')">unk</xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="@Value"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = '5684' ]" mode="index"><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5686' ]" mode="index"><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5688' ]" mode="index"><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '5694' ]" mode="index"><!-- Anbringungsort -->
        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select="@Type"/>
            <xsl:value-of select="replace(replace(@Value, 'recto', 'r'), 'verso', 'v')"/>
        </xsl:element>
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
        <xsl:call-template name="writeLangValue">
            <xsl:with-param name="value" select="@Value"/>
        </xsl:call-template>
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
                    <xsl:when test="@Value != '' ">
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
    <xsl:template match="h1:Field[ @Type = '6770' ]" mode="index"><!-- Repertorium --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6773' ]" mode="index"><!-- Identitätsgrad --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6807' ]" mode="index"><!-- Motiv --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6817' ]" mode="index"><!-- Motivzusatz --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6876' ]" mode="index"><!-- Transkription --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6920' ]" mode="index"><!-- Literaturgattung --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6922' ]" mode="index"><!-- Sacherschließung --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6923' ]" mode="index"><!-- Sacherschl.-Ort --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6930' ]" mode="index"><!-- Sachtitel --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
    <xsl:template match="h1:Field[ @Type = '6930gi' ]" mode="index"><!-- Sachtitel-GI --><xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0"><xsl:attribute name="type" select="@Type"/><xsl:value-of select="normalize-space(@Value)"/></xsl:element></xsl:template>
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
                    <xsl:when test="@Value != '' ">
                        <xsl:value-of select="translate(replace(replace(replace(replace(normalize-space(@Value), ' &amp; ', '_'), ' &amp;', ''), ' / ', '-'), '\p{P}', ''), ' \(\)\[\]\?&lt;&gt;=', '-')"/>
                    </xsl:when>
                    <xsl:otherwise>unk</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="h1:Field" mode="index"/>
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
                    <xsl:when test="@Value != '' ">
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
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:value-of select="concat('_', @Type)"/>
                <xsl:value-of select="concat('[', count(preceding-sibling::h1:Field[@Type = current()/@Type]), ']')"/>
            </xsl:attribute>
            <xsl:attribute name="indexName">
                <xsl:choose>
                    <xsl:when test="(@Value != '') and (@Value != '---') ">
                        <xsl:value-of select="translate(replace(replace(replace(replace(normalize-space(@Value), ' &amp; ', '_'), ' &amp;', ''), ' / ', '-'), '\p{P}', ''), ' \(\)\[\]\?&lt;&gt;=', '-')"/>
                    </xsl:when>
                    <xsl:otherwise>unk</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="h1:Field" mode="index"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par01' ][ @Value != '' ]"><!-- Signatur -->
        <xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:variable name="content">
                <xsl:call-template name="processPar"/>
            </xsl:variable>
            <xsl:value-of select="replace($content, '&lt;lb/&gt;', ' ')"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par02' ][ @Value != '' ]"><!-- Überschrift -->
        <xsl:variable name="content">
            <xsl:call-template name="processPar"/>
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
            <xsl:call-template name="processPar"/>
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
            <xsl:call-template name="processPar"/>
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
        <xsl:call-template name="processPar"/>
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par07' ][ @Value != '' ]"><!-- Einband -->
        <xsl:element name="physDesc" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="n">
                    <xsl:text>MXML-</xsl:text>
                    <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                    <xsl:text>-par07</xsl:text>
                </xsl:attribute>
                <xsl:call-template name="processPar"/>
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
        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="n">
                <xsl:text>MXML-</xsl:text>
                <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                <xsl:text>-par10</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="processPar"/>
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
    </xsl:template>
    <xsl:template match="h1:Field[ @Type = 'par11' ][ @Value != '' ][not(h1:Field[ @Type = '5230' ][ @Value = 'Faszikel' ])]"><!-- Text -->
        <xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select=" 'text' "/>
            <xsl:if test="$mode = 'test' "><xsl:comment>par11</xsl:comment></xsl:if>
            <xsl:call-template name="processPar"/>
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
            <xsl:call-template name="processPar"/>
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
            <xsl:call-template name="processPar"/>
            <xsl:for-each select="parent::h1:Block/h1:Block[h1:Field[ @Type = 'par13' ][ @Value != '' ]]/h1:Field[ @Type = 'par13' ][ @Value != '' ]">
                <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="n">
                        <xsl:text>MXML-</xsl:text>
                        <xsl:value-of select="translate(parent::h1:Block/h1:Field[matches(@Type, '500[0-5]')]/@Value, ',', '-')"/>
                    </xsl:attribute>
                </xsl:element>
                <xsl:if test="$mode = 'test' "><xsl:comment>par13</xsl:comment></xsl:if>
                <xsl:call-template name="processPar"/>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template mode="index" match="h1:Field[ 
        (@Type = '5209') or
        (@Type = '5210') or
        (@Type = '5240') or
        (@Type = '5260') or
        (@Type = '5270') or
        (@Type = '5382') or
        (@Type = '5710')
        ]">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="type">
                    <xsl:choose>
                        <xsl:when test=" @Type = '5209' "><xsl:text>title</xsl:text></xsl:when>
                        <xsl:when test=" @Type = '5210' "><xsl:text>status</xsl:text></xsl:when>
                        <xsl:when test=" @Type = '5240' "><xsl:text>form</xsl:text></xsl:when>
                        <xsl:when test=" @Type = '5260' "><xsl:text>material</xsl:text></xsl:when>
                        <xsl:when test=" @Type = '5270' "><xsl:text>decoration</xsl:text></xsl:when>
                        <xsl:when test=" @Type = '5382' "><xsl:text>format</xsl:text></xsl:when>
                        <xsl:when test=" @Type = '5710' "><xsl:text>textLang</xsl:text></xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="normalize-space(@Value)"/>
            </xsl:element>
            <xsl:choose>
                <xsl:when test="(@Type = '5710') and contains(@Value, ',')">
                    <xsl:for-each select="tokenize(@Value, ',')">
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'textLang-ID' "/>
                            <xsl:call-template name="writeLangValue">
                                <xsl:with-param name="value" select="normalize-space(.)"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="(@Type = '5710') and contains(@Value, 'u.')">
                    <xsl:for-each select="tokenize(@Value, 'u.')">
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'textLang-ID' "/>
                            <xsl:call-template name="writeLangValue">
                                <xsl:with-param name="value" select="normalize-space(.)"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="(@Type = '5710') and contains(@Value, '&amp;')">
                    <xsl:for-each select="tokenize(@Value, '&amp;')">
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'textLang-ID' "/>
                            <xsl:call-template name="writeLangValue">
                                <xsl:with-param name="value" select="normalize-space(.)"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test=" @Type = '5710' ">
                    <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="type" select=" 'textLang-ID' "/>
                        <xsl:call-template name="writeLangValue">
                            <xsl:with-param name="value" select="@Value"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    

    <!-- ========== Kerndatenfelder ========== -->
    <!-- ========== einfache Felder ========== -->
    <xsl:template match="h1:Field[ 
        (@Type = '5209norm') or
        (@Type = '5210norm') or
        (@Type = '5240norm') or
        (@Type = '5270norm') or
        (@Type = '5382norm') or
        (@Type = '5705norm') or
        (@Type = '5706norm')
        ]">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="indexName">
                <xsl:choose>
                    <xsl:when test=" @Type = '5209norm' "><xsl:text>norm_title</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '5210norm' "><xsl:text>norm_status</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '5240norm' "><xsl:text>norm_form</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '5270norm' "><xsl:text>norm_decoration</xsl:text></xsl:when>
                    <xsl:when test=" @Type = '5382norm' "><xsl:text>norm_format</xsl:text></xsl:when>
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
                        <xsl:when test=" @Type = '5382norm' "><xsl:text>format</xsl:text></xsl:when>
                        <xsl:when test=" @Type = '5705norm' "><xsl:text>musicNotation</xsl:text></xsl:when>
                        <xsl:when test=" @Type = '5706norm' "><xsl:text>measure</xsl:text></xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test=" @Type = '5210norm' ">
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
                    <xsl:when test=" @Type = '5382norm' ">
                        <xsl:choose>
                            <xsl:when test="contains(@Value, 'kleiner als Oktav')
                                or contains(@Value, 'Duodez')
                                or contains(@Value, '&lt;Oktav')"><xsl:text>smaller than octavo</xsl:text></xsl:when>
                            <xsl:when test="contains(@Value, 'größer als Folio')
                                or contains(@Value, '&gt;Folio')"><xsl:text>larger than folio</xsl:text></xsl:when>
                            <xsl:when test="(@Value = 'Sonderformat')
                                or (@Value = 'ERRECHNET: Sonderformat')"><xsl:text>other</xsl:text></xsl:when>
                            <xsl:when test="(@Value = 'Folio')
                                or (@Value = 'ERRECHNET: Folio')"><xsl:text>folio</xsl:text></xsl:when>
                            <xsl:when test="(@Value = 'Quart')
                                or (@Value = 'ERRECHNET: Quart')"><xsl:text>quarto</xsl:text></xsl:when>
                            <xsl:when test="(@Value = 'Oktav')
                                or (@Value = 'ERRECHNET: Oktav')"><xsl:text>octavo</xsl:text></xsl:when>
                            <xsl:when test="(@Value = 'Querformat')
                                or (@Value = 'ERRECHNET: Querformat')"><xsl:text>oblong</xsl:text></xsl:when>
                            <xsl:when test="(@Value = 'Quadratformat')
                                or (@Value = 'ERRECHNET: Quadratformat')"><xsl:text>square</xsl:text></xsl:when>
                            <xsl:when test="(@Value = 'Schmalformat')
                                or (@Value = 'ERRECHNET: Schmalformat')"><xsl:text>long and narrow</xsl:text></xsl:when>
                            <xsl:otherwise></xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(@Value)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:if test=" @Type = '5382norm' ">
                <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="type" select=" 'format_typeOfInformation' "/>
                    <xsl:choose>
                        <xsl:when test="contains(@Value, 'ERRECHNET')">computed</xsl:when>
                        <xsl:otherwise>factual</xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:if>
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
        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select=" 'material_type' "/>
            <xsl:choose>
                <xsl:when test=" @Value = 'Pergament' "><xsl:text>parchment</xsl:text></xsl:when>
                <xsl:when test=" @Value = 'Papier' "><xsl:text>paper</xsl:text></xsl:when>
                <xsl:when test=" @Value = 'Papyrus' "><xsl:text>papyrus</xsl:text></xsl:when>
                <xsl:when test=" @Value = 'Sonstiges' "><xsl:text>other</xsl:text></xsl:when>
            </xsl:choose>
        </xsl:element>
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
                            h1:Field[ @Type = '5360vt' ] or h1:Field[ @Type = '5360' ]
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
                            h1:Field[ @Type = '5260vt' ] or h1:Field[ @Type = '5260' ] or
                            h1:Field[ @Type = '5706vt' ] or h1:Field[ @Type = '5706' ] 
                            ) and (
                            h1:Field[ @Type = '5360vt' ] or h1:Field[ @Type = '5360' ]
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
                            h1:Field[ @Type = '5260vt' ] or h1:Field[ @Type = '5260' ] or
                            h1:Field[ @Type = '5706vt' ] or h1:Field[ @Type = '5706' ] or
                            h1:Field[ @Type = '5360vt' ] or h1:Field[ @Type = '5360' ]
                            ) and (
                            h1:Field[ @Type = '5130vt' ] or h1:Field[ @Type = '5130' ]
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
                            h1:Field[ @Type = '5260vt' ] or h1:Field[ @Type = '5260' ] or
                            h1:Field[ @Type = '5706vt' ] or h1:Field[ @Type = '5706' ] or
                            h1:Field[ @Type = '5360vt' ] or h1:Field[ @Type = '5360' ] or
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
                <xsl:when test="h1:Field[ @Type = '5710norm' ]">
                    <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="indexName" select=" 'norm_textLang' "/>
                        <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type" select=" 'textLang' "/>
                            <xsl:for-each select="h1:Field[ @Type = '5710norm' ]">
                                <xsl:if test="preceding-sibling::h1:Field[ @Type = '5710norm' ]"><xsl:text> / </xsl:text></xsl:if>
                                <xsl:apply-templates select="self::h1:Field[ @Type = '5710norm' ]"/>
                            </xsl:for-each>
                        </xsl:element>
                        <xsl:for-each select="h1:Field[ @Type = '5710norm' ]">
                            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="type" select=" 'textLang-ID' "/>
                                <xsl:call-template name="writeLangValue">
                                    <xsl:with-param name="value" select="@Value"/>
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
                    <xsl:apply-templates select="h1:Field[ @Type = '5240norm' ]"/>
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
                    <xsl:apply-templates select="h1:Field[ @Type = '5210norm' ]"/>
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
                    <xsl:apply-templates select="h1:Field[ @Type = 'par10' ]"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="h1:Block[not(h1:Field[ @Type = '5230' ][ @Value = 'Faszikel' ])][not(h1:Field[ @Type = '5230' ][ @Value = 'Text' ])]/h1:Field[ @Type = 'par10' ][ @Value != '' ]">
                <xsl:if test="$mode = 'test' "><xsl:comment>history > Block/par10</xsl:comment></xsl:if>
                <xsl:element name="history" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates select="h1:Block/h1:Field[ @Type = 'par10' ]"/>
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
            <xsl:when test="h1:Field[ @Type = 'par11' ][ @Value != '' ][not(following-sibling::h1:Field[ @Type = '5230' ][ @Value = 'Faszikel' ])]">
                <xsl:element name="msContents" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:if test="$mode = 'test' "><xsl:comment>msContents/when-1</xsl:comment></xsl:if>
                    <xsl:if test="h1:Field[ @Type = '5710' ]">
                        <xsl:element name="textLang" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="mainLang">
                                <xsl:apply-templates select="h1:Field[ @Type = '5710' ][not(preceding-sibling::h1:Field[ @Type = '5710' ])]"/>
                            </xsl:attribute>
                            <xsl:if test="h1:Field[ @Type = '5710' ][preceding-sibling::h1:Field[ @Type = '5710' ]]">
                                <xsl:attribute name="otherLangs">
                                    <xsl:apply-templates select="h1:Field[ @Type = '5710' ][preceding-sibling::h1:Field[ @Type = '5710' ]]"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:for-each select="h1:Field[ @Type = '5710' ]">
                                <xsl:if test="preceding-sibling::h1:Field[ @Type = '5710' ]">
                                    <xsl:text> / </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="normalize-space(@Value)"/>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:if>
                    <xsl:for-each select="h1:Field[ @Type = 'par11' ][ @Value != '' ][not(following-sibling::h1:Field[ @Type = '5230' ][ @Value = 'Faszikel' ])]">
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
                [not(h1:Field[ @Type = '5230' ][ @Value = 'Text' ]) and not(h1:Field[ @Type = 'par09' ]) and not(h1:Field[ @Type = 'par10' ])]">
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
                [h1:Field[ @Type = '599a' ][@Value = 'AUTOR/SACHTITEL' or @Value = 'Textautopsie' or @Value = 'TEXTAUTOPSIE'][h1:Field[ @Type = '599e' ]]]">
                <xsl:element name="msContents" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:if test="$mode = 'test' "><xsl:comment>msContents/when-4</xsl:comment></xsl:if>
                    <xsl:for-each select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Text') ]]
                        [h1:Field[ @Type = '599a' ][@Value = 'AUTOR/SACHTITEL' or @Value = 'Textautopsie' or @Value = 'TEXTAUTOPSIE']]">
                        <xsl:element name="msItem" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:if test="h1:Field[ @Type = '5710' ]">
                                <xsl:element name="textLang" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="mainLang">
                                        <xsl:apply-templates select="h1:Field[ @Type = '5710' ][not(preceding-sibling::h1:Field[ @Type = '5710' ])]"/>
                                    </xsl:attribute>
                                    <xsl:if test="h1:Field[ @Type = '5710' ][position() gt 1]">
                                        <xsl:attribute name="otherLangs">
                                            <xsl:apply-templates select="h1:Field[ @Type = '5710' ][preceding-sibling::h1:Field[ @Type = '5710' ]]"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:for-each select="h1:Field[ @Type = '5710' ]">
                                        <xsl:if test="preceding-sibling::h1:Field[ @Type = '5710' ]">
                                            <xsl:text> / </xsl:text>
                                        </xsl:if>
                                        <xsl:value-of select="normalize-space(@Value)"/>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:if>
                            <xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="type" select=" 'text' "/>
                                <xsl:if test="$mode = 'test' "><xsl:comment>msContents/599a</xsl:comment></xsl:if>
                                <xsl:apply-templates select="h1:Field[ @Type = '4665' ]"/>
                                <xsl:for-each select="h1:Field[ @Type = '599a' ][@Value = 'AUTOR/SACHTITEL' or @Value = 'Textautopsie' or @Value = 'TEXTAUTOPSIE']">
                                    <xsl:apply-templates select="h1:Field[ @Type = '599e' ]"/>
                                    <xsl:if test="following-sibling::h1:Field[ @Type = '599a' ][@Value = 'AUTOR/SACHTITEL' or @Value = 'Textautopsie' or @Value = 'TEXTAUTOPSIE']">
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
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
                            <xsl:if test="h1:Field[ @Type = '5710' ]">
                                <xsl:element name="textLang" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="mainLang">
                                        <xsl:apply-templates select="h1:Field[ @Type = '5710' ][not(preceding-sibling::h1:Field[ @Type = '5710' ])]"/>
                                    </xsl:attribute>
                                    <xsl:if test="h1:Field[ @Type = '5710' ][position() gt 1]">
                                        <xsl:attribute name="otherLangs">
                                            <xsl:apply-templates select="h1:Field[ @Type = '5710' ][preceding-sibling::h1:Field[ @Type = '5710' ]]"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:for-each select="h1:Field[ @Type = '5710' ]">
                                        <xsl:if test="preceding-sibling::h1:Field[ @Type = '5710' ]">
                                            <xsl:text> / </xsl:text>
                                        </xsl:if>
                                        <xsl:value-of select="normalize-space(@Value)"/>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:if>
                            <xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="type" select=" 'text' "/>
                                <xsl:if test="$mode = 'test' "><xsl:comment>msContents/5209</xsl:comment></xsl:if>
                                <xsl:apply-templates select="h1:Field[ @Type = '4665' ]"/>
                                <xsl:if test="h1:Field[ @Type = '4665' ] and h1:Field[ @Type = '5209' ]">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="h1:Field[ @Type = '5209' ]/@Value"/>
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
                <xsl:element name="physDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates select="h1:Field[ @Type = 'par04' ]"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="h1:Field[ @Type = 'par08' ][ @Value != '' ]">
                <xsl:element name="physDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates select="h1:Field[ @Type = 'par08' ][ @Value != '' ]"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="h1:Field[ @Type = 'par09' ][ @Value != '' ]">
                <xsl:element name="physDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates select="h1:Field[ @Type = 'par09' ]"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="h1:Field[ @Type = 'par13' ][ @Value != '' ]">
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
                <xsl:element name="physDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates select="h1:Block[h1:Field[ @Type = '5230' ][ starts-with(@Value, 'Text') ]][h1:Field[ @Type = 'par09' ]]/h1:Field[ @Type = 'par09' ]"/>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="processPar">
        <xsl:param name="element"/>
        <xsl:param name="type"/>
        <xsl:choose>
            <!--
            <xsl:when test="contains(@Value, 'rtf')">
                <xsl:attribute name="Value">
                    <xsl:value-of select="rtftools:removeRTF(string( @Value ) )"/>
                </xsl:attribute>
            </xsl:when>
            -->
            <!--
            <xsl:when test="starts-with(@Value, '{\rtf')">
                <xsl:variable name="processedRTF">
                    <xsl:value-of select="sbbfunc:rtf-to-html(@Value)"/>
                </xsl:variable>
                <xsl:value-of select="substring-before(substring-after($processedRTF,
                    '&lt;body&gt;&#xD;'),
                    '&lt;/body&gt;&#xD;')"/>
            </xsl:when>
            -->
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
        <xsl:variable name="moveWhitespace"      select="replace($convert_bezwrk.6930, '&lt;ref(.*?)&gt; ',                   ' &lt;ref$1&gt;')"/>
        
        <xsl:variable name="removeIFromInitium"   select="replace($moveWhitespace,     '&lt;ref type=&quot;initium&quot; xml:lang=&quot;(\w+)&quot;&gt;\\i(.*?)&lt;/ref&gt;\\plain \\i', '&lt;ref type=&quot;initium&quot; xml:lang=&quot;$1&quot;&gt;$2&lt;/ref&gt;')"/>
        -->
        <xsl:variable name="removeIFromInitium"   select="replace($convertHyperlinks,     '&lt;ref type=&quot;initium&quot; xml:lang=&quot;(\w+)&quot;&gt;\\i(.*?)&lt;/ref&gt;\\plain \\i', '&lt;ref type=&quot;initium&quot; xml:lang=&quot;$1&quot;&gt;$2&lt;/ref&gt;')"/>
        
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
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </xsl:element>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:when test="contains(@Value, ',')">
                                        <xsl:for-each select="tokenize(@Value, ',')">
                                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="role" select=" 'author' "/>
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </xsl:element>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                            <xsl:attribute name="role" select=" 'author' "/>
                                            <xsl:value-of select="normalize-space(@Value)"/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="contains(h1:Field[@Type='9951norm'][@Value='Beschreibung']/h1:Field[@Type='9952norm']/@Value, '/')">
                            <xsl:for-each select="tokenize(h1:Field[@Type='9951norm'][@Value='Beschreibung']/h1:Field[@Type='9952norm']/@Value, '/')">
                                <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="role" select=" 'author' "/>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="contains(h1:Field[@Type='9951norm'][@Value='Beschreibung']/h1:Field[@Type='9952norm']/@Value, ',')">
                            <xsl:for-each select="tokenize(h1:Field[@Type='9951norm'][@Value='Beschreibung']/h1:Field[@Type='9952norm']/@Value, ',')">
                                <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="role" select=" 'author' "/>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="h1:Field[@Type='9951norm'][@Value='Beschreibung']/h1:Field[@Type='9952norm']">
                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="role" select=" 'author' "/>
                                <xsl:value-of select="h1:Field[@Type='9951norm'][@Value='Beschreibung']/h1:Field[@Type='9952norm']/@Value"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="contains(h1:Field[@Type='9904']/@Value, ' &amp; ')">
                            <xsl:for-each select="tokenize(h1:Field[@Type='9904']/@Value, ' &amp; ')">
                                <xsl:choose>
                                    <xsl:when test="contains(., '(Beschreibung)')">
                                        <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                            <xsl:attribute name="role" select=" 'author' "/>
                                            <xsl:value-of select="normalize-space(substring-before(., '(Beschreibung)'))"/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="contains(., '(')"/>
                                    <xsl:otherwise>
                                        <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                            <xsl:attribute name="role" select=" 'author' "/>
                                            <xsl:value-of select="normalize-space(.)"/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="contains(h1:Field[@Type='9904']/@Value, ' unter Mitarbeit von')">
                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="role" select=" 'author' "/>
                                <xsl:value-of select="normalize-space(substring-before(h1:Field[@Type='9904']/@Value, ' unter Mitarbeit von'))"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="contains(h1:Field[@Type='9904']/@Value, '(Beschreibung)')">
                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="role" select=" 'author' "/>
                                <xsl:value-of select="normalize-space(substring-before(h1:Field[@Type='9904']/@Value, '(Beschreibung)'))"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="contains(h1:Field[@Type='9904']/@Value, '(')">
                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="role" select=" 'author' "/>
                                <xsl:value-of select="normalize-space(substring-before(h1:Field[@Type='9904']/@Value, '('))"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="h1:Field[@Type='9904']">
                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="role" select=" 'author' "/>
                                <xsl:value-of select="h1:Field[@Type='9904']/@Value"/>
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
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </xsl:element>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:when test="contains(h1:Field[@Type='9952norm']/@Value, ',')">
                                        <xsl:for-each select="tokenize(h1:Field[@Type='9952norm']/@Value, ',')">
                                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="role" select=" 'author' "/>
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </xsl:element>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                            <xsl:attribute name="role" select=" 'author' "/>
                                            <xsl:value-of select="h1:Field[@Type='9952norm']/@Value"/>
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
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </xsl:element>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:when test="contains(@Value, ',')">
                                        <xsl:for-each select="tokenize(@Value, ',')">
                                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                                <xsl:attribute name="role" select=" 'author' "/>
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </xsl:element>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                            <xsl:attribute name="role" select=" 'author' "/>
                                            <xsl:value-of select="normalize-space(@Value)"/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="contains(h1:Field[@Type='9951norm'][@Value='Überarbeitung']/h1:Field[@Type='9952norm']/@Value, '/')">
                            <xsl:for-each select="tokenize(h1:Field[@Type='9951norm'][@Value='Überarbeitung']/h1:Field[@Type='9952norm']/@Value, '/')">
                                <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="role" select=" 'author' "/>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="contains(h1:Field[@Type='9951norm'][@Value='Überarbeitung']/h1:Field[@Type='9952norm']/@Value, ',')">
                            <xsl:for-each select="tokenize(h1:Field[@Type='9951norm'][@Value='Überarbeitung']/h1:Field[@Type='9952norm']/@Value, ',')">
                                <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="role" select=" 'author' "/>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="h1:Field[@Type='9951norm'][@Value='Überarbeitung']/h1:Field[@Type='9952norm']">
                            <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:attribute name="role" select=" 'author' "/>
                                <xsl:value-of select="h1:Field[@Type='9951norm'][@Value='Überarbeitung']/h1:Field[@Type='9952norm']/@Value"/>
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
    <xsl:template name="writeLangValue">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test=" $value = 'alemannisch'                                     "><xsl:text>gsw</xsl:text></xsl:when>
            <xsl:when test="($value = 'arabisch')       or ($value = 'Arabisch')        "><xsl:text>ar</xsl:text></xsl:when>
            <xsl:when test="($value = 'bairisch')       or ($value = 'bairisch /')      "><xsl:text>bar</xsl:text></xsl:when>
            <xsl:when test=" $value = 'bulgarisch'                                      "><xsl:text>bg</xsl:text></xsl:when>
            <xsl:when test=" $value = 'chinesisch'                                      "><xsl:text>zh</xsl:text></xsl:when>
            <xsl:when test="($value = 'dänisch')        or ($value = 'Dänisch')         "><xsl:text>da</xsl:text></xsl:when>
            <xsl:when test="($value = 'deutsch')        or ($value = 'Deutsch')     or ($value = 'deutsch?')     "><xsl:text>de</xsl:text></xsl:when>
            <xsl:when test="($value = 'englisch')       or ($value = 'Englisch')    or ($value = 'englisch?')    "><xsl:text>en</xsl:text></xsl:when>
            <xsl:when test="($value = 'französisch')    or ($value = 'Französisch') or ($value = 'französisch?') "><xsl:text>fr</xsl:text></xsl:when>
            <xsl:when test="($value = 'griechisch')     or ($value = 'Griechisch')  or ($value = 'griechisch?')  "><xsl:text>el</xsl:text></xsl:when>
            <xsl:when test="($value = 'hebräisch')      or ($value = 'Hebräisch')   or ($value = 'hebräisch?')   "><xsl:text>he</xsl:text></xsl:when>
            <xsl:when test=" $value = 'isländisch'                                      "><xsl:text>is</xsl:text></xsl:when>
            <xsl:when test="($value = 'italienisch')    or ($value = 'Italienisch')     "><xsl:text>it</xsl:text></xsl:when>
            <xsl:when test=" $value = 'javanisch'                                       "><xsl:text>jv</xsl:text></xsl:when>
            <xsl:when test=" $value = 'katalanisch'                                     "><xsl:text>ca</xsl:text></xsl:when>
            <xsl:when test=" $value = 'kirchenslawisch' or ($value = 'Kirchenslawisch') "><xsl:text>cu</xsl:text></xsl:when>
            <xsl:when test="($value = 'lateinisch')     or ($value = 'Lateinisch')  or ($value = 'latein')       "><xsl:text>la</xsl:text></xsl:when>
            <xsl:when test=" $value = 'maduresisch'                                     "><xsl:text>mad</xsl:text></xsl:when>
            <xsl:when test=" $value = 'neugriechisch'                                   "><xsl:text>el</xsl:text></xsl:when>
            <xsl:when test=" $value = 'niederdeutsch'                                   "><xsl:text>nds</xsl:text></xsl:when>
            <xsl:when test=" $value = 'niederländisch'  or ($value = 'Niederländisch')  "><xsl:text>nl</xsl:text></xsl:when>
            <xsl:when test=" $value = 'persisch'                                        "><xsl:text>fa</xsl:text></xsl:when>
            <xsl:when test="($value = 'polnisch')       or ($value = 'Polnisch')        "><xsl:text>pl</xsl:text></xsl:when>
            <xsl:when test="($value = 'portugiesisch')  or ($value = 'Portugiesisch')   "><xsl:text>pt</xsl:text></xsl:when>
            <xsl:when test="($value = 'russisch')       or ($value = 'Russisch')        "><xsl:text>ru</xsl:text></xsl:when>
            <xsl:when test="($value = 'schwäbisch')                                     "><xsl:text>swg</xsl:text></xsl:when>
            <xsl:when test="($value = 'schwedisch')     or ($value = 'Schwedisch')      "><xsl:text>sv</xsl:text></xsl:when>
            <xsl:when test=" $value = 'singhalesisch'                                   "><xsl:text>si</xsl:text></xsl:when>
            <xsl:when test=" $value = 'sorbisch'                                        "><xsl:text>wen</xsl:text></xsl:when>
            <xsl:when test="($value = 'spanisch')       or ($value = 'Spanisch')        "><xsl:text>es</xsl:text></xsl:when>
            <xsl:when test="($value = 'tschechisch')    or ($value = 'Tschechisch')     "><xsl:text>cz</xsl:text></xsl:when>
            <xsl:when test=" $value = 'Tamil'                                           "><xsl:text>ta</xsl:text></xsl:when>
            <xsl:when test="($value = 'türkisch')       or ($value = 'Türkisch')        "><xsl:text>tr</xsl:text></xsl:when>
            <xsl:when test="($value = 'ungarisch')      or ($value = 'Ungarisch')       "><xsl:text>hu</xsl:text></xsl:when>
            <xsl:otherwise>   
                <xsl:text>unk</xsl:text>
                <xsl:message><xsl:value-of select="normalize-space($value)"/></xsl:message>
            </xsl:otherwise>
        </xsl:choose>
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
    <xsl:template name="writeIndexFields">
        <xsl:param name="field"/>
        <!-- Restliche Indexfelder etc ablegen -->
        <xsl:if test="
               h1:Field[ @Type = 'bezper' ]
            or h1:Field[ @Type = 'bezsoz' ][ @Value != 'Verwaltung']
            or h1:Field[ @Type = 'bezwrk' ]
            or h1:Field[ @Type = 'bezlit' ][ @Value = 'Repertoriumseintrag' ]
            or h1:Field[ @Type = '5007' ]
            or h1:Field[ @Type = '5060' ]
            or h1:Field[ @Type = '5200' ]
            or h1:Field[ @Type = '5234' ]
            or h1:Field[ @Type = '5270' ][ @Value != 'vorhanden' ]
            or h1:Field[ @Type = '5382' ]
            or h1:Field[ @Type = '5650' ]
            or h1:Field[ @Type = '6560' ]
            or h1:Block[h1:Field[ @Type = '5230' ][contains(@Value, 'Registereintrag')]]
            or h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = 'bezper' ]
            or h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = 'bezsoz' ]
            or h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = 'bezwrk' ]
            or h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = 'bezlit' ][ @Value = 'Repertoriumseintrag' ]
            or h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = '5007' ]
            or h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = '5200' ]
            or h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = '5234' ]
            or h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = '5270' ][ @Value != 'vorhanden' ]
            or h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = '5382' ]
            or h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = '5650' ]
            or h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = '6560' ]
            or (
            self::h1:Field[ @Type = 'par08' ][
                following-sibling::h1:Field[ @Type = 'bezper' ]
             or following-sibling::h1:Field[ @Type = 'bezsoz' ][ @Value != 'Verwaltung']
             or following-sibling::h1:Field[ @Type = 'bezwrk' ]
             or following-sibling::h1:Field[ @Type = 'bezlit' ][ @Value = 'Repertoriumseintrag' ]
             or following-sibling::h1:Field[ @Type = '5007' ]
             or following-sibling::h1:Field[ @Type = '5060' ]
             or following-sibling::h1:Field[ @Type = '5200' ]
             or following-sibling::h1:Field[ @Type = '5234' ]
             or following-sibling::h1:Field[ @Type = '5270' ][ @Value != 'vorhanden' ]
             or following-sibling::h1:Field[ @Type = '5382' ]
             or following-sibling::h1:Field[ @Type = '5650' ]
             or following-sibling::h1:Field[ @Type = '6560' ]
            ]
            )
            ">
            <xsl:choose>
                <xsl:when test="$field = 'index' ">
                    <xsl:apply-templates select="
                          following-sibling::h1:Field[ @Type = 'bezper' ]
                        | following-sibling::h1:Field[ @Type = 'bezsoz' ][ @Value != 'Verwaltung']
                        | following-sibling::h1:Field[ @Type = 'bezwrk' ]
                        | following-sibling::h1:Field[ @Type = 'bezlit' ][ @Value = 'Repertoriumseintrag' ]
                        | following-sibling::h1:Field[ @Type = '5007' ]
                        | following-sibling::h1:Field[ @Type = '5060' ]
                        | following-sibling::h1:Field[ @Type = '5200' ]
                        | following-sibling::h1:Field[ @Type = '5234' ]
                        | following-sibling::h1:Field[ @Type = '5270' ][ @Value != 'vorhanden' ]
                        | following-sibling::h1:Field[ @Type = '5382' ]
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
                                        | following-sibling::h1:Field[ @Type = 'bezwrk' ]
                                        | following-sibling::h1:Field[ @Type = 'bezlit' ][ @Value = 'Repertoriumseintrag' ]
                                        | following-sibling::h1:Field[ @Type = '5007' ]
                                        | following-sibling::h1:Field[ @Type = '5060' ]
                                        | following-sibling::h1:Field[ @Type = '5200' ]
                                        | following-sibling::h1:Field[ @Type = '5234' ]
                                        | following-sibling::h1:Field[ @Type = '5270' ][ @Value != 'vorhanden' ]
                                        | following-sibling::h1:Field[ @Type = '5382' ]
                                        | following-sibling::h1:Field[ @Type = '5650' ]
                                        | following-sibling::h1:Field[ @Type = '6560' ]
                                        " mode="index"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="
                                          h1:Field[ @Type = 'bezper' ]
                                        | h1:Field[ @Type = 'bezsoz' ][ @Value != 'Verwaltung']
                                        | h1:Field[ @Type = 'bezwrk' ]
                                        | h1:Field[ @Type = 'bezlit' ][ @Value = 'Repertoriumseintrag' ]
                                        | h1:Field[ @Type = '5007' ]
                                        | h1:Field[ @Type = '5060' ]
                                        | h1:Field[ @Type = '5200' ]
                                        | h1:Field[ @Type = '5234' ]
                                        | h1:Field[ @Type = '5270' ][ @Value != 'vorhanden' ]
                                        | h1:Field[ @Type = '5382' ]
                                        | h1:Field[ @Type = '5650' ]
                                        | h1:Field[ @Type = '6560' ]
                                        | h1:Block[h1:Field[ @Type = '5230' ][contains(@Value, 'Registereintrag')]]
                                        | h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = 'bezper' ]
                                        | h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = 'bezsoz' ]
                                        | h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = 'bezwrk' ]
                                        | h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = 'bezlit' ][ @Value = 'Repertoriumseintrag' ]
                                        | h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = '5007' ]
                                        | h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = '5200' ]
                                        | h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = '5234' ]
                                        | h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = '5270' ][ @Value != 'vorhanden' ]
                                        | h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = '5382' ]
                                        | h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = '5650' ]
                                        | h1:Block[h1:Field[ @Type = 'par09' ] or h1:Field[ @Type = 'par10' ]]/h1:Field[ @Type = '6560' ]
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
        <xsl:choose>
            <xsl:when test="matches($value, '\([IVX]* ?\w+ \d+,?\d*\)') and not(contains($value, ' - ('))">
                <xsl:value-of select="replace($value, ' \(', ' - (')"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$value"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="convertGap">
        <xsl:param name="value"/>
        <xsl:value-of select="replace($value, '\. ?\. ?\.', '&#x2026;')"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1UC">
        <xsl:param name="value"/>
        <xsl:value-of select="
            replace(replace(replace(replace(replace(
            $value,
            '\\uc2\\u176 \\\^81\\\^8b\\uc1 ', '&#176;'),
            '\\u-7368 \?', '&#58167;'),
            '\\u8226 \\bullet', '&#8226;'),
            '\\u8309 5', '&#8309;'),
            '\\uc2\\u183 \\\^a1P\\uc1 ', '&#183;')"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U16">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u16')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u161', '&#161;'), '\\u162', '&#162;'), '\\u163', '&#163;'), '\\u166', '&#166;'), '\\u167', '&#167;'), '\\u168', '&#168;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U17">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u17')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u170', '&#170;'), '\\u171', '&#171;'), '\\u172', '&#172;'), '\\u174', '&#174;'), '\\u175', '&#175;'), '\\u176', '&#176;'), '\\u177', '&#177;'), '\\u178', '&#178;'), '\\u179', '&#179;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U18">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u18')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u180', '&#180;'), '\\u181', '&#181;'), '\\u182', '&#182;'), '\\u183', '&#183;'), '\\u184', '&#184;'), '\\u185', '&#185;'), '\\u186', '&#186;'), '\\u187', '&#187;'), '\\u188', '&#188;'), '\\u189', '&#189;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U19">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u19')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u190', '&#190;'), '\\u191', '&#191;'), '\\u192', '&#192;'), '\\u193', '&#193;'), '\\u194', '&#194;'), '\\u195', '&#195;'), '\\u196', '&#196;'), '\\u197', '&#197;'), '\\u198', '&#198;'), '\\u199', '&#199;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U1">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u1')">
                <xsl:variable name="convertSpecialCharacters1U16">
                    <xsl:call-template name="decodeSpecialCharacters1U16">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U17">
                    <xsl:call-template name="decodeSpecialCharacters1U17">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U16"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U18">
                    <xsl:call-template name="decodeSpecialCharacters1U18">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U17"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U19">
                    <xsl:call-template name="decodeSpecialCharacters1U19">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U18"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters1U19"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U20">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u20')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u200', '&#200;'), '\\u201', '&#201;'), '\\u202', '&#202;'), '\\u203', '&#203;'), '\\u204', '&#204;'), '\\u205', '&#205;'), '\\u206', '&#206;'), '\\u207', '&#207;'), '\\u208', '&#208;'), '\\u209', '&#209;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U21">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u21')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u210', '&#210;'), '\\u211', '&#211;'), '\\u212', '&#212;'), '\\u213', '&#213;'), '\\u214', '&#214;'), '\\u215', '&#215;'), '\\u216', '&#216;'), '\\u217', '&#217;'), '\\u218', '&#218;'), '\\u219', '&#219;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U22">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u22')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u220', '&#220;'), '\\u221', '&#221;'), '\\u222', '&#222;'), '\\u223', '&#223;'), '\\u224', '&#224;'), '\\u225', '&#225;'), '\\u226', '&#226;'), '\\u227', '&#227;'), '\\u228', '&#228;'), '\\u229', '&#229;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U23">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u23')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u230', '&#230;'), '\\u231', '&#231;'), '\\u232', '&#232;'), '\\u233', '&#233;'), '\\u234', '&#234;'), '\\u235', '&#235;'), '\\u236', '&#236;'), '\\u237', '&#237;'), '\\u238', '&#238;'), '\\u239', '&#239;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U24">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u24')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u240', '&#240;'), '\\u241', '&#241;'), '\\u242', '&#242;'), '\\u243', '&#243;'), '\\u244', '&#244;'), '\\u245', '&#245;'), '\\u246', '&#246;'), '\\u247', '&#247;'), '\\u248', '&#248;'), '\\u249', '&#249;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U25">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u25')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u250', '&#250;'), '\\u251', '&#251;'), '\\u252', '&#252;'), '\\u253', '&#253;'), '\\u254', '&#254;'), '\\u255', '&#255;'), '\\u256', '&#256;'), '\\u257', '&#257;'), '\\u259', '&#259;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U26">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u26')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u261', '&#261;'), '\\u262', '&#262;'), '\\u263', '&#263;'), '\\u267', '&#267;'), '\\u268', '&#268;'), '\\u269', '&#269;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U27">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u27')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u271', '&#271;'), '\\u273', '&#273;'), '\\u275', '&#275;'), '\\u277', '&#277;'), '\\u278', '&#278;'), '\\u279', '&#279;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U28">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u28')) then
                replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u280', '&#280;'), '\\u281', '&#281;'), '\\u283', '&#283;'), '\\u286', '&#286;'), '\\u287', '&#287;'), '\\u288', '&#288;'), '\\u289', '&#289;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U29">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u29')) then
                replace(replace(replace(replace(
                $value,
                '\\u295', '&#295;'), '\\u297', '&#297;'), '\\u298', '&#298;'), '\\u299', '&#299;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U2">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u2')">
                <xsl:variable name="convertSpecialCharacters1U20">
                    <xsl:call-template name="decodeSpecialCharacters1U20">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U21">
                    <xsl:call-template name="decodeSpecialCharacters1U21">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U20"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U22">
                    <xsl:call-template name="decodeSpecialCharacters1U22">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U21"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U23">
                    <xsl:call-template name="decodeSpecialCharacters1U23">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U22"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U24">
                    <xsl:call-template name="decodeSpecialCharacters1U24">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U23"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U25">
                    <xsl:call-template name="decodeSpecialCharacters1U25">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U24"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U26">
                    <xsl:call-template name="decodeSpecialCharacters1U26">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U25"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U27">
                    <xsl:call-template name="decodeSpecialCharacters1U27">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U26"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U28">
                    <xsl:call-template name="decodeSpecialCharacters1U28">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U27"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U29">
                    <xsl:call-template name="decodeSpecialCharacters1U29">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U28"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$convertSpecialCharacters1U29"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U30">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u30')) then
                replace(replace(replace(replace(
                $value,
                '\\u301', '&#301;'), '\\u304', '&#304;'), '\\u305', '&#305;'), '\\u307', '&#307;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U32">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u32')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u321', '&#321;'), '\\u322', '&#322;'), '\\u323', '&#323;'), '\\u324', '&#324;'), '\\u326', '&#326;'), '\\u328', '&#328;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U33">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u33')) then
                replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u332', '&#332;'), '\\u333', '&#333;'), '\\u334', '&#334;'), '\\u335', '&#335;'), '\\u337', '&#337;'), '\\u338', '&#338;'), '\\u339', '&#339;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U34">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u34')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u341', '&#341;'), '\\u344', '&#344;'), '\\u345', '&#345;'), '\\u346', '&#346;'), '\\u347', '&#347;'), '\\u348', '&#348;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U35">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u35')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u350', '&#350;'), '\\u351', '&#351;'), '\\u352', '&#352;'), '\\u353', '&#353;'), '\\u355', '&#355;'), '\\u357', '&#357;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U36">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u36')) then
                replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u361', '&#361;'), '\\u362', '&#362;'), '\\u363', '&#363;'), '\\u365', '&#365;'), '\\u366', '&#366;'), '\\u367', '&#367;'), '\\u369', '&#369;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U37">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u37')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u375', '&#375;'), '\\u376', '&#376;'), '\\u377', '&#377;'), '\\u378', '&#378;'), '\\u379', '&#379;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U38">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u38')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u380', '&#380;'), '\\u381', '&#381;'), '\\u382', '&#382;'), '\\u383', '&#383;'), '\\u384', '&#384;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U39">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u39')) then
                replace(
                $value,
                '\\u390', '&#390;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U3">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u3')">
                <xsl:variable name="convertSpecialCharacters1U30">
                    <xsl:call-template name="decodeSpecialCharacters1U30">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U32">
                    <xsl:call-template name="decodeSpecialCharacters1U32">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U30"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U33">
                    <xsl:call-template name="decodeSpecialCharacters1U33">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U32"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U34">
                    <xsl:call-template name="decodeSpecialCharacters1U34">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U33"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U35">
                    <xsl:call-template name="decodeSpecialCharacters1U35">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U34"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U36">
                    <xsl:call-template name="decodeSpecialCharacters1U36">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U35"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U37">
                    <xsl:call-template name="decodeSpecialCharacters1U37">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U36"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U38">
                    <xsl:call-template name="decodeSpecialCharacters1U38">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U37"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U39">
                    <xsl:call-template name="decodeSpecialCharacters1U39">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U38"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$convertSpecialCharacters1U39"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U40">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u40')) then
            replace(
            $value,
            '\\u407', '&#407;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U41">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u41')) then
            replace(
            $value,
            '\\u410', '&#410;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U42">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u42')) then
            replace(replace(
            $value,
            '\\u423', '&#423;'), '\\u428', '&#428;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U43">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u43')) then
                replace(replace(
                $value,
                '\\u438', '&#438;'), '\\u439', '&#439;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U44">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u44')) then
                replace(replace(
                $value,
                '\\u448', '&#448;'), '\\u449', '&#449;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U46">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u46')) then
                replace(replace(replace(
                $value,
                '\\u465', '&#465;'), '\\u466', '&#466;'), '\\u468', '&#468;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U48">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u48')) then
                replace(replace(
                $value,
                '\\u486', '&#486;'), '\\u487', '&#487;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U4">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u4')">
                <xsl:variable name="convertSpecialCharacters1U40">
                    <xsl:call-template name="decodeSpecialCharacters1U40">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U41">
                    <xsl:call-template name="decodeSpecialCharacters1U41">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U40"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U42">
                    <xsl:call-template name="decodeSpecialCharacters1U42">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U41"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U43">
                    <xsl:call-template name="decodeSpecialCharacters1U43">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U42"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U44">
                    <xsl:call-template name="decodeSpecialCharacters1U44">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U43"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U46">
                    <xsl:call-template name="decodeSpecialCharacters1U46">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U44"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U48">
                    <xsl:call-template name="decodeSpecialCharacters1U48">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U46"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters1U48"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U5">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u5')) then
                replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u515', '&#515;'), '\\u519', '&#519;'),
                '\\u531', '&#531;'),
                '\\u541', '&#541;'),
                '\\u553', '&#553;'),
                '\\u576', '&#576;'),
                '\\u593', '&#593;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U60">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u60')) then
            replace(replace(
            $value,
            '\\u601', '&#601;'), '\\u603', '&#603;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U61">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u61')) then
            replace(replace(
            $value,
            '\\u618', '&#618;'), '\\u619', '&#619;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U62">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u62')) then
            replace(
            $value,
            '\\u628', '&#628;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U64">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u64')) then
                replace(
                $value,
                '\\u643', '&#643;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U65">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u65')) then
            replace(replace(
            $value,
            '\\u657', '&#657;'), '\\u658', '&#658;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U66">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u66')) then
            replace(
            $value,
            '\\u664', '&#664;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U68">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u68')) then
            replace(
            $value,
            '\\u688', '&#688;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U69">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u69')) then
                replace(replace(
                $value,
                '\\u697', '&#697;'), '\\u699', '&#699;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U6">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u6')">
                <xsl:variable name="convertSpecialCharacters1U60">
                    <xsl:call-template name="decodeSpecialCharacters1U60">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U61">
                    <xsl:call-template name="decodeSpecialCharacters1U61">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U60"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U62">
                    <xsl:call-template name="decodeSpecialCharacters1U62">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U61"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U64">
                    <xsl:call-template name="decodeSpecialCharacters1U64">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U62"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U65">
                    <xsl:call-template name="decodeSpecialCharacters1U65">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U64"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U66">
                    <xsl:call-template name="decodeSpecialCharacters1U66">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U65"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U68">
                    <xsl:call-template name="decodeSpecialCharacters1U68">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U66"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U69">
                    <xsl:call-template name="decodeSpecialCharacters1U69">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U68"/>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:value-of select="$convertSpecialCharacters1U69"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U70">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u70')) then
                replace(replace(replace(replace(
                $value,
                '\\u700', '&#700;'), '\\u701', '&#701;'), '\\u702', '&#702;'), '\\u703', '&#703;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U71">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u71')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u711', '&#711;'), '\\u712', '&#712;'), '\\u713', '&#713;'), '\\u714', '&#714;'), '\\u719', '&#719;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U72">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u72')) then
            replace(
            $value,
            '\\u729', '&#729;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U73">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u73')) then
            replace(
            $value,
            '\\u730', '&#730;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U75">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u75')) then
                replace(
                $value,
                '\\u750', '&#750;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U76">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u76')) then
                replace(replace(
                $value,
                '\\u768', '&#768;'), '\\u769', '&#769;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U77">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u77')) then
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u770', '&#770;'), '\\u771', '&#771;'), '\\u772', '&#772;'), '\\u773', '&#773;'), '\\u774', '&#774;'), '\\u775', '&#775;'), '\\u776', '&#776;'), '\\u778', '&#778;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U78">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u78')) then
            replace(replace(replace(replace(replace(
            $value,
            '\\u780', '&#780;'), '\\u781', '&#781;'), '\\u785', '&#785;'), '\\u787', '&#787;'), '\\u789', '&#789;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U79">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u79')) then
            replace(
            $value,
            '\\u796', '&#796;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U7">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u7')">
                <xsl:variable name="convertSpecialCharacters1U70">
                    <xsl:call-template name="decodeSpecialCharacters1U70">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U71">
                    <xsl:call-template name="decodeSpecialCharacters1U71">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U70"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U72">
                    <xsl:call-template name="decodeSpecialCharacters1U72">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U71"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U73">
                    <xsl:call-template name="decodeSpecialCharacters1U73">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U72"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U75">
                    <xsl:call-template name="decodeSpecialCharacters1U75">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U73"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U76">
                    <xsl:call-template name="decodeSpecialCharacters1U76">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U75"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U77">
                    <xsl:call-template name="decodeSpecialCharacters1U77">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U76"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U78">
                    <xsl:call-template name="decodeSpecialCharacters1U78">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U77"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U79">
                    <xsl:call-template name="decodeSpecialCharacters1U79">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U78"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$convertSpecialCharacters1U79"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U80">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u80')) then
                replace(replace(replace(
                $value,
                '\\u803', '&#803;'), '\\u807', '&#807;'), '\\u808', '&#808;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U82">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u82')) then
                replace(replace(replace(
                $value,
                '\\u822', '&#822;'), '\\u823', '&#823;'), '\\u824', '&#824;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U83">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u83')) then
            replace(replace(replace(
            $value,
            '\\u834', '&#834;'), '\\u836', '&#836;'), '\\u837', '&#837;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U84">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u84')) then
            replace(
            $value,
            '\\u847', '&#847;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U85">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u85')) then
                replace(
                $value,
                '\\u855', '&#855;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U86">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u86')) then
                replace(replace(replace(replace(
                $value,
                '\\u862', '&#862;'), '\\u864', '&#864;'), '\\u867', '&#867;'), '\\u868', '&#868;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U87">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u87')) then
                replace(replace(replace(
                $value,
                '\\u870', '&#870;'), '\\u871', '&#871;'), '\\u878', '&#878;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U88">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u88')) then
                replace(replace(
                $value,
                '\\u884', '&#884;'), '\\u885', '&#885;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U89">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u89')) then
                replace(replace(replace(
                $value,
                '\\u891', '&#891;'), '\\u893', '&#893;'), '\\u894', '&#894;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U8">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u8')">
                <xsl:variable name="convertSpecialCharacters1U80">
                    <xsl:call-template name="decodeSpecialCharacters1U80">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U82">
                    <xsl:call-template name="decodeSpecialCharacters1U82">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U80"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U83">
                    <xsl:call-template name="decodeSpecialCharacters1U83">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U82"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U84">
                    <xsl:call-template name="decodeSpecialCharacters1U84">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U83"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U85">
                    <xsl:call-template name="decodeSpecialCharacters1U85">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U84"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U86">
                    <xsl:call-template name="decodeSpecialCharacters1U86">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U85"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U87">
                    <xsl:call-template name="decodeSpecialCharacters1U87">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U86"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U88">
                    <xsl:call-template name="decodeSpecialCharacters1U88">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U87"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U89">
                    <xsl:call-template name="decodeSpecialCharacters1U89">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U88"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters1U89"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U90">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u90')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u900', '&#900;'), '\\u902', '&#902;'), '\\u903', '&#903;'), '\\u904', '&#904;'), '\\u906', '&#906;'), '\\u908', '&#908;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U91">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u91')) then
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u912', '&#912;'), '\\u913', '&#913;'), '\\u914', '&#914;'), '\\u915', '&#915;'), '\\u916', '&#916;'), '\\u917', '&#917;'), '\\u918', '&#918;'), '\\u919', '&#919;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U92">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u92')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u920', '&#920;'), '\\u921', '&#921;'), '\\u922', '&#922;'), '\\u923', '&#923;'), '\\u924', '&#924;'), '\\u925', '&#925;'), '\\u926', '&#926;'), '\\u927', '&#927;'), '\\u928', '&#928;'), '\\u929', '&#929;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U93">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u93')) then
                replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u931', '&#931;'), '\\u932', '&#932;'), '\\u933', '&#933;'), '\\u934', '&#934;'), '\\u935', '&#935;'), '\\u936', '&#936;'), '\\u937', '&#937;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U94">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u94')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u940', '&#940;'), '\\u941', '&#941;'), '\\u942', '&#942;'), '\\u943', '&#943;'), '\\u944', '&#944;'), '\\u945', '&#945;'), '\\u946', '&#946;'), '\\u947', '&#947;'), '\\u948', '&#948;'), '\\u949', '&#949;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U95">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u95')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u950', '&#950;'), '\\u951', '&#951;'), '\\u952', '&#952;'), '\\u953', '&#953;'), '\\u954', '&#954;'), '\\u955', '&#955;'), '\\u956', '&#956;'), '\\u957', '&#957;'), '\\u958', '&#958;'), '\\u959', '&#959;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U96">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u96')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u960', '&#960;'), '\\u961', '&#961;'), '\\u962', '&#962;'), '\\u963', '&#963;'), '\\u964', '&#964;'), '\\u965', '&#965;'), '\\u966', '&#966;'), '\\u967', '&#967;'), '\\u968', '&#968;'), '\\u969', '&#969;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U97">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u97')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u970', '&#970;'), '\\u971', '&#971;'), '\\u972', '&#972;'), '\\u973', '&#973;'), '\\u974', '&#974;'), '\\u977', '&#977;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U98">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u98')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u981', '&#981;'), '\\u985', '&#985;'), '\\u986', '&#986;'), '\\u987', '&#987;'), '\\u988', '&#988;'), '\\u989', '&#989;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U99">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u99')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u990', '&#990;'), '\\u991', '&#991;'), '\\u992', '&#992;'), '\\u993', '&#993;'), '\\u997', '&#997;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U9">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u9')">
                <xsl:variable name="convertSpecialCharacters1U90">
                    <xsl:call-template name="decodeSpecialCharacters1U90">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U91">
                    <xsl:call-template name="decodeSpecialCharacters1U91">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U90"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U92">
                    <xsl:call-template name="decodeSpecialCharacters1U92">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U91"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U93">
                    <xsl:call-template name="decodeSpecialCharacters1U93">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U92"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U94">
                    <xsl:call-template name="decodeSpecialCharacters1U94">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U93"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U95">
                    <xsl:call-template name="decodeSpecialCharacters1U95">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U94"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U96">
                    <xsl:call-template name="decodeSpecialCharacters1U96">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U95"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U97">
                    <xsl:call-template name="decodeSpecialCharacters1U97">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U96"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U98">
                    <xsl:call-template name="decodeSpecialCharacters1U98">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U97"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U99">
                    <xsl:call-template name="decodeSpecialCharacters1U99">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U98"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters1U99"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1">
        <xsl:param name="value"/>

        <xsl:variable name="convertSpecialCharacters1UC">
            <xsl:call-template name="decodeSpecialCharacters1UC">
                <xsl:with-param name="value" select="$value"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($value, '\u')">
                <xsl:variable name="convertSpecialCharacters1U1">
                    <xsl:call-template name="decodeSpecialCharacters1U1">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1UC"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U2">
                    <xsl:call-template name="decodeSpecialCharacters1U2">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U1"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U3">
                    <xsl:call-template name="decodeSpecialCharacters1U3">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U4">
                    <xsl:call-template name="decodeSpecialCharacters1U4">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U3"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U5">
                    <xsl:call-template name="decodeSpecialCharacters1U5">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U4"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U6">
                    <xsl:call-template name="decodeSpecialCharacters1U6">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U5"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U7">
                    <xsl:call-template name="decodeSpecialCharacters1U7">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U6"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U8">
                    <xsl:call-template name="decodeSpecialCharacters1U8">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U7"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U9">
                    <xsl:call-template name="decodeSpecialCharacters1U9">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U8"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters1U9"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$convertSpecialCharacters1UC"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U100">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u100')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u1001', '&#1001;'), '\\u1008', '&#1008;'),
                '\\u10003', '&#10003;'),
                '\\u10013', '&#10013;'),
                '\\u10056', '&#10056;')
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
                replace(replace(replace(replace(
                $value,
                '\\u1022', '&#1022;'), '\\u1023', '&#1023;'), '\\u1024', '&#1024;'), '\\u1026', '&#1026;')
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
                replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1040', '&#1040;'), '\\u1041', '&#1041;'), '\\u1042', '&#1042;'), '\\u1043', '&#1043;'), '\\u1044', '&#1044;'), '\\u1045', '&#1045;'), '\\u1046', '&#1046;'), '\\u1047', '&#1047;'), '\\u1048', '&#1048;')
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
                replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1090', '&#1090;'), '\\u1091', '&#1091;'), '\\u1092', '&#1092;'), '\\u1093', '&#1093;'), '\\u1094', '&#1094;'), '\\u1095', '&#1095;'), '\\u1096', '&#1096;'), '\\u1097', '&#1097;'), '\\u1098', '&#1098;'), '\\u1099', '&#1099;')
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
                replace(replace(replace(replace(
                $value,
                '\\u1100', '&#1100;'), '\\u1102', '&#1102;'), '\\u1103', '&#1103;'), '\\u1105', '&#1105;')
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
    <xsl:template name="decodeSpecialCharacters2U118">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u118')) then
            replace(replace(
            $value,
            '\\u11819', '&#11819;'), '\\u11825', '&#11825;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U11">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u11')">
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
                <xsl:variable name="convertSpecialCharacters2U118">
                    <xsl:call-template name="decodeSpecialCharacters2U118">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U112"/>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:value-of select="$convertSpecialCharacters2U118"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U12">
        <xsl:param name="value"/>
        <xsl:value-of select="
                replace(replace(replace(
                $value,
                '\\u1237', '&#1237;'),
                '\\u1249', '&#1249;'),
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
    <xsl:template name="decodeSpecialCharacters3U73">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u73')) then
            replace(replace(
            $value,
            '\\u7321', '&#7321;'), '\\u7325', '&#7325;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U74">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u74')) then
            replace(
            $value,
            '\\u7497', '&#7497;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U75">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u75')) then
            replace(replace(
            $value,
            '\\u7533', '&#7533;'), 
            '\\u7584', '&#7584;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U76">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u76')) then
                replace(replace(replace(replace(
                $value,
                '\\u7624', '&#7624;'), '\\u7625', '&#7625;'), 
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
    <xsl:template name="decodeSpecialCharacters3U782">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u782')) then
                replace(replace(
                $value,
                '\\u7822', '&#7822;'), '\\u7823', '&#7823;')
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
                <xsl:variable name="convertSpecialCharacters3U782">
                    <xsl:call-template name="decodeSpecialCharacters3U782">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U781"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U783">
                    <xsl:call-template name="decodeSpecialCharacters3U783">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U782"/>
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
                <xsl:variable name="convertSpecialCharacters3U73">
                    <xsl:call-template name="decodeSpecialCharacters3U73">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U74">
                    <xsl:call-template name="decodeSpecialCharacters3U74">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U73"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U75">
                    <xsl:call-template name="decodeSpecialCharacters3U75">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U74"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U76">
                    <xsl:call-template name="decodeSpecialCharacters3U76">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U75"/>
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
                replace(replace(replace(replace(
                $value,
                '\\u8000', '&#8000;'), '\\u8001', '&#8001;'), '\\u8002', '&#8002;'), '\\u8003', '&#8003;'), '\\u8004', '&#8004;'), '\\u8005', '&#8005;'), '\\u8008', '&#8008;'), '\\u8009', '&#8009;'),
                '\\u8011', '&#8011;'), '\\u8012', '&#8012;'), '\\u8013', '&#8013;'), '\\u8016', '&#8016;'), '\\u8017', '&#8017;'), '\\u8019', '&#8019;'),
                '\\u8020', '&#8020;'), '\\u8021', '&#8021;'), '\\u8022', '&#8022;'), '\\u8023', '&#8023;'), '\\u8025', '&#8025;'), '\\u8029', '&#8029;'),
                '\\u8032', '&#8032;'), '\\u8033', '&#8033;'), '\\u8034', '&#8034;'), '\\u8035', '&#8035;'), '\\u8036', '&#8036;'), '\\u8037', '&#8037;'), '\\u8038', '&#8038;'), '\\u8039', '&#8039;'),
                '\\u8040', '&#8040;'), '\\u8041', '&#8041;'), '\\u8042', '&#8042;'), '\\u8043', '&#8043;'), '\\u8044', '&#8044;'), '\\u8045', '&#8045;'), '\\u8046', '&#8046;'), '\\u8047', '&#8047;'), '\\u8048', '&#8048;'), '\\u8049', '&#8049;'),
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
                replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(
                $value,
                '\\u8100', '&#8100;'), '\\u8102', '&#8102;'), '\\u8103', '&#8103;'), '\\u8104', '&#8104;'),
                '\\u8113', '&#8113;'), '\\u8115', '&#8115;'), '\\u8116', '&#8116;'), '\\u8118', '&#8118;'), '\\u8119', '&#8119;'),
                '\\u8125', '&#8125;'), '\\u8127', '&#8127;'), '\\u8128', '&#8128;'),
                '\\u8131', '&#8131;'), '\\u8132', '&#8132;'), '\\u8134', '&#8134;'), '\\u8135', '&#8135;'),
                '\\u8141', '&#8141;'), '\\u8142', '&#8142;'), '\\u8143', '&#8143;'), '\\u8145', '&#8145;'), '\\u8146', '&#8146;'), '\\u8147', '&#8147;'),
                '\\u8150', '&#8150;'), '\\u8157', '&#8157;'), '\\u8158', '&#8158;'), '\\u8159', '&#8159;'),
                '\\u8160', '&#8160;'), '\\u8161', '&#8161;'), '\\u8162', '&#8162;'), '\\u8163', '&#8163;'), '\\u8164', '&#8164;'), '\\u8165', '&#8165;'), '\\u8166', '&#8166;'),
                '\\u8172', '&#8172;'), '\\u8174', '&#8174;'), '\\u8175', '&#8175;'), '\\u8178', '&#8178;'), '\\u8179', '&#8179;'),
                '\\u8180', '&#8180;'), '\\u8182', '&#8182;'), '\\u8183', '&#8183;'), '\\u8185', '&#8185;'), '\\u8188', '&#8188;'), '\\u8189', '&#8189;'),
                '\\u8190', '&#8190;'), '\\u8193', '&#8193;'), '\\u8194', '&#8194;'), '\\u8198', '&#8198;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U82">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u82')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(
                $value,
                '\\u8202', '&#8202;'), '\\u8203', '&#8203;'), '\\u8204', '&#8204;'), '\\u8206', '&#8206;'),
                '\\u8210', '&#8210;'), '\\u8213', '&#8213;'), '\\u8214', '&#8214;'), '\\u8218', '&#8218;'), '\\u8219', '&#8219;'),
                '\\u8222', '&#8222;'), '\\u8223', '&#8223;'), '\\u8224', '&#8224;'), '\\u8225', '&#8225;'),
                '\\u8230', '&#8230;'), '\\u8239', '&#8239;'),
                '\\u8242', '&#8242;'), '\\u8249', '&#8249;'),
                '\\u8250', '&#8250;'), '\\u8251', '&#8251;'), '\\u8254', '&#8254;'),
                '\\u8278', '&#8278;'),
                '\\u8285', '&#8285;')
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
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u8452', '&#8452;'),
                '\\u8464', '&#8464;'), '\\u8466', '&#8466;'), '\\u8468', '&#8468;'),
                '\\u8470', '&#8470;'), '\\u8478', '&#8478;'),
                '\\u8482', '&#8482;'), '\\u8483', '&#8483;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U85">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u85')) then
                replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u8531', '&#8531;'), '\\u8532', '&#8532;'), '\\u8533', '&#8533;'),
                '\\u8544', '&#8544;'),
                '\\u8592', '&#8592;'), '\\u8593', '&#8593;'), '\\u8594', '&#8594;')
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
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(
                $value,
                '\\u8709', '&#8709;'),
                '\\u8710', '&#8710;'), '\\u8711', '&#8711;'),
                '\\u8722', '&#8722;'), '\\u8729', '&#8729;'),
                '\\u8730', '&#8730;'), '\\u8734', '&#8734;'),
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
