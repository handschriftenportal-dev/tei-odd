<xsl:variable name="convert_0000" select="replace($___, '0000', 'Dokument-Nr.')"/>
<xsl:variable name="convert_0080" select="replace($___, '0080', 'Definition*')"/>
<xsl:variable name="convert_0101" select="replace($___, '0101', 'Begriff')"/>
<xsl:variable name="convert_0102" select="replace($___, '0102', 'Synonym')"/>
<xsl:variable name="convert_0151" select="replace($___, '0151', 'Siehe-auch-Begr.')"/>
<xsl:variable name="convert_0171" select="replace($___, '0171', 'gesperrter Begriff')"/>
<xsl:variable name="convert_0181" select="replace($___, '0181', 'Unterbegriff')"/>
<xsl:variable name="convert_0301" select="replace($___, '0301', 'Oberbegriff')"/>
<xsl:variable name="convert_0360" select="replace($___, '0360', 'höhere Oberbegr.')"/>
<xsl:variable name="convert_0370" select="replace($___, '0370', 'sekund. Oberbegr.')"/>
<xsl:variable name="convert_1000" select="replace($___, '1000', 'Dokument-Nr.')"/>
<xsl:variable name="convert_1022" select="replace($___, '1022', 'verbale Datierung')"/>
<xsl:variable name="convert_1024" select="replace($___, '1024', 'numerische Datier.')"/>
<xsl:variable name="convert_1100" select="replace($___, '1100', 'Dokument-Nr.')"/>
<xsl:variable name="convert_1103" select="replace($___, '1103', 'SBB-Dokument-Nr.')"/>
<xsl:variable name="convert_1104" select="replace($___, '1104', 'Benutzerkennung')"/>
<xsl:variable name="convert_1105" select="replace($___, '1105', 'Benutzerdatum')"/>
<xsl:variable name="convert_1106" select="replace($___, '1106', 'Redaktionsdatum')"/>
<xsl:variable name="convert_1200" select="replace($___, '1200', 'Begriff 0')"/>
<xsl:variable name="convert_1200gi" select="replace($___, '1200gi', 'Begriff 0')"/>
<xsl:variable name="convert_1202gi" select="replace($___, '1202gi', 'f-Begriff 0')"/>
<xsl:variable name="convert_1204gi" select="replace($___, '1204gi', 'p-Begriff 0')"/>
<xsl:variable name="convert_1210" select="replace($___, '1210', 'Begriff 1')"/>
<xsl:variable name="convert_1210gi" select="replace($___, '1210gi', 'Begriff 1')"/>
<xsl:variable name="convert_1212gi" select="replace($___, '1212gi', 'f-Begriff 1')"/>
<xsl:variable name="convert_1214gi" select="replace($___, '1214gi', 'p-Begriff 1')"/>
<xsl:variable name="convert_1216gi" select="replace($___, '1216gi', 'siehe-Verweis 1')"/>
<xsl:variable name="convert_1220" select="replace($___, '1220', 'Begriff 2')"/>
<xsl:variable name="convert_1220gi" select="replace($___, '1220gi', 'Begriff 2')"/>
<xsl:variable name="convert_1222gi" select="replace($___, '1222gi', 'f-Begriff 2')"/>
<xsl:variable name="convert_1224gi" select="replace($___, '1224gi', 'p-Begriff 2')"/>
<xsl:variable name="convert_1226gi" select="replace($___, '1226gi', 'siehe-Verweis 2')"/>
<xsl:variable name="convert_1230" select="replace($___, '1230', 'Begriff 3')"/>
<xsl:variable name="convert_1230gi" select="replace($___, '1230gi', 'Begriff 3')"/>
<xsl:variable name="convert_1232gi" select="replace($___, '1232gi', 'f-Begriff 3')"/>
<xsl:variable name="convert_1240" select="replace($___, '1240', 'Begriff 4')"/>
<xsl:variable name="convert_1240gi" select="replace($___, '1240gi', 'Begriff 4')"/>
<xsl:variable name="convert_1250" select="replace($___, '1250', 'siehe-Verweis')"/>
<xsl:variable name="convert_1250gi" select="replace($___, '1250gi', 'siehe-Verweis')"/>
<xsl:variable name="convert_1700" select="replace($___, '1700', 'Dokument-Nr.')"/>
<xsl:variable name="convert_1703" select="replace($___, '1703', 'SBB-Dokument-Nr.')"/>
<xsl:variable name="convert_1704" select="replace($___, '1704', 'Benutzerkennung')"/>
<xsl:variable name="convert_1706" select="replace($___, '1706', 'Benutzerdatum')"/>
<xsl:variable name="convert_1707" select="replace($___, '1707', 'Redaktionsdatum')"/>
<xsl:variable name="convert_1800" select="replace($___, '1800', 'Initium lateinisch')"/>
<xsl:variable name="convert_1802" select="replace($___, '1802', 'Initium deutsch')"/>
<xsl:variable name="convert_1802a" select="replace($___, '1802a', 'Grundwort Lexer')"/>
<xsl:variable name="convert_1802b" select="replace($___, '1802b', 'Grundwort Lüb.')"/>
<xsl:variable name="convert_1804" select="replace($___, '1804', 'Initium variaspr.')"/>
<xsl:variable name="convert_1900" select="replace($___, '1900', 'Dokument-Nr.')"/>
<xsl:variable name="convert_1903" select="replace($___, '1903', 'BIB-Dokument-Nr.')"/>
<xsl:variable name="convert_1904" select="replace($___, '1904', 'Benutzerkennung')"/>
<xsl:variable name="convert_1905" select="replace($___, '1905', 'Benutzerdatum')"/>
<xsl:variable name="convert_1910" select="replace($___, '1910', 'Katalogkürzel')"/>
<xsl:variable name="convert_1920" select="replace($___, '1920', 'Bibliotheksname')"/>
<xsl:variable name="convert_1921" select="replace($___, '1921', 'Bibl-Name altern.')"/>
<xsl:variable name="convert_1930" select="replace($___, '1930', 'Bibliotheksort')"/>
<xsl:variable name="convert_1931" select="replace($___, '1931', 'Bibl-Ort altern.')"/>
<xsl:variable name="convert_1943" select="replace($___, '1943', 'Sammlung')"/>
<xsl:variable name="convert_1945" select="replace($___, '1945', 'Grundsignatur')"/>
<xsl:variable name="convert_1950" select="replace($___, '1950', 'GI-Signatur')"/>
<xsl:variable name="convert_1951" select="replace($___, '1951', 'GI-Signatur-Zus.')"/>
<xsl:variable name="convert_1960" select="replace($___, '1960', 'Katalogname')"/>
<xsl:variable name="convert_1961" select="replace($___, '1961', 'GI-Folio-Nr.')"/>
<xsl:variable name="convert_1980" select="replace($___, '1980', 'bibliogr. Angabe')"/>
<xsl:variable name="convert_1985" select="replace($___, '1985', 'SBB-Signatur')"/>
<xsl:variable name="convert_2000" select="replace($___, '2000', 'Dokument-Nr.')"/>
<xsl:variable name="convert_2050" select="replace($___, '2050', 'Name d.geogr.Ent.')"/>
<xsl:variable name="convert_2050a" select="replace($___, '2050a', 'Ortsname altern.')"/>
<xsl:variable name="convert_2050p" select="replace($___, '2050p', 'Ortsname poln.')"/>
<xsl:variable name="convert_2050sa" select="replace($___, '2050sa', 'siehe-auch-Ortsn.')"/>
<xsl:variable name="convert_2055" select="replace($___, '2055', 'Art d.geogr.Ent.')"/>
<xsl:variable name="convert_205a" select="replace($___, '205a', 'GI-Ort')"/>
<xsl:variable name="convert_205c" select="replace($___, '205c', 'GI-Landschaft')"/>
<xsl:variable name="convert_205e" select="replace($___, '205e', 'GI-Land')"/>
<xsl:variable name="convert_2119" select="replace($___, '2119', 'Stadt')"/>
<xsl:variable name="convert_2135" select="replace($___, '2135', 'Landschaft')"/>
<xsl:variable name="convert_2154" select="replace($___, '2154', 'Land')"/>
<xsl:variable name="convert_2160" select="replace($___, '2160', 'Gemeinde')"/>
<xsl:variable name="convert_2165" select="replace($___, '2165', 'Kreis')"/>
<xsl:variable name="convert_2170" select="replace($___, '2170', 'Regierungsbezirk')"/>
<xsl:variable name="convert_2180" select="replace($___, '2180', 'Region')"/>
<xsl:variable name="convert_2189" select="replace($___, '2189', 'Länderschlüssel')"/>
<xsl:variable name="convert_2190" select="replace($___, '2190', 'Bundesland')"/>
<xsl:variable name="convert_2194" select="replace($___, '2194', 'Staat')"/>
<xsl:variable name="convert_2196" select="replace($___, '2196', 'Kontinentteil')"/>
<xsl:variable name="convert_2198" select="replace($___, '2198', 'Kontinent')"/>
<xsl:variable name="convert_219a" select="replace($___, '219a', 'Art des Textes')"/>
<xsl:variable name="convert_219c" select="replace($___, '219c', 'Bemerkung*')"/>
<xsl:variable name="convert_219e" select="replace($___, '219e', 'Text*')"/>
<xsl:variable name="convert_4000" select="replace($___, '4000', 'Dokument-Nr.')"/>
<xsl:variable name="convert_4007" select="replace($___, '4007', 'Art der Beziehung')"/>
<xsl:variable name="convert_4010" select="replace($___, '4010', 'Bez-Name')"/>
<xsl:variable name="convert_4011" select="replace($___, '4011', 'Bez-Name N.N.')"/>
<xsl:variable name="convert_4018" select="replace($___, '4018', 'Personen-Komm.*')"/>
<xsl:variable name="convert_4100" select="replace($___, '4100', 'Personenname')"/>
<xsl:variable name="convert_4100gi" select="replace($___, '4100gi', 'Person i. Vorl.')"/>
<xsl:variable name="convert_4105" select="replace($___, '4105', 'Zweitname')"/>
<xsl:variable name="convert_4120" select="replace($___, '4120', 'Geburtsname')"/>
<xsl:variable name="convert_4126" select="replace($___, '4126', 'Pseudonym')"/>
<xsl:variable name="convert_4140" select="replace($___, '4140', 'Geschlecht')"/>
<xsl:variable name="convert_4160" select="replace($___, '4160', 'Stand')"/>
<xsl:variable name="convert_4165" select="replace($___, '4165', 'Beruf/Funktion')"/>
<xsl:variable name="convert_4180" select="replace($___, '4180', 'Nachweiszeit')"/>
<xsl:variable name="convert_4182" select="replace($___, '4182', 'Regierungszeit')"/>
<xsl:variable name="convert_4204" select="replace($___, '4204', 'Nachweisort')"/>
<xsl:variable name="convert_4270" select="replace($___, '4270', 'Geburtsdatum')"/>
<xsl:variable name="convert_4290" select="replace($___, '4290', 'Geburtsort')"/>
<xsl:variable name="convert_4300" select="replace($___, '4300', 'erste Erwähnung')"/>
<xsl:variable name="convert_4320" select="replace($___, '4320', 'e-Erwähn-Ort')"/>
<xsl:variable name="convert_4330" select="replace($___, '4330', 'Sterbedatum')"/>
<xsl:variable name="convert_4350" select="replace($___, '4350', 'Sterbeort')"/>
<xsl:variable name="convert_4400" select="replace($___, '4400', 'Tätigkeitszeit')"/>
<xsl:variable name="convert_4420" select="replace($___, '4420', 'Tätigkeitsort')"/>
<xsl:variable name="convert_4470" select="replace($___, '4470', 'Au      thentizität')"/>
<xsl:variable name="convert_4475" select="replace($___, '4475', 'Tätigkeit')"/>
<xsl:variable name="convert_4496" select="replace($___, '4496', 'Geltungsdauer')"/>
<xsl:variable name="convert_4498" select="replace($___, '4498', 'Person-Komm.*')"/>
<xsl:variable name="convert_449a" select="replace($___, '449a', 'Art d. Freitexts')"/>
<xsl:variable name="convert_449c" select="replace($___, '449c', 'Bemerkung*')"/>
<xsl:variable name="convert_449e" select="replace($___, '449e', 'Freitext*')"/>
<xsl:variable name="convert_449g" select="replace($___, '449g', 'Nachweis')"/>
<xsl:variable name="convert_4500" select="replace($___, '4500', 'Dokument-Nr.')"/>
<xsl:variable name="convert_4501" select="replace($___, '4501', 'Dokument-Teil-Nr.')"/>
<xsl:variable name="convert_4507" select="replace($___, '4507', 'Art der Beziehung')"/>
<xsl:variable name="convert_4509" select="replace($___, '4509', 'Bez-Ort')"/>
<xsl:variable name="convert_4510" select="replace($___, '4510', 'Bez-Sozietätsname')"/>
<xsl:variable name="convert_4511" select="replace($___, '4511', 'Bez-Abteilung')"/>
<xsl:variable name="convert_4564" select="replace($___, '4564', 'Ort')"/>
<xsl:variable name="convert_4594" select="replace($___, '4594', 'Träger')"/>
<xsl:variable name="convert_4596" select="replace($___, '4596', 'Patrozinium')"/>
<xsl:variable name="convert_459t" select="replace($___, '459t', 'Kommentar*')"/>
<xsl:variable name="convert_4602" select="replace($___, '4602', 'Zweitname')"/>
<xsl:variable name="convert_4610" select="replace($___, '4610', 'Person')"/>
<xsl:variable name="convert_4614" select="replace($___, '4614', 'Titel')"/>
<xsl:variable name="convert_4630" select="replace($___, '4630', 'Abteilung')"/>
<xsl:variable name="convert_4640" select="replace($___, '4640', 'Verw-Zusammenh.')"/>
<xsl:variable name="convert_4643" select="replace($___, '4643', 'Sammlung')"/>
<xsl:variable name="convert_4645" select="replace($___, '4645', 'Grundsignatur')"/>
<xsl:variable name="convert_4650" select="replace($___, '4650', 'Signatur')"/>
<xsl:variable name="convert_4652" select="replace($___, '4652', 'alte Signatur')"/>
<xsl:variable name="convert_4656" select="replace($___, '4656', 'Akzess-Nr.')"/>
<xsl:variable name="convert_4665" select="replace($___, '4665', 'Folio-Nr.')"/>
<xsl:variable name="convert_4670" select="replace($___, '4670', 'Verbleib')"/>
<xsl:variable name="convert_4770" select="replace($___, '4770', 'Gründungsdatum')"/>
<xsl:variable name="convert_4830" select="replace($___, '4830', 'Auflösungsdatum')"/>
<xsl:variable name="convert_4970" select="replace($___, '4970', 'Au      thentizität')"/>
<xsl:variable name="convert_4975" select="replace($___, '4975', 'Tätigkeit')"/>
<xsl:variable name="convert_4996" select="replace($___, '4996', 'Geltungsdauer')"/>
<xsl:variable name="convert_4998" select="replace($___, '4998', 'Sozietäts-Komm.*')"/>
<xsl:variable name="convert_499a" select="replace($___, '499a', 'Art d. Freitextes')"/>
<xsl:variable name="convert_499e" select="replace($___, '499e', 'Freitext*')"/>
<xsl:variable name="convert_499i" select="replace($___, '499i', 'URL zum Text')"/>
<xsl:variable name="convert_5000" select="replace($___, '5000', 'Dokument-Nr.')"/>
<xsl:variable name="convert_5001" select="replace($___, '5001', 'Dokument-Teil-Nr.')"/>
<xsl:variable name="convert_5002" select="replace($___, '5002', 'Unter-Teil-Nr.')"/>
<xsl:variable name="convert_5003" select="replace($___, '5003', 'Detail-Nr.')"/>
<xsl:variable name="convert_5004" select="replace($___, '5004', 'Einzel-Nr.')"/>
<xsl:variable name="convert_5007" select="replace($___, '5007', 'Art der Beziehung')"/>
<xsl:variable name="convert_5008" select="replace($___, '5008', 'Bez-Dokument-Nr.')"/>
<xsl:variable name="convert_5009" select="replace($___, '5009', 'Bez-Hersteller')"/>
<xsl:variable name="convert_5010" select="replace($___, '5010', 'Bez-Sachbegriff')"/>
<xsl:variable name="convert_5019" select="replace($___, '5019', 'Geltungsdauer')"/>
<xsl:variable name="convert_501k" select="replace($___, '501k', 'Bez-Verwalter')"/>
<xsl:variable name="convert_501m" select="replace($___, '501m', 'Bez-Signatur')"/>
<xsl:variable name="convert_501n" select="replace($___, '501n', 'Bez-Sachtitel')"/>
<xsl:variable name="convert_501p" select="replace($___, '501p', 'Bez-Folio-Nr.')"/>
<xsl:variable name="convert_501t" select="replace($___, '501t', 'Beschreibung*')"/>
<xsl:variable name="convert_5060" select="replace($___, '5060', 'Art der Datierung')"/>
<xsl:variable name="convert_5061" select="replace($___, '5061', 'Quelle der Dat.')"/>
<xsl:variable name="convert_5064" select="replace($___, '5064', 'Datierung (num.)')"/>
<xsl:variable name="convert_5071" select="replace($___, '5071', 'Anfangsdatum')"/>
<xsl:variable name="convert_5077" select="replace($___, '5077', 'Enddatum')"/>
<xsl:variable name="convert_5130" select="replace($___, '5130', 'Entstehungsort')"/>
<xsl:variable name="convert_5140" select="replace($___, '5140', 'Bedeut. des Orts')"/>
<xsl:variable name="convert_5145" select="replace($___, '5145', 'Name des Orts')"/>
<xsl:variable name="convert_5200" select="replace($___, '5200', 'Objekttitel*')"/>
<xsl:variable name="convert_5209" select="replace($___, '5209', 'ÜBERSCHRIFT*')"/>
<xsl:variable name="convert_5210" select="replace($___, '5210', 'Status')"/>
<xsl:variable name="convert_5220" select="replace($___, '5220', 'Kunstgattung')"/>
<xsl:variable name="convert_5230" select="replace($___, '5230', 'Sachbegriff')"/>
<xsl:variable name="convert_5234" select="replace($___, '5234', 'Sonderfunktion')"/>
<xsl:variable name="convert_5240" select="replace($___, '5240', 'Formtyp')"/>
<xsl:variable name="convert_5260" select="replace($___, '5260', 'Material')"/>
<xsl:variable name="convert_5270" select="replace($___, '5270', 'Buchschmuck-Slw.')"/>
<xsl:variable name="convert_5300" select="replace($___, '5300', 'Technik')"/>
<xsl:variable name="convert_5360" select="replace($___, '5360', 'Höhe x Breite (cm)')"/>
<xsl:variable name="convert_5382" select="replace($___, '5382', 'Buchformat')"/>
<xsl:variable name="convert_5495" select="replace($___, '5495', 'ikonogra. Gattung')"/>
<xsl:variable name="convert_5500" select="replace($___, '5500', 'Ikonographie')"/>
<xsl:variable name="convert_5502" select="replace($___, '5502', 'Erläuterung')"/>
<xsl:variable name="convert_5504" select="replace($___, '5504', 'Schlagwort')"/>
<xsl:variable name="convert_550b" select="replace($___, '550b', 'primäre/Person')"/>
<xsl:variable name="convert_550d" select="replace($___, '550d', 'primäre/Region')"/>
<xsl:variable name="convert_550e" select="replace($___, '550e', 'primäre/Ort')"/>
<xsl:variable name="convert_55hs" select="replace($___, '55hs', 'GI-ikon-Schlagw.')"/>
<xsl:variable name="convert_5650" select="replace($___, '5650', 'Art des Textes')"/>
<xsl:variable name="convert_5664" select="replace($___, '5664', 'Datierung')"/>
<xsl:variable name="convert_5666d" select="replace($___, '5666d', 'Initium-deutsch')"/>
<xsl:variable name="convert_5666g" select="replace($___, '5666g', 'Initium-griechisch')"/>
<xsl:variable name="convert_5666l" select="replace($___, '5666l', 'Initium-latein')"/>
<xsl:variable name="convert_5666v" select="replace($___, '5666v', 'Initium-varia')"/>
<xsl:variable name="convert_5668" select="replace($___, '5668', 'Grundwörter')"/>
<xsl:variable name="convert_5680" select="replace($___, '5680', 'Sprache')"/>
<xsl:variable name="convert_5684" select="replace($___, '5684', 'Inhalt*')"/>
<xsl:variable name="convert_5686" select="replace($___, '5686', 'Text*')"/>
<xsl:variable name="convert_5688" select="replace($___, '5688', 'Übersetzung*')"/>
<xsl:variable name="convert_5694" select="replace($___, '5694', 'Anbringungsort')"/>
<xsl:variable name="convert_5704" select="replace($___, '5704', 'Schriftart')"/>
<xsl:variable name="convert_5705" select="replace($___, '5705', 'Notation')"/>
<xsl:variable name="convert_5706" select="replace($___, '5706', 'Blattzahl')"/>
<xsl:variable name="convert_5710" select="replace($___, '5710', 'Schreibsprache')"/>
<xsl:variable name="convert_599a" select="replace($___, '599a', 'Art d. Freitextes')"/>
<xsl:variable name="convert_599e" select="replace($___, '599e', 'Freitext*')"/>
<xsl:variable name="convert_6000" select="replace($___, '6000', 'Dokument-Nr.')"/>
<xsl:variable name="convert_6080" select="replace($___, '6080', 'Notation')"/>
<xsl:variable name="convert_608a" select="replace($___, '608a', 'Notation-Ebene01')"/>
<xsl:variable name="convert_608b" select="replace($___, '608b', 'Notation-Ebene02')"/>
<xsl:variable name="convert_608c" select="replace($___, '608c', 'Notation-Ebene03')"/>
<xsl:variable name="convert_608d" select="replace($___, '608d', 'Notation-Ebene04')"/>
<xsl:variable name="convert_608e" select="replace($___, '608e', 'Notation-Ebene05')"/>
<xsl:variable name="convert_608f" select="replace($___, '608f', 'Notation-Ebene06')"/>
<xsl:variable name="convert_608g" select="replace($___, '608g', 'Notation-Ebene07')"/>
<xsl:variable name="convert_608h" select="replace($___, '608h', 'Notation-Ebene08')"/>
<xsl:variable name="convert_608i" select="replace($___, '608i', 'Notation-Ebene09')"/>
<xsl:variable name="convert_608j" select="replace($___, '608j', 'Notation-Ebene10')"/>
<xsl:variable name="convert_608k" select="replace($___, '608k', 'Notation-Ebene11')"/>
<xsl:variable name="convert_609t" select="replace($___, '609t', 'Beschreibung*')"/>
<xsl:variable name="convert_60ad" select="replace($___, '60ad', 'Erläut.-dt-Eb01')"/>
<xsl:variable name="convert_60ae" select="replace($___, '60ae', 'Erläut.-en-Eb01')"/>
<xsl:variable name="convert_60bd" select="replace($___, '60bd', 'Erläut.-dt-Eb02')"/>
<xsl:variable name="convert_60be" select="replace($___, '60be', 'Erläut.-en-Eb02')"/>
<xsl:variable name="convert_60cd" select="replace($___, '60cd', 'Erläut.-dt-Eb03')"/>
<xsl:variable name="convert_60ce" select="replace($___, '60ce', 'Erläut.-en-Eb03')"/>
<xsl:variable name="convert_60dd" select="replace($___, '60dd', 'Erläut.-dt-Eb04')"/>
<xsl:variable name="convert_60de" select="replace($___, '60de', 'Erläut.-en-Eb04')"/>
<xsl:variable name="convert_60ed" select="replace($___, '60ed', 'Erläut.-dt-Eb05')"/>
<xsl:variable name="convert_60ee" select="replace($___, '60ee', 'Erläut.-en-Eb05')"/>
<xsl:variable name="convert_60fd" select="replace($___, '60fd', 'Erläut.-dt-Eb06')"/>
<xsl:variable name="convert_60fe" select="replace($___, '60fe', 'Erläut.-en-Eb06')"/>
<xsl:variable name="convert_60gd" select="replace($___, '60gd', 'Erläut.-dt-Eb07')"/>
<xsl:variable name="convert_60ge" select="replace($___, '60ge', 'Erläut.-en-Eb07')"/>
<xsl:variable name="convert_60hd" select="replace($___, '60hd', 'Erläut.-dt-Eb08')"/>
<xsl:variable name="convert_60he" select="replace($___, '60he', 'Erläut.-en-Eb08')"/>
<xsl:variable name="convert_60id" select="replace($___, '60id', 'Erläut.-dt-Eb09')"/>
<xsl:variable name="convert_60ie" select="replace($___, '60ie', 'Erläut.-en-Eb09')"/>
<xsl:variable name="convert_60jd" select="replace($___, '60jd', 'Erläut.-dt-Eb10')"/>
<xsl:variable name="convert_60je" select="replace($___, '60je', 'Erläut.-en-Eb10')"/>
<xsl:variable name="convert_60kd" select="replace($___, '60kd', 'Erläut.-dt-Eb11')"/>
<xsl:variable name="convert_60ke" select="replace($___, '60ke', 'Erläut.-en-Eb11')"/>
<xsl:variable name="convert_6100" select="replace($___, '6100', 'Erläuterung')"/>
<xsl:variable name="convert_6102" select="replace($___, '6102', 'deutsch')"/>
<xsl:variable name="convert_6110" select="replace($___, '6110', 'Schlagwort engl.')"/>
<xsl:variable name="convert_6112" select="replace($___, '6112', 'Schlagwort dt.')"/>
<xsl:variable name="convert_6150" select="replace($___, '6150', 'Geltungsb-Anf.')"/>
<xsl:variable name="convert_6158" select="replace($___, '6158', 'Keynummer')"/>
<xsl:variable name="convert_6170" select="replace($___, '6170', 'Erläuterung')"/>
<xsl:variable name="convert_6172" select="replace($___, '6172', 'deutsch')"/>
<xsl:variable name="convert_6180" select="replace($___, '6180', 'Schlagwort')"/>
<xsl:variable name="convert_6182" select="replace($___, '6182', 'deutsch')"/>
<xsl:variable name="convert_61ad" select="replace($___, '61ad', 'Schlagw-dt-Eb1')"/>
<xsl:variable name="convert_61ae" select="replace($___, '61ae', 'Schlagw-en-Eb1')"/>
<xsl:variable name="convert_61bd" select="replace($___, '61bd', 'Schlagw-dt-Eb2')"/>
<xsl:variable name="convert_61be" select="replace($___, '61be', 'Schlagw-en-Eb2')"/>
<xsl:variable name="convert_61cd" select="replace($___, '61cd', 'Schlagw-dt-Eb3')"/>
<xsl:variable name="convert_61ce" select="replace($___, '61ce', 'Schlagw-en-Eb3')"/>
<xsl:variable name="convert_61dd" select="replace($___, '61dd', 'Schlagw-dt-Eb4')"/>
<xsl:variable name="convert_61de" select="replace($___, '61de', 'Schlagw-en-Eb4')"/>
<xsl:variable name="convert_61ed" select="replace($___, '61ed', 'Schlagw-dt-Eb5')"/>
<xsl:variable name="convert_61ee" select="replace($___, '61ee', 'Schlagw-en-Eb5')"/>
<xsl:variable name="convert_61fd" select="replace($___, '61fd', 'Schlagw-dt-Eb6')"/>
<xsl:variable name="convert_61fe" select="replace($___, '61fe', 'Schlagw-en-Eb6')"/>
<xsl:variable name="convert_61gd" select="replace($___, '61gd', 'Schlagw-dt-Eb7')"/>
<xsl:variable name="convert_61ge" select="replace($___, '61ge', 'Schlagw-en-Eb7')"/>
<xsl:variable name="convert_61hd" select="replace($___, '61hd', 'Schlagw-dt-Eb8')"/>
<xsl:variable name="convert_61he" select="replace($___, '61he', 'Schlagw-en-Eb8')"/>
<xsl:variable name="convert_61id" select="replace($___, '61id', 'Schlagw-dt-Eb9')"/>
<xsl:variable name="convert_61ie" select="replace($___, '61ie', 'Schlagw-en-Eb9')"/>
<xsl:variable name="convert_6524" select="replace($___, '6524', 'Datierung')"/>
<xsl:variable name="convert_6560" select="replace($___, '6560', 'Art des Zeichens')"/>
<xsl:variable name="convert_6565" select="replace($___, '6565', 'Zeichen-Kurztitel')"/>
<xsl:variable name="convert_6568" select="replace($___, '6568', 'Beschreibung*')"/>
<xsl:variable name="convert_6694" select="replace($___, '6694', 'Anbringungsort')"/>
<xsl:variable name="convert_6740" select="replace($___, '6740', 'Lokalisierung')"/>
<xsl:variable name="convert_6770" select="replace($___, '6770', 'Repertorium')"/>
<xsl:variable name="convert_6773" select="replace($___, '6773', 'Identitätsgrad')"/>
<xsl:variable name="convert_6807" select="replace($___, '6807', 'Motiv')"/>
<xsl:variable name="convert_6817" select="replace($___, '6817', 'Motivzusatz')"/>
<xsl:variable name="convert_6876" select="replace($___, '6876', 'Transkription')"/>
<xsl:variable name="convert_6877" select="replace($___, '6877', 'Web-Link')"/>
<xsl:variable name="convert_6900" select="replace($___, '6900', 'Dokument-Nr.')"/>
<xsl:variable name="convert_6907" select="replace($___, '6907', 'Art der Beziehung')"/>
<xsl:variable name="convert_6908" select="replace($___, '6908', 'Bez-Dokument-Nr.')"/>
<xsl:variable name="convert_6909" select="replace($___, '6909', 'Bez-Autor')"/>
<xsl:variable name="convert_6910" select="replace($___, '6910', 'Bez-Sachtitel')"/>
<xsl:variable name="convert_6911" select="replace($___, '6911', 'Bez-Textabschn.')"/>
<xsl:variable name="convert_6920" select="replace($___, '6920', 'Literaturgattung')"/>
<xsl:variable name="convert_6922" select="replace($___, '6922', 'Sacherschließung')"/>
<xsl:variable name="convert_6923" select="replace($___, '6923', 'Sacherschl.-Ort')"/>
<xsl:variable name="convert_6930" select="replace($___, '6930', 'Sachtitel')"/>
<xsl:variable name="convert_6930gi" select="replace($___, '6930gi', 'Sachtitel-GI')"/>
<xsl:variable name="convert_6931" select="replace($___, '6931', 'Originalsprache')"/>
<xsl:variable name="convert_6932" select="replace($___, '6932', 'Stichwörter')"/>
<xsl:variable name="convert_6934" select="replace($___, '6934', 'Untertitel')"/>
<xsl:variable name="convert_6940" select="replace($___, '6940', 'Sachtitel altern.')"/>
<xsl:variable name="convert_6942" select="replace($___, '6942', 'Untertit. altern.')"/>
<xsl:variable name="convert_6948" select="replace($___, '6948', 'Kurztitel')"/>
<xsl:variable name="convert_6970" select="replace($___, '6970', 'Art der Datierung')"/>
<xsl:variable name="convert_6974" select="replace($___, '6974', 'Datierung (num.)')"/>
<xsl:variable name="convert_6980" select="replace($___, '6980', 'Entstehungsort')"/>
<xsl:variable name="convert_6996" select="replace($___, '6996', 'Textversion')"/>
<xsl:variable name="convert_6998" select="replace($___, '6998', 'Kommentar*')"/>
<xsl:variable name="convert_699a" select="replace($___, '699a', 'Art d. Freitextes')"/>
<xsl:variable name="convert_699e" select="replace($___, '699e', 'Freitext*')"/>
<xsl:variable name="convert_8200" select="replace($___, '8200', 'Dokument-Nr.')"/>
<xsl:variable name="convert_8260" select="replace($___, '8260', 'Art der Literatur')"/>
<xsl:variable name="convert_8265" select="replace($___, '8265', 'bibliogr. Angabe')"/>
<xsl:variable name="convert_8270" select="replace($___, '8270', 'Verfasser')"/>
<xsl:variable name="convert_8280" select="replace($___, '8280', 'hrsg. Person')"/>
<xsl:variable name="convert_8284" select="replace($___, '8284', 'hrsg. Institution')"/>
<xsl:variable name="convert_8290" select="replace($___, '8290', 'Titel')"/>
<xsl:variable name="convert_8292" select="replace($___, '8292', 'Sammeltitel')"/>
<xsl:variable name="convert_8294" select="replace($___, '8294', 'Bandzahl')"/>
<xsl:variable name="convert_8300" select="replace($___, '8300', 'Serientitel')"/>
<xsl:variable name="convert_8302" select="replace($___, '8302', 'Untertitel/Folge')"/>
<xsl:variable name="convert_8306" select="replace($___, '8306', 'Bandnummer')"/>
<xsl:variable name="convert_8307" select="replace($___, '8307', 'Zusatzangabe')"/>
<xsl:variable name="convert_8308" select="replace($___, '8308', 'Auflagen-Nr.')"/>
<xsl:variable name="convert_8310" select="replace($___, '8310', 'Zeitschrift')"/>
<xsl:variable name="convert_8312" select="replace($___, '8312', 'Folge')"/>
<xsl:variable name="convert_8316" select="replace($___, '8316', 'Bandnummer')"/>
<xsl:variable name="convert_8318" select="replace($___, '8318', 'Heftnummer')"/>
<xsl:variable name="convert_8319" select="replace($___, '8319', 'Seitenangabe')"/>
<xsl:variable name="convert_8320" select="replace($___, '8320', 'Erscheinungsort')"/>
<xsl:variable name="convert_8322" select="replace($___, '8322', 'Reprint-Ort')"/>
<xsl:variable name="convert_8324" select="replace($___, '8324', 'Erscheinungsjahr')"/>
<xsl:variable name="convert_8326" select="replace($___, '8326', 'Reprint-Jahr')"/>
<xsl:variable name="convert_8330" select="replace($___, '8330', 'Literat-Kurztitel')"/>
<xsl:variable name="convert_8334" select="replace($___, '8334', 'Stelle')"/>
<xsl:variable name="convert_833a" select="replace($___, '833a', 'Kurztitel B-Liste')"/>
<xsl:variable name="convert_8346" select="replace($___, '8346', 'Signatur')"/>
<xsl:variable name="convert_8350" select="replace($___, '8350', 'Literaturnachweis')"/>
<xsl:variable name="convert_8450" select="replace($___, '8450', 'Foto')"/>
<xsl:variable name="convert_8460" select="replace($___, '8460', 'Verwalter')"/>
<xsl:variable name="convert_8470" select="replace($___, '8470', 'Aufnahme-Nr.')"/>
<xsl:variable name="convert_8541" select="replace($___, '8541', 'Verfügbarkeit')"/>
<xsl:variable name="convert_8542" select="replace($___, '8542', 'Anzeigeformate')"/>
<xsl:variable name="convert_854a" select="replace($___, '854a', 'URL - nicht MM')"/>
<xsl:variable name="convert_854b" select="replace($___, '854b', 'weiterer Link')"/>
<xsl:variable name="convert_854c" select="replace($___, '854c', 'Link-Beschriftung')"/>
<xsl:variable name="convert_854g" select="replace($___, '854g', 'graphic URL')"/>
<xsl:variable name="convert_8550" select="replace($___, '8550', 'Marb-Index-Nr.')"/>
<xsl:variable name="convert_855a" select="replace($___, '855a', '1. Folge')"/>
<xsl:variable name="convert_855b" select="replace($___, '855b', '2. Folge')"/>
<xsl:variable name="convert_855c" select="replace($___, '855c', '3. Folge')"/>
<xsl:variable name="convert_855d" select="replace($___, '855d', '4. Folge')"/>
<xsl:variable name="convert_8596" select="replace($___, '8596', 'Bemerkung*')"/>
<xsl:variable name="convert_9050" select="replace($___, '9050', 'ni. digitalisiert')"/>
<xsl:variable name="convert_9100" select="replace($___, '9100', 'Bestandsumfang')"/>
<xsl:variable name="convert_9101" select="replace($___, '9101', 'Bearb.-Status')"/>
<xsl:variable name="convert_9102" select="replace($___, '9102', 'Projektstatus')"/>
<xsl:variable name="convert_9103" select="replace($___, '9103', 'Kat-Auswertung')"/>
<xsl:variable name="convert_9104" select="replace($___, '9104', 'HS-Typ')"/>
<xsl:variable name="convert_9105" select="replace($___, '9105', 'Surrogate')"/>
<xsl:variable name="convert_9106" select="replace($___, '9106', 'Hs-Typ-Sprache')"/>
<xsl:variable name="convert_9110" select="replace($___, '9110', 'Nachw. Kat. in MM')"/>
<xsl:variable name="convert_9900" select="replace($___, '9900', 'Datum')"/>
<xsl:variable name="convert_9902" select="replace($___, '9902', 'Urheber Institut.')"/>
<xsl:variable name="convert_9904" select="replace($___, '9904', 'Urheber Autor')"/>
<xsl:variable name="convert_9907" select="replace($___, '9907', 'Bearb.-Stand')"/>
<xsl:variable name="convert_9910" select="replace($___, '9910', 'Datum letzte Änd.')"/>
<xsl:variable name="convert_9920" select="replace($___, '9920', 'Datum 2. Änder.')"/>
<xsl:variable name="convert_9950" select="replace($___, '9950', 'Datum letzte Änd.')"/>
<xsl:variable name="convert_9968" select="replace($___, '9968', 'Schlagwort')"/>
<xsl:variable name="convert_99bh" select="replace($___, '99bh', 'BH-Notizen')"/>
<xsl:variable name="convert_99fm" select="replace($___, '99fm', 'FM-Notizen*')"/>
<xsl:variable name="convert_99hs" select="replace($___, '99hs', 'HS-Notizen*')"/>
<xsl:variable name="convert_99kk" select="replace($___, '99kk', 'KK-Notizen')"/>
<xsl:variable name="convert_99sb" select="replace($___, '99sb', 'SB-Notizen*')"/>
<xsl:variable name="convert_99sm" select="replace($___, '99sm', 'SM-Notizen*')"/>
<xsl:variable name="convert_LevelInfo" select="replace($___, 'LevelInfo', 'LevelInfo')"/>
<xsl:variable name="convert_bezlit" select="replace($___, 'bezlit', 'Bezieh @ Literatur')"/>
<xsl:variable name="convert_bezper" select="replace($___, 'bezper', 'Bezieh @ Person')"/>
<xsl:variable name="convert_bezwrk" select="replace($___, 'bezwrk', 'Bezieh @ Werk')"/>
<xsl:variable name="convert_d-in-wor" select="replace($___, 'd-in-wor', '...')"/>
<xsl:variable name="convert_dargort" select="replace($___, 'dargort', '(ikonographie)')"/>
<xsl:variable name="convert_dargpers" select="replace($___, 'dargpers', '(ikonographie)')"/>
<xsl:variable name="convert_datierun" select="replace($___, 'datierun', '...')"/>
<xsl:variable name="convert_deu-init" select="replace($___, 'deu-init', '...')"/>
<xsl:variable name="convert_gattung" select="replace($___, 'gattung', '...')"/>
<xsl:variable name="convert_geb-ort" select="replace($___, 'geb-ort', '...')"/>
<xsl:variable name="convert_geschlec" select="replace($___, 'geschlec', '...')"/>
<xsl:variable name="convert_gi-lemma" select="replace($___, 'gi-lemma', '...')"/>
<xsl:variable name="convert_gi-schla" select="replace($___, 'gi-schla', '...')"/>
<xsl:variable name="convert_gr-in-wor" select="replace($___, 'gr-in-wor', '...')"/>
<xsl:variable name="convert_gr-init" select="replace($___, 'gr-init', '...')"/>
<xsl:variable name="convert_hs-deskr" select="replace($___, 'hs-deskr', '...')"/>
<xsl:variable name="convert_hs-schla" select="replace($___, 'hs-schla', '...')"/>
<xsl:variable name="convert_ico" select="replace($___, 'ico', '(ikonographie)')"/>
<xsl:variable name="convert_initiale" select="replace($___, 'initiale', '...')"/>
<xsl:variable name="convert_l-in-wor" select="replace($___, 'l-in-wor', '...')"/>
<xsl:variable name="convert_land" select="replace($___, 'land', '...')"/>
<xsl:variable name="convert_landsch" select="replace($___, 'landsch', '...')"/>
<xsl:variable name="convert_lat-init" select="replace($___, 'lat-init', '...')"/>
<xsl:variable name="convert_lexer" select="replace($___, 'lexer', '...')"/>
<xsl:variable name="convert_lit-gatt" select="replace($___, 'lit-gatt', '...')"/>
<xsl:variable name="convert_luebben" select="replace($___, 'luebben', '...')"/>
<xsl:variable name="convert_material" select="replace($___, 'material', '...')"/>
<xsl:variable name="convert_miniatur" select="replace($___, 'miniatur', '...')"/>
<xsl:variable name="convert_oberbegr" select="replace($___, 'oberbegr', '...')"/>
<xsl:variable name="convert_obj-art" select="replace($___, 'obj-art', '...')"/>
<xsl:variable name="convert_ortsname" select="replace($___, 'ortsname', '...')"/>
<xsl:variable name="convert_par01" select="replace($___, 'par01', 'Signatur')"/>
<xsl:variable name="convert_par02" select="replace($___, 'par02', 'Überschrift')"/>
<xsl:variable name="convert_par03" select="replace($___, 'par03', 'Schlagzeile')"/>
<xsl:variable name="convert_par04" select="replace($___, 'par04', 'Äußeres')"/>
<xsl:variable name="convert_par05" select="replace($___, 'par05', 'Geschichte')"/>
<xsl:variable name="convert_par06" select="replace($___, 'par06', 'Literaturangaben')"/>
<xsl:variable name="convert_par07" select="replace($___, 'par07', 'Einband')"/>
<xsl:variable name="convert_par08" select="replace($___, 'par08', 'Fragment')"/>
<xsl:variable name="convert_par09" select="replace($___, 'par09', 'Faszikel-Äußeres')"/>
<xsl:variable name="convert_par10" select="replace($___, 'par10', 'Faszikel-Geschichte')"/>
<xsl:variable name="convert_par11" select="replace($___, 'par11', 'Text')"/>
<xsl:variable name="convert_par12" select="replace($___, 'par12', 'Stil u. Einordnung (illum.)')"/>
<xsl:variable name="convert_par13" select="replace($___, 'par13', 'Buchschmuck (illum.)')"/>
<xsl:variable name="convert_person" select="replace($___, 'person', '...')"/>
<xsl:variable name="convert_persverb" select="replace($___, 'persverb', '...')"/>
<xsl:variable name="convert_perswort" select="replace($___, 'perswort', '...')"/>
<xsl:variable name="convert_sach-wor" select="replace($___, 'sach-wor', '...')"/>
<xsl:variable name="convert_sachtite" select="replace($___, 'sachtite', '...')"/>
<xsl:variable name="convert_schlagwo" select="replace($___, 'schlagwo', '...')"/>
<xsl:variable name="convert_societas" select="replace($___, 'societas', '...')"/>
<xsl:variable name="convert_sociverb" select="replace($___, 'sociverb', '...')"/>
<xsl:variable name="convert_stichwor" select="replace($___, 'stichwor', '...')"/>
<xsl:variable name="convert_technik" select="replace($___, 'technik', '...')"/>
<xsl:variable name="convert_themen" select="replace($___, 'themen', '...')"/>
<xsl:variable name="convert_thesauru" select="replace($___, 'thesauru', '...')"/>
<xsl:variable name="convert_tod-ort" select="replace($___, 'tod-ort', '...')"/>
<xsl:variable name="convert_v-in-wor" select="replace($___, 'v-in-wor', '...')"/>
<xsl:variable name="convert_var-init" select="replace($___, 'var-init', '...')"/>
<xsl:variable name="convert_y001" select="replace($___, 'y001', 'PND-Identif-Nr.')"/>
<xsl:variable name="convert_z001" select="replace($___, 'z001', 'PND-Identif-Nr.')"/>
<xsl:variable name="convert_z001a" select="replace($___, 'z001a', 'DBI-Produkt-Nr.')"/>
<xsl:variable name="convert_z002a" select="replace($___, 'z002a', 'Erfassungsdatum')"/>
<xsl:variable name="convert_z003" select="replace($___, 'z003', 'Korrekturdatum')"/>
<xsl:variable name="convert_z020a" select="replace($___, 'z020a', 'überreg-Ident-Nr.')"/>
<xsl:variable name="convert_z029" select="replace($___, 'z029', 'sonst-Ident-Nr.')"/>
<xsl:variable name="convert_z800" select="replace($___, 'z800', 'DB-Name')"/>
<xsl:variable name="convert_z801" select="replace($___, 'z801', 'Quelle des Namens')"/>
<xsl:variable name="convert_z814" select="replace($___, 'z814', 'Daten zur Person')"/>
<xsl:variable name="convert_z814a" select="replace($___, 'z814a', 'Lebensdaten')"/>
<xsl:variable name="convert_z814b" select="replace($___, 'z814b', 'Wirkungsdaten')"/>
<xsl:variable name="convert_z814i" select="replace($___, 'z814i', 'Beruf')"/>
<xsl:variable name="convert_z816" select="replace($___, 'z816', 'Werke der Person')"/>
<xsl:variable name="convert_z820" select="replace($___, 'z820', 'andere Ansetzung')"/>
<xsl:variable name="convert_z830" select="replace($___, 'z830', 'Verweisungsform')"/>
