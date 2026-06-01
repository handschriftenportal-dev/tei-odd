<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="#all"
    version="3.0">

    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>

    <xsl:param name="mode"/>
    <xsl:param name="base" select=" 'http://normdaten.staatsbibliothek-berlin.de/hsp/vocabulary/' "/>
    
    <xsl:template name="main" match="/">
        <xsl:for-each select="//doc/@href">
            <xsl:variable name="contents" select="unparsed-text(., 'UTF-8')"/>
            <xsl:result-document href="{concat(substring-before(., '.csv'), '.xml')}">
                <xsl:call-template name="writeFile">
                    <xsl:with-param name="contents" select="$contents"/>
                </xsl:call-template>
            </xsl:result-document>
            
            <!-- Kopie zum Validieren -->
            <xsl:result-document href="{concat('3_0_Produktion/_zuValidieren/', substring-before(tokenize(substring-after(., 'nachweis_daten/'), '/')[3], '.csv'), '.xml')}">
                <xsl:call-template name="writeFile">
                    <xsl:with-param name="contents" select="$contents"/>
                </xsl:call-template>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="insertEntry">
        <xsl:param name="signatures"/>
        <xsl:element name="bibl" namespace="http://www.tei-c.org/ns/1.0">

            <!-- manifestURL -->
            <xsl:if test="(normalize-space(translate($signatures[3], '&#34;', '')) != '')">
                <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="type"><xsl:text>manifest</xsl:text></xsl:attribute>
                    <xsl:attribute name="target"><xsl:value-of select="translate(translate($signatures[3], '&#34;', ''), ' ', '')"/></xsl:attribute>
                </xsl:element>
                <xsl:if test="contains($signatures[3], ' ')">
                    <xsl:message>Fehler: Whitespace in Manifest-URL für <xsl:value-of select="$signatures[2]"/></xsl:message>
                </xsl:if>
                <xsl:if test="starts-with($signatures[3], 'http://')">
                    <xsl:message>Fehler: 'http' statt 'https' für Manifest von <xsl:value-of select="$signatures[2]"/></xsl:message>
                </xsl:if>
            </xsl:if>
            
            <!-- otherURL -->
            <xsl:for-each select="tokenize(translate($signatures[4], '&#34;', ''), '(,)|(;)')">
                <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="type"><xsl:text>other</xsl:text></xsl:attribute>
                    <xsl:attribute name="target"><xsl:value-of select="translate(., ' ', '')"/></xsl:attribute>
                </xsl:element>
                <xsl:if test="contains($signatures[4], ' ')">
                    <xsl:message>Fehler: Whitespace in other-URL für <xsl:value-of select="$signatures[2]"/></xsl:message>
                </xsl:if>
            </xsl:for-each>
            
            <!-- thumbnailURL -->
            <xsl:if test="(normalize-space(translate($signatures[5], '&#34;', '')) != '')">
                <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="type"><xsl:text>thumbnail</xsl:text></xsl:attribute>
                    <xsl:attribute name="target">
                        <xsl:choose>
                            <xsl:when test="starts-with(translate($signatures[5], '&#34;', ''), 'http://digital.slub-dresden.de')">
                                <xsl:variable name="webpage" select="unparsed-text(translate($signatures[5], '&#34;', ''))"/>
                                <xsl:value-of select="concat(substring-before(substring-after($webpage, 'title=&quot;Einzelseite als Bild herunterladen (JPG)&quot; target=&quot;_blank&quot; href=&quot;'), 'original.jpg&quot;'), 'thumbnail.jpg')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of select="translate(translate($signatures[5], '&#34;', ''), ' ', '')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:element>
                <xsl:if test="contains($signatures[5], ' ')">
                    <xsl:message>Fehler: Whitespace in Thumbnail-URL für <xsl:value-of select="$signatures[2]"/></xsl:message>
                </xsl:if>
                <xsl:if test="starts-with($signatures[5], 'http://')">
                    <xsl:message>Fehler: 'http' statt 'https' für Thumbnail von <xsl:value-of select="$signatures[2]"/></xsl:message>
                </xsl:if>
            </xsl:if>
            
            <!-- completeness -->
            <xsl:if test="(normalize-space(translate($signatures[6], '&#34;', '')) != '')">
                <xsl:choose>
                    
                    <xsl:when test="not(empty(index-of((
                        'Komplett','komplett','complete', 
                        'komplett (nur Buchblock)', 'vollständig (nur Buchblock)', 'complete (bookblock only)',
                        'komplett (Buchblock und Spiegel)', 'vollständig (Buchblock und Spiegel)', 'complete (bookblock and paste-down)',
                        'komplett (Buchblock und Deckel)', 'vollständig (Buchblock und Deckel)', 'complete (bookblock and cover)',
                        'komplett (Buchblock, Deckel und Schnitte)', 'vollständig (Buchblock, Deckel und Schnitte)', 'complete (bookblock, cover, and edges)',
                        'komplett (keine weiteren Aufnahmen möglich, z.B. Fragmente)', 'vollständig (keine weiteren Aufnahmen möglich, z.B. Fragmente)', 'complete (no further images possible, e.g. fragments)',
                        'Teilweise', 'teilweise', 'partial',
                        'Teilweise (Beispielseiten)', 'teilweise (Beispielseiten)', 'partial (example pages)', 
                        'Teilweise (zusammenhängende Seiten)', 'teilweise (zusammenhängende Seiten)', 'partial (consecutive pages)'
                        ), translate($signatures[6], '&#34;', ''))))">
                        <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                            <!--completeness-->
                            <xsl:attribute name="type" select=" 'DIGI-B' "/>
                            <xsl:attribute name="target">
                                <xsl:choose>
                                    <xsl:when test="translate($signatures[6], '&#34;', '') = 'Komplett' 
                                                 or translate($signatures[6], '&#34;', '') = 'komplett' 
                                                 or translate($signatures[6], '&#34;', '') = 'complete' "><xsl:value-of select="concat($base, 'DIGI-B363')"/></xsl:when>
                                    <xsl:when test="contains(translate($signatures[6], '&#34;', ''), '(nur Buchblock)') 
                                                 or contains(translate($signatures[6], '&#34;', ''), '(bookblock only)') "><xsl:value-of select="concat($base, 'DIGI-B363')"/></xsl:when>
                                    <xsl:when test="contains(translate($signatures[6], '&#34;', ''), '(Buchblock und Spiegel)') 
                                                 or contains(translate($signatures[6], '&#34;', ''), '(bookblock and paste-down)') "><xsl:value-of select="concat($base, 'DIGI-B363')"/></xsl:when>
                                    <xsl:when test="contains(translate($signatures[6], '&#34;', ''), '(Buchblock und Deckel)') 
                                                 or contains(translate($signatures[6], '&#34;', ''), '(bookblock and cover)') "><xsl:value-of select="concat($base, 'DIGI-B363')"/></xsl:when>
                                    <xsl:when test="contains(translate($signatures[6], '&#34;', ''), '(Buchblock, Deckel und Schnitte)') 
                                                 or contains(translate($signatures[6], '&#34;', ''), '(bookblock, cover, and edges)') "><xsl:value-of select="concat($base, 'DIGI-B363')"/></xsl:when>
                                    <xsl:when test="translate($signatures[6], '&#34;', '') = 'Teilweise' 
                                                 or translate($signatures[6], '&#34;', '') = 'teilweise' 
                                                 or translate($signatures[6], '&#34;', '') = 'partial' "><xsl:value-of select="concat($base, 'DIGI-B575')"/></xsl:when>
                                    <xsl:when test="contains(translate($signatures[6], '&#34;', ''), '(Beispielseiten)') 
                                                 or contains(translate($signatures[6], '&#34;', ''), '(example pages)') "><xsl:value-of select="concat($base, 'DIGI-B575')"/></xsl:when>
                                    <xsl:when test="contains(translate($signatures[6], '&#34;', ''), '(zusammenhängende Seiten)') 
                                                 or contains(translate($signatures[6], '&#34;', ''), '(consecutive pages)') "><xsl:value-of select="concat($base, 'DIGI-B575')"/></xsl:when>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>completeness '<xsl:value-of select="translate($signatures[6], '&#34;', '')"/>' is not known</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <!-- sourceType -->
            <xsl:if test="(normalize-space(translate($signatures[7], '&#34;', '')) != '')">
                <xsl:choose>
                    <xsl:when test="not(empty(index-of(('Original', 'original', 'Reproduktion'), translate($signatures[7], '&#34;', ''))))">
                        <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                            <!--sourceType-->
                            <xsl:attribute name="type" select=" 'DIGI-D' "/>
                            <xsl:attribute name="target">
                                <xsl:choose>
                                    <xsl:when test="translate($signatures[7], '&#34;', '') = 'Original' 
                                                 or translate($signatures[7], '&#34;', '') = 'original' "><xsl:value-of select="concat($base, 'DIGI-D139')"/></xsl:when>
                                    <xsl:when test="translate($signatures[7], '&#34;', '') = 'Reproduktion' "><xsl:value-of select="concat($base, 'DIGI-D537')"/></xsl:when>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>sourceType '<xsl:value-of select="translate($signatures[7], '&#34;', '')"/>' is not known</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <!-- digitizationType -->
            <xsl:if test="(normalize-space(translate($signatures[8], '&#34;', '')) != '')">
                <xsl:choose>
                    <xsl:when test="not(empty(index-of((
                        'Standard', 'Farbe', 'color', 
                        'Graustufen', 'greyscale', 
                        's/w', 'Bitonal', 'bitonal', 
                        'Thermografie', 'Thermographie', 
                        'Spektral', 
                        'Mikroskop', 
                        '3D', 
                        'andere'), translate($signatures[8], '&#34;', ''))))">
                        <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                            <!--digitizationType-->
                            <xsl:attribute name="type" select=" 'DIGI-C' "/>
                            <xsl:attribute name="target">
                                <xsl:choose>
                                    <xsl:when test="translate($signatures[8], '&#34;', '') = 'Standard' 
                                                 or translate($signatures[8], '&#34;', '') = 'Farbe' 
                                                 or translate($signatures[8], '&#34;', '') = 'color' "><xsl:value-of select="concat($base, 'DIGI-C834')"/></xsl:when>
                                    <xsl:when test="translate($signatures[8], '&#34;', '') = 'Graustufen' 
                                                 or translate($signatures[8], '&#34;', '') = 'greyscale' "><xsl:value-of select="concat($base, 'DIGI-C959')"/></xsl:when>
                                    <xsl:when test="translate($signatures[8], '&#34;', '') = 's/w' 
                                                 or translate($signatures[8], '&#34;', '') = 'Bitonal' 
                                                 or translate($signatures[8], '&#34;', '') = 'bitonal' "><xsl:value-of select="concat($base, 'DIGI-C394')"/></xsl:when>
                                    <xsl:when test="translate($signatures[8], '&#34;', '') = 'Thermografie' 
                                                 or translate($signatures[8], '&#34;', '') = 'Thermographie'"><xsl:value-of select="concat($base, 'DIGI-C738')"/></xsl:when>
                                    <xsl:when test="translate($signatures[8], '&#34;', '') = 'Spektral' "><xsl:value-of select="concat($base, 'DIGI-C799')"/></xsl:when>
                                    <xsl:when test="translate($signatures[8], '&#34;', '') = 'Mikroskop' "><xsl:value-of select="concat($base, 'DIGI-C526')"/></xsl:when>
                                    <xsl:when test="translate($signatures[8], '&#34;', '') = '3D' "><xsl:value-of select="concat($base, 'DIGI-C970')"/></xsl:when>
                                    <xsl:when test="translate($signatures[8], '&#34;', '') = 'andere' "><xsl:value-of select="concat($base, 'DIGI-C444')"/></xsl:when>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>digitizationType '<xsl:value-of select="translate($signatures[8], '&#34;', '')"/>' is not known</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <!-- captureType -->
            <xsl:if test="(normalize-space(translate($signatures[9], '&#34;', '')) != '')">
                <xsl:choose>
                    <xsl:when test="not(empty(index-of(('Einzelseite', 'singlePage', 'Doppelseite', 'Detail'), translate($signatures[9], '&#34;', ''))))">
                        <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                            <!--captureType-->
                            <xsl:attribute name="type" select=" 'DIGI-A' "/>
                            <xsl:attribute name="target">
                                <xsl:choose>
                                    <xsl:when test="translate($signatures[9], '&#34;', '') = 'Einzelseite' 
                                                 or translate($signatures[9], '&#34;', '') = 'singlePage' "><xsl:value-of select="concat($base, 'DIGI-A445')"/></xsl:when>
                                    <xsl:when test="translate($signatures[9], '&#34;', '') = 'Doppelseite' "><xsl:value-of select="concat($base, 'DIGI-A635')"/></xsl:when>
                                    <xsl:when test="translate($signatures[9], '&#34;', '') = 'Detail' "><xsl:value-of select="concat($base, 'DIGI-A210')"/></xsl:when>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>captureType '<xsl:value-of select="translate($signatures[9], '&#34;', '')"/>' is not known</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <!-- digitizationDate -->
            <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:variable name="date1" select="normalize-space(translate($signatures[10], '&#34;', ''))"/>
                <xsl:variable name="date2" select="normalize-space(translate($signatures[11], '&#34;', ''))"/>
                <xsl:choose>
                    <xsl:when test="matches($date1, '\d\d\.\d\d\.\d\d\d\d')">
                        <xsl:attribute name="when" select="concat(substring($date1, 7, 4), '-', substring($date1, 4, 2), '-', substring($date1, 1, 2))"/>
                    </xsl:when>
                    <xsl:when test="matches($date1, '\d\.\d\d\.\d\d\d\d')">
                        <xsl:attribute name="when" select="concat(substring($date1, 6, 4), '-', substring($date1, 3, 2), '-0', substring($date1, 1, 1))"/>
                    </xsl:when>
                    <xsl:when test="matches($date1, '\d\d\.\d\.\d\d\d\d')">
                        <xsl:attribute name="when" select="concat(substring($date1, 6, 4), '-0', substring($date1, 4, 1), '-', substring($date1, 1, 2))"/>
                    </xsl:when>
                    <xsl:when test="matches($date1, '\d\.\d\.\d\d\d\d')">
                        <xsl:attribute name="when" select="concat(substring($date1, 5, 4), '-0', substring($date1, 3, 1), '-0', substring($date1, 1, 1))"/>
                    </xsl:when>
                    <xsl:when test="matches($date1, '\d\d\.\d\d\d\d')">
                        <xsl:attribute name="when" select="concat(substring($date1, 4, 4), '-', substring($date1, 1, 2))"/>
                    </xsl:when>
                    <xsl:when test="matches($date1, '\d\d\d\d\-\d\d\d\d')">
                        <xsl:attribute name="when" select="substring($date1, 6, 4)"/>
                    </xsl:when>
                    <xsl:when test="matches($date1, '\d\d\d\d')">
                        <xsl:attribute name="when" select="$date1"/>
                    </xsl:when>
                    
                    
                    <xsl:when test="matches($date2, '\d\d\.\d\d\.\d\d\d\d')">
                        <xsl:attribute name="when" select="concat(substring($date2, 7, 4), '-', substring($date2, 4, 2), '-', substring($date2, 1, 2))"/>
                    </xsl:when>
                    <xsl:when test="matches($date2, '\d\.\d\d\.\d\d\d\d')">
                        <xsl:attribute name="when" select="concat(substring($date2, 6, 4), '-', substring($date2, 3, 2), '-0', substring($date2, 1, 1))"/>
                    </xsl:when>
                    <xsl:when test="matches($date2, '\d\d\.\d\.\d\d\d\d')">
                        <xsl:attribute name="when" select="concat(substring($date2, 6, 4), '-0', substring($date2, 4, 1), '-', substring($date2, 1, 2))"/>
                    </xsl:when>
                    <xsl:when test="matches($date2, '\d\.\d\.\d\d\d\d')">
                        <xsl:attribute name="when" select="concat(substring($date2, 5, 4), '-0', substring($date2, 3, 1), '-0', substring($date2, 1, 1))"/>
                    </xsl:when>
                    <xsl:when test="matches($date2, '\d\d\.\d\d\d\d')">
                        <xsl:attribute name="when" select="concat(substring($date2, 4, 4), '-', substring($date2, 1, 2))"/>
                    </xsl:when>
                    <xsl:when test="matches($date2, '\d\d\d\d\-\d\d\d\d')">
                        <xsl:attribute name="when" select="substring($date2, 6, 4)"/>
                    </xsl:when>
                    <xsl:when test="matches($date2, '\d\d\d\d')">
                        <xsl:attribute name="when" select="$date2"/>
                    </xsl:when>
                </xsl:choose>
                <xsl:attribute name="type"><xsl:text>digitized</xsl:text></xsl:attribute>
            </xsl:element>
            
            <!-- publicationDate-->
            <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:variable name="date1" select="normalize-space(translate($signatures[10], '&#34;', ''))"/>
                <xsl:variable name="date2" select="normalize-space(translate($signatures[11], '&#34;', ''))"/>
                <xsl:choose>
                    <xsl:when test="matches($date2, '\d\d\.\d\d\.\d\d\d\d')">
                        <xsl:attribute name="when" select="concat(substring($date2, 7, 4), '-', substring($date2, 4, 2), '-', substring($date2, 1, 2))"/>
                    </xsl:when>
                    <xsl:when test="matches($date2, '\d\.\d\d\.\d\d\d\d')">
                        <xsl:attribute name="when" select="concat(substring($date2, 6, 4), '-', substring($date2, 3, 2), '-0', substring($date2, 1, 1))"/>
                    </xsl:when>
                    <xsl:when test="matches($date2, '\d\d\.\d\.\d\d\d\d')">
                        <xsl:attribute name="when" select="concat(substring($date2, 6, 4), '-0', substring($date2, 4, 1), '-', substring($date2, 1, 2))"/>
                    </xsl:when>
                    <xsl:when test="matches($date2, '\d\.\d\.\d\d\d\d')">
                        <xsl:attribute name="when" select="concat(substring($date2, 5, 4), '-0', substring($date2, 3, 1), '-0', substring($date2, 1, 1))"/>
                    </xsl:when>
                    <xsl:when test="matches($date2, '\d\d\.\d\d\d\d')">
                        <xsl:attribute name="when" select="concat(substring($date2, 4, 4), '-', substring($date2, 1, 2))"/>
                    </xsl:when>
                    <xsl:when test="matches($date2, '\d\d\d\d\-\d\d\d\d')">
                        <xsl:attribute name="when" select="substring($date2, 6, 4)"/>
                    </xsl:when>
                    <xsl:when test="matches($date2, '\d\d\d\d')">
                        <xsl:attribute name="when" select="$date2"/>
                    </xsl:when>
                    
                    
                    <xsl:when test="matches($date1, '\d\d\.\d\d\.\d\d\d\d')">
                        <xsl:attribute name="when" select="concat(substring($date1, 7, 4), '-', substring($date1, 4, 2), '-', substring($date1, 1, 2))"/>
                    </xsl:when>
                    <xsl:when test="matches($date1, '\d\.\d\d\.\d\d\d\d')">
                        <xsl:attribute name="when" select="concat(substring($date1, 6, 4), '-', substring($date1, 3, 2), '-0', substring($date1, 1, 1))"/>
                    </xsl:when>
                    <xsl:when test="matches($date1, '\d\d\.\d\.\d\d\d\d')">
                        <xsl:attribute name="when" select="concat(substring($date1, 6, 4), '-0', substring($date1, 4, 1), '-', substring($date1, 1, 2))"/>
                    </xsl:when>
                    <xsl:when test="matches($date1, '\d\.\d\.\d\d\d\d')">
                        <xsl:attribute name="when" select="concat(substring($date1, 5, 4), '-0', substring($date1, 3, 1), '-0', substring($date1, 1, 1))"/>
                    </xsl:when>
                    <xsl:when test="matches($date1, '\d\d\.\d\d\d\d')">
                        <xsl:attribute name="when" select="concat(substring($date1, 4, 4), '-', substring($date1, 1, 2))"/>
                    </xsl:when>
                    <xsl:when test="matches($date1, '\d\d\d\d\-\d\d\d\d')">
                        <xsl:attribute name="when" select="substring($date1, 6, 4)"/>
                    </xsl:when>
                    <xsl:when test="matches($date1, '\d\d\d\d')">
                        <xsl:attribute name="when" select="$date1"/>
                    </xsl:when>
                </xsl:choose>
                <xsl:attribute name="type"><xsl:text>published</xsl:text></xsl:attribute>
            </xsl:element>

            <!-- nameOfDigitizingInstitution -->
            <xsl:choose>
                <xsl:when test="(normalize-space(translate($signatures[16], '&#34;', '')) != '') and (normalize-space(translate($signatures[17], '&#34;', '')) != '')">
                    <xsl:element name="orgName" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="ref" select="substring-after(translate($signatures[17], '&#34;', ''), 'd-nb.info/gnd/')"/>
                        <xsl:attribute name="type" select=" 'digitizing' "/>
                        <xsl:value-of select="translate($signatures[16], '&#34;', '')"/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="(normalize-space(translate($signatures[16], '&#34;', '')) != '')">
                    <xsl:message>nameOfDigitizingInstitution: Name fehlt für <xsl:value-of select="translate(translate($signatures[2], '&#34;', ''), ' ', '')"/></xsl:message>
                </xsl:when>
                <xsl:when test="(normalize-space(translate($signatures[17], '&#34;', '')) != '')">
                    <xsl:message>nameOfDigitizingInstitution: GND-ID fehlt für <xsl:value-of select="translate(translate($signatures[2], '&#34;', ''), ' ', '')"/></xsl:message>
                </xsl:when>
            </xsl:choose>
            
            <!-- placeOfDigitizingInstitution -->
            <xsl:choose>
                <xsl:when test="(normalize-space(translate($signatures[18], '&#34;', '')) != '') and (normalize-space(translate($signatures[19], '&#34;', '')) != '')">
                    <xsl:element name="placeName" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="ref" select="substring-after(translate($signatures[19], '&#34;', ''), 'd-nb.info/gnd/')"/>
                        <xsl:attribute name="type" select=" 'digitizing' "/>
                        <xsl:value-of select="translate($signatures[18], '&#34;', '')"/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="(normalize-space(translate($signatures[18], '&#34;', '')) != '')">
                    <xsl:message>placeOfDigitizingInstitution: Name fehlt für <xsl:value-of select="translate(translate($signatures[2], '&#34;', ''), ' ', '')"/></xsl:message>
                </xsl:when>
                <xsl:when test="(normalize-space(translate($signatures[19], '&#34;', '')) != '')">
                    <xsl:message>placeOfDigitizingInstitution: GND-ID fehlt für <xsl:value-of select="translate(translate($signatures[2], '&#34;', ''), ' ', '')"/></xsl:message>
                </xsl:when>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template name="writeFile">
        <xsl:param name="contents"/>
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader xml:lang="de">
                <fileDesc>
                    <titleStmt>
                        <title>KOD-Import für <xsl:value-of select="."/></title>
                    </titleStmt>
                    <publicationStmt>
                        <publisher>
                            <name type="org">Handschriftenportal</name>
                            <ptr target="http://www.handschriftenportal.de"/>
                        </publisher>
                        <availability status="free">
                            <licence target="https://creativecommons.org/publicdomain/zero/1.0/deed.de">
                                <p>Für das Kulturobjektdokument verzichtet das Handschriftenportal auf alle Nutzungsrechte.</p>
                                <p>Für die Nutzung weiterer Daten wie Digitalisaten gelten gegebenenfalls andere Lizenzen. Vgl. die <ref target="http://www.handschriftenportal.de">Nutzungshinweise</ref> des Handschriftenportals.</p>
                            </licence>
                        </availability>
                    </publicationStmt>
                    <sourceDesc>
                        <xsl:for-each select="tokenize($contents, '(\r)|(\n)|(\r\n)')">
                            <xsl:if test="(normalize-space(.) != '') and (normalize-space(.) != '&#xD;')">
                                <msDesc type="hsp:object" xml:lang="de">
                                    <xsl:variable name="signatures" select="tokenize(., '\$')"/>
                                    <msIdentifier>
                                        <settlement>
                                            <xsl:attribute name="key" select="normalize-space(replace(substring-after($signatures[15], 'd-nb.info/gnd/'), '&#34;', ''))"/>
                                            <xsl:value-of select="normalize-space(replace($signatures[14], '&#34;', ''))"/>
                                        </settlement>
                                        <repository>
                                            <xsl:attribute name="key" select="normalize-space(replace(substring-after($signatures[13], 'd-nb.info/gnd/'), '&#34;', ''))"/>
                                            <xsl:value-of select="normalize-space(replace($signatures[12], '&#34;', ''))"/>
                                        </repository>
                                        <idno>
                                            <xsl:value-of select="translate(normalize-space($signatures[2]), '\&quot;', '')"/>
                                        </idno>
                                    </msIdentifier>
                                    <additional>
                                        <surrogates>
                                            <xsl:variable name="signatures" select="tokenize(., '(\$)|(;)')"/>
                                            <xsl:call-template name="insertEntry">
                                                <xsl:with-param name="signatures" select="$signatures"/>
                                            </xsl:call-template>
                                        </surrogates>
                                    </additional>
                                </msDesc>
                            </xsl:if>
                        </xsl:for-each>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <p/>
                </body>
            </text>
        </TEI>
    </xsl:template>

</xsl:stylesheet>
