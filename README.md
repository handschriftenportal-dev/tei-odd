# Handschriftenportal - Transformation Pipeline for Manuscript Descriptions -

## Description

This repository contains the transformation pipeline of the Handschriftenportal. It offers a set of XSLT scripts to transform manuscript descriptions and related metadata and authority files from the legacy data in MXML format (exported from the deprecated portal Manuscripta Mediaevalia) to [TEI XML](https://tei-c.org/).

TEI XML is used as the central data model as well as format for data exchange throughout the project "[Handschriftenportal](https://handschriftenportal.de/)". The transformation is based on a special [TEI ODD (One Document Does-it-all)](https://tei-c.org/guidelines/customization/getting-started-with-p5-odds/) description designed for the Handschriftenportal and enabling manuscript descriptions according to the [DFG guidelines for cataloguing manuscripts](http://bilder.manuscripta-mediaevalia.de/hs//kataloge/HSKRICH.htm). The ODD provides a customized TEI P5 schema in the file [`hsp_cataloguing.odd`](hsp_cataloguing.odd). Together with the XSL scripts the ODD and the schemas generated from it build the core for transformation and validation of manuscript descriptions. The transformation pipeline includes several validation tasks in order to validate the manuscript descriptions according to the XML Schema, RELAX NG and IOS Schematron schemas generated from the ODD.

This tool is independent of the backend services of the manuscripts portal "Handschriftenportal". It provides the data for the import service of the backend.

## Technology stack

- The pipeline is implemented as a [Maven](https://maven.apache.org/) project.
- [Saxon-HE](https://github.com/Saxonica/Saxon-HE) is used for XSLT processing.
- The [Trang multi-format schema converter](https://relaxng.org/jclark/trang.html) is used for XML Schema generation from RELAX NG schema.
- The [PH Schematron](https://github.com/phax/ph-schematron) Maven plugin is used for ISO Schematron validation.
- [XMLUnit](https://www.xmlunit.org/) is used for testing the equality of XML files after transformation round-trips (between TEI and HSP-TEI dialect).
- To build the project `mvn` is used.

## Status

Beta (in development)

## Getting started

1. Get the source code

   ```
   git clone https://github.com/handschriftenportal-dev/hsp-tei-odd
   ```

2. Build the project

   ```
   mvn clean install
   ```


After a successful build, you will find the TEI XML files according to the HSP Cataloguing ODD schema in the `target` directory. In case of errors in the XML files, the pipeline may have stopped. If the pipeline stopps after Schematron validation, you will find the SVRL (Schematron Validation Report Language) validation reports in the subfolder `svrl-reports` in the `target` directory.

## Configuration

Transformation and validation in the TEI ODD framework builds on the following components: 

* custom TEI ODD
* schema files (XML Schema, Relax NG, ISO Schematron)
* XSLT scripts

The configuration of the transformation and validation tasks executed in the pipeline is based on entries in the `executions` sections in the `pom.xml` file.

The pipeline can be adapted to specific requirements by modifying the configuration in the POM.

### Transformation tasks in the POM configuration

#### Tasks to generate schemas from ODD:

- Process [`odd2relax.xsl`](src/main/resources/Stylesheets/odds/odd2odd.xsl) to generate RELAX NG schema `hsp_cataloguing.rng` from compiled ODD.
- Process [`extract-isosch.xsl`](src/main/resources/Stylesheets/odds/) to generate ISO Schematron schema `hsp_cataloguing.isosch` from compiled ODD.
- The XML Schema file `hsp_cataloguing.xsd` is generated via Trang from the RELAX NG schema `hsp_cataloguing.rng`.

#### Tasks to validate authority files via XSLT:

- Validate authority files for interrelated places given in [`hsp_TEI_Import_Orte.xml`](nachweis_daten/1_0_Normdaten/hsp_TEI_Import_Orte.xml) with the script [`validate_relation_soz.xsl`](Skripte/validate_relation_geo.xsl).
- Validate authority files for organizations and related places given in [`hsp_TEI_Import_Koerperschaften.xml`](nachweis_daten/1_0_Normdaten/hsp_TEI_Import_Koerperschaften.xml) and [`hsp_TEI_Import_Orte.xml`](nachweis_daten/1_0_Normdaten/hsp_TEI_Import_Orte.xml) with the script [`validate_relation_soz.xsl`](Skripte/validate_relation_soz.xsl).

#### Tasks to transform manuscript descriptions:

- Process [´MXML-to-TEI-P5.xsl`](MXML2TEI/MXML-to-TEI-P5.xsl) to transform MXML-encoded documents into the HSP-TEI dialect.
- Process [`TEI-to-TEI-HSP.xsl`](Skripte/TEI-to-TEI-HSP.xsl) to transform TEI-encoded documents to the HSP-TEI dialect.
- Process [`switch_TEI-to-HSP.xsl`](Skripte/switch_TEI-to-HSP.xsl).
- Process [`switch_HSP-to-TEI.xsl`](Skripte/switch_HSP-to-TEI.xsl).

### Validation tasks in the POM configuration

- Validate TEI documents against TEI-All schema.
- Validate TEI documents against RELAX NG schema (ODD).
- Validate TEI documents against ISO Schematron (ODD).

## Usage

XML files containing manuscript descriptions and authority files have to be filed under the [`nachweis_daten`](nachweis_daten/) directory:

The following templates for TEI encoded authority files are available in the [`nachweis_templates`](nachweis_templates/) directory:

- TEI template for organizations (applying the TEI element `listOrg`): [`TEI_KoerperschaftenTemplate.xml`](nachweis_templates/TEI_KoerperschaftenTemplate.xml)
- TEI template for places (applying the TEI element `listPlace`): [`TEI_OrteTemplate.xml`](nachweis_templates/TEI_OrteTemplate.xml)
- TEI template for persons (applying the TEI element `listPerson`): [`TEI_PersonTemplate.xml`](nachweis_templates/TEI_PersonTemplate.xml)
- TEI template for languages (applying the TEI element `langUsage`): [`TEI_SprachenTemplate.xml`](nachweis_templates/TEI_SprachenTemplate.xml)

## Known issues

## Getting help

To get help please use our contact possibilities on [twitter](https://twitter.com/hsprtl)
and [handschriftenportal.de](https://handschriftenportal.de/)

## Getting involved

To get involved please contact our develoment
team [handschriftenportal@sbb.spk-berlin.de](handschriftenportal-dev@sbb.spk-berlin.de)

## Open source licensing info

The project is published under the [MIT License](https://opensource.org/licenses/MIT).

## Credits and references

1. [Github Project Repository](https://github.com/handschriftenportal-dev)
2. [Project Page](https://handschriftenportal.de/)
3. [Internal Documentation](doc/ARC42.md)

## RELEASE Notes
