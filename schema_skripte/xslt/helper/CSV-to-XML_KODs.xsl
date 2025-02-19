<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="#all"
    version="2.0">

    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>

    <xsl:param name="mode"/>
    <xsl:variable name="toBeReplaced" select=" '‘' "/>
    <xsl:variable name="replacement" select=" 'f' "/>
    
    <xsl:template name="main" match="/">
        <xsl:for-each select="//doc/@href">
            <xsl:variable name="contents" select="unparsed-text(., 'UTF-8')"/>
            <!--<xsl:variable name="sortKeys" select="unparsed-text(replace(., '01', '05'), 'UTF-8')"/>-->
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
                                        <p>Für die Nutzung weiterer Daten wie Digitalisaten gelten gegebenenfalls andere Lizenzen. Vgl. die <ref target="http://www.handschriftenportal.de">Copyright Information </ref> des Handschriftenportals.</p>
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
                                                            <xsl:attribute name="key" select="normalize-space(replace($signatures[2], '&#34;', ''))"/>
                                                            <xsl:value-of select="normalize-space(replace($signatures[1], '&#34;', ''))"/>
                                                        </settlement>
                                                        <repository>
                                                            <xsl:if test="normalize-space(replace($signatures[4], '&#34;', '')) != ''">
                                                                <xsl:attribute name="key" select="normalize-space(replace($signatures[4], '&#34;', ''))"/>
                                                            </xsl:if>
                                                            <xsl:value-of select="normalize-space(replace($signatures[3], '&#34;', ''))"/>
                                                        </repository>
                                                        <idno>
                                                            <xsl:attribute name="xml:id">
                                                                <xsl:value-of select="concat('_', 
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    translate(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(normalize-space($signatures[5]), $toBeReplaced, $replacement)
                                                                    , '\. ', ' ')
                                                                    , '&#34;', '')
                                                                    , '&amp;', '-')
                                                                    , '&lt;', '-')
                                                                    , '&gt;', '-')
                                                                    , '\[Tresor\] ', '')
                                                                    , '  °º/,;.:()[]=+*#:–', '-------------------')
                                                                    , '¹', '-1')
                                                                    , '²', '-2')
                                                                    , '³', '-3'))"/>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="translate(normalize-space($signatures[5]), '\&quot;', '')"/>
                                                        </idno>
                                                        <xsl:for-each select="$signatures[normalize-space(.) != '']" >
                                                            <xsl:if test="position()gt 5">
                                                                <xsl:variable name="altIdentifier" select="translate(., '\&quot;', '')"/>
                                                                <xsl:if test="$altIdentifier != ''">
                                                                    <altIdentifier type="alternative">
                                                                        <idno><xsl:value-of select="normalize-space($altIdentifier)"/></idno>
                                                                    </altIdentifier>
                                                                </xsl:if>
                                                            </xsl:if>
                                                        </xsl:for-each>
                                                    </msIdentifier>
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
                                                            <xsl:attribute name="key" select="normalize-space(replace($signatures[2], '&#34;', ''))"/>
                                                            <xsl:value-of select="normalize-space(replace($signatures[1], '&#34;', ''))"/>
                                                        </settlement>
                                                        <repository>
                                                            <xsl:if test="normalize-space(replace($signatures[4], '&#34;', '')) != ''">
                                                                <xsl:attribute name="key" select="normalize-space(replace($signatures[4], '&#34;', ''))"/>
                                                            </xsl:if>
                                                            <xsl:value-of select="normalize-space(replace($signatures[3], '&#34;', ''))"/>
                                                        </repository>
                                                        <idno>
                                                            <xsl:attribute name="xml:id">
                                                                <xsl:value-of select="concat('_', 
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    translate(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(normalize-space($signatures[5]), $toBeReplaced, $replacement)
                                                                    , '\. ', ' ')
                                                                    , '&#34;', '')
                                                                    , '&amp;', '-')
                                                                    , '&lt;', '-')
                                                                    , '&gt;', '-')
                                                                    , '\[Tresor\] ', '')
                                                                    , '  °º/,;.:()[]=+*#:–', '-------------------')
                                                                    , '¹', '-1')
                                                                    , '²', '-2')
                                                                    , '³', '-3'))"/>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="translate(normalize-space($signatures[5]), '\&quot;', '')"/>
                                                        </idno>
                                                        <xsl:for-each select="$signatures[normalize-space(.) != '']" >
                                                            <xsl:if test="position()gt 5">
                                                                <xsl:variable name="altIdentifier" select="translate(., '\&quot;', '')"/>
                                                                <xsl:if test="$altIdentifier != ''">
                                                                    <altIdentifier type="alternative">
                                                                        <idno><xsl:value-of select="normalize-space($altIdentifier)"/></idno>
                                                                    </altIdentifier>
                                                                </xsl:if>
                                                            </xsl:if>
                                                        </xsl:for-each>
                                                    </msIdentifier>
                                                </msDesc>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:when test="contains($contents, '\n')">
                                        <xsl:for-each select="tokenize($contents, '\n')" >
                                            <xsl:if test="(normalize-space(.) != '') and (normalize-space(.) != '\n')">
                                                <msDesc type="hsp:object" xml:lang="de">
                                                    <xsl:variable name="signatures" select="tokenize(., '\$')"/>
                                                    <msIdentifier>
                                                        <settlement>
                                                            <xsl:attribute name="key" select="normalize-space(replace($signatures[2], '&#34;', ''))"/>
                                                            <xsl:value-of select="normalize-space(replace($signatures[1], '&#34;', ''))"/>
                                                        </settlement>
                                                        <repository>
                                                            <xsl:if test="normalize-space(replace($signatures[4], '&#34;', '')) != ''">
                                                                <xsl:attribute name="key" select="normalize-space(replace($signatures[4], '&#34;', ''))"/>
                                                            </xsl:if>
                                                            <xsl:value-of select="normalize-space(replace($signatures[3], '&#34;', ''))"/>
                                                        </repository>
                                                        <idno>
                                                            <xsl:attribute name="xml:id">
                                                                <xsl:value-of select="concat('_', 
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    translate(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(normalize-space($signatures[5]), $toBeReplaced, $replacement)
                                                                    , '\. ', ' ')
                                                                    , '&#34;', '')
                                                                    , '&amp;', '-')
                                                                    , '&lt;', '-')
                                                                    , '&gt;', '-')
                                                                    , '\[Tresor\] ', '')
                                                                    , '  °º/,;.:()[]=+*#:–', '-------------------')
                                                                    , '¹', '-1')
                                                                    , '²', '-2')
                                                                    , '³', '-3'))"/>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="translate(normalize-space($signatures[5]), '\&quot;', '')"/>
                                                        </idno>
                                                        <xsl:for-each select="$signatures[normalize-space(.) != '']" >
                                                            <xsl:if test="position()gt 5">
                                                                <xsl:variable name="altIdentifier" select="translate(., '\&quot;', '')"/>
                                                                <xsl:if test="$altIdentifier != ''">
                                                                    <altIdentifier type="alternative">
                                                                        <idno><xsl:value-of select="normalize-space($altIdentifier)"/></idno>
                                                                    </altIdentifier>
                                                                </xsl:if>
                                                            </xsl:if>
                                                        </xsl:for-each>
                                                    </msIdentifier>
                                                </msDesc>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="$mode = 'test'"><xsl:message>single entries or entries separated by anything else for <xsl:value-of select="."/></xsl:message></xsl:if>
                                        <xsl:if test="(normalize-space($contents) != '')">
                                            <msDesc type="hsp:object" xml:lang="de">
                                                <xsl:variable name="signatures" select="tokenize(., '\$')"/>
                                                <msIdentifier>
                                                    <settlement>
                                                        <xsl:attribute name="key" select="normalize-space(replace($signatures[2], '&#34;', ''))"/>
                                                        <xsl:value-of select="normalize-space(replace($signatures[1], '&#34;', ''))"/>
                                                    </settlement>
                                                    <repository>
                                                        <xsl:if test="normalize-space(replace($signatures[4], '&#34;', '')) != ''">
                                                            <xsl:attribute name="key" select="normalize-space(replace($signatures[4], '&#34;', ''))"/>
                                                        </xsl:if>
                                                        <xsl:value-of select="normalize-space(replace($signatures[3], '&#34;', ''))"/>
                                                    </repository>
                                                    <idno>
                                                        <xsl:attribute name="xml:id">
                                                            <xsl:value-of select="concat('_', 
                                                                replace(
                                                                replace(
                                                                replace(
                                                                translate(
                                                                replace(
                                                                replace(
                                                                replace(
                                                                replace(
                                                                replace(
                                                                replace(
                                                                replace(normalize-space($signatures[5]), $toBeReplaced, $replacement)
                                                                , '\. ', ' ')
                                                                , '&#34;', '')
                                                                , '&amp;', '-')
                                                                , '&lt;', '-')
                                                                , '&gt;', '-')
                                                                , '\[Tresor\] ', '')
                                                                , '  °º/,;.:()[]=+*#:–', '-------------------')
                                                                , '¹', '-1')
                                                                , '²', '-2')
                                                                , '³', '-3'))"/>
                                                        </xsl:attribute>
                                                        <xsl:value-of select="translate(normalize-space($signatures[5]), '\&quot;', '')"/>
                                                    </idno>
                                                    <xsl:for-each select="$signatures[normalize-space(.) != '']" >
                                                        <xsl:if test="position()gt 5">
                                                            <xsl:variable name="altIdentifier" select="translate(., '\&quot;', '')"/>
                                                            <xsl:if test="$altIdentifier != ''">
                                                                <altIdentifier type="alternative">
                                                                    <idno><xsl:value-of select="normalize-space($altIdentifier)"/></idno>
                                                                </altIdentifier>
                                                            </xsl:if>
                                                        </xsl:if>
                                                    </xsl:for-each>
                                                </msIdentifier>
                                            </msDesc>
                                        </xsl:if>
                                    </xsl:otherwise>
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
                                        <p>Für die Nutzung weiterer Daten wie Digitalisaten gelten gegebenenfalls andere Lizenzen. Vgl. die <ref target="http://www.handschriftenportal.de">Copyright Information </ref> des Handschriftenportals.</p>
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
                                                            <xsl:attribute name="key" select="normalize-space(replace($signatures[2], '&#34;', ''))"/>
                                                            <xsl:value-of select="normalize-space(replace($signatures[1], '&#34;', ''))"/>
                                                        </settlement>
                                                        <repository>
                                                            <xsl:if test="normalize-space(replace($signatures[4], '&#34;', '')) != ''">
                                                                <xsl:attribute name="key" select="normalize-space(replace($signatures[4], '&#34;', ''))"/>
                                                            </xsl:if>
                                                            <xsl:value-of select="normalize-space(replace($signatures[3], '&#34;', ''))"/>
                                                        </repository>
                                                        <idno>
                                                            <xsl:attribute name="xml:id">
                                                                <xsl:value-of select="concat('_', 
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    translate(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(normalize-space($signatures[5]), $toBeReplaced, $replacement)
                                                                    , '\. ', ' ')
                                                                    , '&#34;', '')
                                                                    , '&amp;', '-')
                                                                    , '&lt;', '-')
                                                                    , '&gt;', '-')
                                                                    , '\[Tresor\] ', '')
                                                                    , '  °º/,;.:()[]=+*#:–', '-------------------')
                                                                    , '¹', '-1')
                                                                    , '²', '-2')
                                                                    , '³', '-3'))"/>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="translate(normalize-space($signatures[5]), '\&quot;', '')"/>
                                                        </idno>
                                                        <xsl:for-each select="$signatures[normalize-space(.) != '']" >
                                                            <xsl:if test="position()gt 5">
                                                                <xsl:variable name="altIdentifier" select="translate(., '\&quot;', '')"/>
                                                                <xsl:if test="$altIdentifier != ''">
                                                                    <altIdentifier type="alternative">
                                                                        <idno><xsl:value-of select="normalize-space($altIdentifier)"/></idno>
                                                                    </altIdentifier>
                                                                </xsl:if>
                                                            </xsl:if>
                                                        </xsl:for-each>
                                                    </msIdentifier>
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
                                                            <xsl:attribute name="key" select="normalize-space(replace($signatures[2], '&#34;', ''))"/>
                                                            <xsl:value-of select="normalize-space(replace($signatures[1], '&#34;', ''))"/>
                                                        </settlement>
                                                        <repository>
                                                            <xsl:if test="normalize-space(replace($signatures[4], '&#34;', '')) != ''">
                                                                <xsl:attribute name="key" select="normalize-space(replace($signatures[4], '&#34;', ''))"/>
                                                            </xsl:if>
                                                            <xsl:value-of select="normalize-space(replace($signatures[3], '&#34;', ''))"/>
                                                        </repository>
                                                        <idno>
                                                            <xsl:attribute name="xml:id">
                                                                <xsl:value-of select="concat('_', 
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    translate(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(normalize-space($signatures[5]), $toBeReplaced, $replacement)
                                                                    , '\. ', ' ')
                                                                    , '&#34;', '')
                                                                    , '&amp;', '-')
                                                                    , '&lt;', '-')
                                                                    , '&gt;', '-')
                                                                    , '\[Tresor\] ', '')
                                                                    , '  °º/,;.:()[]=+*#:–', '-------------------')
                                                                    , '¹', '-1')
                                                                    , '²', '-2')
                                                                    , '³', '-3'))"/>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="translate(normalize-space($signatures[5]), '\&quot;', '')"/>
                                                        </idno>
                                                        <xsl:for-each select="$signatures[normalize-space(.) != '']" >
                                                            <xsl:if test="position()gt 5">
                                                                <xsl:variable name="altIdentifier" select="translate(., '\&quot;', '')"/>
                                                                <xsl:if test="$altIdentifier != ''">
                                                                    <altIdentifier type="alternative">
                                                                        <idno><xsl:value-of select="normalize-space($altIdentifier)"/></idno>
                                                                    </altIdentifier>
                                                                </xsl:if>
                                                            </xsl:if>
                                                        </xsl:for-each>
                                                    </msIdentifier>
                                                </msDesc>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:when test="contains($contents, '\n')">
                                        <xsl:for-each select="tokenize($contents, '\n')" >
                                            <xsl:if test="(normalize-space(.) != '') and (normalize-space(.) != '\n')">
                                                <msDesc type="hsp:object" xml:lang="de">
                                                    <xsl:variable name="signatures" select="tokenize(., '\$')"/>
                                                    <msIdentifier>
                                                        <settlement>
                                                            <xsl:attribute name="key" select="normalize-space(replace($signatures[2], '&#34;', ''))"/>
                                                            <xsl:value-of select="normalize-space(replace($signatures[1], '&#34;', ''))"/>
                                                        </settlement>
                                                        <repository>
                                                            <xsl:if test="normalize-space(replace($signatures[4], '&#34;', '')) != ''">
                                                                <xsl:attribute name="key" select="normalize-space(replace($signatures[4], '&#34;', ''))"/>
                                                            </xsl:if>
                                                            <xsl:value-of select="normalize-space(replace($signatures[3], '&#34;', ''))"/>
                                                        </repository>
                                                        <idno>
                                                            <xsl:attribute name="xml:id">
                                                                <xsl:value-of select="concat('_', 
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    translate(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(
                                                                    replace(normalize-space($signatures[5]), $toBeReplaced, $replacement)
                                                                    , '\. ', ' ')
                                                                    , '&#34;', '')
                                                                    , '&amp;', '-')
                                                                    , '&lt;', '-')
                                                                    , '&gt;', '-')
                                                                    , '\[Tresor\] ', '')
                                                                    , '  °º/,;.:()[]=+*#:–', '-------------------')
                                                                    , '¹', '-1')
                                                                    , '²', '-2')
                                                                    , '³', '-3'))"/>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="translate(normalize-space($signatures[5]), '\&quot;', '')"/>
                                                        </idno>
                                                        <xsl:for-each select="$signatures[normalize-space(.) != '']" >
                                                            <xsl:if test="position()gt 5">
                                                                <xsl:variable name="altIdentifier" select="translate(., '\&quot;', '')"/>
                                                                <xsl:if test="$altIdentifier != ''">
                                                                    <altIdentifier type="alternative">
                                                                        <idno><xsl:value-of select="normalize-space($altIdentifier)"/></idno>
                                                                    </altIdentifier>
                                                                </xsl:if>
                                                            </xsl:if>
                                                        </xsl:for-each>
                                                    </msIdentifier>
                                                </msDesc>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="$mode = 'test'"><xsl:message>single entries or entries separated by anything else for <xsl:value-of select="."/></xsl:message></xsl:if>
                                        <xsl:if test="(normalize-space($contents) != '')">
                                            <msDesc type="hsp:object" xml:lang="de">
                                                <xsl:variable name="signatures" select="tokenize(., '\$')"/>
                                                <msIdentifier>
                                                    <settlement>
                                                        <xsl:attribute name="key" select="normalize-space(replace($signatures[2], '&#34;', ''))"/>
                                                        <xsl:value-of select="normalize-space(replace($signatures[1], '&#34;', ''))"/>
                                                    </settlement>
                                                    <repository>
                                                        <xsl:if test="normalize-space(replace($signatures[4], '&#34;', '')) != ''">
                                                            <xsl:attribute name="key" select="normalize-space(replace($signatures[4], '&#34;', ''))"/>
                                                        </xsl:if>
                                                        <xsl:value-of select="normalize-space(replace($signatures[3], '&#34;', ''))"/>
                                                    </repository>
                                                    <idno>
                                                        <xsl:attribute name="xml:id">
                                                            <xsl:value-of select="concat('_', 
                                                                replace(
                                                                replace(
                                                                replace(
                                                                translate(
                                                                replace(
                                                                replace(
                                                                replace(
                                                                replace(
                                                                replace(
                                                                replace(
                                                                replace(normalize-space($signatures[5]), $toBeReplaced, $replacement)
                                                                , '\. ', ' ')
                                                                , '&#34;', '')
                                                                , '&amp;', '-')
                                                                , '&lt;', '-')
                                                                , '&gt;', '-')
                                                                , '\[Tresor\] ', '')
                                                                , '  °º/,;.:()[]=+*#:–', '-------------------')
                                                                , '¹', '-1')
                                                                , '²', '-2')
                                                                , '³', '-3'))"/>
                                                        </xsl:attribute>
                                                        <xsl:value-of select="translate(normalize-space($signatures[5]), '\&quot;', '')"/>
                                                    </idno>
                                                    <xsl:for-each select="$signatures[normalize-space(.) != '']" >
                                                        <xsl:if test="position()gt 5">
                                                            <xsl:variable name="altIdentifier" select="translate(., '\&quot;', '')"/>
                                                            <xsl:if test="$altIdentifier != ''">
                                                                <altIdentifier type="alternative">
                                                                    <idno><xsl:value-of select="normalize-space($altIdentifier)"/></idno>
                                                                </altIdentifier>
                                                            </xsl:if>
                                                        </xsl:if>
                                                    </xsl:for-each>
                                                </msIdentifier>
                                            </msDesc>
                                        </xsl:if>
                                    </xsl:otherwise>
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
</xsl:stylesheet>