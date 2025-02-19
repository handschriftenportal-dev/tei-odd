<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="#all"
    version="2.0">

    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>

    <xsl:param name="mode"/>
    
    <xsl:template name="main" match="/">
        <xsl:for-each select="//doc/@href">
            <xsl:variable name="contents" select="unparsed-text(., 'UTF-8')"/>
            <xsl:result-document href="{concat(substring-before(., '.csv'), '.xml')}">
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
                                <xsl:choose>
                                    <xsl:when test="contains($contents, '&#xD;')">
                                        <xsl:for-each select="tokenize($contents, '&#xD;')" >
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
                                                            <xsl:choose>
                                                                <xsl:when test="contains(., '$')">
                                                                    <xsl:variable name="signatures" select="tokenize(., '\$')"/>
                                                                    <xsl:call-template name="insertEntry">
                                                                        <xsl:with-param name="signatures" select="$signatures"/>
                                                                    </xsl:call-template>
                                                                </xsl:when>
                                                                <xsl:when test="contains(., ';')">
                                                                    <xsl:variable name="signatures" select="tokenize(., ';')"/>
                                                                    <xsl:call-template name="insertEntry">
                                                                        <xsl:with-param name="signatures" select="$signatures"/>
                                                                    </xsl:call-template>
                                                                </xsl:when>
                                                            </xsl:choose>
                                                        </surrogates>
                                                    </additional>
                                                </msDesc>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:when test="contains($contents, '&#x0A;')">
                                        <xsl:for-each select="tokenize($contents, '&#x0A;')" >
                                            <xsl:if test="(normalize-space(.) != '') and (normalize-space(.) != '&#x0A;')">
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
                                                            <xsl:choose>
                                                                <xsl:when test="contains(., '$')">
                                                                    <xsl:variable name="signatures" select="tokenize(., '\$')"/>
                                                                    <xsl:call-template name="insertEntry">
                                                                        <xsl:with-param name="signatures" select="$signatures"/>
                                                                    </xsl:call-template>
                                                                </xsl:when>
                                                                <xsl:when test="contains(., ';')">
                                                                    <xsl:variable name="signatures" select="tokenize(., ';')"/>
                                                                    <xsl:call-template name="insertEntry">
                                                                        <xsl:with-param name="signatures" select="$signatures"/>
                                                                    </xsl:call-template>
                                                                </xsl:when>
                                                            </xsl:choose>
                                                        </surrogates>
                                                    </additional>
                                                </msDesc>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                </xsl:choose>
                            </sourceDesc>
                        </fileDesc>
                    </teiHeader>
                    <text>
                        <body>
                            <p/>
                        </body>
                    </text>
                </TEI>
            </xsl:result-document>
            
            <!-- Kopie zum Validieren -->
            <xsl:result-document href="{concat(substring-before(., tokenize(., '/')[12]), '_zuValidieren/', substring-before(tokenize(., '/')[13], '.csv'), '.xml')}">
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
                                <xsl:choose>
                                    <xsl:when test="contains($contents, '&#xD;')">
                                        <xsl:for-each select="tokenize($contents, '&#xD;')" >
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
                                                            <xsl:attribute name="xml:id">
                                                                <xsl:value-of select="concat('_', replace(replace(replace(translate(replace(replace(replace(normalize-space($signatures[2]), '\. ', ' '), '&#34;', ''), '\[Tresor\] ', ''), '  /,\.:()[]+\&lt;\&gt;*#:–°º', '-----------------ff'), '¹', '-1'), '²', '-2'), '³', '-3'))"/>
                                                                <xsl:choose>
                                                                    <xsl:when test="contains($signatures[3], 'urn:')">
                                                                        <xsl:value-of select="concat('_', translate(tokenize($signatures[3], ':')[last()], '\&#34;\&amp;=\?:', ''))"/>
                                                                    </xsl:when>
                                                                    <xsl:when test="contains($signatures[4], 'urn:')">
                                                                        <xsl:value-of select="concat('_', translate(tokenize($signatures[4], ':')[last()], '\&#34;\&amp;=\?:', ''))"/>
                                                                    </xsl:when>
                                                                    <xsl:when test="contains($signatures[3], '/') and contains(tokenize($signatures[3], '/')[last()], 'manifest') ">
                                                                        <xsl:value-of select="concat('_', translate(tokenize($signatures[3], '/')[last() - 1], '\&#34;\&amp;=\?:', ''))"/>
                                                                    </xsl:when>
                                                                    <xsl:when test="contains($signatures[4], '/') and contains(tokenize($signatures[4], '/')[last()], 'manifest') ">
                                                                        <xsl:value-of select="concat('_', translate(tokenize($signatures[4], '/')[last() - 1], '\&#34;\&amp;=\?:', ''))"/>
                                                                    </xsl:when>
                                                                    <xsl:when test="contains($signatures[3], '/')">
                                                                        <xsl:value-of select="concat('_', translate(tokenize($signatures[3], '/')[last()], '\&#34;\&amp;=\?:', ''))"/>
                                                                    </xsl:when>
                                                                    <xsl:when test="contains($signatures[4], '/')">
                                                                        <xsl:value-of select="concat('_', translate(tokenize($signatures[4], '/')[last()], '\&#34;\&amp;=\?:', ''))"/>
                                                                    </xsl:when>
                                                                </xsl:choose>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="translate(normalize-space($signatures[2]), '\&quot;', '')"/>
                                                        </idno>
                                                        <xsl:comment>
                                                            <xsl:choose>
                                                                <xsl:when test="contains($signatures[3], 'urn:')">
                                                                    <xsl:value-of select="concat('1_', tokenize($signatures[3], ':')[last()])"/>
                                                                </xsl:when>
                                                                <xsl:when test="contains($signatures[4], 'urn:')">
                                                                    <xsl:value-of select="concat('2_', tokenize($signatures[4], ':')[last()])"/>
                                                                </xsl:when>
                                                                <xsl:when test="contains($signatures[3], '/') and contains(tokenize($signatures[3], '/')[last()], 'manifest') ">
                                                                    <xsl:value-of select="concat('3_', tokenize($signatures[3], '/')[last() - 1])"/>
                                                                </xsl:when>
                                                                <xsl:when test="contains($signatures[4], '/') and contains(tokenize($signatures[4], '/')[last()], 'manifest') ">
                                                                    <xsl:value-of select="concat('4_', tokenize($signatures[4], '/')[last() - 1])"/>
                                                                </xsl:when>
                                                                <xsl:when test="contains($signatures[3], '/')">
                                                                    <xsl:value-of select="concat('5_', tokenize($signatures[3], '/')[last()])"/>
                                                                </xsl:when>
                                                                <xsl:when test="contains($signatures[4], '/')">
                                                                    <xsl:value-of select="concat('6_', tokenize($signatures[4], '/')[last()])"/>
                                                                </xsl:when>
                                                            </xsl:choose>
                                                        </xsl:comment>
                                                    </msIdentifier>
                                                    <additional>
                                                        <surrogates>
                                                            <xsl:choose>
                                                                <xsl:when test="contains(., '$')">
                                                                    <xsl:variable name="signatures" select="tokenize(., '\$')"/>
                                                                    <xsl:call-template name="insertEntry">
                                                                        <xsl:with-param name="signatures" select="$signatures"/>
                                                                    </xsl:call-template>
                                                                </xsl:when>
                                                                <xsl:when test="contains(., ';')">
                                                                    <xsl:variable name="signatures" select="tokenize(., ';')"/>
                                                                    <xsl:call-template name="insertEntry">
                                                                        <xsl:with-param name="signatures" select="$signatures"/>
                                                                    </xsl:call-template>
                                                                </xsl:when>
                                                            </xsl:choose>
                                                        </surrogates>
                                                    </additional>
                                                </msDesc>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:when test="contains($contents, '&#x0A;')">
                                        <xsl:for-each select="tokenize($contents, '&#x0A;')" >
                                            <xsl:if test="(normalize-space(.) != '') and (normalize-space(.) != '&#x0A;')">
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
                                                            <xsl:attribute name="xml:id">
                                                                <xsl:value-of select="concat('_', replace(replace(replace(translate(replace(replace(replace(normalize-space($signatures[2]), '\. ', ' '), '&#34;', ''), '\[Tresor\] ', ''), '  /,\.:()[]+\&lt;\&gt;*#:–°º', '-----------------ff'), '¹', '-1'), '²', '-2'), '³', '-3'))"/>
                                                                <xsl:choose>
                                                                    <xsl:when test="contains($signatures[3], 'urn:')">
                                                                        <xsl:value-of select="concat('_', translate(tokenize($signatures[3], ':')[last()], '\&#34;\&amp;=\?:', ''))"/>
                                                                    </xsl:when>
                                                                    <xsl:when test="contains($signatures[4], 'urn:')">
                                                                        <xsl:value-of select="concat('_', translate(tokenize($signatures[4], ':')[last()], '\&#34;\&amp;=\?:', ''))"/>
                                                                    </xsl:when>
                                                                    <xsl:when test="contains($signatures[3], '/') and contains(tokenize($signatures[3], '/')[last()], 'manifest') ">
                                                                        <xsl:value-of select="concat('_', translate(tokenize($signatures[3], '/')[last() - 1], '\&#34;\&amp;=\?:', ''))"/>
                                                                    </xsl:when>
                                                                    <xsl:when test="contains($signatures[4], '/') and contains(tokenize($signatures[4], '/')[last()], 'manifest') ">
                                                                        <xsl:value-of select="concat('_', translate(tokenize($signatures[4], '/')[last() - 1], '\&#34;\&amp;=\?:', ''))"/>
                                                                    </xsl:when>
                                                                    <xsl:when test="contains($signatures[3], '/')">
                                                                        <xsl:value-of select="concat('_', translate(tokenize($signatures[3], '/')[last()], '\&#34;\&amp;=\?:', ''))"/>
                                                                    </xsl:when>
                                                                    <xsl:when test="contains($signatures[4], '/')">
                                                                        <xsl:value-of select="concat('_', translate(tokenize($signatures[4], '/')[last()], '\&#34;\&amp;=\?:', ''))"/>
                                                                    </xsl:when>
                                                                </xsl:choose>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="translate(normalize-space($signatures[2]), '\&quot;', '')"/>
                                                        </idno>
                                                        <xsl:comment>
                                                            <xsl:choose>
                                                                <xsl:when test="contains($signatures[3], 'urn:')">
                                                                    <xsl:value-of select="concat('1_', tokenize($signatures[3], ':')[last()])"/>
                                                                </xsl:when>
                                                                <xsl:when test="contains($signatures[4], 'urn:')">
                                                                    <xsl:value-of select="concat('2_', tokenize($signatures[4], ':')[last()])"/>
                                                                </xsl:when>
                                                                <xsl:when test="contains($signatures[3], '/') and contains(tokenize($signatures[3], '/')[last()], 'manifest') ">
                                                                    <xsl:value-of select="concat('3_', tokenize($signatures[3], '/')[last() - 1])"/>
                                                                </xsl:when>
                                                                <xsl:when test="contains($signatures[4], '/') and contains(tokenize($signatures[4], '/')[last()], 'manifest') ">
                                                                    <xsl:value-of select="concat('4_', tokenize($signatures[4], '/')[last() - 1])"/>
                                                                </xsl:when>
                                                                <xsl:when test="contains($signatures[3], '/')">
                                                                    <xsl:value-of select="concat('5_', tokenize($signatures[3], '/')[last()])"/>
                                                                </xsl:when>
                                                                <xsl:when test="contains($signatures[4], '/')">
                                                                    <xsl:value-of select="concat('6_', tokenize($signatures[4], '/')[last()])"/>
                                                                </xsl:when>
                                                            </xsl:choose>
                                                        </xsl:comment>
                                                    </msIdentifier>
                                                    <additional>
                                                        <surrogates>
                                                            <xsl:choose>
                                                                <xsl:when test="contains(., '$')">
                                                                    <xsl:variable name="signatures" select="tokenize(., '\$')"/>
                                                                    <xsl:call-template name="insertEntry">
                                                                        <xsl:with-param name="signatures" select="$signatures"/>
                                                                    </xsl:call-template>
                                                                </xsl:when>
                                                                <xsl:when test="contains(., ';')">
                                                                    <xsl:variable name="signatures" select="tokenize(., ';')"/>
                                                                    <xsl:call-template name="insertEntry">
                                                                        <xsl:with-param name="signatures" select="$signatures"/>
                                                                    </xsl:call-template>
                                                                </xsl:when>
                                                            </xsl:choose>
                                                        </surrogates>
                                                    </additional>
                                                </msDesc>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                </xsl:choose>
                            </sourceDesc>
                        </fileDesc>
                    </teiHeader>
                    <text>
                        <body>
                            <p/>
                        </body>
                    </text>
                </TEI>
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
            <xsl:choose>
                <xsl:when test="contains(translate($signatures[4], '&#34;', ''), ',')">
                    <xsl:for-each select="tokenize(translate($signatures[4], '&#34;', ''), ',')">
                        <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type"><xsl:text>other</xsl:text></xsl:attribute>
                            <xsl:attribute name="target"><xsl:value-of select="translate(., ' ', '')"/></xsl:attribute>
                        </xsl:element>
                        <xsl:if test="contains($signatures[4], ' ')">
                            <xsl:message>Fehler: Whitespace in other-URL für <xsl:value-of select="$signatures[2]"/></xsl:message>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="contains(translate($signatures[4], '&#34;', ''), ';')">
                    <xsl:for-each select="tokenize(translate($signatures[4], '&#34;', ''), ';')">
                        <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type"><xsl:text>other</xsl:text></xsl:attribute>
                            <xsl:attribute name="target"><xsl:value-of select="translate(., ' ', '')"/></xsl:attribute>
                        </xsl:element>
                        <xsl:if test="contains($signatures[4], ' ')">
                            <xsl:message>Fehler: Whitespace in other-URL für <xsl:value-of select="$signatures[2]"/></xsl:message>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="(normalize-space(translate($signatures[4], '&#34;', '')) != '')">
                    <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:attribute name="type"><xsl:text>other</xsl:text></xsl:attribute>
                        <xsl:attribute name="target"><xsl:value-of select="translate(translate($signatures[4], '&#34;', ''), ' ', '')"/></xsl:attribute>
                    </xsl:element>
                    <xsl:if test="contains($signatures[4], ' ')">
                        <xsl:message>Fehler: Whitespace in other-URL für <xsl:value-of select="$signatures[2]"/></xsl:message>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
            
            <!-- thumbnailURL -->
            <xsl:if test="(normalize-space(translate($signatures[5], '&#34;', '')) != '')">
                <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="type"><xsl:text>thumbnail</xsl:text></xsl:attribute>
                    <xsl:attribute name="target">
                        <xsl:choose>
                            <xsl:when test="starts-with(translate($signatures[5], '&#34;', ''), 'http://digital.slub-dresden.de')">
                                <xsl:variable name="webpage" select="unparsed-text(translate($signatures[5], '&#34;', ''))" as="xs:string"/>
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
                    <xsl:when test="not(empty(index-of(('Komplett', 'komplett', 'complete', 'Teilweise'), translate($signatures[6], '&#34;', ''))))">
                        <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type"><xsl:text>completeness</xsl:text></xsl:attribute>
                            <xsl:attribute name="target">
                                <xsl:text>http://normdaten.staatsbibliothek-berlin.de/vocabulary/completeness/</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="translate($signatures[6], '&#34;', '') = 'Komplett' 
                                                 or translate($signatures[6], '&#34;', '') = 'komplett' 
                                                 or translate($signatures[6], '&#34;', '') = 'complete' ">complete</xsl:when>
                                    <xsl:when test="translate($signatures[6], '&#34;', '') = 'Teilweise' ">partial</xsl:when>
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
                            <xsl:attribute name="type"><xsl:text>sourceType</xsl:text></xsl:attribute>
                            <xsl:attribute name="target">
                                <xsl:text>http://normdaten.staatsbibliothek-berlin.de/vocabulary/sourceType/</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="translate($signatures[7], '&#34;', '') = 'Original' 
                                                 or translate($signatures[7], '&#34;', '') = 'original' ">original</xsl:when>
                                    <xsl:when test="translate($signatures[7], '&#34;', '') = 'Reproduktion' ">reproduction</xsl:when>
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
                    <xsl:when test="not(empty(index-of(('Standard', 'Farbe', 'color', 'Graustufen', 's/w', 'Bitonal', 'bitonal', 'Thermografie', 'Thermographie', 'Spektral', 'Mikroskop', '3D', 'andere'), translate($signatures[8], '&#34;', ''))))">
                        <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:attribute name="type"><xsl:text>digitizationType</xsl:text></xsl:attribute>
                            <xsl:attribute name="target">
                                <xsl:text>http://normdaten.staatsbibliothek-berlin.de/vocabulary/digitizationType/</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="translate($signatures[8], '&#34;', '') = 'Standard' 
                                                 or translate($signatures[8], '&#34;', '') = 'Farbe' 
                                                 or translate($signatures[8], '&#34;', '') = 'color' ">color</xsl:when>
                                    <xsl:when test="translate($signatures[8], '&#34;', '') = 'Graustufen' ">greyscale</xsl:when>
                                    <xsl:when test="translate($signatures[8], '&#34;', '') = 's/w' 
                                                 or translate($signatures[8], '&#34;', '') = 'Bitonal' 
                                                 or translate($signatures[8], '&#34;', '') = 'bitonal' ">bw</xsl:when>
                                    <xsl:when test="translate($signatures[8], '&#34;', '') = 'Thermografie' 
                                                 or translate($signatures[8], '&#34;', '') = 'Thermographie'">thermo</xsl:when>
                                    <xsl:when test="translate($signatures[8], '&#34;', '') = 'Spektral' ">spectral</xsl:when>
                                    <xsl:when test="translate($signatures[8], '&#34;', '') = 'Mikroskop' ">microscope</xsl:when>
                                    <xsl:when test="translate($signatures[8], '&#34;', '') = '3D' ">threeD</xsl:when>
                                    <xsl:when test="translate($signatures[8], '&#34;', '') = 'andere' ">other</xsl:when>
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
                            <xsl:attribute name="type"><xsl:text>captureType</xsl:text></xsl:attribute>
                            <xsl:attribute name="target">
                                <xsl:text>http://normdaten.staatsbibliothek-berlin.de/vocabulary/captureType/</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="translate($signatures[9], '&#34;', '') = 'Einzelseite' 
                                                 or translate($signatures[9], '&#34;', '') = 'singlePage' ">singlePage</xsl:when>
                                    <xsl:when test="translate($signatures[9], '&#34;', '') = 'Doppelseite' ">opening</xsl:when>
                                    <xsl:when test="translate($signatures[9], '&#34;', '') = 'Detail' ">detail</xsl:when>
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
    
</xsl:stylesheet>
