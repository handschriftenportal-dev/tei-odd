<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="3.0">
   <xsl:template name="writeCatAuthorRef">
      <xsl:param name="value"/>
      <xsl:choose>
         <xsl:when test="$value = 'Adolf Becker'"><xsl:attribute name="ref">https://d-nb.info/gnd/1055272070</xsl:attribute>Becker, Adolf</xsl:when>
         <xsl:when test="$value = 'Agata Mazurek'"><xsl:attribute name="ref">https://d-nb.info/gnd/1055776168</xsl:attribute>Mazurek, Agata</xsl:when>
         <xsl:when test="$value = 'Almuth Märker'"><xsl:attribute name="ref">https://d-nb.info/gnd/113217986</xsl:attribute>Märker, Almuth</xsl:when>
         <xsl:when test="$value = 'András Vizkelety'"><xsl:attribute name="ref">https://d-nb.info/gnd/123827167</xsl:attribute>Vizkelety, András</xsl:when>
         <xsl:when test="$value = 'Andreas Fingernagel'"><xsl:attribute name="ref">https://d-nb.info/gnd/134120264</xsl:attribute>Fingernagel, Andreas</xsl:when>
         <xsl:when test="$value = 'Anette Haucap'"><xsl:attribute name="key">NORM-9b04d152-845e-30a3-b839-4003c96da594</xsl:attribute>Haucap, Anette</xsl:when>
         <xsl:when test="$value = 'Anja Freckmann'"><xsl:attribute name="ref">http://d-nb.info/gnd/1170618898</xsl:attribute>Freckmann, Anja</xsl:when>
         <xsl:when test="$value = 'Anna Rzepka'"><xsl:attribute name="key">NORM-cf004fdc-76fa-3a4f-a5f6-2e0eb5261ca3</xsl:attribute>Rzepka, Anna</xsl:when>
         <xsl:when test="$value = 'Anne-Beate Riecke'"><xsl:attribute name="ref">http://d-nb.info/gnd/124764495</xsl:attribute>Riecke, Anne-Beate</xsl:when>
         <xsl:when test="$value = 'Annegret Butz'"><xsl:attribute name="key">NORM-32bb90e8-976a-3b52-98d5-da10fe66f21d</xsl:attribute>Butz, Annegret</xsl:when>
         <xsl:when test="$value = 'Annelen Ottermann'"><xsl:attribute name="ref">https://d-nb.info/gnd/112004857</xsl:attribute>Ottermann, Annelen</xsl:when>
         <xsl:when test="$value = 'Annemarie Spethmann'"><xsl:attribute name="key">NORM-7eabe3a1-649f-3a2b-bff8-c02ebfd5659f</xsl:attribute>Spethmann, Annemarie</xsl:when>
         <xsl:when test="$value = 'Armin Hetzer'"><xsl:attribute name="ref">https://d-nb.info/gnd/1074525442</xsl:attribute>Hetzer, Armin</xsl:when>
         <xsl:when test="$value = 'Armin Schlechter'"><xsl:attribute name="ref">https://d-nb.info/gnd/112907784</xsl:attribute>Schlechter, Armin</xsl:when>
         <xsl:when test="$value = 'Arno Mentzel-Reuters'"><xsl:attribute name="ref">https://d-nb.info/gnd/143260391</xsl:attribute>Mentzel-Reuters, Arno</xsl:when>
         <xsl:when test="$value = 'Barbara A. Shailor'"><xsl:attribute name="ref">https://d-nb.info/gnd/13764745X</xsl:attribute></xsl:when>
         <xsl:when test="$value = 'Beate Braun-Niehr'"><xsl:attribute name="ref">https://d-nb.info/gnd/114429006</xsl:attribute>Braun-Niehr, Beate</xsl:when>
         <xsl:when test="$value = 'Bernd Michael'"><xsl:attribute name="ref">https://d-nb.info/gnd/1068466294</xsl:attribute>Michael, Bernd</xsl:when>
         <xsl:when test="$value = 'Bernhard Tönnies'"><xsl:attribute name="ref">https://d-nb.info/gnd/1121517471</xsl:attribute>Tönnies, Bernhard</xsl:when>
         <xsl:when test="$value = 'Bertram Lesser'"><xsl:attribute name="ref">https://d-nb.info/gnd/131369466</xsl:attribute>Lesser, Bertram</xsl:when>
         <xsl:when test="$value = 'Bettina Klein-Ilbeck'"><xsl:attribute name="ref">https://d-nb.info/gnd/1131563395</xsl:attribute>Klein-Ilbeck, Bettina</xsl:when>
         <xsl:when test="$value = 'Betty C. Bushey'"><xsl:attribute name="ref">https://d-nb.info/gnd/174058160</xsl:attribute></xsl:when>
         <xsl:when test="$value = 'Birgitt Hilberg'"><xsl:attribute name="key">NORM-fa7cdfad-1a5a-3f83-b0eb-eda47a1ff1c3</xsl:attribute>Hilberg, Birgitt</xsl:when>
         <xsl:when test="$value = 'Birgitt Weimann'"><xsl:attribute name="key">NORM-58238e9a-e2dd-305d-b9c2-ebc8c1883422</xsl:attribute>Weimann, Birgitt</xsl:when>
         <xsl:when test="$value = 'Brigitte Pfeil'"><xsl:attribute name="ref">https://d-nb.info/gnd/121295265</xsl:attribute>Pfeil, Brigitte</xsl:when>
         <xsl:when test="$value = 'Carolin Schreiber'"><xsl:attribute name="ref">http://d-nb.info/gnd/1081256710</xsl:attribute>Schreiber, Carolin</xsl:when>
         <xsl:when test="$value = 'Christa Krause'"><xsl:attribute name="key">NORM-a5bfc9e0-7964-38dd-9eb9-5fc584cd965d</xsl:attribute>Krause, Christa</xsl:when>
         <xsl:when test="$value = 'Christian Alschner'"><xsl:attribute name="ref">https://d-nb.info/gnd/10675131X</xsl:attribute>Alschner, Christian</xsl:when>
         <xsl:when test="$value = 'Christian Heitzmann'"><xsl:attribute name="ref">https://d-nb.info/gnd/17330866X</xsl:attribute>Heitzmann, Christian</xsl:when>
         <xsl:when test="$value = 'Christina Meckelnborg'"><xsl:attribute name="ref">https://d-nb.info/gnd/114872139</xsl:attribute>Meckelnborg, Christina</xsl:when>
         <xsl:when test="$value = 'Christine Sauer'"><xsl:attribute name="ref">https://d-nb.info/gnd/1027468179</xsl:attribute>Sauer, Christine</xsl:when>
         <xsl:when test="$value = 'Christoph Mackert'"><xsl:attribute name="ref">http://d-nb.info/gnd/1043185712</xsl:attribute>Mackert, Christoph</xsl:when>
         <xsl:when test="$value = 'Christoph Winterer'"><xsl:attribute name="ref">https://d-nb.info/gnd/13080102X</xsl:attribute>Winterer, Christoph</xsl:when>
         <xsl:when test="$value = 'Clytus Gottwald'"><xsl:attribute name="ref">https://d-nb.info/gnd/118917439</xsl:attribute>Gottwald, Clytus</xsl:when>
         <xsl:when test="$value = 'Cornelia Hopf'"><xsl:attribute name="ref">https://d-nb.info/gnd/129487961</xsl:attribute>Hopf, Cornelia</xsl:when>
         <xsl:when test="$value = 'Daria Barow-Vassilevitch'"><xsl:attribute name="ref">https://d-nb.info/gnd/130874043</xsl:attribute>Barow-Vassilevitch, Daria</xsl:when>
         <xsl:when test="$value = 'Detlef Döring'"><xsl:attribute name="ref">https://d-nb.info/gnd/133899616</xsl:attribute>Döring, Detlef</xsl:when>
         <xsl:when test="$value = 'Dieter Kudorfer'"><xsl:attribute name="ref">https://d-nb.info/gnd/108426750</xsl:attribute>Kudorfer, Dieter</xsl:when>
         <xsl:when test="$value = 'Dieter Merzbacher'"><xsl:attribute name="ref">https://d-nb.info/gnd/111778662</xsl:attribute>Merzbacher, Dieter</xsl:when>
         <xsl:when test="$value = 'Dominique Stutzmann'"><xsl:attribute name="ref">https://d-nb.info/gnd/1046529714</xsl:attribute>Stutzmann, Dominique</xsl:when>
         <xsl:when test="$value = 'Doris Fouquet-Plümacher'"><xsl:attribute name="ref">https://d-nb.info/gnd/1047963302</xsl:attribute>Fouquet-Plümacher, Doris</xsl:when>
         <xsl:when test="$value = 'Eef Overgaauw'"><xsl:attribute name="ref">https://d-nb.info/gnd/124154778</xsl:attribute>Overgaauw, Eef</xsl:when>
         <xsl:when test="$value = 'Elisabeth Klemm'"><xsl:attribute name="ref">https://d-nb.info/gnd/1032250313</xsl:attribute>Klemm, Elisabeth</xsl:when>
         <xsl:when test="$value = 'Elisabeth Remak-Honnef'"><xsl:attribute name="ref">https://d-nb.info/gnd/1032151234</xsl:attribute>Remak-Honnef, Elisabeth</xsl:when>
         <xsl:when test="$value = 'Elisabeth Wunderle'"><xsl:attribute name="ref">http://d-nb.info/gnd/138997063</xsl:attribute>Wunderle, Elisabeth</xsl:when>
         <xsl:when test="$value = 'Elke Matthes'"><xsl:attribute name="ref">https://d-nb.info/gnd/136126278</xsl:attribute>Matthes, Elke</xsl:when>
         <xsl:when test="$value = 'Erich Petzet'"><xsl:attribute name="ref">https://d-nb.info/gnd/116135603</xsl:attribute>Petzet, Erich</xsl:when>
         <xsl:when test="$value = 'Erich Stahleder'"><xsl:attribute name="ref">https://d-nb.info/gnd/120543303</xsl:attribute>Stahleder, Erich</xsl:when>
         <xsl:when test="$value = 'Erwin Rauner'"><xsl:attribute name="ref">https://d-nb.info/gnd/1183173091</xsl:attribute>Rauner, Erwin</xsl:when>
         <xsl:when test="$value = 'Felix Ekowski'"><xsl:attribute name="key">NORM-a5e00132-373a-3031-800f-d987a3c9f87b</xsl:attribute>Ekowski, Felix</xsl:when>
         <xsl:when test="$value = 'Felix Heinzer'"><xsl:attribute name="ref">https://d-nb.info/gnd/110386906</xsl:attribute>Heinzer, Felix</xsl:when>
         <xsl:when test="$value = 'Franz Georg Kaltwasser'"><xsl:attribute name="ref">https://d-nb.info/gnd/116035382</xsl:attribute>Kaltwasser, Franz Georg</xsl:when>
         <xsl:when test="$value = 'Franz Schnorr von Carolsfeld'"><xsl:attribute name="ref">https://d-nb.info/gnd/116848987</xsl:attribute>Carolsfeld, Franz Schnorr von</xsl:when>
         <xsl:when test="$value = 'Franzjosef Pensel'"><xsl:attribute name="ref">https://d-nb.info/gnd/121218198</xsl:attribute>Pensel, Franzjosef</xsl:when>
         <xsl:when test="$value = 'Fridolin Dressler'"><xsl:attribute name="ref">https://d-nb.info/gnd/118879790</xsl:attribute>Dressler, Fridolin</xsl:when>
         <xsl:when test="$value = 'Friederike Berger'"><xsl:attribute name="key">NORM-d82c8d16-19ad-3176-9665-453cfb2e55f0</xsl:attribute>Berger, Friederike</xsl:when>
         <xsl:when test="$value = 'Friedrich Helmer'"><xsl:attribute name="ref">https://d-nb.info/gnd/1202015069</xsl:attribute>Helmer, Friedrich</xsl:when>
         <xsl:when test="$value = 'Friedrich Leitschuh'"><xsl:attribute name="ref">https://d-nb.info/gnd/119001632</xsl:attribute>Leitschuh, Friedrich</xsl:when>
         <xsl:when test="$value = 'Gerard Achten'"><xsl:attribute name="ref">https://d-nb.info/gnd/117761923</xsl:attribute>Achten, Gerard</xsl:when>
         <xsl:when test="$value = 'Gerd Brinkhus'"><xsl:attribute name="ref">https://d-nb.info/gnd/136621007</xsl:attribute>Brinkhus, Gerd</xsl:when>
         <xsl:when test="$value = 'Gerhard Karpp'"><xsl:attribute name="ref">https://d-nb.info/gnd/1053150784</xsl:attribute>Karpp, Gerhard</xsl:when>
         <xsl:when test="$value = 'Gerhard List'"><xsl:attribute name="ref">https://d-nb.info/gnd/1239672187</xsl:attribute>List, Gerhard</xsl:when>
         <xsl:when test="$value = 'Gerhard Schott'"><xsl:attribute name="ref">https://d-nb.info/gnd/13668839X</xsl:attribute>Schott, Gerhard</xsl:when>
         <xsl:when test="$value = 'Gerhard Stamm'"><xsl:attribute name="ref">https://d-nb.info/gnd/10729558X</xsl:attribute>Stamm, Gerhard</xsl:when>
         <xsl:when test="$value = 'Gerhardt Powitz'"><xsl:attribute name="ref">https://d-nb.info/gnd/130126454</xsl:attribute>Powitz, Gerhardt</xsl:when>
         <xsl:when test="$value = 'Gisela Kornrumpf'"><xsl:attribute name="ref">https://d-nb.info/gnd/1053148704</xsl:attribute>Kornrumpf, Gisela</xsl:when>
         <xsl:when test="$value = 'Gottfried Kentenich'"><xsl:attribute name="ref">https://d-nb.info/gnd/116130741</xsl:attribute>Kentenich, Gottfried</xsl:when>
         <xsl:when test="$value = 'Gregor Patt'"><xsl:attribute name="ref">https://d-nb.info/gnd/1160104301</xsl:attribute>Patt, Gregor</xsl:when>
         <xsl:when test="$value = 'Gude Suckale-Redlefsen'"><xsl:attribute name="ref">https://d-nb.info/gnd/108209164</xsl:attribute>Suckale-Redlefsen, Gude</xsl:when>
         <xsl:when test="$value = 'Günter Glauche'"><xsl:attribute name="ref">https://d-nb.info/gnd/1114323993</xsl:attribute>Glauche, Günter</xsl:when>
         <xsl:when test="$value = 'Günter Hägele'"><xsl:attribute name="ref">https://d-nb.info/gnd/110302451</xsl:attribute>Hägele, Günter</xsl:when>
         <xsl:when test="$value = 'Hans Butzmann'"><xsl:attribute name="ref">https://d-nb.info/gnd/118518151</xsl:attribute>Butzmann, Hans</xsl:when>
         <xsl:when test="$value = 'Hans Fischer'"><xsl:attribute name="ref">https://d-nb.info/gnd/118883917</xsl:attribute>Fischer, Hans</xsl:when>
         <xsl:when test="$value = 'Hans Thurn'"><xsl:attribute name="ref">https://d-nb.info/gnd/119369613</xsl:attribute>Thurn, Hans</xsl:when>
         <xsl:when test="$value = 'Harald Weigel'"><xsl:attribute name="ref">https://d-nb.info/gnd/10675727X</xsl:attribute>Weigel, Harald</xsl:when>
         <xsl:when test="$value = 'Hardo Hilg'"><xsl:attribute name="ref">https://d-nb.info/gnd/1202015115</xsl:attribute>Hilg, Hardo</xsl:when>
         <xsl:when test="$value = 'Hartmut Broszinski'"><xsl:attribute name="ref">https://d-nb.info/gnd/116714395</xsl:attribute>Broszinski, Hartmut</xsl:when>
         <xsl:when test="$value = 'Hedwig Röckelein'"><xsl:attribute name="ref">https://d-nb.info/gnd/123811023</xsl:attribute>Röckelein, Hedwig</xsl:when>
         <xsl:when test="$value = 'Helmar Härtel'"><xsl:attribute name="ref">https://d-nb.info/gnd/107203731</xsl:attribute>Härtel, Helmar</xsl:when>
         <xsl:when test="$value = 'Helmut Boese'"><xsl:attribute name="ref">https://d-nb.info/gnd/1053059922</xsl:attribute>Boese, Helmut</xsl:when>
         <xsl:when test="$value = 'Herbert Buck'"><xsl:attribute name="ref">https://d-nb.info/gnd/17098494X</xsl:attribute>Buck, Herbert</xsl:when>
         <xsl:when test="$value = 'Hermann Degering'"><xsl:attribute name="ref">https://d-nb.info/gnd/116051272</xsl:attribute>Degering, Hermann</xsl:when>
         <xsl:when test="$value = 'Hermann Hauke'"><xsl:attribute name="ref">https://d-nb.info/gnd/1032151404</xsl:attribute>Hauke, Hermann</xsl:when>
         <xsl:when test="$value = 'Hermann Knaus'"><xsl:attribute name="ref">https://d-nb.info/gnd/119052512</xsl:attribute>Knaus, Hermann</xsl:when>
         <xsl:when test="$value = 'Herrad Spilling'"><xsl:attribute name="ref">https://d-nb.info/gnd/129308889</xsl:attribute>Spilling, Herrad</xsl:when>
         <xsl:when test="$value = 'Ilona Hubay'"><xsl:attribute name="ref">https://d-nb.info/gnd/1037902351</xsl:attribute>Hubay, Ilona</xsl:when>
         <xsl:when test="$value = 'Ingeborg Krekler'"><xsl:attribute name="ref">https://d-nb.info/gnd/1228086443</xsl:attribute>Krekler, Ingeborg</xsl:when>
         <xsl:when test="$value = 'Ingeborg Neske'"><xsl:attribute name="ref">https://d-nb.info/gnd/107636336</xsl:attribute>Neske, Ingeborg</xsl:when>
         <xsl:when test="$value = 'Irene Stahl'"><xsl:attribute name="ref">https://d-nb.info/gnd/12961436X</xsl:attribute>Stahl, Irene</xsl:when>
         <xsl:when test="$value = 'Irmgard Fischer'"><xsl:attribute name="key">NORM-f0935e4c-d592-3aa6-87c9-96a5ee53a70f</xsl:attribute>Fischer, Irmgard</xsl:when>
         <xsl:when test="$value = 'Joachim Ott'"><xsl:attribute name="ref">https://d-nb.info/gnd/1053181078</xsl:attribute>Ott, Joachim</xsl:when>
         <xsl:when test="$value = 'Joachim Vennebusch'"><xsl:attribute name="ref">https://d-nb.info/gnd/1030344175</xsl:attribute>Vennebusch, Joachim</xsl:when>
         <xsl:when test="$value = 'Johanne Autenrieth'"><xsl:attribute name="ref">https://d-nb.info/gnd/104648791</xsl:attribute>Autenrieth, Johanne</xsl:when>
         <xsl:when test="$value = 'Johannes Staub'"><xsl:attribute name="ref">https://d-nb.info/gnd/1156951917</xsl:attribute>Staub, Johannes</xsl:when>
         <xsl:when test="$value = 'John L. Flood'"><xsl:attribute name="ref">https://d-nb.info/gnd/128619082</xsl:attribute></xsl:when>
         <xsl:when test="$value = 'Josef Hofmann'"><xsl:attribute name="ref">https://d-nb.info/gnd/116951583</xsl:attribute>Hofmann, Josef</xsl:when>
         <xsl:when test="$value = 'Julia Knödler'"><xsl:attribute name="ref">https://d-nb.info/gnd/136959946</xsl:attribute>Knödler, Julia</xsl:when>
         <xsl:when test="$value = 'Juliane Trede'"><xsl:attribute name="ref">http://d-nb.info/gnd/121910598</xsl:attribute>Trede, Juliane</xsl:when>
         <xsl:when test="$value = 'Jürgen Geiß-Wunderlich'"><xsl:attribute name="ref">https://d-nb.info/gnd/1063822025</xsl:attribute>Geiß-Wunderlich, Jürgen</xsl:when>
         <xsl:when test="$value = 'Jutta Fliege'"><xsl:attribute name="ref">https://d-nb.info/gnd/138898022</xsl:attribute>Fliege, Jutta</xsl:when>
         <xsl:when test="$value = 'Jutta Hager'"><xsl:attribute name="key">NORM-db8e1af0-cb3a-3a1a-a2d0-018624204529</xsl:attribute>Hager, Jutta</xsl:when>
         <xsl:when test="$value = 'Karin Bredehorn'"><xsl:attribute name="key">NORM-44f683a8-4163-3352-bafe-57c2e008bc8c	</xsl:attribute>Bredehorn, Karin</xsl:when>
         <xsl:when test="$value = 'Karin Dengler-Schreiber'"><xsl:attribute name="ref">https://d-nb.info/gnd/121738515</xsl:attribute>Dengler-Schreiber, Karin</xsl:when>
         <xsl:when test="$value = 'Karin Schneider'"><xsl:attribute name="ref">https://d-nb.info/gnd/188464794</xsl:attribute>Schneider, Karin</xsl:when>
         <xsl:when test="$value = 'Karl Bartsch'"><xsl:attribute name="ref">https://d-nb.info/gnd/118506943</xsl:attribute>Bartsch, Karl</xsl:when>
         <xsl:when test="$value = 'Karl Heinz Keller'"><xsl:attribute name="ref">https://d-nb.info/gnd/1153638088</xsl:attribute>Keller, Karl Heinz</xsl:when>
         <xsl:when test="$value = 'Karl Menne'"><xsl:attribute name="ref">https://d-nb.info/gnd/116882336</xsl:attribute>Menne, Karl</xsl:when>
         <xsl:when test="$value = 'Karl-Georg Pfändtner'"><xsl:attribute name="ref">https://d-nb.info/gnd/114651957</xsl:attribute>Pfändtner, Karl-Georg</xsl:when>
         <xsl:when test="$value = 'Katharina Bierbrauer'"><xsl:attribute name="ref">https://d-nb.info/gnd/1223563391</xsl:attribute>Bierbrauer, Katharina</xsl:when>
         <xsl:when test="$value = 'Katrin Janz-Wenig'"><xsl:attribute name="ref">https://d-nb.info/gnd/1124176675</xsl:attribute>Janz-Wenig, Katrin</xsl:when>
         <xsl:when test="$value = 'Katrin Sturm'"><xsl:attribute name="ref">http://d-nb.info/gnd/1177743264</xsl:attribute>Sturm, Katrin</xsl:when>
         <xsl:when test="$value = 'Katrin Wenzel'"><xsl:attribute name="ref">https://d-nb.info/gnd/142566896</xsl:attribute>Wenzel, Katrin</xsl:when>
         <xsl:when test="$value = 'Kerstin Schnabel'"><xsl:attribute name="ref">https://d-nb.info/gnd/1043037160</xsl:attribute>Schnabel, Kerstin</xsl:when>
         <xsl:when test="$value = 'Klaus Klein'"><xsl:attribute name="ref">https://d-nb.info/gnd/1032633662</xsl:attribute>Klein, Klaus</xsl:when>
         <xsl:when test="$value = 'Klaus Niebler'"><xsl:attribute name="ref">https://d-nb.info/gnd/1045263818</xsl:attribute>Niebler, Klaus</xsl:when>
         <xsl:when test="$value = 'Klaus Walter Littger'"><xsl:attribute name="ref">https://d-nb.info/gnd/1023753413</xsl:attribute>Littger, Klaus Walter</xsl:when>
         <xsl:when test="$value = 'Konrad Wiedemann'"><xsl:attribute name="ref">https://d-nb.info/gnd/117353736</xsl:attribute>Wiedemann, Konrad</xsl:when>
         <xsl:when test="$value = 'Kristina Stöbener'"><xsl:attribute name="ref">https://d-nb.info/gnd/1141696924</xsl:attribute>Stöbener, Kristina</xsl:when>
         <xsl:when test="$value = 'Kurt Hans Staub'"><xsl:attribute name="ref">https://d-nb.info/gnd/12935211X</xsl:attribute>Staub, Kurt Hans</xsl:when>
         <xsl:when test="$value = 'Kurt Heydeck'"><xsl:attribute name="ref">https://d-nb.info/gnd/1177404419</xsl:attribute>Heydeck, Kurt</xsl:when>
         <xsl:when test="$value = 'Laurence C. Witten II'"><xsl:attribute name="key">NORM-0bb4aec1-7105-31c1-aee7-6289d9440817</xsl:attribute></xsl:when>
         <xsl:when test="$value = 'Leo Eizenhöfer'"><xsl:attribute name="ref">https://d-nb.info/gnd/101590114X</xsl:attribute>Eizenhöfer, Leo</xsl:when>
         <xsl:when test="$value = 'Lisa Fagin Davis'"><xsl:attribute name="ref">https://d-nb.info/gnd/1056097094</xsl:attribute>Davis, Lisa Fagin</xsl:when>
         <xsl:when test="$value = 'Lotte Kurras'"><xsl:attribute name="ref">https://d-nb.info/gnd/106231936</xsl:attribute>Kurras, Lotte</xsl:when>
         <xsl:when test="$value = 'Ludwig Schmidt'"><xsl:attribute name="ref">https://d-nb.info/gnd/104077891</xsl:attribute>Schmidt, Ludwig</xsl:when>
         <xsl:when test="$value = 'Lukas Wolfinger'"><xsl:attribute name="ref">https://d-nb.info/gnd/1164241095</xsl:attribute>Wolfinger, Lukas</xsl:when>
         <xsl:when test="$value = 'Luitgard Camerer'"><xsl:attribute name="ref">https://d-nb.info/gnd/174062982</xsl:attribute>Camerer, Luitgard</xsl:when>
         <xsl:when test="$value = 'Magda Fischer'"><xsl:attribute name="ref">https://d-nb.info/gnd/1033730157</xsl:attribute>Fischer, Magda</xsl:when>
         <xsl:when test="$value = 'Marek Wejwoda'"><xsl:attribute name="ref">https://d-nb.info/gnd/1023553686</xsl:attribute>Wejwoda, Marek</xsl:when>
         <xsl:when test="$value = 'Maria Kapp'"><xsl:attribute name="ref">https://d-nb.info/gnd/1043383301</xsl:attribute>Kapp, Maria</xsl:when>
         <xsl:when test="$value = 'Maria Sophia Buhl'"><xsl:attribute name="ref">https://d-nb.info/gnd/1027433820</xsl:attribute>Buhl, Maria Sophia</xsl:when>
         <xsl:when test="$value = 'Marianne Reuter'"><xsl:attribute name="ref">https://d-nb.info/gnd/1032154667</xsl:attribute>Reuter, Marianne</xsl:when>
         <xsl:when test="$value = 'Marie-Luise Heckmann'"><xsl:attribute name="ref">https://d-nb.info/gnd/1129902374</xsl:attribute>Heckmann, Marie-Luise</xsl:when>
         <xsl:when test="$value = 'Marina Arnold'"><xsl:attribute name="key">NORM-a0a080f4-2e6f-33b3-a2df-133f073095dd</xsl:attribute>Arnold, Marina</xsl:when>
         <xsl:when test="$value = 'Marita Kremer'"><xsl:attribute name="ref">https://d-nb.info/gnd/116651970</xsl:attribute>Kremer, Marita</xsl:when>
         <xsl:when test="$value = 'Marlis Stähli'"><xsl:attribute name="ref">https://d-nb.info/gnd/1053160046</xsl:attribute>Stähli, Marlis</xsl:when>
         <xsl:when test="$value = 'Martin Wierschin'"><xsl:attribute name="ref">https://d-nb.info/gnd/117366110</xsl:attribute>Wierschin, Martin</xsl:when>
         <xsl:when test="$value = 'Matthias Bley'"><xsl:attribute name="ref">https://d-nb.info/gnd/144019159</xsl:attribute>Bley, Matthias</xsl:when>
         <xsl:when test="$value = 'Matthias Eifler'"><xsl:attribute name="ref">https://d-nb.info/gnd/1079549838</xsl:attribute>Eifler, Matthias</xsl:when>
         <xsl:when test="$value = 'Max Keuffer'"><xsl:attribute name="ref">https://d-nb.info/gnd/116152168</xsl:attribute>Keuffer, Max</xsl:when>
         <xsl:when test="$value = 'Michael Klein'"><xsl:attribute name="ref">https://d-nb.info/gnd/1025729633</xsl:attribute>Klein, Michael</xsl:when>
         <xsl:when test="$value = 'Monika E. Müller'"><xsl:attribute name="ref">https://d-nb.info/gnd/13727971X</xsl:attribute></xsl:when>
         <xsl:when test="$value = 'Natalia Daniel'"><xsl:attribute name="ref">https://d-nb.info/gnd/1032539313</xsl:attribute>Daniel, Natalia</xsl:when>
         <xsl:when test="$value = 'Nicole Eichenberger'"><xsl:attribute name="ref">http://d-nb.info/gnd/1032889594</xsl:attribute>Eichenberger, Nicole</xsl:when>
         <xsl:when test="$value = 'Otto Pültz'"><xsl:attribute name="ref">https://d-nb.info/gnd/1053179553</xsl:attribute>Pültz, Otto</xsl:when>
         <xsl:when test="$value = 'Patrizia Carmassi'"><xsl:attribute name="ref">https://d-nb.info/gnd/173476856</xsl:attribute>Carmassi, Patrizia</xsl:when>
         <xsl:when test="$value = 'Paula Väth'"><xsl:attribute name="ref">https://d-nb.info/gnd/113398581</xsl:attribute>Väth, Paula</xsl:when>
         <xsl:when test="$value = 'Paul-Gerhard Völker'"><xsl:attribute name="ref">https://d-nb.info/gnd/1057562564</xsl:attribute>Völker, Paul-Gerhard</xsl:when>
         <xsl:when test="$value = 'Peter Burkhart'"><xsl:attribute name="ref">https://d-nb.info/gnd/112400736</xsl:attribute>Burkhart, Peter</xsl:when>
         <xsl:when test="$value = 'Peter Höhler'"><xsl:attribute name="key">NORM-5878a7ab-84fb-3340-a106-c575658472fa</xsl:attribute>Höhler, Peter</xsl:when>
         <xsl:when test="$value = 'Peter Jörg Becker'"><xsl:attribute name="ref">https://d-nb.info/gnd/130066478</xsl:attribute>Becker, Peter Jörg</xsl:when>
         <xsl:when test="$value = 'Peter Vogel'"><xsl:attribute name="key">NORM-6855456e-2fe4-3a9d-89d3-d3af4f57443d</xsl:attribute>Vogel, Peter</xsl:when>
         <xsl:when test="$value = 'Peter Zahn'"><xsl:attribute name="ref">https://d-nb.info/gnd/1033228753</xsl:attribute>Zahn, Peter</xsl:when>
         <xsl:when test="$value = 'Philip G. Rusche'"><xsl:attribute name="key">NORM-d9d4f495-e875-32e0-b5a1-a4a6e1b9770f</xsl:attribute></xsl:when>
         <xsl:when test="$value = 'Piotr Tylus'"><xsl:attribute name="ref">https://d-nb.info/gnd/1053304536</xsl:attribute>Tylus, Piotr</xsl:when>
         <xsl:when test="$value = 'Regina Hausmann'"><xsl:attribute name="key">NORM-47d1e990-583c-3c67-824d-369f3414728e</xsl:attribute>Hausmann, Regina</xsl:when>
         <xsl:when test="$value = 'Renate Giermann'"><xsl:attribute name="key">NORM-4c56ff4c-e4aa-3957-baa5-dff913df997a</xsl:attribute>Giermann, Renate</xsl:when>
         <xsl:when test="$value = 'Renate Schipke'"><xsl:attribute name="ref">https://d-nb.info/gnd/140192107</xsl:attribute>Schipke, Renate</xsl:when>
         <xsl:when test="$value = 'Richard Pachella'"><xsl:attribute name="key">NORM-9de6d14f-ff98-36d4-bcd1-ef555be766cd</xsl:attribute>Pachella, Richard</xsl:when>
         <xsl:when test="$value = 'Rudolf Helssig'"><xsl:attribute name="ref">https://d-nb.info/gnd/11669257X</xsl:attribute>Helssig, Rudolf</xsl:when>
         <xsl:when test="$value = 'Sabine Buttinger'"><xsl:attribute name="ref">http://d-nb.info/gnd/129602817</xsl:attribute>Buttinger, Sabine</xsl:when>
         <xsl:when test="$value = 'Sabine Schmolinsky'"><xsl:attribute name="ref">https://d-nb.info/gnd/113013388</xsl:attribute>Schmolinsky, Sabine</xsl:when>
         <xsl:when test="$value = 'Sigrid von Borries-Schulten'"><xsl:attribute name="key">NORM-093f65e0-80a2-35f8-876b-1c5722a46aa2</xsl:attribute>Borries-Schulten, Sigrid von</xsl:when>
         <xsl:when test="$value = 'Sirka Heyne'"><xsl:attribute name="ref">https://d-nb.info/gnd/1299502431</xsl:attribute>Heyne, Sirka</xsl:when>
         <xsl:when test="$value = 'Stefanie Westphal'"><xsl:attribute name="ref">https://d-nb.info/gnd/128848189</xsl:attribute>Westphal, Stefanie</xsl:when>
         <xsl:when test="$value = 'Stephan Kellner'"><xsl:attribute name="ref">https://d-nb.info/gnd/124123724</xsl:attribute>Kellner, Stephan</xsl:when>
         <xsl:when test="$value = 'Sven Limbeck'"><xsl:attribute name="ref">https://d-nb.info/gnd/1047479125</xsl:attribute>Limbeck, Sven</xsl:when>
         <xsl:when test="$value = 'Thomas Elsmann'"><xsl:attribute name="ref">https://d-nb.info/gnd/112028799</xsl:attribute>Elsmann, Thomas</xsl:when>
         <xsl:when test="$value = 'Thomas Falmagne'"><xsl:attribute name="ref">https://d-nb.info/gnd/132678209</xsl:attribute>Falmagne, Thomas</xsl:when>
         <xsl:when test="$value = 'Thomas Fuchs'"><xsl:attribute name="ref">https://d-nb.info/gnd/134211960</xsl:attribute>Fuchs, Thomas</xsl:when>
         <xsl:when test="$value = 'Thomas Sänger'"><xsl:attribute name="ref">https://d-nb.info/gnd/172376645</xsl:attribute>Sänger, Thomas</xsl:when>
         <xsl:when test="$value = 'Tilo Brandis'"><xsl:attribute name="ref">https://d-nb.info/gnd/122096134</xsl:attribute>Brandis, Tilo</xsl:when>
         <xsl:when test="$value = 'Udo Kühne'"><xsl:attribute name="ref">https://d-nb.info/gnd/1140036963</xsl:attribute>Kühne, Udo</xsl:when>
         <xsl:when test="$value = 'Ulrich Kuder'"><xsl:attribute name="ref">https://d-nb.info/gnd/136340776</xsl:attribute>Kuder, Ulrich</xsl:when>
         <xsl:when test="$value = 'Ulrike Bauer-Eberhardt'"><xsl:attribute name="ref">http://d-nb.info/gnd/1065040113</xsl:attribute>Bauer-Eberhardt, Ulrike</xsl:when>
         <xsl:when test="$value = 'Ulrike Hascher-Burger'"><xsl:attribute name="ref">https://d-nb.info/gnd/124200389</xsl:attribute>Hascher-Burger, Ulrike</xsl:when>
         <xsl:when test="$value = 'Ulrike Spyra'"><xsl:attribute name="ref">https://d-nb.info/gnd/129861170</xsl:attribute>Spyra, Ulrike</xsl:when>
         <xsl:when test="$value = 'Ursula Winter'"><xsl:attribute name="ref">https://d-nb.info/gnd/120003376</xsl:attribute>Winter, Ursula</xsl:when>
         <xsl:when test="$value = 'Virgil Ernst Fiala'"><xsl:attribute name="ref">https://d-nb.info/gnd/1059654350</xsl:attribute>Fiala, Virgil Ernst</xsl:when>
         <xsl:when test="$value = 'Walter Wambach'"><xsl:attribute name="ref">https://d-nb.info/gnd/1228187754</xsl:attribute>Wambach, Walter</xsl:when>
         <xsl:when test="$value = 'Werner Hoffmann'"><xsl:attribute name="ref">https://d-nb.info/gnd/1053137532</xsl:attribute>Hoffmann, Werner</xsl:when>
         <xsl:when test="$value = 'Wilhelm Schum'"><xsl:attribute name="ref">https://d-nb.info/gnd/117647667</xsl:attribute>Schum, Wilhelm</xsl:when>
         <xsl:when test="$value = 'Winfried Hagenmaier'"><xsl:attribute name="ref">https://d-nb.info/gnd/106325442</xsl:attribute>Hagenmaier, Winfried</xsl:when>
         <xsl:when test="$value = 'Wolf Gehrt'"><xsl:attribute name="ref">https://d-nb.info/gnd/1053132972</xsl:attribute>Gehrt, Wolf</xsl:when>
         <xsl:when test="$value = 'Wolf-Dieter Otte'"><xsl:attribute name="key">NORM-f7664060-cc52-3c6f-bd62-0bcedc94a4b6</xsl:attribute>Otte, Wolf-Dieter</xsl:when>
         <xsl:when test="$value = 'Wolfgang Georg Bayerer'"><xsl:attribute name="key">NORM-f457c545-a9de-388f-98ec-ee47145a72c0</xsl:attribute>Bayerer, Wolfgang Georg</xsl:when>
         <xsl:when test="$value = 'Wolfgang Irtenkauf'"><xsl:attribute name="ref">https://d-nb.info/gnd/117204366</xsl:attribute>Irtenkauf, Wolfgang</xsl:when>
         <xsl:when test="$value = 'Wolfgang Metzger'"><xsl:attribute name="ref">https://d-nb.info/gnd/143871528</xsl:attribute>Metzger, Wolfgang</xsl:when>
         <xsl:when test="$value = 'Wolfgang-Valentin Ikas'"><xsl:attribute name="ref">https://d-nb.info/gnd/128420308</xsl:attribute>Ikas, Wolfgang-Valentin</xsl:when>
         <xsl:otherwise><xsl:message>kein Eintrag gefunden für Beschreibungsautor <xsl:value-of select="$value"/></xsl:message></xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
