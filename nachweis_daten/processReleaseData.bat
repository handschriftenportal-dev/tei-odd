// kopiere die neuesten Schemata
copy C:\Users\schassan\Documents\_GitHub-clones\HSP\tei-odd\target\tei-odd\schema_skripte\isosch\tei_hsp\hsp_cataloguing.isosch C:\Users\schassan\Documents\_GitHub-clones\HSP\tei-odd\schema_skripte\isosch\tei_hsp\

// Generiere neue Normdaten-Importdateien
java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" net.sf.saxon.Transform -t -s:1_0_Normdaten\1_1_Orte\GEO-gesamt.xml -xsl:..\schema_skripte\xslt\helper\MXML-to-TEI-P5_geo.xsl -o:1_0_Normdaten\hsp_TEI_Import_Orte.xml
java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" net.sf.saxon.Transform -t -s:1_0_Normdaten\1_2_Koerperschaften\SOZ-gesamt.xml -xsl:..\schema_skripte\xslt\helper\MXML-to-TEI-P5_soz.xsl -o:1_0_Normdaten\hsp_TEI_Import_Koerperschaften.xml
java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" net.sf.saxon.Transform -t -s:1_0_Normdaten\1_3_Personen\PER-gesamt.xml -xsl:..\schema_skripte\xslt\helper\MXML-to-TEI-P5_per.xsl -o:1_0_Normdaten\hsp_TEI_Import_Personen.xml

// Validiere Normdaten-Importdateien
java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" net.sf.saxon.Transform -t -s:1_0_Normdaten\hsp_TEI_Import_Relationen-geo.xml -xsl:..\schema_skripte\xslt\helper\validate_relation_geo.xsl -o:_report_validate_relation_geo.txt
java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" net.sf.saxon.Transform -t -s:1_0_Normdaten\hsp_TEI_Import_Relationen-soz.xml -xsl:..\schema_skripte\xslt\helper\validate_relation_soz.xsl -o:_report_validate_relation_soz.txt

// Schreibe neue Katalog-Dateien
dir /B /S 01_*.csv > catalog_KOD_neu.txt
dir /B /S 02_*_EXT.xml > catalog_DSC_neu.txt
dir /B /S 02_*_EXT_TEI.xml > catalog_DSC-TEI_neu.txt
dir /B /S 03_*.csv > catalog_DIG_neu.txt
dir /B /S 04_*.xml > catalog_KAT_neu.txt

java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" net.sf.saxon.Transform -t -s:..\schema_skripte\xslt\helper\dummy.xml -xsl:..\schema_skripte\xslt\helper\txt-to-xml.xsl

del catalog_DIG_neu.txt
del catalog_DSC_neu.txt
del catalog_DSC-TEI_neu.txt
del catalog_KAT_neu.txt
del catalog_KOD_neu.txt

//CSV-to-XML_KODs
// java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" net.sf.saxon.Transform -t -s:catalog_KOD.xml -xsl:..\schema_skripte\xslt\helper\CSV-to-XML_KODs.xsl -o:_result_CSV-to-XML_KODs.txt mode=test
java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" net.sf.saxon.Transform -t -s:catalog_KOD.xml -xsl:..\schema_skripte\xslt\helper\CSV-to-XML_KODs.xsl -o:_result_CSV-to-XML_KODs.txt

// validate_place+org validate_idno
java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" net.sf.saxon.Transform -t -s:catalog_DSC.xml -xsl:..\schema_skripte\xslt\helper\validate_place+org.xsl -o:_report_validate-place+org.txt
java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" net.sf.saxon.Transform -t -s:catalog_DSC.xml -xsl:..\schema_skripte\xslt\helper\validate_idno.xsl -o:_report_validate-idno.txt

//CSV-to-XML_DIGs
// java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" net.sf.saxon.Transform -t -s:catalog_DIG.xml -xsl:..\schema_skripte\xslt\helper\CSV-to-XML_DIGs.xsl mode=test
java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" net.sf.saxon.Transform -t -s:catalog_DIG.xml -xsl:..\schema_skripte\xslt\helper\CSV-to-XML_DIGs.xsl mode=test

// validate_digis
java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" net.sf.saxon.Transform -t -s:catalog_DIG.xml -xsl:..\schema_skripte\xslt\helper\validate_digis.xsl -o:_report_validate-digis.txt

//count all
java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" net.sf.saxon.Transform -t -s:catalog_KOD.xml -xsl:..\schema_skripte\xslt\helper\count_idno.xsl

//search-replace in Beschreibungen
//search §§ Value="[x \-]+"## replace §§##
//search §§&#x0d;&#x0a;## replace §§ ##
//search §§\s+<h1:Field Type="[\d\w]+"/>## replace §§##

//search-replace in Katalogen
// mehrfach ausführen:
//search §§\s+<tei:(catchwords|del|height|material|measure|origDate|origPlace|watermark|width)( (key|quantity|type|unit)="\w+")+## replace §§ <tei:$1##
//search §§\s+<tei:(catchwords|del|height|material|measure|origDate|origPlace|watermark|width)>(.*?)</tei:\1>(\s*)## replace §§ $2$3##
//search §§<tei:(catchwords|del|height|material|measure|origDate|origPlace|watermark|width)( (key|quantity|type|unit)="\w+")+## replace §§<tei:$1##
//search §§<tei:(catchwords|del|height|material|measure|origDate|origPlace|watermark|width)>(.*?)</tei:\1>(\s*)## replace §§$2$3##
//search §§\s+<tei:pb n="Page\d+"/>## replace §§##

//search §§(\s+)<tei:sourceDesc>(\s+)<tei:p>OCR-Ausgangsdatei: 04_([a-zA-Z]+)_([a-zA-Z]+)(.*?)_tei.xml</tei:p>\s+</tei:sourceDesc>##
//replace §§$1<tei:sourceDesc>$2<tei:msDesc xml:id="OCR_04_$3_$4$5_tei" type="hsp:catalog" xml:lang="de">$2   <tei:msIdentifier>$2      <tei:settlement>$3</tei:settlement>$2      <tei:repository>$4</tei:repository>$2      <tei:idno>$5</tei:idno>$2   </tei:msIdentifier>$2   <tei:p>OCR-Ausgangsdatei: 04_$3_$4$5_tei.xml</tei:p>$2</tei:msDesc>$1</tei:sourceDesc>##

//search $$(\s+)<tei:pubPlace>([\p{L}\-]+)<tei:ptr type="thumbnail"\s*(.*?)/>\s+</tei:pubPlace>\s+<tei:date>(\d+)</tei:date>\s+<tei:idno type="hsk">(\d+)</tei:idno>\s+<tei:availability>\s+<tei:licence target="(.*?)">\s+<tei:p>(.*?)</tei:p>\s+</tei:licence>\s+</tei:availability>##
//replace $$$1<tei:pubPlace>$2</tei:pubPlace>$1<tei:date>$4</tei:date>$1<tei:idno type="hsk">$5</tei:idno>$1<tei:availability>$1   <tei:licence target="$6">$1      <tei:p>$7</tei:p>$1   </tei:licence>$1</tei:availability>$1<tei:ptr type="thumbnail" $3/>##



//Suche in Katalogen
//search §§<tei:publisher/?>##

//listPar
java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" net.sf.saxon.Transform -t -s:catalog_DSC.xml -xsl:..\schema_skripte\xslt\helper\listPar.xsl -o:_listPar/listPar.csv

//MXML-to-TEI-P5_obj
java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" net.sf.saxon.Transform -t -s:_testdaten\_obj_testdatenset.xml -xsl:..\MXML2TEI\MXML-to-TEI-P5.xsl -o:_MXML-to-TEI-HSP_result\_obj_testdatenset_TEI-HSP.xml TEI-schema=3.1.0
java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" net.sf.saxon.Transform -t -s:catalog_DSC.xml -xsl:..\schema_skripte\xslt\helper\process_MXML-to-TEI-HSP.xsl TEI-schema=3.1.0

//MXML-to-text
java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" net.sf.saxon.Transform -t -s:catalog_DSC.xml -xsl:..\schema_skripte\xslt\helper\extract_MXML-text.xsl

//TEI-to-TEI
java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" net.sf.saxon.Transform -t -s:catalog_DSC-TEI.xml -xsl:..\schema_skripte\xslt\helper\process_TEI-to-TEI-HSP.xsl TEI-schema=3.1.0

// MXML-to-TEI-P5_obj ManuMed Gesamtexport
java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" net.sf.saxon.Transform -t -s:..\..\..\mssDB\Hss-Erschliessung\externeDaten\ManuMed\Gesamtexport\catalog_DSC.xml -xsl:..\schema_skripte\xslt\helper\MXML-to-TEI-P5_obj.xsl

// java -cp "C:\Users\schassan\Documents\_Software\Saxon\saxon-he-12.3\saxon-he-12.3.jar" com.saxonica.Validate -xsd:..\hsp_cataloguing.rng -s:3_0_Produktion\Wolfenbuettel_HAB\01_Wolfenbuettel_HAB.xml.xml
