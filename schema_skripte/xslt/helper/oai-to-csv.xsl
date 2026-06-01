<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:mx="info:lc/xmlns/marcxchange-v1"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="mx oai xs math"
    version="3.0">

    <xsl:param name="crlf" select=" '&#x0A;' "/>
    <xsl:variable name="collection" select="collection('file:///C:/Users/schassan/Downloads/B3Kat?select=*.xml;recursive=yes')"/>
    <xsl:output method="text" encoding="UTF-8"/>

    <!-- Das Ergebis soll so aussehen:
        "836"$
        "Cod.icon. 311"$
        "https://api.digitale-sammlungen.de/iiif/presentation/v2/bsb00001650/manifest"$
        "https://mdz-nbn-resolving.de/urn:nbn:de:bvb:12-bsb00001650-7"$
        "https://api.digitale-sammlungen.de/iiif/image/v2/bsb00001650_00003/full/280,/0/default.jpg"$
        "Komplett"$
        "Original"$
        "Standard"$
        "Einzelseite"$
        ""$
        ""$
        "Bayerische Staatsbibliothek"$"https://d-nb.info/gnd/2031351-2"$
        "München"$"https://d-nb.info/gnd/4127793-4"$
        "Bayerische Staatsbibliothek"$"https://d-nb.info/gnd/2031351-2"$
        "München"$"https://d-nb.info/gnd/4127793-4"
    -->

    <xsl:template match="/">
        <xsl:apply-templates select="$collection//mx:datafield[@tag='776']">
            <xsl:sort>
                <xsl:choose>
                    <xsl:when test="contains(following-sibling::mx:datafield[@tag='955']/mx:subfield[@code='a'], '#Mikroform')">
                        <xsl:value-of select="substring-before(following-sibling::mx:datafield[@tag='955']/mx:subfield[@code='a'], '#Mikroform')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="following-sibling::mx:datafield[@tag='955']/mx:subfield[@code='a']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:sort>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="mx:datafield[@tag='776']">
        <xsl:param name="id" select="mx:subfield[@code='o']/substring-before(substring-after(., 'urn:nbn:de:bvb:12-'), '-')"/>
        <xsl:text>&quot;</xsl:text>
        <xsl:value-of select="position()"/>
        <xsl:text>&quot;$&quot;</xsl:text>
        <!-- Signatur -->
        <xsl:choose>
            <xsl:when test="contains(following-sibling::mx:datafield[@tag='955']/mx:subfield[@code='a'], '#Mikroform')">
                <xsl:value-of select="substring-before(following-sibling::mx:datafield[@tag='955']/mx:subfield[@code='a'], '#Mikroform')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="following-sibling::mx:datafield[@tag='955']/mx:subfield[@code='a']"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&quot;$&quot;</xsl:text>
        <!-- ManifestURL -->
        <xsl:value-of select="concat('https://api.digitale-sammlungen.de/iiif/presentation/v2/', $id, '/manifest')"/>
        <xsl:text>&quot;$&quot;</xsl:text>
        <!-- andere URL -->
        <xsl:value-of select="mx:subfield[@code='o']/concat('https://mdz-nbn-resolving.de/', .)"/>
        <xsl:text>&quot;$&quot;</xsl:text>
        <!-- Thumbnail -->
        <xsl:value-of select="following-sibling::mx:datafield[@tag='982']/mx:subfield[@code='t'][contains(., $id)]"/>
        <!-- Vollständigkeit -->
        <xsl:text>&quot;$&quot;</xsl:text>
        <xsl:text>Komplett</xsl:text>
        <!-- Gegenstand -->
        <xsl:text>&quot;$&quot;</xsl:text>
        <xsl:choose>
            <xsl:when test="contains(following-sibling::mx:datafield[@tag='955']/mx:subfield[@code='a'], '#Mikroform')">
                <xsl:text>Reproduktion</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Original</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <!-- Aufnahmetechnik -->
        <xsl:text>&quot;$&quot;</xsl:text>
        <xsl:choose>
            <xsl:when test="contains(following-sibling::mx:datafield[@tag='955']/mx:subfield[@code='a'], '#Mikroform')">
                <xsl:text>Graustufen</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Standard</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <!-- Aufnahmeart -->
        <xsl:text>&quot;$&quot;</xsl:text>
        <xsl:text>Einzelseite</xsl:text>
        <!-- AufnahmeDatum -->
        <xsl:text>&quot;$&quot;</xsl:text>
        <xsl:value-of select="tokenize(mx:subfield[@code='d'], ' ')[last()]"/>
        <!-- PublikationsDatum -->
        <xsl:text>&quot;$&quot;</xsl:text>
        <xsl:value-of select="substring(following-sibling::mx:datafield[@tag='982'][mx:subfield[@code='t'][contains(., $id)]]/mx:subfield[@code='d'], 1, 4)"/>
        <xsl:text>&quot;$&quot;</xsl:text>
        <!-- besitzende Einrichtung -->
        <xsl:text>Bayerische Staatsbibliothek</xsl:text>
        <xsl:text>&quot;$&quot;</xsl:text>
        <xsl:text>https://d-nb.info/gnd/2031351-2</xsl:text>
        <xsl:text>&quot;$&quot;</xsl:text>
        <xsl:text>München</xsl:text>
        <xsl:text>&quot;$&quot;</xsl:text>
        <xsl:text>https://d-nb.info/gnd/4127793-4</xsl:text>
        <xsl:text>&quot;$&quot;</xsl:text>
        <!-- digitalisierende Einrichtung -->
        <xsl:text>Bayerische Staatsbibliothek</xsl:text>
        <xsl:text>&quot;$&quot;</xsl:text>
        <xsl:text>https://d-nb.info/gnd/2031351-2</xsl:text>
        <xsl:text>&quot;$&quot;</xsl:text>
        <xsl:text>München</xsl:text>
        <xsl:text>&quot;$&quot;</xsl:text>
        <xsl:text>https://d-nb.info/gnd/4127793-4</xsl:text>
        <xsl:text>&quot;</xsl:text>
        <xsl:value-of select="$crlf"/>
    </xsl:template>

</xsl:stylesheet>
