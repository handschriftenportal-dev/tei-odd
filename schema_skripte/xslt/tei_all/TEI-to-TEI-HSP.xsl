<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xpath-default-namespace="http://www.tei-c.org/ns/1.0"
	exclude-result-prefixes="xi xsi tei"
	version="2.0">

	<!-- script for transforming generic TEI-encoded documents into the HSP-TEI dialect / 2022 / schassan@hab.de -->

	<xsl:param name="TEI-schema">@parsedVersion.majorVersion@.@parsedVersion.minorVersion@.@parsedVersion.incrementalVersion@</xsl:param>
	<xsl:param name="availabilityLicence">http://rightsstatements.org/vocab/InC/1.0/</xsl:param>

	<xsl:param name="cRef-biblical-start"><xsl:text>https://www.biblija.net/biblija.cgi?m=</xsl:text></xsl:param>
	<xsl:param name="cRef-biblical-end"><xsl:text>&amp;id12=1&amp;id38=1&amp;set=3&amp;l=en</xsl:text></xsl:param>
	<xsl:param name="opac"><xsl:text>https://opac.lbs-braunschweig.gbv.de/DB=2/</xsl:text></xsl:param>
	<xsl:param name="gbv"><xsl:text>https://kxp.k10plus.de/DB=2.1/</xsl:text></xsl:param>
	<xsl:param name="gw"><xsl:text>httpss://gesamtkatalogderwiegendrucke.de/docs/GW</xsl:text></xsl:param>
	<xsl:param name="dnb"><xsl:text>https://dispatch.opac.ddb.de/DB=4.1/</xsl:text></xsl:param>
	<xsl:param name="bvb"><xsl:text>https://gateway-bayern.de/</xsl:text></xsl:param>  <!-- z.B. http://gateway-bayern.de/BV035591903 -->
	<xsl:param name="swb"><xsl:text>https://swb.bsz-bw.de/DB=2.1/PPNSET?PPN=</xsl:text></xsl:param>
	<xsl:param name="bnf"><xsl:text>https://catalogue.bnf.fr/rechercher.do?motRecherche=</xsl:text></xsl:param>
	<xsl:param name="searchForPPN"><xsl:text>PPN?PPN=</xsl:text></xsl:param>
	<xsl:param name="searchForPPNSET"><xsl:text>PPNSET?PPN=</xsl:text></xsl:param>
	<xsl:param name="searchForTerm"><xsl:text>CLK?IKT=8310&amp;TRM=</xsl:text></xsl:param>
	<xsl:param name="vd17"><xsl:text>https://gso.gbv.de/DB=1.28/COLMODE=1/CMD?ACT=SRCHA&amp;IKT=1016&amp;SRT=YOP&amp;TRM=vdn+</xsl:text></xsl:param>
	
	<xsl:param name="cantus"><xsl:text>http://cantusindex.org/id/</xsl:text></xsl:param>
	<xsl:param name="ebdb"><xsl:text>http://www.hist-einband.de/recherche/?</xsl:text></xsl:param>
	<xsl:param name="GettyThesaurus"><xsl:text>http://www.getty.edu/research/conducting_research/vocabularies/tgn/?find=</xsl:text></xsl:param>
	<xsl:param name="perseus"><xsl:text>http://www.perseus.tufts.edu/hopper/xmlchunk?doc=</xsl:text></xsl:param>
	<xsl:param name="perseus_text"><xsl:text>http://www.perseus.tufts.edu/hopper/text?doc=</xsl:text></xsl:param>
	<xsl:param name="Piccard-Online"><xsl:text>http://www.piccard-online.de/?nr=</xsl:text></xsl:param>
	<xsl:param name="Stegmüller_RB"><xsl:text>http://www.repbib.uni-trier.de/cgi-bin/rebiIndex.tcl?ac=searchlist&amp;tlnr=</xsl:text></xsl:param>
	<xsl:param name="wilc"><xsl:text>http://watermark.kb.nl/index.html?http://watermark.kb.nl/findWM.asp?wm_number=</xsl:text></xsl:param>
	<xsl:param name="wzma"><xsl:text>http://www.ksbm.oeaw.ac.at/_scripts/php/loadWmarkImg.php?refnr_wm=</xsl:text></xsl:param>
	<xsl:param name="wzis"><xsl:text>https://www.wasserzeichen-online.de/?ref=</xsl:text></xsl:param>
	<xsl:param name="cRef-gw-start"><xsl:text>http://gesamtkatalogderwiegendrucke.de/docs/GW</xsl:text></xsl:param>
	<xsl:param name="cRef-gw-end"><xsl:text>.htm</xsl:text></xsl:param>
	
	<xsl:param name="Trennzeichen"> &#x2014; </xsl:param>
	<xsl:variable name="crlf" select=" '&#x0A;' "/>

	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>

	<xsl:template match="* | @*[. != '']">
		<xsl:copy>
			<xsl:apply-templates select="* | @* | text()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="* | @*" mode="Volltext">
		<xsl:apply-templates select="* | @* | text()" mode="Volltext"/>
		<xsl:text> </xsl:text>
	</xsl:template>
	<xsl:template match="text()"><xsl:value-of select="."/></xsl:template>

	<xsl:template match="tei:TEI | tei:teiCorpus">
		<xsl:copy>
			<xsl:attribute name="version" select="$TEI-schema"/>
			<xsl:apply-templates select="@xml:id | @xml:lang"/>
			<xsl:choose>
				<xsl:when test="descendant::tei:body[not(normalize-space(.) = '')]">
					<xsl:apply-templates select="* | node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="* | node()"/>
					<xsl:element name="text" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:element name="body" namespace="http://www.tei-c.org/ns/1.0">
							<xsl:apply-templates select="descendant::tei:msDesc"/>
						</xsl:element>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:fileDesc">
		<xsl:copy>
			<xsl:apply-templates select="tei:titleStmt"/>
			<xsl:choose>
				<xsl:when test="tei:publicationStmt[normalize-space(.) = ''] or parent::tei:teiHeader[parent::tei:teiCorpus]">
					<xsl:element name="publicationStmt" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:element name="publisher" namespace="http://www.tei-c.org/ns/1.0">
							<xsl:element name="name" namespace="http://www.tei-c.org/ns/1.0">
								<xsl:attribute name="type" select=" 'org' "/>
								<xsl:text>Handschriftenportal</xsl:text>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="tei:publicationStmt"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="tei:sourceDesc[normalize-space(.) = ''] or parent::tei:teiHeader[parent::tei:teiCorpus]">
					<xsl:element name="sourceDesc" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
							<xsl:text>Automatisch generierter Handschriftenkatalog aus einem am </xsl:text>
							<xsl:value-of select="current-date()"/>
							<xsl:text> transformierten TEI-Dokument.</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="tei:sourceDesc"/>
				</xsl:otherwise>
			</xsl:choose>
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

	<xsl:template match="tei:altIdentifier">
		<xsl:choose>
			<xsl:when test="(@type != 'former') and (@type != 'formerShelfmark') and (@type != 'formerShelfMark')"/>
			<xsl:when test="((@type = 'former') or (@type = 'formerShelfmark') or (@type = 'formerShelfMark')) and not(tei:repository)"/>
			<xsl:otherwise>
				<xsl:element name="altIdentifier" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:attribute name="type" select=" 'former' "/>
					<xsl:copy-of select="*"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
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
				<xsl:if test="following-sibling::tei:title"><xsl:text> </xsl:text></xsl:if>
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
				<xsl:apply-templates select="* | text()"/>
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

	<xsl:template match="tei:body">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="tei:div/tei:msDesc">
					<xsl:apply-templates select="tei:div/tei:msDesc"/>
				</xsl:when>
				<xsl:when test="tei:msDesc">
					<xsl:apply-templates select="tei:msDesc"/>
				</xsl:when>
				<xsl:when test="preceding-sibling::teiHeader/descendant::tei:sourceDesc/tei:msDesc">
					<xsl:apply-templates select="preceding-sibling::teiHeader/descendant::tei:sourceDesc/tei:msDesc"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:choice">
		<xsl:apply-templates select="tei:abbr | tei:sic | tei:orig"/>
		<xsl:apply-templates select="tei:expan | tei:corr | tei:reg"/>
	</xsl:template>
	<xsl:template match="tei:expan | tei:corr | tei:reg">
		<xsl:text> [</xsl:text><xsl:apply-templates/><xsl:text>] </xsl:text>
	</xsl:template>

	<xsl:template match="tei:date">
		<xsl:choose>
			<xsl:when test="ancestor::tei:msDesc">
				<xsl:apply-templates select="* |text()"/>
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

	<xsl:template match="tei:del">
		<xsl:element name="hi" namespace="http://www.tei-c.org/ns/1.0">
			<xsl:attribute name="rend" select=" 'del' "/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="tei:dimensions[*][not(@type = 'leaf')]">
		<!-- Größe -->
		<xsl:apply-templates select="*"/>
		<xsl:choose>
			<xsl:when test="@unit and not(tei:height/@unit) and not(tei:width/@unit) and not(tei:depth/@unit)">
				<xsl:value-of select="concat(' ',@unit)"/>
			</xsl:when>
			<xsl:when test="tei:height/@unit or tei:width/@unit"/>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="tei:dimensions[not(normalize-space(.)='')]" mode="index">
		<!-- Größe -->
		<xsl:value-of select="tei:height"/>
		<xsl:if test="tei:height and (tei:width or tei:depth)">
			<xsl:text> &#x00D7; </xsl:text>
		</xsl:if>
		<xsl:value-of select="tei:width"/>
		<xsl:if test="tei:width and tei:depth">
			<xsl:text> &#x00D7; </xsl:text>
		</xsl:if>
		<xsl:value-of select="tei:depth"/>
		<xsl:choose>
			<xsl:when test="@unit and not(tei:height/@unit) and not(tei:width/@unit) and not(tei:depth/@unit)">
				<xsl:value-of select="concat(' ',@unit)"/>
			</xsl:when>
			<xsl:when test="tei:height/@unit or tei:width/@unit"/>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="tei:height[not(normalize-space(.)='')]">
		<xsl:value-of select="."/>
		<xsl:if test="@unit and not(../tei:width/@unit) and not(../tei:depth/@unit)">
			<xsl:text> </xsl:text>
			<xsl:value-of select="@unit"/>
		</xsl:if>
		<xsl:if test="../tei:width or ../tei:depth">
			<xsl:text> &#x00D7; </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="tei:width[not(normalize-space(.)='')]">
		<xsl:value-of select="."/>
		<xsl:if test="@unit and not(../tei:depth/@unit)">
			<xsl:text> </xsl:text>
			<xsl:value-of select="@unit"/>
		</xsl:if>
		<xsl:if test="../tei:depth">
			<xsl:text> &#x00D7; </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="tei:depth[not(normalize-space(.)='')]">
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
	
	<xsl:template match="tei:ex">
		<xsl:text>[</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>]</xsl:text>
	</xsl:template>
	
	<xsl:template match="tei:extent[not(normalize-space(.)='')]" mode="Schlagzeile">
		<!-- Umfang -->
		<xsl:if test="(ancestor::tei:physDesc/preceding-sibling::tei:msIdentifier/tei:altIdentifier[(@type = 'former') or (@type = 'formerShelfmark')][not(@rend='doNotShow')] 
			and not(contains(ancestor::tei:physDesc/preceding-sibling::tei:msIdentifier/tei:idno,concat('olim ',ancestor::tei:physDesc/preceding-sibling::tei:msIdentifier/tei:altIdentifier[(@type = 'former') or (@type = 'formerShelfmark')][not(@rend='doNotShow')][1]/tei:idno))))
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
				and descendant::tei:dimensions[@type = 'leaf']">
				<xsl:value-of select="$Trennzeichen"/>
				<xsl:apply-templates select="descendant::tei:dimensions[@type = 'leaf']" mode="index"/>
			</xsl:when>
			<xsl:when test="descendant::tei:measure[@type = 'pageDimensions']">
				<xsl:apply-templates select="descendant::tei:measure[@type = 'pageDimensions']" mode="index"/>
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
			<xsl:when test="parent::tei:msDesc and (following-sibling::tei:physDesc/tei:objectDesc/@form != '')">
				<xsl:copy>
					<xsl:call-template name="writeCoreFields">
						<xsl:with-param name="form" select="following-sibling::tei:physDesc/tei:objectDesc/@form"/>
					</xsl:call-template>
				</xsl:copy>
			</xsl:when>
			<xsl:when test="parent::tei:msPart and (following-sibling::tei:physDesc/tei:objectDesc/@form != '')">
				<xsl:copy>
					<xsl:call-template name="writeCoreFields">
						<xsl:with-param name="form" select="following-sibling::tei:physDesc/tei:objectDesc/@form"/>
					</xsl:call-template>
				</xsl:copy>
			</xsl:when>
			<xsl:when test="parent::tei:msDesc">
				<xsl:copy>
					<xsl:call-template name="writeCoreFields">
						<xsl:with-param name="form" select=" 'codex' "/>
					</xsl:call-template>
				</xsl:copy>
			</xsl:when>
			<xsl:when test="parent::tei:msPart[@rend = 'condensed']">
				<xsl:copy>
					<xsl:call-template name="writeCoreFields">
						<xsl:with-param name="form" select=" 'fragment' "/>
					</xsl:call-template>
				</xsl:copy>
			</xsl:when>
			<xsl:when test="parent::tei:msPart">
				<xsl:copy>
					<xsl:call-template name="writeCoreFields">
						<xsl:with-param name="form" select=" 'booklet' "/>
					</xsl:call-template>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:heraldry">
		<xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
			<xsl:attribute name="type" select=" 'heraldry' "/>
			<xsl:apply-templates/>
		</xsl:element>
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
			<xsl:apply-templates select="* | text()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="tei:index"/>
	<xsl:template match="tei:index" mode="index">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates mode="index"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="tei:term">
		<xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
			<xsl:attribute name="type" select=" 'term' "/>
			<xsl:apply-templates select="* | text()"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="tei:term" mode="index">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates mode="#default"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="tei:l">
		<xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:list">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="tei:item">
		<xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:locus">
		<xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
			<xsl:choose>
				<xsl:when test="@target">
					<xsl:copy-of select="@target"/>
				</xsl:when>
				<xsl:when test="@from or @to or @facs">
					<xsl:attribute name="target">
						<xsl:if test="@from"><xsl:value-of select="concat('#', @from)"/></xsl:if>
						<xsl:if test="@from and @to"><xsl:text> </xsl:text></xsl:if>
						<xsl:if test="@to"><xsl:value-of select="concat('#', @to)"/></xsl:if>
						<xsl:if test="(@from or @to) and @facs"><xsl:text> </xsl:text></xsl:if>
						<xsl:if test="@facs"><xsl:value-of select="@facs"/></xsl:if>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="not(@*)">
					<xsl:attribute name="type" select=" 'locus' "/>
				</xsl:when>
			</xsl:choose>
			<xsl:apply-templates select="* | text()"/>
		</xsl:element>
		<xsl:if test="following-sibling::*"><xsl:text> </xsl:text></xsl:if>
	</xsl:template>

	<xsl:template match="tei:locusGrp">
		<xsl:for-each select="tei:locus">
			<xsl:apply-templates/>
			<xsl:choose>
				<xsl:when test="following-sibling::tei:locus"><xsl:text>, </xsl:text></xsl:when>
				<xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
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

	<xsl:template match="tei:msContents[normalize-space(.) != '']">
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
				<xsl:when test="tei:head[normalize-space(.) != '']"><xsl:apply-templates select="tei:head"/></xsl:when>
				<xsl:otherwise>
					<xsl:element name="head" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:call-template name="writeCoreFields">
							<xsl:with-param name="form" select=" 'codex' "/>
						</xsl:call-template>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="tei:physDesc[normalize-space(.) != '']"/>
			<xsl:apply-templates select="tei:physDesc/tei:bindingDesc/tei:binding[normalize-space(.) != '']"/>
			<xsl:apply-templates select="tei:msPart[@type = 'binding'][normalize-space(.) != '']"/>
			<xsl:apply-templates select="tei:msPart[descendant::tei:objectDesc[@form = 'fragment']][normalize-space(.) != '']"/>
			<xsl:apply-templates select="tei:msPart[(@rend = 'condensed') and not(descendant::tei:objectDesc[@form = 'fragment'])][normalize-space(.) != '']"/>
			<xsl:apply-templates select="tei:physDesc/tei:accMat[@type = 'fragment'][normalize-space(.) != '']"/>
			<xsl:apply-templates select="tei:history[normalize-space(.) != '']"/>
			<xsl:apply-templates select="tei:additional[normalize-space(.) != '']"/>
			<xsl:apply-templates select="tei:msContents[normalize-space(.) != '']"/>
			<xsl:apply-templates select="tei:msPart[(@type='booklet') or descendant::tei:objectDesc[@form = 'booklet']][normalize-space(.) != '']"/>
			<xsl:apply-templates select="tei:physDesc/tei:accMat[@type != 'fragment'][normalize-space(.) != '']"/>
			<xsl:if test="descendant::tei:index[not(ancestor::tei:msItem)][not(ancestor::tei:head)][normalize-space(.) != '']">
				<xsl:element name="msPart" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:attribute name="type" select=" 'other' "/>
					<xsl:element name="msIdentifier" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">Sonstiges</xsl:element>
					</xsl:element>
					<xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:apply-templates select="descendant::tei:index[not(ancestor::tei:msItem)][not(parent::tei:index)][not(ancestor::tei:head)]" mode="index"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:msItem">
		<xsl:choose>
			<xsl:when test="*[not(self::tei:msItem) and not(self::tei:decoNote) and not(self::tei:textLang)]">
				<xsl:copy>
					<xsl:apply-templates select="@*"/>
					<xsl:apply-templates select="tei:textLang"/>
					<xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="type" select=" 'text' "/>
						<xsl:apply-templates select="*[not(self::tei:msItem) and not(self::tei:decoNote) and not(self::tei:textLang)]"/>
					</xsl:element>
					<xsl:apply-templates select="tei:decoNote"/>
					<xsl:apply-templates select="tei:msItem"/>
					<xsl:if test="tei:index">
						<xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
							<xsl:attribute name="type" select=" 'register' "/>
							<xsl:apply-templates select="tei:index" mode="index"/>
						</xsl:element>
					</xsl:if>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:msPart">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="@type = 'binding' ">
					<xsl:attribute name="type" select=" 'binding' "/>
				</xsl:when>
				<xsl:when test="@type = 'fragment' ">
					<xsl:attribute name="type" select=" 'fragment' "/>
				</xsl:when>
				<xsl:when test="descendant::tei:objectDesc[@form = 'fragment']">
					<xsl:attribute name="type" select=" 'fragment' "/>
				</xsl:when>
				<xsl:when test="@rend = 'condensed' ">
					<xsl:attribute name="type" select=" 'fragment' "/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="type" select=" 'booklet' "/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="@*[not(name() = 'type')]"/>
			<xsl:choose>
				<xsl:when test="tei:msIdentifier[normalize-space(.) = '']">
					<xsl:element name="msIdentifier" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0"/>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="tei:msIdentifier"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="tei:head"><xsl:apply-templates select="tei:head"/></xsl:when>
				<xsl:otherwise>
					<xsl:element name="head" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:call-template name="writeCoreFields">
							<xsl:with-param name="form">
								<xsl:choose>
									<xsl:when test="@type = 'fragment' ">fragment</xsl:when>
									<xsl:when test="@type = 'binding' ">binding</xsl:when>
									<xsl:when test="descendant::tei:objectDesc[@form = 'fragment']">fragment</xsl:when>
									<xsl:when test="@rend = 'condensed' ">fragment</xsl:when>
									<xsl:otherwise>booklet</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="tei:physDesc[normalize-space(.) != '']"/>
			<xsl:apply-templates select="tei:msPart[descendant::tei:objectDesc[@form = 'fragment']][normalize-space(.) != '']"/>
			<xsl:apply-templates select="tei:physDesc/tei:accMat[@type = 'fragment'][normalize-space(.) != '']"/>
			<xsl:apply-templates select="tei:history[normalize-space(.) != '']"/>
			<xsl:apply-templates select="tei:additional[normalize-space(.) != '']"/>
			<xsl:apply-templates select="tei:msContents[normalize-space(.) != '']"/>
			<xsl:apply-templates select="tei:physDesc/tei:accMat[@type != 'fragment'][normalize-space(.) != '']"/>
			<xsl:if test="descendant::tei:index[not(ancestor::tei:msItem)][not(ancestor::tei:head)][normalize-space(.) != '']">
				<xsl:element name="msPart" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:attribute name="type" select=" 'other' "/>
					<xsl:element name="msIdentifier" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:element name="idno" namespace="http://www.tei-c.org/ns/1.0">Sonstiges</xsl:element>
					</xsl:element>
					<xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:apply-templates select="descendant::tei:index[not(ancestor::tei:msItem)][not(parent::tei:index)][not(ancestor::tei:head)]" mode="index"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:name">
		<xsl:choose>
			<xsl:when test=" @type = 'person' ">
				<xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:if test="preceding-sibling::tei:resp[contains(., 'Beschrieben durch')]
						or preceding-sibling::tei:resp[contains(., 'Beschrieben von')]
						or preceding-sibling::tei:resp[contains(., 'Katalogisiert durch')]
						or preceding-sibling::tei:resp[contains(., 'Katalogisiert von')]">
						<xsl:attribute name="role" select=" 'author' "/>
					</xsl:if>
					<xsl:value-of select="."/>
				</xsl:element>
			</xsl:when>
			<xsl:when test=" @type = 'org' ">
				<xsl:choose>
					<xsl:when test="parent::tei:respStmt and preceding-sibling::tei:name[@type = 'person']"/>
					<xsl:otherwise>
						<xsl:copy>
							<xsl:apply-templates select="@* | node()"/>
						</xsl:copy>
					</xsl:otherwise>
				</xsl:choose>
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
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:origDate">
		<!--<xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">-->
			<xsl:apply-templates select="* | text()"/>
		<!--</xsl:element>-->
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
						<xsl:value-of select="ancestor::tei:msPart/tei:msIdentifier/tei:idno"/>
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
	
	<xsl:template match="tei:origPlace">
		<xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
			<xsl:if test="@ref">
				<xsl:attribute name="target" select="@ref"/>
			</xsl:if>
			<xsl:if test="not(@type)">
				<xsl:attribute name="type" select=" 'place' "/>
			</xsl:if>
			<xsl:apply-templates select="@*[not(name() = 'ref')]"/>
			<xsl:apply-templates select="*| text()"/>
		</xsl:element>
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
						<xsl:value-of select="ancestor::tei:msPart/tei:msIdentifier/tei:idno"/>
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
				or parent::tei:accMat 
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
					<xsl:when test="preceding-sibling::tei:p">
						<xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
						<xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
					</xsl:when>
				</xsl:choose>
				<xsl:apply-templates select="* | text()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="* | text()"/>
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
						<xsl:attribute name="when" select="substring(string(current-date()), 1, 4)"/>
						<xsl:attribute name="type">secondary</xsl:attribute>
						<xsl:value-of select="substring(string(current-date()), 1, 4)"/>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="when" select="substring(string(current-date()), 1, 4)"/>
						<xsl:attribute name="type">primary</xsl:attribute>
						<xsl:value-of select="substring(string(current-date()), 1, 4)"/>
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
				<xsl:when test="(@type = 'biblical') and @cRef">
					<xsl:attribute name="target">
						<xsl:value-of select="$cRef-biblical-start"/>
						<xsl:choose>
							<xsl:when test="starts-with(@cRef, 'IV_')">
								<xsl:value-of select="replace(translate(translate(translate(@cRef,' ','+'),',',':'),'_','+'), 'IV', '4')"/>
							</xsl:when>
							<xsl:when test="starts-with(@cRef, 'III_')">
								<xsl:value-of select="replace(translate(translate(translate(@cRef,' ','+'),',',':'),'_','+'), 'III', '3')"/>
							</xsl:when>
							<xsl:when test="starts-with(@cRef, 'II_')">
								<xsl:value-of select="replace(translate(translate(translate(@cRef,' ','+'),',',':'),'_','+'), 'II', '2')"/>
							</xsl:when>
							<xsl:when test="starts-with(@cRef, 'I_')">
								<xsl:value-of select="replace(translate(translate(translate(@cRef,' ','+'),',',':'),'_','+'), 'I', '1')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="translate(translate(translate(@cRef,' ','+'),',',':'),'_','+')"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="$cRef-biblical-end"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="(@type = 'ebdb') and @cRef">
					<xsl:if test="self::tei:ptr"><a href="#EBDB">EBDB</a><xsl:text> </xsl:text></xsl:if>
					<xsl:attribute name="target">
						<xsl:choose>
							<xsl:when test="starts-with(@cRef, 'k')">
								<xsl:value-of select="concat($ebdb, 'wk=', @cRef)"/>
							</xsl:when>
							<xsl:when test="starts-with(@cRef, 's') or
								starts-with(@cRef, 'r') or
								starts-with(@cRef, 'p')">
								<xsl:value-of select="concat($ebdb, 'wz=', @cRef)"/>
							</xsl:when>
							<xsl:when test="starts-with(@cRef, 'w')">
								<xsl:value-of select="concat($ebdb, 'ws=', @cRef)"/>
							</xsl:when>
						</xsl:choose>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="@cRef and (
					@type = 'cantus' or
					@type = 'gbv' or @type = 'gw' or
					@type = 'opac' or
					@type = 'Piccard-Online' or
					@type = 'vd17' or
					@type = 'wilc' or @type = 'wzis' or @type = 'wzma'
					)">
					<xsl:attribute name="target">
						<xsl:choose>
							<xsl:when test="@type = 'cantus'"><xsl:value-of select="concat($cantus, @cRef)"/></xsl:when>
							<xsl:when test="@type = 'gbv'"><xsl:value-of select="concat($gbv, $searchForPPNSET, @cRef)"/></xsl:when>
							<xsl:when test="@type = 'gw'"><xsl:value-of select="concat($cRef-gw-start, @cRef, $cRef-gw-end)"/></xsl:when>
							<xsl:when test="@type = 'opac'"><xsl:value-of select="concat($opac, $searchForPPN, @cRef)"/></xsl:when>
							<xsl:when test="@type = 'Piccard-Online'"><xsl:value-of select="concat($Piccard-Online, @cRef)"/></xsl:when>
							<xsl:when test="@type = 'vd17'"><xsl:value-of select="concat($vd17, @cRef)"/></xsl:when>
							<xsl:when test="@type = 'wilc'"><xsl:value-of select="concat($wilc, translate(substring-after(@cRef, 'WM_'), '_', '+'), '&amp;max=50')"/></xsl:when>
							<xsl:when test="@type = 'wzis'"><xsl:value-of select="concat($wzis, @cRef)"/></xsl:when>
							<xsl:when test="@type = 'wzma'"><xsl:value-of select="concat($wzma, @cRef)"/></xsl:when>
						</xsl:choose>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="@type[. != ''] and @cRef[. != '']">
					<xsl:apply-templates select="@*[. != '']"/>
				</xsl:when>
				<xsl:when test="@cRef[. != '']">
					<xsl:attribute name="type">mss</xsl:attribute>
					<xsl:apply-templates select="@*[. != '']"/>
				</xsl:when>
				<xsl:when test="@type[. != ''] and @target[. != '']">
					<xsl:copy-of select="@type"/>
					<xsl:copy-of select="@target"/>
				</xsl:when>
				<xsl:when test="@target[. != '']">
					<xsl:copy-of select="@target"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="type">unk</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="* | text()"/>
		</xsl:copy>
		<xsl:if test="@type = 'biblical' ">
			<xsl:call-template name="constructCRef"/>
		</xsl:if>
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

	<xsl:template match="tei:sic">
		<xsl:apply-templates/>
		<xsl:text> [!]</xsl:text>
	</xsl:template>

	<xsl:template match="tei:sourceDesc">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="ancestor::tei:TEI/descendant::tei:msDesc/descendant::tei:source/tei:bibl">
					<xsl:element name="bibl" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:apply-templates select="ancestor::tei:TEI/descendant::tei:msDesc/descendant::tei:source/tei:bibl"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="ancestor::tei:TEI/descendant::tei:msDesc/descendant::tei:source/tei:p">
					<xsl:element name="bibl" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:value-of select="ancestor::tei:TEI/descendant::tei:msDesc/descendant::tei:source/tei:p"/>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:apply-templates select="preceding-sibling::tei:titleStmt/tei:respStmt" mode="Volltext"/>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tei:stamp">
		<xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
			<xsl:attribute name="type" select=" 'stamp' "/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="tei:supplied">
		<xsl:text>[</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>]</xsl:text>
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
				<xsl:copy>
					<xsl:apply-templates select="* | @*[. != ''] | text()"/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:title">
		<xsl:choose>
			<xsl:when test="parent::tei:titleStmt">
				<xsl:copy-of select="."/>
			</xsl:when>
			<xsl:when test="@type = 'sub' ">
				<xsl:text> (</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>)</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="following-sibling::*"><xsl:text> </xsl:text></xsl:if>
	</xsl:template>

	<xsl:template match="tei:unclear">
		<xsl:apply-templates/>
		<xsl:text> (?)</xsl:text>
	</xsl:template>

	<xsl:template match="tei:watermark">
		<xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
			<xsl:attribute name="type" select=" 'watermark' "/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template name="constructCRef">
		<xsl:if test="ancestor::tei:rubric or ancestor::tei:incipit or ancestor::tei:quote or ancestor::tei:explicit or ancestor::tei:colophon or ancestor::tei:finalRubric or ancestor::tei:index or ancestor::tei:title">
			<xsl:text> [</xsl:text>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="not(normalize-space(.) = translate(@cRef, '_', ' '))">
				<xsl:choose>
					<xsl:when test="starts-with(@cRef, 'Lao')">
						<xsl:value-of select="translate(translate(translate(translate(@cRef,'+',' '),':',','),'_',' '), 'Lao', 'Laod')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="translate(translate(translate(@cRef,'+',' '),':',','),'_',' ')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="ancestor::tei:rubric or ancestor::tei:incipit or ancestor::tei:quote or ancestor::tei:explicit or ancestor::tei:colophon or ancestor::tei:finalRubric or ancestor::tei:index or ancestor::tei:title">
			<xsl:text>]</xsl:text>
		</xsl:if>
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
						<xsl:when test="preceding-sibling::tei:msIdentifier/tei:altIdentifier[(@type = 'former') or (@type = 'formerShelfmark')][not(@rend='doNotShow')][not(contains(preceding-sibling::tei:idno, tei:idno))]">
							<xsl:apply-templates select="preceding-sibling::tei:msIdentifier/tei:altIdentifier[(@type = 'former') or (@type = 'formerShelfmark')][not(@rend='doNotShow')][not(contains(preceding-sibling::tei:idno, tei:idno))]" mode="Schlagzeile"/>
						</xsl:when>
						<xsl:when test="parent::tei:msPart">
							<xsl:apply-templates select="preceding-sibling::tei:altIdentifier[(@type = 'former') or (@type = 'formerShelfmark')][not(@rend='doNotShow')]" mode="Schlagzeile"/>
						</xsl:when>
					</xsl:choose>
					<xsl:apply-templates select="following-sibling::tei:physDesc/descendant::tei:supportDesc" mode="Schlagzeile"/>
					<xsl:choose>
						<xsl:when test="(tei:origPlace != '')">
							<xsl:if test="preceding-sibling::tei:msIdentifier/tei:altIdentifier[(@type = 'former') or (@type = 'formerShelfmark')][not(@rend='doNotShow')] 
								and not(contains(preceding-sibling::tei:msIdentifier/tei:idno,concat('olim ',preceding-sibling::tei:msIdentifier/tei:altIdentifier[(@type = 'former') or (@type = 'formerShelfmark')][not(@rend='doNotShow')][1]/tei:idno)))
								or following-sibling::tei:physDesc/descendant::tei:supportDesc">
								<xsl:value-of select="$Trennzeichen"/>
							</xsl:if>
							<xsl:apply-templates select="tei:origPlace" mode="Schlagzeile"/>
						</xsl:when>
						<xsl:when test="(following-sibling::tei:history/tei:origin//tei:origPlace != '')">
							<xsl:if test="preceding-sibling::tei:msIdentifier/tei:altIdentifier[(@type = 'former') or (@type = 'formerShelfmark')][not(@rend='doNotShow')] 
								and not(contains(preceding-sibling::tei:msIdentifier/tei:idno,concat('olim ',preceding-sibling::tei:msIdentifier/tei:altIdentifier[(@type = 'former') or (@type = 'formerShelfmark')][not(@rend='doNotShow')][1]/tei:idno)))
								or following-sibling::tei:physDesc/descendant::tei:supportDesc">
								<xsl:value-of select="$Trennzeichen"/>
							</xsl:if>
							<xsl:apply-templates select="following-sibling::tei:history/tei:origin//tei:origPlace" mode="Schlagzeile"/>
						</xsl:when>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="(tei:origDate != '')">
							<xsl:if test="preceding-sibling::tei:msIdentifier/tei:altIdentifier[(@type = 'former') or (@type = 'formerShelfmark')][not(@rend='doNotShow')] 
								and not(contains(preceding-sibling::tei:msIdentifier/tei:idno,concat('olim ',preceding-sibling::tei:msIdentifier/tei:altIdentifier[(@type = 'former') or (@type = 'formerShelfmark')][not(@rend='doNotShow')][1]/tei:idno)))
								or following-sibling::tei:physDesc/descendant::tei:supportDesc
								or tei:origPlace or following-sibling::tei:history/tei:origin//tei:origPlace">
								<xsl:value-of select="$Trennzeichen"/>
							</xsl:if>
							<xsl:apply-templates select="tei:origDate" mode="Schlagzeile"/>
						</xsl:when>
						<xsl:when test="(following-sibling::tei:history/tei:origin//tei:origDate != '')">
							<xsl:if test="preceding-sibling::tei:msIdentifier/tei:altIdentifier[(@type = 'former') or (@type = 'formerShelfmark')][not(@rend='doNotShow')] 
								and not(contains(preceding-sibling::tei:msIdentifier/tei:idno,concat('olim ',preceding-sibling::tei:msIdentifier/tei:altIdentifier[(@type = 'former') or (@type = 'formerShelfmark')][not(@rend='doNotShow')][1]/tei:idno)))
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
						<xsl:choose>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:support/tei:p[tei:material][1]">
								<xsl:value-of select="following-sibling::tei:physDesc/descendant::tei:support/tei:p[tei:material][1]"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:support/tei:material[1]">
								<xsl:value-of select="following-sibling::tei:physDesc/descendant::tei:support/tei:material[1]"/>
							</xsl:when>
						</xsl:choose>
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
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:measure[@type='leavesCount'][matches(., '\d+ Blatt')]">
								<xsl:value-of select="following-sibling::tei:physDesc/descendant::tei:measure[@type='leavesCount']/substring-before(., ' Blatt')"/>
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
						<xsl:apply-templates select="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]" mode="index"/>
					</xsl:element>
					<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="type" select=" 'height' "/>
						<xsl:choose>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height/@quantity[contains(., '.') and (substring-after(., '.') = '7' or substring-after(., '.') = '6' or substring-after(., '.') = '4' or substring-after(., '.') = '3')]">
								<xsl:value-of select="concat(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height/@quantity, '.'), ',5')"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height/@quantity[contains(., '.') and (substring-after(., '.') = '9' or substring-after(., '.') = '8')]">
								<xsl:value-of select="number(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height/@quantity, '.')) + 1"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height/@quantity[contains(., '.') and (substring-after(., '.') = '2' or substring-after(., '.') = '1')]">
								<xsl:value-of select="number(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height/@quantity, '.')) - 1"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height/@quantity">
								<xsl:value-of select="translate(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')][1]/tei:height/@quantity, '.', ',')"/>
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
							<xsl:when test="not(matches(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height, '\p{P}'))">
								<xsl:value-of select="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:height"/>
							</xsl:when>
						</xsl:choose>
					</xsl:element>
					<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="type" select=" 'width' "/>
						<xsl:choose>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width/@quantity[contains(., '.') and (substring-after(., '.') = '7' or substring-after(., '.') = '6' or substring-after(., '.') = '4' or substring-after(., '.') = '3')]">
								<xsl:value-of select="concat(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width/@quantity, '.'), ',5')"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width/@quantity[contains(., '.') and (substring-after(., '.') = '9' or substring-after(., '.') = '8')]">
								<xsl:value-of select="number(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width/@quantity, '.')) + 1"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width/@quantity[contains(., '.') and (substring-after(., '.') = '2' or substring-after(., '.') = '1')]">
								<xsl:value-of select="number(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width/@quantity, '.')) - 1"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width/@quantity">
								<xsl:value-of select="translate(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')][1]/tei:width/@quantity, '.', ',')"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width[contains(., ',') and (substring-after(., ',') = '7' or substring-after(., ',') = '6' or substring-after(., ',') = '4' or substring-after(., ',') = '3')]">
								<xsl:value-of select="concat(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')][1]/tei:width, ','), ',5')"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width[contains(., ',') and (substring-after(., ',') = '9' or substring-after(., ',') = '8')]">
								<xsl:value-of select="number(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width, ',')) + 1"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width[contains(., ',') and (substring-after(., ',') = '2' or substring-after(., ',') = '1')]">
								<xsl:value-of select="number(substring-before(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width, ',')) - 1"/>
							</xsl:when>
							<xsl:when test="not(matches(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width, '\p{P}'))">
								<xsl:value-of select="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:width"/>
							</xsl:when>
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
							<xsl:when test="not(matches(following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:depth, '\p{P}'))">
								<xsl:value-of select="following-sibling::tei:physDesc/descendant::tei:extent/tei:dimensions[(@type = 'leaf')]/tei:depth"/>
							</xsl:when>
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
			<xsl:when test="tei:index[@indexName='norm_origDate'][tei:term[@type='origDate_notBefore'][. != ''] and tei:term[@type='origDate_notAfter'][. != '']]">
				<xsl:copy-of select="tei:index[@indexName='norm_origDate']"/>
			</xsl:when>
			<xsl:when test="tei:index[@indexName='norm_origDate'][tei:term[@type='origDate_notBefore'][. = ''] and tei:term[@type='origDate_notAfter'][. = '']]">
				<xsl:copy-of select="tei:index[@indexName='norm_origDate']"/>
			</xsl:when>
			<xsl:when test="tei:index[@indexName='norm_origDate'][tei:term[@type='origDate_notBefore'][. != ''] or tei:term[@type='origDate_notAfter'][. != '']]">
				<xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:attribute name="indexName" select=" 'norm_origDate' "/>
					<xsl:copy-of select="tei:index[@indexName='norm_origDate']/tei:term[@type='origDate']"/>
					<xsl:choose>
						<xsl:when test="tei:index[@indexName='norm_origDate']/tei:term[@type='origDate_notBefore'][. != '']">
							<xsl:copy-of select="tei:index[@indexName='norm_origDate']/tei:term[@type='origDate_notBefore']"/>
							<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
								<xsl:attribute name="type" select=" 'origDate_notAfter' "/>
								<xsl:choose>
									<xsl:when test="matches(tei:index[@indexName='norm_origDate']/tei:term[@type='origDate_notBefore'], '^\d{4}\-\d')">
										<xsl:value-of select="number(substring(tei:index[@indexName='norm_origDate']/tei:term[@type='origDate_notBefore'], 1, 4)) + 20"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="number(tei:index[@indexName='norm_origDate']/tei:term[@type='origDate_notBefore']) + 20"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
						</xsl:when>
						<xsl:when test="tei:index[@indexName='norm_origDate']/tei:term[@type='origDate_notAfter'][. != '']">
							<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
								<xsl:attribute name="type" select=" 'origDate_notBefore' "/>
								<xsl:choose>
									<xsl:when test="matches(tei:index[@indexName='norm_origDate']/tei:term[@type='origDate_notBefore'], '^\d{4}\-\d')">
										<xsl:value-of select="number(substring(tei:index[@indexName='norm_origDate']/tei:term[@type='origDate_notAfter'], 1, 4)) - 20"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="number(tei:index[@indexName='norm_origDate']/tei:term[@type='origDate_notAfter']) - 20"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
							<xsl:copy-of select="tei:index[@indexName='norm_origDate']/tei:term[@type='origDate_notAfter']"/>
						</xsl:when>
					</xsl:choose>
					<xsl:copy-of select="tei:index[@indexName='norm_origDate']/tei:term[@type='origDate_type']"/>
				</xsl:element>
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
										<xsl:when test="matches(., '\d{4}') and string-length(.) = 4">
											<xsl:value-of select="."/>
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
										<xsl:when test="matches(., '\d{4}') and string-length(.) = 4">
											<xsl:value-of select="."/>
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
				<xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
					<xsl:attribute name="indexName" select=" 'norm_textLang' "/>
					<xsl:copy-of select="tei:index[@indexName='norm_textLang']/tei:term[@type='textLang']"/>
					<xsl:for-each select="tei:index[@indexName='norm_textLang']/tei:term[@type='textLang-ID']">
						<xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
							<xsl:attribute name="type" select=" 'textLang-ID' "/>
							<xsl:call-template name="writeTextLang-ID">
								<xsl:with-param name="key" select="."/>
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
						<xsl:choose>
							<xsl:when test="following-sibling::tei:msContents/tei:textLang[normalize-space(.) != '']">
								<xsl:value-of select="following-sibling::tei:msContents/tei:textLang"/>
							</xsl:when>
							<xsl:when test="following-sibling::tei:msContents/tei:textLang/@mainLang">
								<xsl:call-template name="writeTextLang">
									<xsl:with-param name="key" select="@mainLang"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="following-sibling::tei:msContents/tei:msItem/tei:textLang/@mainLang">
								<xsl:for-each select="distinct-values(following-sibling::tei:msContents/tei:msItem/tei:textLang/@mainLang)">
									<xsl:call-template name="writeTextLang">
										<xsl:with-param name="key" select="."/>
									</xsl:call-template>
								</xsl:for-each>
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
							<xsl:when test="ancestor::tei:msPart[@rend='condensed']">fragment</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/tei:objectDesc/@form = 'booklet' ">booklet</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/tei:objectDesc/@form = 'fascicle' ">booklet</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/tei:objectDesc/@form = 'fragment' ">fragment</xsl:when>
							<xsl:when test="following-sibling::tei:physDesc/tei:objectDesc/@form = 'leaf' ">singleSheet</xsl:when>
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
							<xsl:when test="($form = 'codex') and ancestor::tei:TEI/descendant::tei:keywords/tei:term[. = 'Illuminiert']">yes</xsl:when>
							<xsl:when test="($form = 'codex') and descendant::tei:decoNote[normalize-space(.) != '']">yes</xsl:when>
							<xsl:when test="($form = 'codex') and 
								( 
								ancestor::tei:TEI/descendant::tei:titleStmt/tei:title[contains(., 'illuminiert')]
								or ancestor::tei:TEI/descendant::tei:projectDesc[contains(., 'illuminiert')]
								or ancestor::tei:TEI/descendant::tei:source[contains(., 'illuminiert')]
								)">yes</xsl:when>
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
	<xsl:template match="tei:add | tei:biblScope | tei:catchwords | tei:desc | tei:dim | tei:figure | tei:formula | tei:label | tei:lg | tei:material | tei:measure | tei:notatedMusic | tei:orig | tei:w">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="tei:summary | 
		tei:filiation | 
		tei:musicNotation | 
		tei:additions | tei:collation | tei:condition | tei:extent | 
		tei:figDesc | tei:foliation | tei:handDesc | tei:handNote | 
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
						<xsl:apply-templates select="tei:listBibl"/>
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
	<xsl:template match="@ana | @*[. = '']"/>
	<xsl:template match="*[normalize-space(.) = ''][not(@*)][not(*/@*)][not(self::tei:msIdentifier) and not(self::tei:head)]"/>
	<xsl:template match="tei:adminInfo | tei:country | tei:dimensions[@type = 'leaf'] | tei:funder | tei:measure[@type = 'leavesCount'] | tei:pb | tei:profileDesc"/>
	
	<xsl:template name="writeTextLang">
		<xsl:param name="key"/>
		<xsl:choose>
			<xsl:when test="($key = 'ar') or ($key = 'ara')">arabisch</xsl:when>
			<xsl:when test="$key = 'ca' ">katalanisch</xsl:when>
			<xsl:when test="$key = 'cs' ">tschechisch</xsl:when>
			<xsl:when test="$key = 'cu' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'de' ">deutsch</xsl:when>
			<xsl:when test="($key = 'el') or ($key = 'grc')">griechisch</xsl:when>
			<xsl:when test="$key = 'en' ">englisch</xsl:when>
			<xsl:when test="$key = 'es' ">spanisch</xsl:when>
			<xsl:when test="$key = 'fr' ">französisch</xsl:when>
			<xsl:when test="$key = 'gmh' ">deutsch</xsl:when>
			<xsl:when test="$key = 'gml' ">deutsch</xsl:when>
			<xsl:when test="$key = 'goh' ">deutsch</xsl:when>
			<xsl:when test="$key = 'heb' ">hebräisch</xsl:when>
			<xsl:when test="$key = 'it' ">italienisch</xsl:when>
			<xsl:when test="$key = 'la' ">lateinisch</xsl:when>
			<xsl:when test="$key = 'nl' ">niederländisch</xsl:when>
			<xsl:when test="$key = 'pl' ">polnisch</xsl:when>
			<xsl:when test="$key = 'ru' ">russisch</xsl:when>
			<xsl:when test="$key = 'tur' ">türkisch</xsl:when>
			<xsl:when test="$key = 'wen' "><xsl:value-of select="$key"/></xsl:when>
			<xsl:when test="$key = 'yid' "><xsl:value-of select="$key"/></xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="writeTextLang-ID">
		<xsl:param name="key"/>
		<xsl:choose>
			<xsl:when test="($key = 'ar') or ($key = 'ara')">ar</xsl:when>
			<xsl:when test="($key = 'ca') or ($key = 'cat')">ca</xsl:when>
			<xsl:when test="($key = 'cs')">cs</xsl:when>
			<xsl:when test="($key = 'cu')">cu</xsl:when>
			<xsl:when test="($key = 'de') or ($key = 'deu') or ($key = 'ger')">de</xsl:when>
			<xsl:when test="($key = 'gmh') or ($key = 'gml') or ($key = 'goh')">de</xsl:when>
			<xsl:when test="($key = 'el') or ($key = 'gre') or ($key = 'grc')">el</xsl:when>
			<xsl:when test="($key = 'en') or ($key = 'eng')">en</xsl:when>
			<xsl:when test="($key = 'es') or ($key = 'spa')">es</xsl:when>
			<xsl:when test="($key = 'fr') or ($key = 'fra') or ($key = 'fre')">fr</xsl:when>
			<xsl:when test="($key = 'he') or ($key = 'heb')">he</xsl:when>
			<xsl:when test="($key = 'it') or ($key = 'ita')">it</xsl:when>
			<xsl:when test="($key = 'la') or ($key = 'lat')">la</xsl:when>
			<xsl:when test="($key = 'nl') or ($key = 'dut')">nl</xsl:when>
			<xsl:when test="($key = 'pl') or ($key = 'pol')">pl</xsl:when>
			<xsl:when test="($key = 'pt') or ($key = 'por')">pt</xsl:when>
			<xsl:when test="($key = 'ru')">ru</xsl:when>
			<xsl:when test="($key = 'syc')">syc</xsl:when>
			<xsl:when test="($key = 'syr')">syr</xsl:when>
			<xsl:when test="($key = 'tur')">tur</xsl:when>
			<xsl:when test="($key = 'wen')">wen</xsl:when>
			<xsl:when test="($key = 'yid')">yid</xsl:when>
			<xsl:when test="($key != '')">
				<xsl:message>unknown textLang-ID: '<xsl:value-of select="$key"/>'</xsl:message>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
