<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei marc" version="3.0">
	<xsl:output method="xml" indent="yes"/>
	<xsl:variable name="list" select="document('marc21_codes_mapping.xml')"/>
	<!-- Parameter zur Bestimmung, ob Dateiabfrage wiederholt oder erstmalig; muss noch definiert werden -->
	<xsl:param name="retrievalOccurence"/>
	<!-- Variablen für Kerndaten -->
	<xsl:variable name="numberOfOrigPlace" select="count($origPlace)"/>
	<xsl:variable name="normForm" select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_form']/tei:term[@type = 'form']"/>
	<xsl:variable name="extent" select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_measure']/tei:term[@type = 'measure']"/>
	<xsl:variable name="material" select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_material']/tei:term[@type = 'material']"/>
	<xsl:variable name="status" select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_status']/tei:term[@type = 'status']"/>
	<xsl:variable name="statusTerm">
		<xsl:choose>
			<xsl:when test="$status = 'displaced'">
				<xsl:text>Disloziert</xsl:text>
			</xsl:when>
			<xsl:when test="$status = 'missing'">
				<xsl:text>Verschollen</xsl:text>
			</xsl:when>
			<xsl:when test="$status = 'destroyed'">
				<xsl:text>Zerstört</xsl:text>
			</xsl:when>
			<xsl:when test="$status = 'unknown'">
				<xsl:text>Unbekannt</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Vorhanden</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="illustrated" select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_decoration']/tei:term[@type = 'decoration']"/>
	<xsl:variable name="notation" select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_musicNotation']/tei:term[@type = 'musicNotation']"/>
	<xsl:variable name="format" select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_format']/tei:term[@type = 'format']"/>
	<xsl:variable name="dimensions" select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_dimensions']/tei:term[@type = 'dimensions']"/>
	<xsl:variable name="title" select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_title']/tei:term[@type = 'title']"/>
	<!-- Variable für HSP-ID -->
	<xsl:variable name="hspID" select="descendant::tei:msDesc/@xml:id"/>
	<!-- Variable für Institutions-ID -->
	<xsl:variable name="instID" select="descendant::tei:msDesc/tei:msIdentifier/tei:repository/@ref"/>
	<!-- Variable für Links nach extern -->
	<xsl:variable name="extLink" select="descendant::tei:additional/tei:surrogates/tei:bibl/tei:ref[@type = 'other']"/>
	<xsl:variable name="manifestLink" select="descendant::tei:additional/tei:surrogates/tei:bibl/tei:ref[@type = 'manifest']/@target"/>
	<!-- Variable für leeres KOD -->
	<xsl:variable name="empty" select="$title = '' and $material = '' and $extent = '' and $dimensions = '' and $format = '' and $origPlace = '' and $origDate = '' and $textLang = '' and $normForm = '' and $status = '' and $illustrated = '' and $notation = ''"/>
	<!-- Variablen für Zeitdaten -->
	<xsl:variable name="origDate" select="descendant::tei:index[@indexName = 'norm_origDate']/tei:term[@type = 'origDate']"/>
	<xsl:variable name="numberOfDates" select="count($origDate)"/>
	<xsl:variable name="highestDate" select="max($origDate/following-sibling::tei:term[@type = 'origDate_notAfter']/xs:integer(.))"/>
	<xsl:variable name="lowestDate" select="min($origDate/following-sibling::tei:term[@type = 'origDate_notBefore']/xs:integer(.))"/>
	<xsl:variable name="numberDated" select="count($origDate[following-sibling::tei:term[@type = 'origDate_type'] = 'dated'])"/>
	<xsl:variable name="numberDatable" select="count($origDate[following-sibling::tei:term[@type = 'origDate_type'] = 'datable'])"/>
	<!-- Variablen für Ländercodes -->
	<xsl:variable name="origPlace" select="descendant::tei:msDesc/tei:head/tei:index[@indexName = 'norm_origPlace']/tei:term[@type = 'origPlace_norm']"/>
	<!-- Variablen für Sprachangaben -->
	<xsl:variable name="languageCode" xmlns=""> </xsl:variable>
	<xsl:variable name="textLang" select="descendant::tei:index[@indexName = 'norm_textLang']/tei:term[@type = 'textLang-ID']"/>
	<xsl:variable name="numberOfTextLang" select="count($textLang)"/>
	<xsl:variable name="sourceDoc">
		<xsl:value-of select="base-uri(tei:TEI)"/>
	</xsl:variable>
	<!-- Beginn Datensatz, Typ "Bibliographic" -->
	<xsl:template match="tei:TEI">
		<xsl:element name="record" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="type" select="'Bibliographic'"/>
			<xsl:call-template name="write_leader"/>
			<xsl:call-template name="write_001"/>
			<xsl:element name="controlfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="tag" select="'003'"/>
				<xsl:text>DE-629</xsl:text>
			</xsl:element>
			<xsl:call-template name="write_005"/>
			<xsl:call-template name="write_007"/>
			<xsl:call-template name="write_008"/>
			<xsl:call-template name="write_035"/>
			<xsl:call-template name="write_040"/>
			<xsl:if test="$textLang[. != '']">
				<xsl:call-template name="write_041"/>
			</xsl:if>
			<xsl:if test="$numberOfOrigPlace &gt; 1 or $list//countries/item[place = $sourceDoc//$origPlace/preceding-sibling::tei:term[@type = 'origPlace']]/MarcCountryCode[2]">
				<xsl:call-template name="write_044"/>
			</xsl:if>
			<xsl:call-template name="write_245_bvb"/>
			<!-- <xsl:call-template name="write_245"/> -->
			<xsl:if test="$title != ''">
				<xsl:call-template name="write_246"/>
			</xsl:if>
			<xsl:call-template name="write_264"/>
			<xsl:if test="$extent[. != ''] or $format[. != ''] or $illustrated[. = 'yes'] or $dimensions[. != '']">
				<xsl:call-template name="write_300_bvb"/>
				<!-- <xsl:call-template name="write_300"/> -->
			</xsl:if>
			<xsl:call-template name="write_336_txt"/>
			<xsl:if test="$illustrated = 'yes'">
				<xsl:call-template name="write_336_ill"/>
			</xsl:if>
			<xsl:call-template name="write_337"/>
			<xsl:call-template name="write_338"/>
			<xsl:if test="$material[. != '']">
				<xsl:call-template name="write_340"/>
			</xsl:if>
			<xsl:call-template name="write_500"/>
			<xsl:call-template name="write_655"/>
			<xsl:call-template name="write_852"/>
			<xsl:call-template name="write_856_hsp"/>
			<xsl:if test="$extLink != ''">
				<xsl:call-template name="write_856_ext"/>
			</xsl:if>
			<xsl:if test="$manifestLink != ''">
				<xsl:call-template name="write_856_iiif"/>
			</xsl:if>
			<xsl:if test="descendant::tei:surrogates/tei:bibl/tei:ref">
				<xsl:call-template name="write_940_bvb"/>
				<xsl:call-template name="write_955_bvb"/>
				<xsl:if test="$extLink != ''">
					<xsl:call-template name="write_982_bvb"/>
				</xsl:if>
			</xsl:if>
			<!-- <xsl:call-template name="write_980"/> -->
		</xsl:element>
	</xsl:template>
	<!-- HSP-ID als Kontrollnummer der den Datensatz erstellenden Institution: kann bei Datenübernahme mit Kontrollnummer der importierenden Institution überschrieben werden; die Institution, die vorliegende Kontrollnummer vergibt, wird in Feld 003 definiert -->
	<xsl:template name="write_leader">
		<xsl:element name="leader" namespace="http://www.loc.gov/MARC21/slim">
			<!-- Pos. 00-04: Länge des Datensatzes, maschinell belegt -->
			<xsl:text>00000</xsl:text>
			<!-- Pos. 05: Datensatz neu = "n" oder revidiert/korrigiert = "c"; Martin Baumgartner (BSB): betrifft die Perspektive der liefernden Institution -->
			<xsl:choose>
				<xsl:when test="descendant::tei:revisionDesc/tei:change">c</xsl:when>
				<xsl:otherwise>n</xsl:otherwise>
			</xsl:choose>
			<!-- Pos. 06: Art des Datensatzes, grobe Kategorisierung des beschriebenen Objekts; für das HSP pauschal auf "t" = handschriftliche Sprachmaterialien [für hsl. Noten eigtl. "d", für hsl. kartografisches Material "f", allerdings aus KOD-Daten nicht herauszulesen] -->
			<xsl:text>t</xsl:text>
			<!-- Pos. 07: Bibliografischer Level, grobe Kategorisierung der Veröffentlichungsform; für das HSP per default auf "m" (Monografie/Exemplar), bei Sammlungen auf "c" -->
			<xsl:choose>
				<xsl:when test="$normForm = 'collection'">c</xsl:when>
				<xsl:otherwise>m</xsl:otherwise>
			</xsl:choose>
			<!-- Pos. 08: Art der Beschreibung, Leerstelle für "nicht-archivarisch"; Pos. 09: Zeichenkodierungsschema, "a" für Unicode; Pos. 10: Indikatorzähler, pauschal "2"; Pos. 11: Unterfeldcode-Zähler, pauschal "2"; Pos. 12-16: Datenanfangsadresse, maschinell besetzt -->
			<xsl:text>&#32;a2200000</xsl:text>
			<!-- Pos. 17 (Katalogisierungslevel): in Abstimmung mit MARC-Experten ggf. anpassen; "_" für vollständigen, aufgrund Autopsie erstellten MARC-Datensatz; "1" für Daten, die ohne Autopsie von einer anderen Beschreibung abgeleitet wurden, wenn alle Angaben der Beschreibung übernommen wurden; „2“ für Daten, die ohne Autopsie von einer anderen Beschreibung abgeleitet wurden, wenn alle beschreibenden Sucheinstiege, aber nur Teile der anderen Datenelemente  übernommen wurden; „3“ für kurzen Datensatz, der nicht dem Minimallevel der Katalogisierungsanforderungen [...] entspricht; „z“, wenn kein Katalogisierungslevel auf den Datensatz anwendbar ist. TS votiert für "_", da zugrundeliegende Beschreibung auf einer Autopsie beruht -->
			<xsl:choose>
				<xsl:when test="$empty">z</xsl:when>
				<xsl:otherwise>2</xsl:otherwise>
			</xsl:choose>
			<!-- Pos. 18: Form der Formalerschließung, Leerzeichen für nicht ISBD-Regeln folgend, Pos. 19: Datensatzlevel für mehrbändige Ressourcen, Leerzeichen für nicht anwendbar; Felder 20-23: pauschal "4500" -->
			<xsl:text>&#32;&#32;4500</xsl:text>
		</xsl:element>
	</xsl:template>
	<!-- Kontrollnummer: ID der den Datensatz haltenden Institution; wird bei Import vom importierenden System überschrieben -->
	<xsl:template name="write_001">
		<xsl:element name="controlfield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'001'"/>
			<xsl:text>(DE-629)</xsl:text>
			<xsl:value-of select="$hspID"/>
		</xsl:element>
	</xsl:template>
	<!-- Versionskontrolle: Letzte Transaktion/Change Date: nach Absprache mit TS Festlegung letzte Transaktion = Abfragedatum/Export -->
	<xsl:template name="write_005">
		<xsl:element name="controlfield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'005'"/>
			<xsl:value-of select="format-dateTime(current-dateTime(), '[Y][M,2][D,2][H,2][m,2][s,2].[f,1-1]')"/>
		</xsl:element>
	</xsl:template>
	<!-- Allgemeiner Typ des Materials: nach Absprache mit TS pauschal auf unspezifiziertes Textmaterial ("tu") festgelegt -->
	<xsl:template name="write_007">
		<xsl:element name="controlfield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'007'"/>
			<xsl:text>tu</xsl:text>
		</xsl:element>
	</xsl:template>
	<!-- Allgemeine Informationen zu Datensatz und Objekttyp: Pos. 00-05 Datum der Ersterfassung in Abstimmung mit TS als Datum der Veröffentlichung des KODs im HSP = tei:date[@type = 'issued'] interpretiert -->
	<xsl:template name="write_008">
		<xsl:element name="controlfield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'008'"/>
			<!-- Pos. 00-05: Datum der Ersterfassung, in Abstimmung mit TS als Datum der Veröffentlichung des KODs im HSP = tei:date[@type = 'issued'] interpretiert -->
			<xsl:value-of select="format-date(descendant::tei:publicationStmt/tei:date[@type = 'issued']/@when, '[Y,2-2][M,2][D,2]')"/>
			<!-- Pos. 06: Art der Datumsangabe -->
			<xsl:choose>
				<!-- keine Datumsangabe = "b" -->
				<xsl:when test="not($origDate)">
					<xsl:text>b</xsl:text>
				</xsl:when>
				<xsl:when test="$numberOfDates = 1 and $origDate = '' and ($title != '' or $material != '' or $extent != '' or $dimensions != '' or $format != '' or $origPlace != '' or $textLang != '' or $normForm != '' or $status != '' or $illustrated != '' or $notation != '')">
					<xsl:text>b</xsl:text>
				</xsl:when>
				<!-- Datumsangaben unbekannt = "n" -->
				<xsl:when test="$numberOfDates = 1 and $empty">
					<xsl:text>n</xsl:text>
				</xsl:when>
				<!-- Einzig bekanntes/wahrscheinliches Datum = "s" -->
				<xsl:when test="$numberOfDates = 1 and $origDate[following-sibling::tei:term[@type = 'origDate_type'] = 'dated'] and $normForm != 'collection'">
					<xsl:text>s</xsl:text>
				</xsl:when>
				<!-- Geschätzte Datumsangaben = "q" -->
				<xsl:when test="$numberOfDates = 1 and $origDate[following-sibling::tei:term[@type = 'origDate_type'] = 'datable']">
					<xsl:text>q</xsl:text>
				</xsl:when>
				<xsl:when test="$numberOfDates &gt; 1 and $numberDated = 0">
					<xsl:text>q</xsl:text>
				</xsl:when>
				<!-- Mehrfache Datumsangaben = "m" -->
				<xsl:when test="$numberOfDates &gt; 1 and $numberDated &gt;= 1 and $normForm != 'collection'">
					<xsl:text>m</xsl:text>
				</xsl:when>
				<!-- Entstehungszeitraum einer Sammlung = "i" -->
				<xsl:when test="$numberOfDates &gt;= 1 and $numberDated &gt;= 1 and $origDate != '' and $normForm = 'collection'">
					<xsl:text>i</xsl:text>
				</xsl:when>
			</xsl:choose>
			<!-- Datum der Herstellung: Pos. 07-10 (erstes Datum) und 11-14 (zweites Datum); wenn Pos. 06 = "b" oder "n", 8 Leerzeichen-->
			<xsl:choose>
				<xsl:when test="not($origDate)">
					<xsl:text>&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;</xsl:text>
				</xsl:when>
				<xsl:when test="$origDate = ''">
					<xsl:text>&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;</xsl:text>
				</xsl:when>
				<xsl:when test="$numberOfDates = 1 and $origDate/following-sibling::tei:term[@type = 'origDate_notBefore'] = $origDate/following-sibling::tei:term[@type = 'origDate_notAfter']">
					<xsl:value-of select="$origDate/tei:term[@type = 'origDate_notBefore']"/>
					<xsl:text>&#32;&#32;&#32;&#32;</xsl:text>
				</xsl:when>
				<xsl:when test="$numberOfDates = 1 and $origDate/following-sibling::tei:term[@type = 'origDate_notBefore'] != $origDate/following-sibling::tei:term[@type = 'origDate_notAfter']">
					<xsl:value-of select="$origDate/following-sibling::tei:term[@type = 'origDate_notBefore']"/>
					<xsl:value-of select="$origDate/following-sibling::tei:term[@type = 'origDate_notAfter']"/>
				</xsl:when>
				<xsl:when test="$numberOfDates &gt; 1">
					<xsl:value-of select="$lowestDate"/>
					<xsl:value-of select="$highestDate"/>
				</xsl:when>
			</xsl:choose>
			<!-- Pos. 15-17: Ort der Herstellung = Land; lt. MARC-Regeln muss bei mehreren Ortsangaben hier das erste der in Feld 044 angegebenen Länder eingesetzt werden; da ein primärer Herstellungsort aus den KODs nicht herauszulesen ist, und die Reihenfolge in KOD und Hilfsdatei nicht zwangsläufig übereinstimmt, hier der alphabetisch erste Wert.
				Die Befüllung aus einer externen Liste stellt eine Interimslösung dar: sobald die Länderdaten in den Graphen eingepflegt sind, sollen diese aus letzterem gezogen werden -->
			<xsl:choose>
				<xsl:when test="$numberOfOrigPlace = 0">
					<xsl:text>xx&#32;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$origPlace = ''">xx&#32;</xsl:when>
						<!-- Die folgende When-Schleife soll den Fall abfangen, dass einer von mehreren term[@type="origPlace_norm"] leer ist, oder belegt, aber ohne GND-ID -->
						<xsl:when test="$origPlace[(@ref = 'http://d-nb.info/gnd/') or (@ref = '')]">
							<xsl:for-each select="$list//countries/item[place = $sourceDoc//$origPlace/preceding-sibling::tei:term[@type = 'origPlace']]/MarcCountryCode">
								<xsl:sort select="." order="ascending"/>
								<xsl:if test="position() = 1">
									<xsl:value-of select="."/>
									<xsl:if test="not(matches(., '\w{3}'))">
										<xsl:text>&#32;</xsl:text>
									</xsl:if>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="$list//countries/item[gndGeoID = $sourceDoc//$origPlace/@ref]/MarcCountryCode">
								<xsl:sort select="." order="ascending"/>
								<xsl:if test="position() = 1">
									<xsl:value-of select="."/>
									<xsl:if test="not(matches(., '\w{3}'))">
										<xsl:text>&#32;</xsl:text>
									</xsl:if>
								</xsl:if>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Pos. 18-21: Illustrationsangaben: "||||" = keine Angabe; nach Absprache mit TS pauschal auf Buchmalerei ("p"), wenn Buchschmuck vorhanden  -->
			<xsl:choose>
				<xsl:when test="$illustrated = 'yes'">
					<xsl:text>&#32;&#32;&#32;p</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>&#32;&#32;&#32;&#32;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Pos. 22: Zielgruppe: Leerzeichen = nicht spezifiziert oder "|" = keine Angabe -->
			<xsl:text>&#32;</xsl:text>
			<!-- Pos. 23: Art der Vorlage: "|" = keine Angabe -->
			<xsl:text>|</xsl:text>
			<!-- Pos. 24-27: Art des Inhalts: "||||" = keine Angabe oder vier Leerzeichen = nicht näher bestimmt -->
			<xsl:text>||||</xsl:text>
			<!-- Pos. 28-31: Amtsdruckschrift, Kongressschrift, Festschrift oder Register: "||||" = keine Angabe oder "&#32;000" = kein(e) Amtsdruckschrift/Kongressschrift/Festschrift/Register -->
			<xsl:text>||||</xsl:text>
			<!-- Pos. 32: nicht definierte Position -->
			<xsl:text>&#32;</xsl:text>
			<!-- Pos. 33: literarische Form: "|" = keine Angabe -->
			<xsl:text>|</xsl:text>
			<!-- Pos. 34: Biografie: "|" = keine Angabe -->
			<xsl:text>|</xsl:text>
			<!-- Pos. 35-37: (vorherrschende) Sprache: lt. MARC-Regeln muss bei mehreren Sprachangaben hier die erste der in Feld 041 angegebenen Sprachen eingesetzt werden, und soll der vorherrschenden Sprache des Objekts entsprechen; die vorherrschende Sprache ist allerdings aus den KOD-Daten nicht ablesbar. Bei mehreren Sprachangaben als Alternative denkbar: multiple languages ("mul") -->
			<xsl:choose>
				<xsl:when test="$numberOfTextLang = 0">und</xsl:when>
				<xsl:when test="$numberOfTextLang = 1">
					<xsl:choose>
						<xsl:when test="$textLang = ''">und</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$list//languages/item[@key = $sourceDoc//$textLang]"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$numberOfTextLang &gt; 1">
					<xsl:value-of select="$list//languages/item[@key = $sourceDoc//$textLang[1]]"/>
					<!-- <xsl:text>mul</xsl:text> -->
				</xsl:when>
			</xsl:choose>
			<!-- Pos. 38: modifizierter Datensatz: Leerzeichen = nicht modifiziert -->
			<xsl:text>&#32;</xsl:text>
			<!-- Pos. 39: Katalogisierungsquelle: "d" = weder nationalbibliografische Agentur noch kooperatives Katalogisierungsprogramm -->
			<xsl:text>d</xsl:text>
		</xsl:element>
	</xsl:template>
	<!-- HSP-ID als "andere" Kontrollnummer: bleibt stehen, auch wenn die Datensatz haltende Institution Felder 001 und 003 besetzen -->
	<xsl:template name="write_035">
		<xsl:element name="datafield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'035'"/>
			<xsl:attribute name="ind1" select="' '"/>
			<xsl:attribute name="ind2" select="' '"/>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'a'"/>
				<xsl:text>(DE-629)</xsl:text>
				<xsl:value-of select="$hspID"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- Unterfeld $a: HSP als "Original-Katalogisierungsstelle", bestimmt mit Feld 008/39 die Verantwortlichen für den Datensatz; außerdem Katalogisierungssprache, Überschreibungsstelle und - nach DNB: Marc 21 für bibliographische Daten - per Default Kennzeichnung als RDA-Datensatz; für Unterfeld $e ggf. "DFG-Richtlinien Handschriftenkatalogisierung für Beschreibungsregeln? -->
	<xsl:template name="write_040">
		<xsl:element name="datafield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'040'"/>
			<xsl:attribute name="ind1" select="' '"/>
			<xsl:attribute name="ind2" select="' '"/>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'a'"/>
				<xsl:text>DE-629</xsl:text>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'b'"/>
				<xsl:text>ger</xsl:text>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'c'"/>
				<xsl:text>DE-629</xsl:text>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'e'"/>
				<xsl:text>rda</xsl:text>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- Schreibsprachen: bei mehreren Sprachen erfolgt hier die vollständige Auflistung in der durch das KOD vorgegebenen Reihenfolge (vorherrschende Sprache nicht feststellbar); (nur) der erste Wert wird in Feld 008/35-37 ausgegeben -->
	<xsl:template name="write_041">
		<xsl:element name="controlfield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'041'"/>
			<xsl:attribute name="ind1" select="' '"/>
			<xsl:attribute name="ind2" select="' '"/>
			<xsl:choose>
				<xsl:when test="$numberOfTextLang = 0">
					<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
						<xsl:attribute name="code" select="'a'"/>
						<xsl:text>und</xsl:text>
					</xsl:element>
				</xsl:when>
				<xsl:when test="$numberOfTextLang = 1">
					<xsl:choose>
						<xsl:when test="$textLang = ''">
							<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
								<xsl:attribute name="code" select="'a'"/>
								<xsl:text>und</xsl:text>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
								<xsl:attribute name="code" select="'a'"/>
								<xsl:value-of select="$list//languages/item[@key = $sourceDoc//$textLang]"/>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$numberOfTextLang &gt; 1">
					<xsl:for-each select="$textLang">
						<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
							<xsl:attribute name="code" select="'a'"/>
							<xsl:value-of select="$list//languages/item[@key = current()]"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<!-- Ländercodes: bei Ortsangaben, die mehrere Länder übergreifen, erfolgt hier die vollständige Auflistung, (nur) der erste Wert wird in Feld 008/15-17 ausgegeben; da ein primärer Herstellungsort aus den KODs nicht herauszulesen ist, und die Reihenfolge in KOD und Hilfsdatei nicht zwangsläufig übereinstimmt, hier alphabetisch geordnet -->
	<xsl:template name="write_044">
		<xsl:element name="controlfield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'044'"/>
			<xsl:attribute name="ind1" select="' '"/>
			<xsl:attribute name="ind2" select="' '"/>
			<!-- When-Schleife noch zu überarbeiten!!! Vgl. Feld 008/15-17 -->
			<xsl:choose>
				<xsl:when test="$origPlace[(@ref = 'http://d-nb.info/gnd/') or (@ref = '')]">
					<xsl:for-each select="$list//countries/item[place = $sourceDoc//$origPlace/preceding-sibling::tei:term[@type = 'origPlace']]/MarcCountryCode">
						<xsl:sort select="." order="ascending"/>
						<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
							<xsl:attribute name="code" select="'a'"/>
							<xsl:value-of select="."/>
						</xsl:element>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each-group select="$origPlace/@ref" group-by="$list//countries/item[gndGeoID = $origPlace/@ref]/MarcCountryCode">
						<xsl:sort select="current-grouping-key()" order="ascending"/>
						<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
							<xsl:attribute name="code" select="'a'"/>
							<xsl:value-of select="current-grouping-key()"/>
						</xsl:element>
					</xsl:for-each-group>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<!-- Identifikation: in der vorliegenden Form ("write_245_bvb") an die Belegungskonventionen des BVB angepasst -->
	<xsl:template name="write_245_bvb">
		<xsl:element name="controlfield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'245'"/>
			<xsl:attribute name="ind1" select="'1'"/>
			<xsl:attribute name="ind2" select="'0'"/>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'a'"/>
				<xsl:if test="$title != ''">
					<xsl:value-of select="$title"/>
					<xsl:text>&#32;-&#32;</xsl:text>
				</xsl:if>
				<xsl:value-of select="descendant::tei:msDesc/tei:msIdentifier/concat(tei:settlement, ', ', tei:repository, ', ', tei:idno)"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- <xsl:template name="write_245">
		<xsl:element name="controlfield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'245'"/>
			<xsl:attribute name="ind1" select="'1'"/>
			<xsl:attribute name="ind2" select="'0'"/>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'a'"/>
				<xsl:value-of select="descendant::tei:msDesc/tei:msIdentifier/concat(tei:settlement, ', ', tei:repository, ', ', tei:idno)"/>
			</xsl:element>
		</xsl:element>
	</xsl:template> -->
	<!-- Schlagzeilentitel als alternativer Titel: über 2. Indikator ggf. als "spezifischer Titel" ("2") zu kennzeichnen? -->
	<xsl:template name="write_246">
		<xsl:element name="controlfield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'246'"/>
			<xsl:attribute name="ind1" select="'1'"/>
			<xsl:attribute name="ind2" select="' '"/>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'a'"/>
				<xsl:value-of select="$title"/>
			</xsl:element>
			<!-- <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'i'"/>
				<xsl:text>Titel der Handschrift: </xsl:text>
			</xsl:element> -->
		</xsl:element>
	</xsl:template>
	<!-- Entstehungsort und -datum -->
	<xsl:template name="write_264">
		<xsl:element name="datafield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'264'"/>
			<xsl:attribute name="ind1" select="' '"/>
			<xsl:attribute name="ind2" select="'0'"/>
			<!-- Unterfeld $a: Entstehungsort; nach Absprache mit TS nicht in normierter Form (tei:term[@type='origPlace_norm']), sondern in TEI-Freitextform (tei:term[@type='origPlace']) -->
			<xsl:if test="$origPlace != ''">
				<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
					<xsl:attribute name="code" select="'a'"/>
					<xsl:value-of select="$origPlace/preceding-sibling::tei:term[@type = 'origPlace']"/>
				</xsl:element>
			</xsl:if>
			<xsl:choose>
				<!-- Entstehungszeit: Auslassen des Unterfelds, wenn reines Signaturdokument vorliegt? -->
				<xsl:when test="$empty">
					<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
						<xsl:attribute name="code" select="'c'"/>
						<xsl:text>1XXX</xsl:text>
					</xsl:element>
				</xsl:when>
				<!-- Entstehungszeit: tatsächlich "1XXX", wenn keine Angabe der Entstehungszeit? -->
				<xsl:when test="$numberOfDates = 1 and $origDate = '' and not($empty)">
					<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
						<xsl:attribute name="code" select="'c'"/>
						<xsl:text>1XXX</xsl:text>
					</xsl:element>
				</xsl:when>
				<xsl:when test="$numberOfDates &gt;= 1 and $origDate != ''">
					<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
						<xsl:attribute name="code" select="'c'"/>
						<xsl:value-of select="$origDate" separator="; "/>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<!-- Umfang, Buchschmuck, Größe, Format: in der vorliegenden Form ("write_300_bvb") an die Belegungskonventionen des BVB angepasst  -->
	<xsl:template name="write_300_bvb">
		<xsl:element name="datafield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'300'"/>
			<xsl:attribute name="ind1" select="' '"/>
			<xsl:attribute name="ind2" select="' '"/>
			<!-- Unterfeld $a für Umfang ist eigentlich Pflichtfeld -->
			<xsl:if test="$extent[. != ''] or $material[. != '']">
				<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
					<xsl:attribute name="code" select="'a'"/>
					<xsl:value-of select="$extent"/>
					<xsl:text> - </xsl:text>
					<xsl:value-of select="$material"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$dimensions[. != ''] or $format[. != '']">
				<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
					<xsl:attribute name="code" select="'c'"/>
					<xsl:choose>
						<xsl:when test="$dimensions != '' and $format != ''">
							<xsl:value-of select="$dimensions"/>
							<xsl:text> (</xsl:text>
							<xsl:value-of select="$format"/>
							<xsl:text>)</xsl:text>
						</xsl:when>
						<xsl:when test="$dimensions != '' and $format = ''">
							<xsl:value-of select="$dimensions"/>
						</xsl:when>
						<xsl:when test="$dimensions = '' and $format != ''">
							<xsl:value-of select="$format"/>
						</xsl:when>
					</xsl:choose>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<!-- <xsl:template name="write_300">
		<xsl:element name="datafield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'300'"/>
			<xsl:attribute name="ind1" select="' '"/>
			<xsl:attribute name="ind2" select="' '"/>
			Unterfeld $a für Umfang ist eigentlich Pflichtfeld
			<xsl:if test="$extent[. != '']">
				<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
					<xsl:attribute name="code" select="'a'"/>
					<xsl:value-of select="$extent"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$illustrated = 'yes' or $notation = 'yes'">
				<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
					<xsl:attribute name="code" select="'b'"/>
					<xsl:choose>
						<xsl:when test="$illustrated = 'yes' and $notation != 'yes'">
							<xsl:text>Buchschmuck enthalten</xsl:text>
						</xsl:when>
						<xsl:when test="$illustrated != 'yes' and $notation = 'yes'">
							<xsl:text>Musiknotation enthalten</xsl:text>
						</xsl:when>
						<xsl:when test="$illustrated = 'yes' and $notation = 'yes'">
							<xsl:text>Buchschmuck und Musiknotation enthalten</xsl:text>
						</xsl:when>
					</xsl:choose>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$dimensions[. != ''] or $format[. != '']">
				<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
					<xsl:attribute name="code" select="'c'"/>
					<xsl:choose>
						<xsl:when test="$dimensions != '' and $format != ''">
							<xsl:value-of select="$dimensions"/>
							<xsl:text> cm (</xsl:text>
							<xsl:value-of select="$format"/>
							<xsl:text>)</xsl:text>
						</xsl:when>
						<xsl:when test="$dimensions != '' and $format = ''">
							<xsl:value-of select="$dimensions"/>
							<xsl:text> cm</xsl:text>
						</xsl:when>
						<xsl:when test="$dimensions = '' and $format != ''">
							<xsl:value-of select="$format"/>
						</xsl:when>
					</xsl:choose>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template> -->
	<!-- Felder 336-338: RDA-Angaben: Rücksprache zu halten mit Hrn. Boveland resp. Fr. Remmer, ob unsere Daten RDA-konform -->
	<!-- RDA-Inhaltstyp: pauschal auf Text, auch bei Wappenbüchern, Kartenwerken oder Partituren (aus KODs nicht auslesbar) -->
	<xsl:template name="write_336_txt">
		<xsl:element name="datafield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'336'"/>
			<xsl:attribute name="ind1" select="' '"/>
			<xsl:attribute name="ind2" select="' '"/>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'a'"/>
				<xsl:text>Text</xsl:text>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'b'"/>
				<xsl:text>txt</xsl:text>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'c'"/>
				<xsl:text>rdacontent</xsl:text>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template name="write_336_ill">
		<xsl:element name="datafield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'336'"/>
			<xsl:attribute name="ind1" select="' '"/>
			<xsl:attribute name="ind2" select="' '"/>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'a'"/>
				<xsl:text>unbewegtes Bild</xsl:text>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'b'"/>
				<xsl:text>sti</xsl:text>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'c'"/>
				<xsl:text>rdacontent</xsl:text>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- RDA-Medientyp -->
	<xsl:template name="write_337">
		<xsl:element name="datafield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'337'"/>
			<xsl:attribute name="ind1" select="' '"/>
			<xsl:attribute name="ind2" select="' '"/>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'a'"/>
				<xsl:text>ohne Hilfsmittel zu benutzen</xsl:text>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'b'"/>
				<xsl:text>n</xsl:text>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'c'"/>
				<xsl:text>rdamedia</xsl:text>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- RDA-Datenträgertyp: Unschärfen bei Fragmenten ("Blatt", wenn mehrere ungeordnete), Sammlungen (geordnete/gezählte Loseblattsammlungen = "Band", ungeordnete Loseblattsammlungen = "Blatt", keine Kategorie für Sammlungen gemischten Materials), Heften (bei uns "Sonstiges", für RDA i.A. "Band") -->
	<xsl:template name="write_338">
		<xsl:element name="datafield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'338'"/>
			<xsl:attribute name="ind1" select="' '"/>
			<xsl:attribute name="ind2" select="' '"/>
			<xsl:choose>
				<!-- Die Klausel or ($normForm = 'fragment' and $extent/following-sibling::tei:term[@type = 'measure_noOfLeaves'] = '') bietet ein Failsafe für den Fall, dass tei:term[@type = 'measure_noOfLeaves'] nicht belegt ist, verursacht dadurch aber auch eine Unschärfe: zu entfernen, wenn dieser Wert (entspricht MXML-Feld 5706rech) überall nachgerüstet ist -->
				<xsl:when test="$normForm = 'codex' or $normForm = 'composite' or $normForm = 'sammelband' or $normForm = 'printWithManuscriptParts' or $normForm = 'hostVolume' or ($normForm = 'fragment' and $extent/following-sibling::tei:term[@type = 'measure_noOfLeaves'] = '') or ($normForm = 'fragment' and $extent/following-sibling::tei:term[@type = 'measure_noOfLeaves'] &gt;= 2) or $normForm = ''">
					<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
						<xsl:attribute name="code" select="'a'"/>
						<xsl:text>Band</xsl:text>
					</xsl:element>
					<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
						<xsl:attribute name="code" select="'b'"/>
						<xsl:text>nc</xsl:text>
					</xsl:element>
				</xsl:when>
				<xsl:when test="$normForm = 'singleSheet' or ($normForm = 'fragment' and $extent/following-sibling::tei:term[@type = 'measure_noOfLeaves'] = 1)">
					<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
						<xsl:attribute name="code" select="'a'"/>
						<xsl:text>Blatt</xsl:text>
					</xsl:element>
					<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
						<xsl:attribute name="code" select="'b'"/>
						<xsl:text>nb</xsl:text>
					</xsl:element>
				</xsl:when>
				<xsl:when test="$normForm = 'scroll'">
					<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
						<xsl:attribute name="code" select="'a'"/>
						<xsl:text>Rolle</xsl:text>
					</xsl:element>
					<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
						<xsl:attribute name="code" select="'b'"/>
						<xsl:text>na</xsl:text>
					</xsl:element>
				</xsl:when>
				<xsl:when test="$normForm = 'collection' or $normForm = 'other'">
					<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
						<xsl:attribute name="code" select="'a'"/>
						<xsl:text>Sonstige Datenträger, die ohne Hilfsmittel zu benutzen sind</xsl:text>
					</xsl:element>
					<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
						<xsl:attribute name="code" select="'b'"/>
						<xsl:text>nz</xsl:text>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'c'"/>
				<xsl:text>rdacarrier</xsl:text>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- Beschreibstoff für Materialien, die besonderer Aufbewahrung oder Erhaltung bedürfen; mit TS abgestimmt -->
	<xsl:template name="write_340">
		<xsl:element name="datafield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'340'"/>
			<xsl:attribute name="ind1" select="' '"/>
			<xsl:attribute name="ind2" select="' '"/>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'a'"/>
				<xsl:value-of select="$material"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- Allgemeine Fußnoten: Kennzeichnung Fremddatenübernahme; mit MARC-Experten (und Datennehmern) abstimmen -->
	<xsl:template name="write_500">
		<xsl:element name="datafield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'500'"/>
			<xsl:attribute name="ind1" select="' '"/>
			<xsl:attribute name="ind2" select="' '"/>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'a'"/>
				<xsl:text>Fremddatenübernahme aus HSP</xsl:text>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- Formtyp: wenn nicht Codex, dann ... überarbeiten bzw. abklären! -->
	<xsl:template name="write_655">
		<xsl:element name="datafield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'655'"/>
			<xsl:attribute name="ind1" select="' '"/>
			<xsl:attribute name="ind2" select="'7'"/>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'a'"/>
				<xsl:text>Handschrift</xsl:text>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'0'"/>
				<xsl:text>(DE-588)4023287-6</xsl:text>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'0'"/>
				<xsl:text>(DE-627)10457187X</xsl:text>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'0'"/>
				<xsl:text>(DE-576)208948376</xsl:text>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'2'"/>
				<xsl:text>gnd-content</xsl:text>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- HSP-Link -->
	<xsl:template name="write_856_hsp">
		<xsl:element name="datafield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'856'"/>
			<xsl:attribute name="ind1" select="'4'"/>
			<xsl:attribute name="ind2" select="'0'"/>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'q'"/>
				<xsl:text>text/html</xsl:text>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'u'"/>
				<xsl:text>https://www.handschriftenportal.de/search?q=</xsl:text>
				<xsl:value-of select="$hspID"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- Link zu externer elektronischer Ressource -->
	<xsl:template name="write_856_ext">
		<xsl:element name="datafield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'856'"/>
			<xsl:attribute name="ind1" select="'4'"/>
			<xsl:attribute name="ind2" select="'2'"/>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'q'"/>
				<xsl:text>text/html</xsl:text>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'u'"/>
				<xsl:value-of select="$extLink"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- Link zu externem Manifest -->
	<xsl:template name="write_856_iiif">
		<xsl:element name="datafield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'856'"/>
			<xsl:attribute name="ind1" select="'4'"/>
			<xsl:attribute name="ind2" select="'0'"/>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'q'"/>
				<xsl:text>application/json</xsl:text>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'u'"/>
				<xsl:value-of select="$manifestLink"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- Statusangabe: anstelle von Feld 980 (nur lokal definiert und unterschiedlich belegt: bei SBB Signatur u.a. (Lokaldaten?), im Deutschen Exilarchiv für Sortiernamen) allgemein definiertes Feld 852 gewählt, nimmt bei Exporten Info aus in Konkordanztabelle genanntem PICA-Feld 4801 auf -->
	<xsl:template name="write_852">
		<xsl:element name="datafield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'852'"/>
			<xsl:attribute name="ind1" select="' '"/>
			<xsl:attribute name="ind2" select="' '"/>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'z'"/>
				<xsl:value-of select="$statusTerm"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- lokaler Inhalt BDR, nur für Aufnahmen mit Digitalisat: Bibliographische Identifier des Quellsystems; $a = Identifier des Katalogsystems, $b = Identifier des OAI-PMH-Repositoriums [für uns also erst belegbar, wenn OAI-Schnittstelle eingerichtet und deren Adresse bekannt ist?!] -->
	<xsl:template name="write_940_bvb">
		<xsl:element name="datafield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'940'"/>
			<xsl:attribute name="ind1" select="' '"/>
			<xsl:attribute name="ind2" select="' '"/>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'a'"/>
				<xsl:text>(DE-629)</xsl:text>
				<xsl:value-of select="$hspID"/>
			</xsl:element>
			<!-- <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'b'"/>
			</xsl:element> -->
		</xsl:element>
	</xsl:template>
	<!-- lokaler Inhalt BDR, nur für Aufnahmen mit Digitalisat: $a = Signatur, $b = "[Ort], [aufbewahrende Institution]", $c = ISIL-Sigle der aufbewahrenden Institution; Für $c noch Liste der ISIL-Siglen aller aufbewahrenden Institutionen im HSP erstellen und in Hilfsdatei einarbeiten!!! -->
	<xsl:template name="write_955_bvb">
		<xsl:element name="datafield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'955'"/>
			<xsl:attribute name="ind1" select="' '"/>
			<xsl:attribute name="ind2" select="' '"/>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'a'"/>
				<xsl:value-of select="descendant::tei:msDesc/tei:msIdentifier/tei:idno"/>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'b'"/>
				<xsl:value-of select="descendant::tei:msDesc/tei:msIdentifier/tei:settlement"/>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="descendant::tei:msDesc/tei:msIdentifier/tei:repository"/>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'c'"/>
				<xsl:value-of select="$list//institutions/item[gndID = $instID]/isil"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- lokaler Inhalt BDR: $d = Änderungsdatum der Strukturdatei, $t = Link zum Thumbnail -->
	<xsl:template name="write_982_bvb">
		<xsl:element name="datafield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'982'"/>
			<xsl:attribute name="ind1" select="' '"/>
			<xsl:attribute name="ind2" select="' '"/>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'d'"/>
				<xsl:value-of select="descendant::tei:msDesc/tei:additional/tei:surrogates/tei:bibl/tei:date[@type = 'published']"/>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'t'"/>
				<xsl:value-of select="descendant::tei:msDesc/tei:additional/tei:surrogates/tei:bibl/tei:ref[@type = 'thumbnail']/@target"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- Exemplarebene: Signatur. Feld 980 ist nur lokal definiert, und wird daher nicht in allen Systemen angesteuert; außerdem unterschiedlich belegt, in der GND z.B. mit Sortiernamen des Deutschen Exilarchivs. Signaturdaten sind außerdem schon in Feld 245 -->
	<xsl:template name="write_980_bvb">
		<xsl:element name="controlfield" namespace="http://www.loc.gov/MARC21/slim">
			<xsl:attribute name="tag" select="'980'"/>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'f'"/>
				<xsl:text>1:HSM</xsl:text>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'d'"/>
				<xsl:value-of select="descendant::tei:msDesc/tei:msIdentifier/tei:idno"/>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'e'"/>
				<xsl:text>i</xsl:text>
			</xsl:element>
			<xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
				<xsl:attribute name="code" select="'k'"/>
				<xsl:choose>
					<xsl:when test="$status[. != '']">
						<xsl:value-of select="$status"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>vorhanden</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="$status[. != '']">
					<xsl:text>, </xsl:text>
				</xsl:if>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
