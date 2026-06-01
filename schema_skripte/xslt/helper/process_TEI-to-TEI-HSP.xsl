<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:import href="../tei_all/TEI-to-TEI-HSP.xsl"/>
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:param name="mode"/>
    
    <xsl:template name="main" match="/">
        <xsl:for-each select="//doc/@href">
            <xsl:variable name="contents" select="doc(.)"/>
            <xsl:result-document href="{concat('../nachweis_daten/_TEI-to-TEI-HSP_result/', substring-before(tokenize(., '/')[last()],'_TEI.xml'), '_TEI_TEI-HSP.xml')}">
                <xsl:variable name="creationDate" select="if (//tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:date != '') then //tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:date else string(current-date())"/>
                <!--
        <xsl:processing-instruction name="xml-model">
            <xsl:attribute name="href" select="$TEI-schema"/>
            <xsl:attribute name="type" select=" 'application/xml' "/>
            <xsl:attribute name="schematypens" select=" 'http://relaxng.org/ns/structure/1.0' "/>
        </xsl:processing-instruction>
        <xsl:processing-instruction name="xml-model">
            <xsl:attribute name="href" select="$TEI-schema"/>
            <xsl:attribute name="type" select=" 'application/xml' "/>
            <xsl:attribute name="schematypens" select=" 'http://purl.oclc.org/dsdl/schematron' "/>
        </xsl:processing-instruction>
        -->
                <xsl:value-of select="$crlf"/>
                <xsl:element name="teiCorpus" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="version" select="$TEI-schema"/>
                    <xsl:element name="teiHeader" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="fileDesc" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:element name="titleStmt" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:text>Automatisch generierter Handschriftenkatalog</xsl:text>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="publicationStmt" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:element name="publisher" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:text>Handschriftenportal</xsl:text>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="sourceDesc" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:text>Automatisch generierter Handschriftenkatalog aus einem </xsl:text>
                                    <xsl:if test="$creationDate != '' "><xsl:value-of select="concat('am ', $creationDate, ' transformierten ')"/></xsl:if>
                                    <xsl:text>TEI-Dokument.</xsl:text>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:for-each select="$contents/descendant-or-self::tei:TEI">
                        <xsl:copy>
                            <xsl:apply-templates>
                                <xsl:with-param name="creationDate" select="$creationDate"/>
                            </xsl:apply-templates>
                        </xsl:copy>
                    </xsl:for-each>
                </xsl:element>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
