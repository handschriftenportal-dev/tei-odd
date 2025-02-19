<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/">
        <xsl:element name="TEI" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="teiHeader" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="fileDesc" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="titleStmt" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="title" namespace="http://www.tei-c.org/ns/1.0">Surrogates</xsl:element>
                    </xsl:element>
                    <xsl:element name="publicationStmt" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">Publication Information</xsl:element>
                    </xsl:element>
                    <xsl:element name="sourceDesc" namespace="http://www.tei-c.org/ns/1.0">
                        <xsl:element name="msDesc" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:element name="msIdentifier" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:element name="settlement" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="ref">
                                        <xsl:text>http://d-nb.info/gnd/</xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="descendant::DigitalisatInfo[1]/GNDOfPlaceOfHostInstitution != ''">
                                                <xsl:value-of select="descendant::DigitalisatInfo[1]/GNDOfPlaceOfHostInstitution"/>
                                            </xsl:when>
                                            <xsl:when test="descendant::DigitalisatInfo[1]/GNDOfPlaceOfDigitalisingInstitution != ''">
                                                <xsl:value-of select="descendant::DigitalisatInfo[1]/GNDOfPlaceOfDigitalisingInstitution"/>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="descendant::DigitalisatInfo[1]/placeOfHostInstitution != ''">
                                            <xsl:value-of select="descendant::DigitalisatInfo[1]/placeOfHostInstitution"/>
                                        </xsl:when>
                                        <xsl:when test="descendant::DigitalisatInfo[1]/placeOfDigitalisingInstitution != ''">
                                            <xsl:value-of select="descendant::DigitalisatInfo[1]/placeOfDigitalisingInstitution"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:element>
                                <xsl:element name="repository" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:attribute name="ref">
                                        <xsl:text>http://d-nb.info/gnd/</xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="descendant::DigitalisatInfo[1]/GNDOfHostInstitution != ''">
                                                <xsl:value-of select="descendant::DigitalisatInfo[1]/GNDOfHostInstitution"/>
                                            </xsl:when>
                                            <xsl:when test="descendant::DigitalisatInfo[1]/GNDOfDigitalisingInstitution != ''">
                                                <xsl:value-of select="descendant::DigitalisatInfo[1]/GNDOfDigitalisingInstitution"/>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="descendant::DigitalisatInfo[1]/nameOfHostInstitution != ''">
                                            <xsl:value-of select="descendant::DigitalisatInfo[1]/nameOfHostInstitution"/>
                                        </xsl:when>
                                        <xsl:when test="descendant::DigitalisatInfo[1]/nameOfDigitalisingInstitution != ''">
                                            <xsl:value-of select="descendant::DigitalisatInfo[1]/nameOfDigitalisingInstitution"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="additional" namespace="http://www.tei-c.org/ns/1.0">
                                <xsl:element name="surrogates" namespace="http://www.tei-c.org/ns/1.0">
                                    <xsl:apply-templates select="descendant::DigitalisatInfo[.!='']"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="text" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:element name="body" namespace="http://www.tei-c.org/ns/1.0">
                    <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="DigitalisatInfo[.!='']">
        <xsl:element name="bibl" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="hsp_object[.!='']">
        <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type"><xsl:text>hsp:object</xsl:text></xsl:attribute>
            <xsl:attribute name="target"><xsl:value-of select="."/></xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="manifestURL[.!='']">
        <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type"><xsl:text>manifest</xsl:text></xsl:attribute>
            <xsl:attribute name="target"><xsl:value-of select="."/></xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="otherURL[.!='']">
        <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type"><xsl:text>other</xsl:text></xsl:attribute>
            <xsl:attribute name="target"><xsl:value-of select="."/></xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="thumbnailURL[.!='']">
        <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type"><xsl:text>thumbnail</xsl:text></xsl:attribute>
            <xsl:attribute name="target">
                <xsl:choose>
                    <xsl:when test="starts-with(., 'http://digital.slub-dresden.de')">
                        <xsl:variable name="webpage" select="unparsed-text(.)" as="xs:string"/>
                        <xsl:value-of select="concat(substring-before(substring-after($webpage, '&lt;a class=&quot;download-page image&quot; title=&quot;Einzelseite als Bild herunterladen (JPG)&quot; target=&quot;_blank&quot; href=&quot;'), 'original.jpg&quot;'), 'thumbnail.jpg')"/>
                    </xsl:when>
                    <xsl:when test="ends-with(., '.jpg') or ends-with(., '.png')">
                        <xsl:copy-of select="."/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>Bitte eine Thumbnail-Adresse angeben für <xsl:value-of select="preceding-sibling::hsp_object"/></xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="completeness[.!='']">
        <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type"><xsl:text>completeness</xsl:text></xsl:attribute>
            <xsl:attribute name="target"><xsl:value-of select="."/></xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="sourceType[.!='']">
        <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type"><xsl:text>sourceType</xsl:text></xsl:attribute>
            <xsl:attribute name="target"><xsl:value-of select="."/></xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="digitalisationType[.!='']">
        <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type"><xsl:text>digitalisationType</xsl:text></xsl:attribute>
            <xsl:attribute name="target"><xsl:value-of select="."/></xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="captureType[.!='']">
        <xsl:element name="ref" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type"><xsl:text>captureType</xsl:text></xsl:attribute>
            <xsl:attribute name="target"><xsl:value-of select="."/></xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="digitalisationDate[.!='']">
        <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type"><xsl:text>digitized</xsl:text></xsl:attribute>
            <xsl:attribute name="when"><xsl:value-of select="."/></xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="publicationDate[.!='']">
        <xsl:element name="date" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type"><xsl:text>published</xsl:text></xsl:attribute>
            <xsl:attribute name="when"><xsl:value-of select="."/></xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="nameOfHostInstitution[.!='']">
        <xsl:element name="orgName" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select=" 'hostInstitution' "></xsl:attribute>
            <xsl:attribute name="ref" select="."/>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="placeOfHostInstitution[.!='']">
        <xsl:element name="placeName" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select=" 'hostInstitution' "></xsl:attribute>
            <xsl:attribute name="ref" select="."/>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="nameOfDigitalisingInstitution[.!='']">
        <xsl:element name="orgName" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select=" 'digitalisingInstitution' "></xsl:attribute>
            <xsl:attribute name="ref" select="."/>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="placeOfDigitalisingInstitution[.!='']">
        <xsl:element name="placeName" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select=" 'digitalisingInstitution' "></xsl:attribute>
            <xsl:attribute name="ref" select="."/>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>