# Release Notes, TEI-ODD


# Version 0.5.0 - 22.11.2021

- Elemente persName, orgName, placeName
  - @role hat jetzt eine enumerated List mit maxOccurence="unbounded", Trennungszeichen Whitespace(s), kann mehrere Werte enthalten
  - @role mode="required"
- Komponente Kopf
  - Schemaregeln für head in KOK sind gelockert worden 
  - textnodes der index-term-elemente sind nicht mehr verpflichtend
  - *Ausnahmen* : origDate_type dimensions_typeOfInformation, decoration musicNotation
  - index-term-elemente müssen existent sein
- Komponente Sonstiges
  - msPart type="other" hat nur eine zulässige idno "Sonstiges"
  - Sonstiges kann nur einmal vorkommen und enthält genau ein p Element, andere Elemente sind nicht erlaubt
- Komponenten binding, accMat, booklet, fragment haben neue schematron Regeln
  - msPart type binding, fragment und accMat können Children msPart type accMat oder fragment enthalten
  - msPart type booklet kann children msPart type fragment, booklet, accMat enthalten
- isoschematron-Datei wird jetzt ausgegeben


# Version 0.5.0 - 25.11.2021

- Komponente Sonstiges kann mehrere p Elemente enthalten
- KOKs können Komponente Literatur enthalten
- Komponente Sonstiges kann auch eine Unterkomponente von KOKs sein
- head:
  - Werteliste für decoration kann 'unknown' enthalten
  - Werteliste für musicNotation kann 'unknown' enthalten
  - dimensions_typeOfInformation kann 'unknown' enthalten
  - origDate_type kann 'unknown' enthalten

Update:
- .odd
- .rng
- .html
- loremIpsum

# Version 0.5.1 - 13.12.2021

- Komponente Kopf hat nun 3 wiederholbare index-Gruppen:
  - dimensions (@indexName="norm_dimensions")
  - origDate (@indexName="norm_origDate")
  - origPlace (@indexName="norm_origPlace")

- Das Element index @indexName hat neue Werte, die eine bessere Lokalisierung möglich machen
  - norm_title
  - norm_material
  - norm_measure
  - norm_dimensions
  - norm_origPlace
  - norm_origDate
  - norm_textLang
  - norm_form
  - norm_status
  - norm_decoration
  - norm_musicNotation

Update:
- .odd
- .rng
- .html
- .isosch
- loremIpsum
- erfassungsregelnODD.json
- attributWerte.json
- new: tei_bare.xml

# Version 0.6.0 - 04.01.2022

- origPlace in Komponente Kopf hat nun doch keine Wiederholbarkeit als Eigenschaft mehr
- beschreibunginitial.xml update
- altIdentifier hat neue typen former, corpus, hsp-ID
- Komponente Sonstiges kann nun auch in den msPart stehen (wichtig für Registerinformationen, die nicht in den übrigen Komponenten abgelegt werden können)

Update:
- .odd
- .rng
- .html
- beschreibunginitial.xml
- erfassungsregelnODD.json

# Version 0.6.1 - 12.01.2022-18.01.2022

- date besitzt nun definierte type-attribute: created(für interne), modified(für interne), published(für externe)
- Komponente Kopf: neues index-term-Feld 'format' (Gruppe wiederholbar)
- Komponente Kopf: unknown ist nun kein gültiger Wert mehr. Substitute: ' '
- Komponente Kopf: Felder für length, width, depth in head können nun leer sein
- Komponente Kopf: neue Werte @format_typeOfInformation @dimensions_typeOfInformation @origDate_type in engl. Sprache datable, dated ; factual, deduced; computed 
- Komponente Inhalt: msItem lässt als direktes Kindelement auch 0 bis unbounded index elemente zu
- persName Attribut @role hat 2 neue Werte: complementedBy, editedBy
- msDesc hat neuen @type hsp:description_retro für Registerdokumente


Update:
- .odd
- .rng
- .html
- .isosch
- loremIpsum_beschreibung.xml
- beschreibunginitial.xml
- hsp_bare.xml
- attributwerte.json
- erfassungsregelnODD.json

# Version 0.7.0 -upcoming release- 

- date wird nun im teiHeader an 3 Orten ausgezeichet:
  - profileDesc > creation > date (für Erstellung intern)
  - revisionDesc > change > date (max 2 Angaben) (für Änderungen)
  - publicationStmt > date für externe Beschreibungen. Unterscheidung zwischen @type="primary" und "secondary"
- Komponente Identifikation
  - neu altIdentifier type="mxml-ID für HIDA-obj-ID (s. ODD Agenda)
  - nicht bearbeitbar
- Komponente Kopf:
  - neue Reihenfolge der Title
  - index-term-title
  - title
  - Schlagzeile (siehe auch https://projects.dev.sbb.berlin/projects/handschriftenportal-deutschland/wiki/Fachliche_Festlegungen#Wie-ist-die-Komponente-Kopf-aufgebaut )

- msPart
  - Komponente Identifikation in msPart:
    - idno darf nicht leer sein
    - settlement, repository optional
    - altIdentifier @type ="former"
    - settlement, repository optional
    - idno optional
      - bei settlement, repository und idno in altIdentifier muss mind. ein Feld ausgefüllt sein
  - Komponente Kopf in Identifikation:
    - index-term form: Wenn msPart @type="accMat" then term @type=form" = "loose insert"
- Reihenfolge der msParts
  - binding
  - fragment
  - accMat
  - booklet
  - other

# Version 1.0.9 - 15.06.2022

- Komponente Kopf
  - neue Werteliste für status: missing, existent, destroyed, dismembered, unknown, displaced or empty
  - Attributname für origPlace_gnd-ID ändert sich zu origPlace_norm (Rückwärtskompatibilität gewährleistet)
    - weitere Attribute: @key und @ref beide optional
- msPart
  - Bugfix repository/settlement in msIdentifier
  - neue Werteliste für status: missing, existent, destroyed, dismembered, unknown, displaced or empty
  - Attributname für origPlace_gnd-ID ändert sich zu origPlace_norm (Rückwärtskompatibilität gewährleistet)
    - weitere Attribute: @key und @ref beide optional
- Allgemein:
  - date: constraintSpec ändern: Löschung "@when or (@notAfter and @notBefore) or (@from and @to)"

Update:
- .odd
- .rng
- .html
- .isosch
- loremIpsum_beschreibung.xml
- beschreibunginitial.xml
- hsp_bare.xml
- attributwerte.json
- komponenteKopf_werte.json

# Version 1.0.10 - 22.06.2022

Wir betrachten nur die Dateien hsp_cataloguing.odd und nachweis_templates/*.

- Keine Änderungen

# Version 1.0.11 - 28.06.2022

Wir betrachten nur die Dateien hsp_cataloguing.odd und nachweis_templates/*.

- Keine Änderungen

# Version 1.0.12 - 07.07.2022

Wir betrachten nur die Dateien hsp_cataloguing.odd und nachweis_templates/*.

- beschreibungsintitial_medieval.xml
  - Platzhaltertext für Abmessung und Format

# Version 1.0.13 - 11.07.2022

- Keine Änderungen

# Version 1.0.14 - 12.07.2022

- Keine Änderungen

# Version 1.0.15 - 13.07.2022

- Keine Änderungen

# Version 1.0.16 - 31.08.2022

- Keine Änderungen

# Version 1.0.17 - 02.09.2022

- Keine Änderungen

# Version 1.0.18

**fehlt**

# Version 1.0.19 - 05.09.2022

- Keine Änderungen

# Version 1.0.20 - 06.10.2022

- Keine Änderungen

# Version 1.0.21 - 06.10.2022

- Keine Änderungen

# Version 1.0.22 - 07.10.2022

- Keine Änderungen

# Version 1.0.23 - 25.10.2022

Wir betrachten nur die Dateien hsp_cataloguing.odd und nachweis_templates/*.

- hsp_cataloguing
  - Werteergänzung von title > hi > rend
    - italic super
    - italic line-throuh
    - super small-caps
    - super
  - Werteergänzung von note > hi > rend
    - italic super
    - italic line-through
    - super small-caps
    - super

# Version 1.0.24 - 26.10.2022

Wir betrachten nur die Dateien hsp_cataloguing.odd und nachweis_templates/*.

- Keine Änderungen

# Version 1.0.25 - 08.11.2022

Wir betrachten nur die Dateien hsp_cataloguing.odd und nachweis_templates/*.

- hsp_cataloguing
  - Fehlertexte wurden verändert und verbessert
  - Werteergänzung von title > hi > rend
    - italic super -> italic sup
    - super small-caps -> sup small-caps
    - super -> sup
  - Werteergänzung von note > hi > rend
    - italic super -> italic sup
    - super small-caps -> sup small-caps
    - super -> sup

# Version 1.0.26 - 22.11.2022

Wir betrachten nur die Dateien hsp_cataloguing.odd und nachweis_templates/*.

- Keine Änderungen


# Version 1.0.27 - 01.03.2023

Wir betrachten nur die Dateien hsp_cataloguing.odd und nachweis_templates/*.

- nachweis_templates/kodinitial.xml
  - Ergänzung um Kerndatenfelder (Index Term)

# Version 1.0.28 - 06.03.2023

Wir betrachten nur die Dateien hsp_cataloguing.odd und nachweis_templates/*.

- nachweis_templates/beschreibunginitial_medieval.xml
  - Platzhaltertexte anpassen
  - Unnötige Abmessung und Format Platzhalter entfernen
- nachweis_templates/kodinitial.xml
  - Leere hsp-uuid attribute entfernt
  - Platzhaltertexte anpassen

# Version 1.0.29 - 09.05.2023

Wir betrachten nur die Dateien hsp_cataloguing.odd und nachweis_templates/*.

- hsp_cataloguing.odd
  - Korrektur der deutschen Übersetzung von Author
- nachweis_templates/hsp_kodsurrogatevorlage.xml
  - Digitalisattemplate
  - Noch nicht normalisiertes Aufbau, Daten sind redundant
- nachweis_templates/kodinitial.xml
  - msDesc Attribut xml:lang ist nun standardmässig auf `de` gesetzt 

# Version 1.0.30 - 12.05.2023

Wir betrachten nur die Dateien hsp_cataloguing.odd und nachweis_templates/*.

- Keine Änderungen

# Version 1.0.31 - 16.05.2023

Wir betrachten nur die Dateien hsp_cataloguing.odd und nachweis_templates/*.

- Keine Änderungen
