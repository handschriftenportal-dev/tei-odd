<?xml version="1.0" encoding="UTF-8"?>
<!--
  ~ MIT License
  ~
  ~ Copyright (c) 2023 Staatsbibliothek zu Berlin - Preußischer Kulturbesitz
  ~
  ~ Permission is hereby granted, free of charge, to any person obtaining a copy
  ~ of this software and associated documentation files (the "Software"), to deal
  ~ in the Software without restriction, including without limitation the rights
  ~ to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  ~ copies of the Software, and to permit persons to whom the Software is
  ~ furnished to do so, subject to the following conditions:
  ~
  ~ The above copyright notice and this permission notice shall be included in all
  ~ copies or substantial portions of the Software.
  ~
  ~ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  ~ IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  ~ FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  ~ AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  ~ LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  ~ OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  ~ SOFTWARE.
  ~
  -->

<xsl:stylesheet
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xpath-default-namespace="http://www.tei-c.org/ns/1.0"
	exclude-result-prefixes="#all"
	version="2.0">

	<!-- script for transforming generic TEI-encoded documents into the HSP-TEI dialect / 2022 / schassan@hab.de -->

	<xsl:param name="TEI-schema">@parsedVersion.majorVersion@.@parsedVersion.minorVersion@.@parsedVersion.incrementalVersion@</xsl:param>
	<xsl:param name="availabilityLicence">http://rightsstatements.org/vocab/InC/1.0/</xsl:param>
	<xsl:param name="Trennzeichen"> &#x2014; </xsl:param>
	<xsl:variable name="crlf" select=" '&#x0A;' "/>

	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>

	<xsl:template match="* | @*">
		<xsl:copy>
			<xsl:apply-templates select="* | @* | text()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="* | @*" mode="Volltext">
		<xsl:apply-templates select="* | @* | text()" mode="Volltext"/>
		<xsl:text> </xsl:text>
	</xsl:template>
	<xsl:template match="text()"><xsl:value-of select="."/></xsl:template>
	<xsl:template match="tei:biblScope">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:TEI">
		<xsl:copy>
			<xsl:attribute name="version" select="$TEI-schema"/>
			<xsl:apply-templates select="@xml:id | @xml:lang"/>
			<xsl:apply-templates select="* | node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:abbr">
		<xsl:choose>
			<xsl:when test="parent::tei:bibl">
				<xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:attribute name="type" select=" 'abbr' "/>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:accMat">
		<xsl:element name="msPart" namespace="http://www.tei-c.org/ns/1.0">
			<xsl:choose>
				<xsl:when test="@type = 'fragment' ">
					<xsl:attribute name="type" select=" 'fragment' "/>
				</xsl:when>
				<xsl:when test="starts-with(., 'Fragment')">
					<xsl:attribute name="type" select=" 'fragment' "/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="type" select=" 'accMat' "/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:element name="msIdentifier" namespace="http://www.tei-c.org/ns/1.0">
				<xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:choose>
						<xsl:when test="@type = 'fragment' ">
							<xsl:text>Fragment</xsl:text>
						</xsl:when>
						<xsl:when test="starts-with(., 'Fragmente')">
							<xsl:text>Fragmente</xsl:text>
						</xsl:when>
						<xsl:when test="starts-with(., 'Fragment')">
							<xsl:text>Fragment</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>Einlage</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:element>
			<xsl:element name="head" namespace="http://www.tei-c.org/ns/1.0">
				<xsl:call-template name="writeCoreFields">
					<xsl:with-param name="form">
						<xsl:choose>
							<xsl:when test="@type = 'fragment' ">fragment</xsl:when>
							<xsl:when test="starts-with(., 'Fragment')">fragment</xsl:when>
							<xsl:otherwise>loose insert</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:element>
			<xsl:element name="physDesc" namespace="http://www.tei-c.org/ns/1.0">
				<xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="tei:author">
		<xsl:choose>
			<xsl:when test="parent::tei:bibl">
				<xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:attribute name="role" select=" 'author' "/>
					<xsl:apply-templates select="@*"/>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="parent::tei:titleStmt">
				<xsl:element name="respStmt" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:element name="resp" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:text>Katalogisiert durch </xsl:text>
					</xsl:element>
					<xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="role" select=" 'author' "/>
						<xsl:apply-templates select="@*"/>
						<xsl:apply-templates/>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:attribute name="role" select=" 'author' "/>
					<xsl:apply-templates select="@*"/>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- temporär, bis zu einer Adaption der TEI -->
	<xsl:template match="tei:bibl">
		<xsl:choose>
			<xsl:when test="parent::tei:textLang">
				<xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:copy>
						<xsl:apply-templates select="* | @* | text()"/>
					</xsl:copy>
				</xsl:element>
			</xsl:when>
			<xsl:when test="parent::tei:listBibl[parent::tei:additional]">
				<xsl:if test="preceding-sibling::tei:bibl"><xsl:text> </xsl:text></xsl:if>
				<xsl:apply-templates select="* | text()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="not(starts-with(., tei:abbr[1]))">
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:apply-templates/>
				<xsl:if test="parent::tei:listBibl 
					and following-sibling::tei:bibl
					and not(ends-with(., ';'))
					and not(ends-with(., '.'))
					and not(starts-with(following-sibling::text()[1], ';'))
					and not(starts-with(following-sibling::text()[1], '.'))">
					<xsl:text>; </xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:binding">
		<xsl:element name="msPart" namespace="http://www.tei-c.org/ns/1.0">
			<xsl:attribute name="type" select=" 'binding' "/>
			<xsl:element name="msIdentifier" namespace="http://www.tei-c.org/ns/1.0">
				<xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:text>Einband</xsl:text>
					<xsl:if test="preceding-sibling::tei:binding
						or following-sibling::tei:binding">
						<xsl:value-of select="concat(' ', count(preceding-sibling::tei:binding) +1)"/>
					</xsl:if>
				</xsl:element>
			</xsl:element>
			<xsl:element name="head" namespace="http://www.tei-c.org/ns/1.0">
				<xsl:call-template name="writeCoreFields">
					<xsl:with-param name="form" select=" 'binding' "/>
				</xsl:call-template>
			</xsl:element>
			<xsl:element name="physDesc" namespace="http://www.tei-c.org/ns/1.0">
				<xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="tei:choice">
		<xsl:apply-templates select="tei:abbr | tei:sic | tei:orig"/>
		<xsl:apply-templates select="tei:expan | tei:corr | tei:reg"/>
	</xsl:template>
	<xsl:template match="tei:expan | tei:corr | tei:reg">
		<xsl:text> [</xsl:text><xsl:apply-templates/><xsl:text>] </xsl:text>
	</xsl:template>
	<xsl:template match="tei:ex">
		<xsl:text>(</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>)</xsl:text>
	</xsl:template>

	<xsl:template match="tei:date">
		<xsl:choose>
			<xsl:when test="ancestor::tei:msDesc">
				<xsl:copy>
					<xsl:apply-templates select="node() | @*"/>
				</xsl:copy>
			</xsl:when>
			<xsl:when test="not(@type) or (@type != 'digitised') ">
				<xsl:copy>
					<xsl:apply-templates select="@*[not(name() = 'type')]"/>
					<xsl:choose>
						<xsl:when test="@type = 'issued'">
							<xsl:attribute name="type" select=" 'primary' "/>
						</xsl:when>
						<xsl:otherwise><xsl:apply-templates select="@type"/></xsl:otherwise>
					</xsl:choose>
					<xsl:apply-templates select="* | text()"/>
				</xsl:copy>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:decoDesc">
		<xsl:copy>
			<xsl:element name="decoNote" namespace="http://www.tei-c.org/ns/1.0">
				<xsl:attribute name="type" select=" 'form' "/>
				<xsl:apply-templates/>
			</xsl:element>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:decoNote">
		<xsl:choose>
			<xsl:when test="ancestor::tei:decoDesc">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:when test="parent::tei:msItem">
				<xsl:copy>
					<xsl:attribute name="type" select=" 'content' "/>
					<xsl:apply-templates/>
				</xsl:copy>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:dimensions[not(normalize-space(.)='')][(@type = 'leaf')]" mode="Schlagzeile">
		<!-- Größe -->
		<xsl:apply-templates mode="Schlagzeile"/>
		<xsl:choose>
			<xsl:when test="@unit and not(tei:height/@unit) and not(tei:width/@unit) and not(tei:depth/@unit)">
				<xsl:value-of select="concat(' ',@unit)"/>
			</xsl:when>
			<xsl:when test="tei:height/@unit or tei:width/@unit"/>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="tei:height[not(normalize-space(.)='')]" mode="Schlagzeile">
		<xsl:value-of select="."/>
		<xsl:if test="@unit and not(../tei:width/@unit) and not(../tei:depth/@unit)">
			<xsl:text> </xsl:text>
			<xsl:value-of select="@unit"/>
		</xsl:if>
		<xsl:if test="../tei:width or ../tei:depth">
			<xsl:text> &#x00D7; </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="tei:width[not(normalize-space(.)='')]" mode="Schlagzeile">
		<xsl:value-of select="."/>
		<xsl:if test="@unit and not(../tei:depth/@unit)">
			<xsl:text> </xsl:text>
			<xsl:value-of select="@unit"/>
		</xsl:if>
		<xsl:if test="../tei:depth">
			<xsl:text> &#x00D7; </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="tei:depth[not(normalize-space(.)='')]" mode="Schlagzeile">
		<xsl:value-of select="."/>
		<xsl:if test="@unit">
			<xsl:text> </xsl:text>
			<xsl:value-of select="@unit"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:editor">
		<xsl:choose>
			<xsl:when test="parent::tei:bibl">
				<xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:attribute name="role" select=" 'editor' "/>
					<xsl:apply-templates select="@*"/>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="parent::tei:titleStmt">
				<xsl:element name="respStmt" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:element name="resp" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:text>Herausgegeben durch </xsl:text>
					</xsl:element>
					<xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="role" select=" 'editor' "/>
						<xsl:apply-templates select="@*"/>
						<xsl:apply-templates/>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:attribute name="role" select=" 'editor' "/>
					<xsl:apply-templates select="@*"/>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:extent[not(normalize-space(.)='')]" mode="Schlagzeile">
		<!-- Umfang -->
		<xsl:if test="(ancestor::tei:physDesc/preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type = 'former'][not(@rend='doNotShow')] 
			and not(contains(ancestor::tei:physDesc/preceding-sibling::tei:msIdentifier/tei:idno,concat('olim ',ancestor::tei:physDesc/preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type = 'former'][not(@rend='doNotShow')][1]/tei:idno))))
			or 
			(ancestor::tei:physDesc/tei:objectDesc/tei:supportDesc/@material 
			or (normalize-space(ancestor::tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support//tei:material) != ''))">
			<xsl:value-of select="$Trennzeichen"/>
		</xsl:if>
		<xsl:value-of select="descendant::tei:measure[@type = 'leavesCount']"/>
		<xsl:choose>
			<xsl:when test="descendant::tei:measure[@type = 'leavesCount'] 
				and descendant::tei:measure[(@type = 'pageDimensions') or (@type = 'leavesSize')]">
				<xsl:value-of select="$Trennzeichen"/>
				<xsl:value-of select="descendant::tei:measure[(@type = 'pageDimensions') or (@type = 'leavesSize')]"/>
			</xsl:when>
			<xsl:when test="descendant::tei:measure[@type = 'leavesCount'] 
				and descendant::tei:dimensions[(@type = 'leaf')]">
				<xsl:value-of select="$Trennzeichen"/>
				<xsl:apply-templates select="descendant::tei:dimensions[(@type = 'leaf')]" mode="Schlagzeile"/>
			</xsl:when>
			<xsl:when test="descendant::tei:measure[@type = 'pageDimensions']">
				<xsl:apply-templates select="descendant::tei:measure[@type = 'pageDimensions']" mode="Schlagzeile"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:gap">
		<xsl:text>[&#x2026;]</xsl:text>
	</xsl:template>

	<xsl:template match="tei:head">
		<xsl:choose>
			<xsl:when test="parent::tei:listBibl">
				<xsl:apply-templates/>
				<xsl:choose>
					<xsl:when test="ends-with(.,'.') or ends-with(.,':')"><xsl:text> </xsl:text></xsl:when>
					<xsl:otherwise><xsl:text>: </xsl:text></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="parent::tei:msDesc">
				<xsl:copy>
					<xsl:call-template name="writeCoreFields"/>
				</xsl:copy>
			</xsl:when>
			<xsl:when test="parent::tei:msPart">
				<xsl:copy>
					<xsl:call-template name="writeCoreFields"/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:hi">
		<xsl:choose>
			<xsl:when test="(@rend = 'sup') or (@rend = 'sub')">
				<xsl:copy>
					<xsl:apply-templates select="node() | @*"/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:history">
		<xsl:copy>
			<xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
				<xsl:apply-templates/>
			</xsl:element>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:incipit | tei:explicit | tei:rubric | tei:colophon | tei:finalRubric">
		<xsl:element name="quote" namespace="http://www.tei-c.org/ns/1.0">
			<xsl:attribute name="type" select="local-name()"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="tei:material[not(normalize-space(.)='')]" mode="Schlagzeile">
		<xsl:if test="preceding-sibling::tei:material">
			<xsl:apply-templates select="preceding-sibling::tei:locus[position() = 1]"/>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="following-sibling::tei:material">
				<xsl:value-of select="."/>
				<xsl:text>, </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:msContents">
		<xsl:choose>
			<xsl:when test="tei:msItem or tei:summary">
				<xsl:copy>
					<xsl:apply-templates select="tei:textLang"/>
					<xsl:if test="tei:summary">
						<xsl:element name="msItem" namespace="http://www.tei-c.org/ns/1.0">
							<xsl:attribute name="n" select=" 'summary' "/>
							<xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
								<xsl:attribute name="type" select=" 'text' "/>
								<xsl:apply-templates select="tei:summary"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:apply-templates select="tei:msItem"/>
				</xsl:copy>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:msDesc">
		<xsl:copy>
			<xsl:apply-templates select="@*[not(name() = 'type') and not(name() = 'subtype') and not(name() = 'status')]"/>
			<xsl:attribute name="type" select=" 'hsp:description' "/>
			<xsl:attribute name="subtype" select=" 'medieval' "/>
			<xsl:attribute name="status" select=" 'extern' "/>
			<xsl:apply-templates select="tei:msIdentifier"/>
			<xsl:choose>
				<xsl:when test="tei:head"><xsl:apply-templates select="tei:head"/></xsl:when>
				<xsl:otherwise>
					<xsl:element name="head" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:call-template name="writeCoreFields"/>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="tei:msContents"/>
			<xsl:apply-templates select="tei:physDesc"/>
			<xsl:apply-templates select="tei:history"/>
			<xsl:apply-templates select="tei:additional"/>
			<xsl:apply-templates select="tei:physDesc/tei:bindingDesc/tei:binding"/>
			<xsl:apply-templates select="tei:msPart[descendant::tei:objectDesc[@form = 'fragment']]"/>
			<xsl:apply-templates select="tei:physDesc/tei:accMat[@type eq 'fragment']"/>
			<xsl:apply-templates select="tei:msPart[(@type='booklet') or descendant::tei:objectDesc[@form = 'booklet']]"/>
			<xsl:apply-templates select="tei:physDesc/tei:accMat[@type ne 'fragment']"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:msItem">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="tei:textLang"/>
			<xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
				<xsl:attribute name="type" select=" 'text' "/>
				<xsl:apply-templates select="*[not(self::tei:msItem) and not(self::tei:decoNote) and not(self::tei:textLang)]"/>
			</xsl:element>
			<xsl:apply-templates select="tei:decoNote"/>
			<xsl:apply-templates select="tei:msItem"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:msPart">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="@type = 'fragment' ">
					<xsl:attribute name="type" select=" 'fragment' "/>
				</xsl:when>
				<xsl:when test="descendant::tei:objectDesc[@form = 'fragment']">
					<xsl:attribute name="type" select=" 'fragment' "/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="type" select=" 'booklet' "/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="@*[not(name() = 'type')]"/>
			<xsl:apply-templates select="tei:msIdentifier"/>
			<xsl:choose>
				<xsl:when test="tei:head"><xsl:apply-templates select="tei:head"/></xsl:when>
				<xsl:otherwise>
					<xsl:element name="head" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:call-template name="writeCoreFields">
							<xsl:with-param name="form">
								<xsl:choose>
									<xsl:when test="@type = 'fragment' ">fragment</xsl:when>
									<xsl:when test="descendant::tei:objectDesc[@form = 'fragment']">fragment</xsl:when>
									<xsl:otherwise>booklet</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="tei:msContents"/>
			<xsl:apply-templates select="tei:physDesc"/>
			<xsl:apply-templates select="tei:history"/>
			<xsl:apply-templates select="tei:additional"/>
			<xsl:apply-templates select="tei:msPart[descendant::tei:objectDesc[@form = 'fragment']]"/>
			<xsl:apply-templates select="tei:msPart[descendant::tei:objectDesc[@form = 'codex']]"/>
			<xsl:apply-templates select="tei:physDesc/tei:accMat"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:name">
		<xsl:choose>
			<xsl:when test="@type='person'">
				<xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:if test="preceding-sibling::tei:resp[contains(., 'Beschrieben durch')]
						or preceding-sibling::tei:resp[contains(., 'Katalogisiert durch')]">
						<xsl:attribute name="role" select=" 'author' "/>
					</xsl:if>
					<xsl:value-of select="."/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@type = 'org' ">
				<xsl:copy>
					<xsl:apply-templates select="@* | node()"/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@* | node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:note">
		<xsl:text> </xsl:text>
		<xsl:choose>
			<xsl:when test="parent::tei:bibl">
				<xsl:copy>
					<xsl:apply-templates/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:origDate[not(normalize-space(.)='')]" mode="Schlagzeile">
		<!-- Entstehungszeit -->
		<xsl:if test="preceding-sibling::tei:origDate">
			<xsl:text> / </xsl:text>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="parent::tei:head">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:when test="ancestor::tei:origin">
				<xsl:choose>
					<xsl:when test="not(ancestor::tei:msPart)">
						<xsl:if test="not(preceding-sibling::tei:origDate)">
							<xsl:value-of select="$Trennzeichen"/>
						</xsl:if>
						<xsl:value-of select="."/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="not(preceding::tei:msPart) and not(preceding-sibling::tei:origDate)">
							<xsl:value-of select="$Trennzeichen"/>
						</xsl:if>
						<xsl:value-of select="ancestor::tei:msPart/tei:altIdentifier/tei:idno"/>
						<xsl:text>: </xsl:text>
						<xsl:value-of select="."/>
						<xsl:if test="following::tei:msPart/descendant::tei:origDate">
							<xsl:text> / </xsl:text>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:origPlace[not(normalize-space(.)='')]" mode="Schlagzeile">
		<!-- Entstehungsort -->
		<xsl:choose>
			<xsl:when test="preceding-sibling::tei:origPlace and parent::node()/tei:origPlace[@cert='medium']">
				<xsl:text> oder </xsl:text>
			</xsl:when>
			<xsl:when test="preceding-sibling::tei:origPlace">
				<xsl:text> / </xsl:text>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="parent::tei:head">
				<xsl:value-of select="."/>
				<xsl:if test="exists(@cert) and @cert != 'high' "> (?)</xsl:if>
			</xsl:when>
			<xsl:when test="ancestor::tei:origin">
				<xsl:choose>
					<xsl:when test="not(ancestor::tei:msPart)">
						<xsl:if test="not(preceding-sibling::tei:origPlace)">
							<xsl:value-of select="$Trennzeichen"/>
						</xsl:if>
						<xsl:value-of select="."/>
						<xsl:if test="exists(@cert) and @cert != 'high' "> (?)</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="not(preceding::tei:msPart) and not(preceding-sibling::tei:origPlace)">
							<xsl:value-of select="$Trennzeichen"/>
						</xsl:if>
						<xsl:value-of select="ancestor::tei:msPart/tei:altIdentifier/tei:idno"/>
						<xsl:text>: </xsl:text>
						<xsl:value-of select="."/>
						<xsl:if test="exists(@cert) and @cert != 'high' "> (?)</xsl:if>
						<xsl:if test="following::tei:msPart/descendant::tei:origPlace">
							<xsl:text> / </xsl:text>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:p">
		<xsl:choose>
			<xsl:when test="parent::tei:support and (normalize-space(.) = tei:material)"/>
			<xsl:when test="parent::tei:physDesc 
				or parent::tei:additions 
				or parent::tei:binding 
				or parent::tei:collation 
				or parent::tei:condition 
				or parent::tei:decoNote 
				or parent::tei:extent 
				or parent::tei:foliation 
				or parent::tei:handDesc 
				or parent::tei:handNote 
				or parent::tei:layout 
				or parent::tei:musicNotation 
				or parent::tei:scriptDesc 
				or parent::tei:scriptNote 
				or parent::tei:support 
				or (parent::tei:accMat and parent::tei:accMat/text()) 
				or parent::tei:accMat[. = tei:p] 
				or parent::tei:history or parent::tei:origin or parent::tei:provenance or parent::tei:acquisition 
				or parent::tei:summary">
				<xsl:choose>
					<xsl:when test="@rend = 'break' ">
						<xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
					</xsl:when>
					<xsl:when test="parent::tei:decoNote[preceding-sibling::tei:decoNote]">
						<xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
						<xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
					</xsl:when>
				</xsl:choose>
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:physDesc">
		<xsl:copy>
			<xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
				<xsl:apply-templates select="*[not(self::tei:bindingDesc) and not(self::tei:accMat) and not(self::tei:decoDesc)]"/>
			</xsl:element>
			<xsl:apply-templates select="tei:decoDesc"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:publicationStmt">
		<xsl:copy>
			<xsl:element name="publisher" namespace="http://www.tei-c.org/ns/1.0">
				<xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:attribute name="type">org</xsl:attribute>
					<xsl:text>Handschriftenportal</xsl:text>
				</xsl:element>
			</xsl:element>
			<xsl:choose>
				<xsl:when test="tei:date[ @type = 'issued' ]">
					<xsl:apply-templates select="tei:date[ @type = 'issued' ]"/>
					<xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="when" select="substring(string(current-date()), 1, 10)"/>
						<xsl:attribute name="type">secondary</xsl:attribute>
						<xsl:value-of select="concat(substring(string(current-date()), 9, 2), '.', substring(string(current-date()), 6, 2), '.', substring(string(current-date()), 1, 4))"/>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="when" select="substring(string(current-date()), 1, 10)"/>
						<xsl:attribute name="type">primary</xsl:attribute>
						<xsl:value-of select="concat(substring(string(current-date()), 9, 2), '.', substring(string(current-date()), 6, 2), '.', substring(string(current-date()), 1, 4))"/>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="tei:availability">
					<xsl:copy-of select="tei:availability"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="availability" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="status" select=" 'restricted' "/>
						<xsl:element name="licence" namespace="http://www.tei-c.org/ns/1.0">
							<xsl:attribute name="target"><xsl:value-of select="$availabilityLicence"/></xsl:attribute>
							<xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
								<xsl:value-of select="$availabilityLicence"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
			<!--
			<xsl:if test="h1:Field[ @Type = '1903' ]">
				<xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:attribute name="type" select=" 'hsk' "/>
					<xsl:value-of select="h1:Field[ @Type = '1903' ]/@Value"/>
				</xsl:element>
			</xsl:if>
			-->
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:publisher">
		<xsl:choose>
			<xsl:when test="parent::tei:publicationStmt">
				<xsl:copy>
					<xsl:apply-templates/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:attribute name="role" select=" 'publisher' "/>
					<xsl:apply-templates select="@*"/>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:ref">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="@type and @cRef">
					<xsl:apply-templates select="@*"/>
				</xsl:when>
				<xsl:when test="@cRef">
					<xsl:attribute name="type">mss</xsl:attribute>
					<xsl:apply-templates select="@*"/>
				</xsl:when>
				<xsl:when test="@type and @target">
					<xsl:copy-of select="@type"/>
					<xsl:copy-of select="@target"/>
				</xsl:when>
				<xsl:when test="@target">
					<xsl:copy-of select="@target"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="type">unk</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="* | text()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:rs">
		<xsl:choose>
			<xsl:when test="@type='person'">
				<xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:apply-templates select="@ref | @role"/>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@type='place'">
				<xsl:element name="placeName" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:apply-templates select="@ref | @role"/>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@type='corporate'">
				<xsl:element name="orgName" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:apply-templates select="@ref | @role"/>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@type='author'">
				<xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:attribute name="role" select=" 'author' "/>
					<xsl:apply-templates select="@ref"/>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:attribute name="type" select=" 'unk' "/>
					<xsl:if test="@ref">
						<xsl:attribute name="target" select="@ref"/>
					</xsl:if>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:sourceDesc">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="ancestor::tei:TEI/descendant::tei:msDesc/descendant::tei:source/tei:bibl">
					<xsl:copy-of select="ancestor::tei:TEI/descendant::tei:msDesc/descendant::tei:source/tei:bibl"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:apply-templates select="preceding-sibling::tei:titleStmt/tei:respStmt" mode="Volltext"/>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:supportDesc" mode="Schlagzeile">
		<xsl:choose>
			<xsl:when test="tei:support/descendant::tei:material[normalize-space(.) != '']">
				<xsl:apply-templates select="tei:support/descendant::tei:material" mode="Schlagzeile"/>
			</xsl:when>
			<xsl:when test="@material = 'perg' "><xsl:text>Pergament</xsl:text></xsl:when>
			<xsl:when test="@material = 'chart' "><xsl:text>Papier</xsl:text></xsl:when>
			<xsl:when test="@material = 'papyrus' "><xsl:text>Papyrus</xsl:text></xsl:when>
			<xsl:when test="(@material = 'mixed') and (normalize-space(tei:support/tei:p[. = tei:material]) != '')">
				<xsl:value-of select="tei:support/tei:p[. = tei:material]"/>
			</xsl:when>
			<xsl:when test="(@material = 'mixed')">
				<xsl:value-of select="tei:support"/>
			</xsl:when>
		</xsl:choose>
		<xsl:apply-templates select="descendant::tei:extent" mode="Schlagzeile"/>
	</xsl:template>

	<xsl:template match="tei:textLang">
		<xsl:choose>
			<xsl:when test="parent::tei:msContents | parent::tei:msItem">
				<xsl:copy-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="Schlagzeile">
		<xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
			<xsl:attribute name="type" select=" 'headline' "/>
			<xsl:choose>
				<xsl:when test="(tei:note[@type = 'caption'] != '')">
					<xsl:value-of select="tei:note[@type = 'caption']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type = 'former'][not(@rend='doNotShow')][not(contains(preceding-sibling::tei:idno, tei:idno))]">
							<xsl:apply-templates select="preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type = 'former'][not(@rend='doNotShow')][not(contains(preceding-sibling::tei:idno, tei:idno))]" mode="Schlagzeile"/>
						</xsl:when>
						<xsl:when test="parent::tei:msPart">
							<xsl:apply-templates select="preceding-sibling::tei:altIdentifier[@type = 'former'][not(@rend='doNotShow')]" mode="Schlagzeile"/>
						</xsl:when>
					</xsl:choose>
					<xsl:apply-templates select="following-sibling::tei:physDesc/descendant::tei:supportDesc" mode="Schlagzeile"/>
					<xsl:choose>
						<xsl:when test="(tei:origPlace != '')">
							<xsl:if test="preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type = 'former'][not(@rend='doNotShow')] 
								and not(contains(preceding-sibling::tei:msIdentifier/tei:idno,concat('olim ',preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type = 'former'][not(@rend='doNotShow')][1]/tei:idno)))
								or following-sibling::tei:physDesc/descendant::tei:supportDesc">
								<xsl:value-of select="$Trennzeichen"/>
							</xsl:if>
							<xsl:apply-templates select="tei:origPlace" mode="Schlagzeile"/>
						</xsl:when>
						<xsl:when test="(following-sibling::tei:history/tei:origin//tei:origPlace != '')">
							<xsl:if test="preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type = 'former'][not(@rend='doNotShow')] 
								and not(contains(preceding-sibling::tei:msIdentifier/tei:idno,concat('olim ',preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type = 'former'][not(@rend='doNotShow')][1]/tei:idno)))
								or following-sibling::tei:physDesc/descendant::tei:supportDesc">
								<xsl:value-of select="$Trennzeichen"/>
							</xsl:if>
							<xsl:apply-templates select="following-sibling::tei:history/tei:origin//tei:origPlace" mode="Schlagzeile"/>
						</xsl:when>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="(tei:origDate != '')">
							<xsl:if test="preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type = 'former'][not(@rend='doNotShow')] 
								and not(contains(preceding-sibling::tei:msIdentifier/tei:idno,concat('olim ',preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type = 'former'][not(@rend='doNotShow')][1]/tei:idno)))
								or following-sibling::tei:physDesc/descendant::tei:supportDesc
								or tei:origPlace or following-sibling::tei:history/tei:origin//tei:origPlace">
								<xsl:value-of select="$Trennzeichen"/>
							</xsl:if>
							<xsl:apply-templates select="tei:origDate" mode="Schlagzeile"/>
						</xsl:when>
						<xsl:when test="(following-sibling::tei:history/tei:origin//tei:origDate != '')">
							<xsl:if test="preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type = 'former'][not(@rend='doNotShow')] 
								and not(contains(preceding-sibling::tei:msIdentifier/tei:idno,concat('olim ',preceding-sibling::tei:msIdentifier/tei:altIdentifier[@type = 'former'][not(@rend='doNotShow')][1]/tei:idno)))
								or following-sibling::tei:physDesc/descendant::tei:supportDesc
								or tei:origPlace or following-sibling::tei:history/tei:origin//tei:origPlace">
								<xsl:value-of select="$Trennzeichen"/>
							</xsl:if>
							<xsl:apply-templates select="following-sibling::tei:history/tei:origin//tei:origDate" mode="Schlagzeile"/>
						</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>

	<xsl:template name="writeCoreFields">
		<xsl:param name="form"/>
		<xsl:choose><!-- title -->
			<xsl:when test="tei:index[@indexName='norm_title']">
				<xsl:copy-of select="tei:index[@indexName='norm_title']"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:attribute name="indexName" select=" 'norm_title' "/>
					<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="type" select=" 'title' "/>
						<xsl:value-of select="tei:title"/>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose><!-- Schlagzeile -->
			<xsl:when test="tei:note[@type='headline']">
				<xsl:copy-of select="tei:note[@type='headline']"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="Schlagzeile"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">
			<xsl:value-of select="tei:title"/>
		</xsl:element>
		
		<xsl:choose><!-- material -->
			<xsl:when test="tei:index[@indexName='norm_material']">
				<xsl:copy-of select="tei:index[@indexName='norm_material']"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:attribute name="indexName" select=" 'norm_material' "/>
					<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="type" select=" 'material' "/>
						<xsl:value-of select="following-sibling::tei:physDesc/descendant::tei:support/tei:p[tei:material][1]"/>
					</xsl:element>
					<xsl:choose>
						<xsl:when test="following-sibling::tei:physDesc/descendant::tei:supportDesc[(@material = 'parch') or (@material = 'perg')]">
							<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
								<xsl:attribute name="type" select=" 'material_type' "/>
								<xsl:text>parchment</xsl:text>
							</xsl:element>
						</xsl:when>
						<xsl:when test="following-sibling::tei:physDesc/descendant::tei:supportDesc[(@material = 'paper') or (@material = 'chart')]">
							<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
								<xsl:attribute name="type" select=" 'material_type' "/>
								<xsl:text>paper</xsl:text>
							</xsl:element>
						</xsl:when>
						<xsl:when test="following-sibling::tei:physDesc/descendant::tei:supportDesc[(@material = 'perg_chart') or (@material = 'mixed')]">
							<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
								<xsl:attribute name="type" select=" 'material_type' "/>
								<xsl:text>parchment</xsl:text>
							</xsl:element>
							<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
								<xsl:attribute name="type" select=" 'material_type' "/>
								<xsl:text>paper</xsl:text>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
								<xsl:attribute name="type" select=" 'material_type' "/>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose><!-- measure -->
			<xsl:when test="tei:index[@indexName='norm_measure']">
				<xsl:copy-of select="tei:index[@indexName='norm_measure']"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:attribute name="indexName" select=" 'norm_measure' "/>
					<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="type" select=" 'measure' "/>
						<xsl:value-of select="following-sibling::tei:physDesc/descendant::tei:measure[@type='leavesCount']"/>
					</xsl:element>
					<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="type" select=" 'measure_noOfLeaves' "/>
						<xsl:choose>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:measure[@type='leavesCount']/@quantity">
								<xsl:value-of select="following-sibling::tei:physDesc/descendant::tei:measure[@type='leavesCount']/@quantity"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:measure[@type='leavesCount'][matches(., '\d+ Bl.')]">
								<xsl:value-of select="following-sibling::tei:physDesc/descendant::tei:measure[@type='leavesCount']/substring-before(., ' Bl.')"/>
							</xsl:when>
						</xsl:choose>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose><!-- dimensions -->
			<xsl:when test="tei:index[@indexName='norm_dimensions']">
				<xsl:copy-of select="tei:index[@indexName='norm_dimensions']"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0"><!-- dimensions -->
					<xsl:attribute name="indexName" select=" 'norm_dimensions' "/>
					<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="type" select=" 'dimensions' "/>
						<xsl:apply-templates select="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]" mode="Schlagzeile"/>
					</xsl:element>
					<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="type" select=" 'height' "/>
						<xsl:choose>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height/@quantity[contains(., ',') and (substring-after(., ',') = '7' or substring-after(., ',') = '6' or substring-after(., ',') = '4' or substring-after(., ',') = '3')]">
								<xsl:value-of select="concat(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height/@quantity, ','), ',5')"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height/@quantity[contains(., ',') and (substring-after(., ',') = '9' or substring-after(., ',') = '8')]">
								<xsl:value-of select="number(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height/@quantity, ',')) + 1"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height/@quantity[contains(., ',') and (substring-after(., ',') = '2' or substring-after(., ',') = '1')]">
								<xsl:value-of select="number(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height/@quantity, ',')) - 1"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height/@quantity">
								<xsl:value-of select="translate(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height/@quantity, '.', ',')"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height[contains(., ',') and (substring-after(., ',') = '7' or substring-after(., ',') = '6' or substring-after(., ',') = '4' or substring-after(., ',') = '3')]">
								<xsl:value-of select="concat(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height, ','), ',5')"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height[contains(., ',') and (substring-after(., ',') = '9' or substring-after(., ',') = '8')]">
								<xsl:value-of select="number(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height, ',')) + 1"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height[contains(., ',') and (substring-after(., ',') = '2' or substring-after(., ',') = '1')]">
								<xsl:value-of select="number(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height, ',')) - 1"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="type" select=" 'width' "/>
						<xsl:choose>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width/@quantity[contains(., ',') and (substring-after(., ',') = '7' or substring-after(., ',') = '6' or substring-after(., ',') = '4' or substring-after(., ',') = '3')]">
								<xsl:value-of select="concat(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width/@quantity, ','), ',5')"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width/@quantity[contains(., ',') and (substring-after(., ',') = '9' or substring-after(., ',') = '8')]">
								<xsl:value-of select="number(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width/@quantity, ',')) + 1"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width/@quantity[contains(., ',') and (substring-after(., ',') = '2' or substring-after(., ',') = '1')]">
								<xsl:value-of select="number(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width/@quantity, ',')) - 1"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width/@quantity">
								<xsl:value-of select="translate(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width/@quantity, '.', ',')"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width[contains(., ',') and (substring-after(., ',') = '7' or substring-after(., ',') = '6' or substring-after(., ',') = '4' or substring-after(., ',') = '3')]">
								<xsl:value-of select="concat(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width, ','), ',5')"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width[contains(., ',') and (substring-after(., ',') = '9' or substring-after(., ',') = '8')]">
								<xsl:value-of select="number(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width, ',')) + 1"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width[contains(., ',') and (substring-after(., ',') = '2' or substring-after(., ',') = '1')]">
								<xsl:value-of select="number(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width, ',')) - 1"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="type" select=" 'depth' "/>
						<xsl:choose>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:depth/@quantity[contains(., ',') and (substring-after(., ',') = '7' or substring-after(., ',') = '6' or substring-after(., ',') = '4' or substring-after(., ',') = '3')]">
								<xsl:value-of select="concat(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:depth/@quantity, ','), ',5')"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:depth/@quantity[contains(., ',') and (substring-after(., ',') = '9' or substring-after(., ',') = '8')]">
								<xsl:value-of select="number(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:depth/@quantity, ',')) + 1"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:depth/@quantity[contains(., ',') and (substring-after(., ',') = '2' or substring-after(., ',') = '1')]">
								<xsl:value-of select="number(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:depth/@quantity, ',')) - 1"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:depth/@quantity">
								<xsl:value-of select="translate(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:depth/@quantity, '.', ',')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:depth"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="type" select=" 'dimensions_typeOfInformation' "/>
						<xsl:text>factual</xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose><!-- format -->
			<xsl:when test="tei:index[@indexName='norm_format']">
				<xsl:copy-of select="tei:index[@indexName='norm_format']"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:attribute name="indexName" select=" 'norm_format' "/>
					<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="type" select=" 'format' "/>
					</xsl:element>
					<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="type" select=" 'format_typeOfInformation' "/><!--factual-->
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose><!-- origPlace -->
			<xsl:when test="tei:index[@indexName='norm_origPlace']">
				<xsl:copy-of select="tei:index[@indexName='norm_origPlace']"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose><!-- origPlace -->
					<xsl:when test="tei:origPlace">
						<xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0"><!-- origPlace -->
							<xsl:attribute name="indexName" select=" 'norm_origPlace' "/>
							<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
								<xsl:attribute name="type" select=" 'origPlace' "/>
								<xsl:for-each select="tei:origPlace">
									<xsl:choose>
										<xsl:when test="tei:placeName[@type='settlement']">
											<xsl:value-of select="tei:placeName[@type='settlement']"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="."/>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:if test="following-sibling::tei:origPlace">
										<xsl:text>, </xsl:text>
									</xsl:if>
								</xsl:for-each>
							</xsl:element>
							<xsl:for-each select="tei:origPlace">
								<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
									<xsl:attribute name="type" select=" 'origPlace_norm' "/>
									<xsl:choose>
										<xsl:when test="contains(@ref, 'd-nb.info/gnd/')">
											<xsl:attribute name="ref">
												<xsl:value-of select="concat('http://d-nb.info/gnd/', substring-after(@ref, 'd-nb.info/gnd/'))"/>
											</xsl:attribute>
										</xsl:when>
										<xsl:when test="contains(tei:placeName[@type='settlement']/@ref, 'd-nb.info/gnd/')">
											<xsl:attribute name="ref">
												<xsl:value-of select="concat('http://d-nb.info/gnd/', substring-after(tei:placeName[@type='settlement']/@ref, 'd-nb.info/gnd/'))"/>
											</xsl:attribute>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="contains(tei:placeName, '(') and not(starts-with(tei:placeName, '('))">
											<xsl:value-of select="normalize-space(substring-before(tei:placeName, '('))"/>
										</xsl:when>
										<xsl:when test="tei:placeName">
											<xsl:value-of select="tei:placeName"/>
										</xsl:when>
										<xsl:when test="contains(., '(') and not(starts-with(., '('))">
											<xsl:value-of select="normalize-space(substring-before(., '('))"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="."/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0"><!-- origPlace -->
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
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose><!-- origDate -->
			<xsl:when test="tei:index[@indexName='norm_origDate']">
				<xsl:copy-of select="tei:index[@indexName='norm_origDate']"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose><!-- origDate -->
					<xsl:when test="tei:origDate">
						<xsl:for-each select="tei:origDate">
							<xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
								<xsl:attribute name="indexName" select=" 'norm_origDate' "/>
								<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
									<xsl:attribute name="type" select=" 'origDate' "/>
									<xsl:value-of select="."/>
								</xsl:element>
								<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
									<xsl:attribute name="type" select=" 'origDate_notBefore' "/>
									<xsl:choose>
										<xsl:when test="@notBefore">
											<xsl:value-of select="@notBefore"/>
										</xsl:when>
										<xsl:when test="@when">
											<xsl:value-of select="@when"/>
										</xsl:when>
									</xsl:choose>
								</xsl:element>
								<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
									<xsl:attribute name="type" select=" 'origDate_notAfter' "/>
									<xsl:choose>
										<xsl:when test="@notAfter">
											<xsl:value-of select="@notAfter"/>
										</xsl:when>
										<xsl:when test="@when">
											<xsl:value-of select="@when"/>
										</xsl:when>
									</xsl:choose>
								</xsl:element>
								<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
									<xsl:attribute name="type" select=" 'origDate_type' "/>
									<xsl:choose>
										<xsl:when test="@when">dated</xsl:when>
										<xsl:when test="@notBefore = @notAfter">dated</xsl:when>
										<xsl:when test="@notBefore and @notAfter">datable</xsl:when>
										<xsl:otherwise>datable</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
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
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose><!-- textLang -->
			<xsl:when test="tei:index[@indexName='norm_textLang']">
				<xsl:copy-of select="tei:index[@indexName='norm_textLang']"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0"><!-- textLang -->
					<xsl:attribute name="indexName" select=" 'norm_textLang' "/>
					<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="type" select=" 'textLang' "/>
						<xsl:choose>
							<xsl:when test="following-sibling::tei:msContents/tei:textLang[. != '']">
								<xsl:value-of select="following-sibling::tei:msContents/tei:textLang"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:msContents/tei:textLang/@mainLang">
								<xsl:call-template name="writeTextLang">
									<xsl:with-param name="key" select="@mainLang"/>
								</xsl:call-template>
							</xsl:when>
						</xsl:choose>
					</xsl:element>
					<xsl:choose>
						<xsl:when test="parent::tei:msDesc">
							<xsl:choose>
								<xsl:when test="parent::tei:msDesc/descendant::textLang/@mainLang
									or parent::tei:msDesc/descendant::tei:rubric/@xml:lang
									or parent::tei:msDesc/descendant::tei:incipit/@xml:lang
									or parent::tei:msDesc/descendant::tei:quote/@xml:lang
									or parent::tei:msDesc/descendant::tei:explicit/@xml:lang
									or parent::tei:msDesc/descendant::tei:finalRubric/@xml:lang">
									<xsl:for-each-group select="parent::tei:msDesc/descendant::textLang/@mainLang
										| parent::tei:msDesc/descendant::tei:rubric/@xml:lang
										| parent::tei:msDesc/descendant::tei:incipit/@xml:lang
										| parent::tei:msDesc/descendant::tei:quote/@xml:lang
										| parent::tei:msDesc/descendant::tei:explicit/@xml:lang
										| parent::tei:msDesc/descendant::tei:finalRubric/@xml:lang" group-by=".">
										<!-- 
				| if (contains(following-sibling::tei:msContents/descendant::textLang/@otherLangs, ' ') then tokenize(following-sibling::tei:msContents/descendant::textLang/@otherLangs, ' ') else following-sibling::tei:msContents/descendant::textLang/@otherLangs
				-->
										<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
											<xsl:attribute name="type" select=" 'textLang-ID' "/>
											<xsl:call-template name="writeTextLang-ID">
												<xsl:with-param name="key" select="current-grouping-key()"/>
											</xsl:call-template>
										</xsl:element>
									</xsl:for-each-group>
								</xsl:when>
								<xsl:otherwise>
									<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
										<xsl:attribute name="type" select=" 'textLang-ID' "/>
									</xsl:element>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="parent::tei:msPart">
							<xsl:choose>
								<xsl:when test="parent::tei:msPart/descendant::textLang/@mainLang
									or parent::tei:msPart/descendant::tei:rubric/@xml:lang
									or parent::tei:msPart/descendant::tei:incipit/@xml:lang
									or parent::tei:msPart/descendant::tei:quote/@xml:lang
									or parent::tei:msPart/descendant::tei:explicit/@xml:lang
									or parent::tei:msPart/descendant::tei:finalRubric/@xml:lang">
									<xsl:for-each-group select="parent::tei:msPart/descendant::textLang/@mainLang
										| parent::tei:msPart/descendant::tei:rubric/@xml:lang
										| parent::tei:msPart/descendant::tei:incipit/@xml:lang
										| parent::tei:msPart/descendant::tei:quote/@xml:lang
										| parent::tei:msPart/descendant::tei:explicit/@xml:lang
										| parent::tei:msPart/descendant::tei:finalRubric/@xml:lang" group-by=".">
										<!-- 
				| if (contains(following-sibling::tei:msContents/descendant::textLang/@otherLangs, ' ') then tokenize(following-sibling::tei:msContents/descendant::textLang/@otherLangs, ' ') else following-sibling::tei:msContents/descendant::textLang/@otherLangs
				-->
										<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
											<xsl:attribute name="type" select=" 'textLang-ID' "/>
											<xsl:call-template name="writeTextLang-ID">
												<xsl:with-param name="key" select="current-grouping-key()"/>
											</xsl:call-template>
										</xsl:element>
									</xsl:for-each-group>
								</xsl:when>
								<xsl:otherwise>
									<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
										<xsl:attribute name="type" select=" 'textLang-ID' "/>
									</xsl:element>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
								<xsl:attribute name="type" select=" 'textLang-ID' "/>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose><!-- form -->
			<xsl:when test="tei:index[@indexName='norm_form']">
				<xsl:copy-of select="tei:index[@indexName='norm_form']"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0"><!-- form -->
					<xsl:attribute name="indexName" select=" 'norm_form' "/>
					<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="type" select=" 'form' "/>
						<xsl:choose>
							<xsl:when test="$form != ''"><xsl:value-of select="$form"/></xsl:when>
							<xsl:when test="parent::tei:msDesc and descendant::tei:objectDesc/@form = 'fascicle' ">composite</xsl:when>
							<xsl:when test="ancestor::tei:msPart[@type='booklet']">booklet</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/tei:objectDesc/@form = 'booklet' ">booklet</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/tei:objectDesc/@form = 'fascicle' ">booklet</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/tei:objectDesc/@form = 'fragment' ">fragment</xsl:when>
							<xsl:otherwise>codex</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose><!-- status -->
			<xsl:when test="tei:index[@indexName='norm_status']">
				<xsl:copy-of select="tei:index[@indexName='norm_status']"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0"><!-- status -->
					<xsl:attribute name="indexName" select=" 'norm_status' "/>
					<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="type" select=" 'status' "/>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose><!-- decoration -->
			<xsl:when test="tei:index[@indexName='norm_decoration']">
				<xsl:copy-of select="tei:index[@indexName='norm_decoration']"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0"><!-- decoration -->
					<xsl:attribute name="indexName" select=" 'norm_decoration' "/>
					<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="type" select=" 'decoration' "/>
						<xsl:choose>
							<xsl:when test="ancestor::tei:TEI/descendant::tei:keywords/tei:term[. = 'Illuminiert']">yes</xsl:when>
							<xsl:when test="descendant::tei:decoNote[. != '']">yes</xsl:when>
						</xsl:choose>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose><!-- musicNotation -->
			<xsl:when test="tei:index[@indexName='norm_musicNotation']">
				<xsl:copy-of select="tei:index[@indexName='norm_musicNotation']"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0"><!-- musicNotation -->
					<xsl:attribute name="indexName" select=" 'norm_musicNotation' "/>
					<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="type" select=" 'musicNotation' "/>
						<xsl:if test="following-sibling::tei:physDesc/tei:musicNotation">yes</xsl:if>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- in der Verarbeitung durchreichen, ohne selbst geschrieben zu werden -->
	<xsl:template match="tei:summary | 
		tei:filiation | 
		tei:musicNotation | 
		tei:additions | tei:collation | tei:condition | tei:extent | 
		tei:foliation | tei:handDesc | tei:handNote | 
		tei:layout | tei:layoutDesc | tei:objectDesc |   
		tei:scriptDesc | tei:scriptNote | tei:sealDesc | tei:support | tei:supportDesc | tei:typeDesc | tei:typeNote |  
		tei:acquisition | tei:origin | tei:provenance ">
		<xsl:text> </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>
	<!-- temporäre Lösung, bis zu einer Änderung des ODD -->
	<xsl:template match="tei:listBibl">
		<xsl:choose>
			<xsl:when test="parent::tei:additional">
				<xsl:copy>
					<xsl:element name="bibl" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:apply-templates select="tei:head"/>
						<xsl:apply-templates select="tei:bibl"/>
					</xsl:element>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="tei:head"/>
				<xsl:apply-templates select="tei:bibl"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- von der Verarbeitung ausschließen -->
	<xsl:template match="comment() | processing-instruction()"/>
	<xsl:template match="tei:adminInfo | tei:dimensions[@type = 'leaf'] | tei:measure[@type = 'leavesCount']"/>

	<xsl:template name="writeTextLang">
		<xsl:param name="key"/>
		<xsl:choose>
			<xsl:when test="$key = 'de' ">deutsch</xsl:when>
			<xsl:when test="$key = 'en' ">englsch</xsl:when>
			<xsl:when test="$key = 'fr' ">französisch</xsl:when>
			<xsl:when test="$key = 'it' ">italienisch</xsl:when>
			<xsl:when test="$key = 'la' ">lateinisch</xsl:when>
			<xsl:when test="$key = 'nl' ">niederländisch</xsl:when>
			<xsl:when test="$key = 'cs' ">tschechisch</xsl:when>
			<xsl:when test="$key = 'el' ">griechisch</xsl:when>
			<xsl:when test="$key = 'pl' ">polnisch</xsl:when>
			<xsl:when test="$key = 'cu' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'ru' ">russisch</xsl:when>
			<xsl:when test="$key = 'ca' ">katalanisch</xsl:when>
			<xsl:when test="$key = 'es' ">spanisch</xsl:when>
			<xsl:when test="$key = 'wen' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'tur' ">türkisch</xsl:when>
			<xsl:when test="$key = 'heb' ">hebräisch</xsl:when>
			<xsl:when test="$key = 'ara' ">arabisch</xsl:when>
			<xsl:when test="$key = 'yid' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'gml' ">deutsch</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="writeTextLang-ID">
		<xsl:param name="key"/>
		<xsl:choose>
			<xsl:when test="$key = 'de' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'en' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'fr' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'it' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'la' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'nl' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'cs' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'el' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'pl' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'cu' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'ru' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'ca' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'es' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'wen' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'tur' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'heb' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'ara' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'yid' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'gml' "><xsl:text>de</xsl:text></xsl:when>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
