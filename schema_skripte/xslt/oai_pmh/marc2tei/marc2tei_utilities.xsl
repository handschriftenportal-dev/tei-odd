<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:ckm="http://handschriftenportal.de/ckm"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:h1="http://www.startext.de/HiDA/DefService/XMLSchema"
    xmlns:h2="katneu4-2009-12-richedit-illum-neu.xml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:rtftools="http://www.startext.de/rtftools"
    xmlns:sbbfunc="http://dev.sbb.berlin/sbb"
    xmlns="http://www.openarchives.org/OAI/2.0/"
    xmlns:marcxml="http://www.loc.gov/MARC21/slim"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:mx="info:lc/xmlns/marcxchange-v1"
    xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd"
    extension-element-prefixes="saxon"
    exclude-result-prefixes="#all">
    <xsl:preserve-space elements="text"/>
    <xsl:param name="split_var" select="'§§§'"></xsl:param>
    
    <xsl:template name="check_kods">
        <xsl:param name="signature"/>
        <xsl:variable name="docs" select="collection('../0_Daten/KODs/?select=01*.xml')" />
        <xsl:choose>
            <xsl:when test="$docs/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:idno = $signature or $docs/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:altIdentifier/tei:idno = $signature">
                <xsl:value-of select="true()"/>
                <xsl:message><xsl:text>Signatur gefunden: </xsl:text><xsl:value-of select="$signature"/></xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()"/>
                <xsl:message><xsl:text>Signatur nicht gefunden: </xsl:text><xsl:value-of select="$signature"/></xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="check_fields">
        <xsl:if test="oai:metadata/mx:record/mx:datafield[@tag = '506']">
            <xsl:message><xsl:text>Datafield 506 existed and not used. Could contain information to licence.</xsl:text></xsl:message>
        </xsl:if>
        <xsl:if test="oai:metadata/mx:record/mx:datafield[@tag = '506']">
            <xsl:message><xsl:text>Datafield 506 existed and not used. Could contain information to licence.</xsl:text></xsl:message>
        </xsl:if>
        <xsl:if test="oai:metadata/mx:record/mx:datafield[@tag = '845']/mx:subfield[@code = 'a'] = ''">
            <xsl:message><xsl:text>Datafield 845 does not existed. Licnece is missing.</xsl:text></xsl:message>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="material"> <!-- Kerndatenm Headline: material -->
        <!--    output: "Material Material_type§§§Material Material_type"
                e.g.:   raw_material = "II, 600 S. - Papier, Leineneinband" -> output ="Papier paper§§§Leineneinband linen§§§" -->
        <xsl:param name="value"/>

        <xsl:variable name="material">
            <xsl:for-each select="tokenize($value, ' ')">
                <xsl:choose>
                    <xsl:when test="contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÜÖ', 'abcdefghijklmnopqrstuvwxyzäüö'), 'papier')">
                        <xsl:value-of select="."/>
                        <xsl:text> paper§§§</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÜÖ', 'abcdefghijklmnopqrstuvwxyzäüö'), 'pergament')">
                        <xsl:value-of select="."/>
                        <xsl:text> parchment§§§</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÜÖ', 'abcdefghijklmnopqrstuvwxyzäüö'), 'leine')">
                        <xsl:value-of select="."/>
                        <xsl:text> linen§§§</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÜÖ', 'abcdefghijklmnopqrstuvwxyzäüö'), 'papyrus')">
                        <xsl:value-of select="."/>
                        <xsl:text> papyrus§§§</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÜÖ', 'abcdefghijklmnopqrstuvwxyzäüö'), 'palm')">
                        <xsl:value-of select="."/>
                        <xsl:text> palm§§§</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="substring($material, 0, string-length($material)-2)"/>
    </xsl:template>
    
    <xsl:template name="measure"> <!-- Kerndatenm Headline: measure/Blattangabe -->
        <xsl:param name="value"/>
        <xsl:variable name="measure"/>
            <xsl:choose>
                <xsl:when test="matches($value,'^([IVX+,]+\s?)[0-9]*?\sS\.\s?$' ) or matches($value,'^([IVX+,]+\s?)?[0-9]*?\sBl\.\s?$') or matches($value,'^([IVX+,]+\s?)?[0-9]*?\sBlätter\s?$') or matches($value,'^([IVX+,]+\s?)?[0-9]*?\sBlatt\s?$') or matches($value,'^([IVX+,]+\s?)?[0-9]*?\sSeiten\s?$')">
                    <xsl:value-of select="tokenize(replace($value, '^([IVX+,]+\s?)', '' ), ' ')[1]"/>
                </xsl:when>
                <xsl:when test="matches($value,'^[0-9]*?\sS\.\s?$' ) or matches($value,'^[0-9]*?\sBl\.\s?$') or matches($value,'^[0-9]*?\sBlätter\s?$') or matches($value,'^[0-9]*?\sBlatt\s?$') or matches($value,'^[0-9]*?\sSeiten\s?$')">
                    <xsl:value-of select="tokenize($value, ' ')[1]"/>
                </xsl:when>
            </xsl:choose>
    </xsl:template>
    
    <xsl:template name="dimension"> <!-- Kerndatenm Headline: dimension/Maße -->
        <!-- output:    value§§§norm_height§§§width_norm§§§norm_depth§§§dimensions_typeOfInformation
        wenn keine DAten vorhanden, dann output '' -->
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="matches($value, '^(\d+,?\d*\s?x\s?){1,2}\d+,?\d*\s?cm$')">
                <xsl:variable name="sub_value" select="translate($value, 'cm', '')"/>
                <xsl:variable name="norm_height">
                    <xsl:call-template name="norm_decimal">
                        <xsl:with-param name="value" select="translate(tokenize($sub_value, 'x')[1], ' ', '')"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="norm_width">
                    <xsl:call-template name="norm_decimal">
                        <xsl:with-param name="value" select="translate(tokenize($sub_value, 'x')[2], ' ', '')"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="norm_depth">
                    <xsl:call-template name="norm_decimal">
                        <xsl:with-param name="value" select="translate(tokenize($sub_value, 'x')[3], ' ', '')"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($value, $split_var, $norm_height, $split_var, $norm_width, $split_var, $norm_depth, $split_var, 'factual')"/>
            </xsl:when>
            
            <xsl:when test="matches($value, '^(\d+\s?x\s?){1,2}\d+\s?mm$')">
                <xsl:variable name="sub_value" select="translate($value, 'mm', '')"/>
                <xsl:variable name="norm_height">
                    <xsl:call-template name="norm_decimal">
                        <xsl:with-param name="value" select="translate(format-number(number(translate(tokenize($sub_value, 'x')[1], ' ', '')) div 10, '#.#'), '.', ',')"/>
                    </xsl:call-template> 
                </xsl:variable>
                <xsl:variable name="norm_width">
                    <xsl:call-template name="norm_decimal">
                        <xsl:with-param name="value" select="translate(format-number(number(translate(tokenize($sub_value, 'x')[2], ' ', '')) div 10, '#.#'), '.', ',')"/>
                    </xsl:call-template> 
                </xsl:variable>
                <xsl:variable name="norm_depth">
                    <xsl:call-template name="norm_decimal">
                        <xsl:with-param name="value" select="translate(format-number(number(translate(tokenize($sub_value, 'x')[3], ' ', '')) div 10, '#.#'), '.', ',')"/>
                    </xsl:call-template> 
                </xsl:variable>
                <xsl:value-of select="concat($value, $split_var, $norm_height, $split_var, $norm_width, $split_var, $norm_depth, $split_var, 'factual')"/>
            </xsl:when>
            
            <xsl:when test="matches($value, '^circa\s\d+,?\d*\s?x\s?\d+,?\d*\s?cm und kleiner$')">
                <xsl:variable name="sub_value" select="translate(translate($value, 'cm und kleiner', ''), 'circa ', '')"/>
                <xsl:variable name="norm_height">
                    <xsl:call-template name="norm_decimal">
                        <xsl:with-param name="value" select="translate(tokenize($sub_value, 'x')[1], ' ', '')"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="norm_width">
                    <xsl:call-template name="norm_decimal">
                        <xsl:with-param name="value" select="translate(tokenize($sub_value, 'x')[2], ' ', '')"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="norm_depth"/>
                <xsl:value-of select="concat($value, $split_var, $norm_height, $split_var, $norm_width, $split_var, $norm_depth, $split_var, 'factual')"/>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="norm_decimal"> <!-- Testet die Zahl auf eine mögliche Normierung. Nur erlaubt: ganze Zahl, endet auf ,5. Wird für dimensions verwendet-->
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="matches($value, '^\d+,\d+$')">
                <xsl:choose>
                    <xsl:when test="substring($value, string-length($value)-1) = ',5'">
                        <xsl:value-of select="$value"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="substring($value, string-length($value)-1) = ',0' or substring($value, string-length($value)-1) = ',1' or substring($value, string-length($value)-1) = ',2' or substring($value, string-length($value)-1) = ',3' or substring($value, string-length($value)-1) = ',4'">
                                <!-- ABRUNDEN -->
                                <xsl:value-of select="substring($value, 1, string-length($value)-2)"/>
                            </xsl:when>
                            <xsl:when test="substring($value, string-length($value)-1) = ',6' or substring($value, string-length($value)-1) = ',7' or substring($value, string-length($value)-1) = ',8' or substring($value, string-length($value)-1) = ',9'">
                                <!-- AUFRUNDEN -->
                                <xsl:value-of select="format-number(number(substring($value, 1, string-length($value)-2))+1, '0')"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="format">
        <xsl:param name="norm_value"/>
        <xsl:param name="raw_value"/>
        <xsl:message><xsl:text>NORM_DIMENSION: </xsl:text><xsl:value-of select="$norm_value"/></xsl:message>
        <xsl:choose>
            <xsl:when test="$norm_value = ''">
                <xsl:call-template name="identify_format">
                    <xsl:with-param name="value" select="$raw_value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="calc_format">
                    <xsl:with-param name="value" select="$norm_value"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="calc_format">
        <!-- Berechnet Fomat mit bereits genormten Werten. Das bedeutet, dass die Zahl bereits auf- oder abgerundet wurde, falls das nötig war. -->
        <xsl:param name="value"/>
        <xsl:variable name="height" select="number(translate(tokenize($value, $split_var)[2], ',', '.'))"/>
        <xsl:variable name="width" select="number(translate(tokenize($value, $split_var)[3], ',', '.'))"/>
        
        <xsl:choose>
            <!-- calculate oblongo format -->
            <xsl:when test="$width - 1 &gt;= $height">
                <xsl:choose>
                    <xsl:when test="$height &lt; 13">                       <xsl:value-of select="concat('computed', $split_var, 'smaller than octavo', $split_var, 'oblong')"/></xsl:when>
                    <xsl:when test="$height &gt;= 13 and $height &lt; 15">  <xsl:value-of select="concat('computed', $split_var, 'smaller than octavo', $split_var, 'octavo', $split_var, 'oblong')"/></xsl:when>
                    <xsl:when test="$height &gt;= 15 and $height &lt; 19">  <xsl:value-of select="concat('computed', $split_var, 'octavo', $split_var, 'oblong')"/></xsl:when>
                    <xsl:when test="$height &gt;= 19 and $height &lt;= 21"> <xsl:value-of select="concat('computed', $split_var, 'octavo', $split_var, 'quarto', $split_var, 'oblong')"/></xsl:when>
                    <xsl:when test="$height &gt; 21 and $height &lt; 28">   <xsl:value-of select="concat('computed', $split_var, 'quarto', $split_var, 'oblong')"/></xsl:when>
                    <xsl:when test="$height &gt;= 28 and $height &lt;= 31"> <xsl:value-of select="concat('computed', $split_var, 'quarto', $split_var, 'folio', $split_var, 'oblong')"/></xsl:when>
                    <xsl:when test="$height &gt; 31 and $height &lt;= 50">  <xsl:value-of select="concat('computed', $split_var, 'folio', $split_var, 'oblong')"/></xsl:when>
                    <xsl:when test="$height &gt; 50 and $height &lt;= 51">  <xsl:value-of select="concat('computed', $split_var, 'folio', $split_var, 'larger than folio', $split_var, 'oblong')"/></xsl:when>
                    <xsl:when test="$height &gt; 51">                       <xsl:value-of select="concat('computed', $split_var, 'larger than folio', $split_var, 'oblong')"/></xsl:when>
                </xsl:choose>
            </xsl:when>
            
            <!-- calculate square format -->
            <xsl:when test="$width + 0.5 = $height or $width + 1 = $height or $width - 0.5 = $height or $width - 1 = $height">
                <xsl:choose>
                    <xsl:when test="$height &lt; 13">                       <xsl:value-of select="concat('computed', $split_var, 'smaller than octavo', $split_var, 'oblong')"/></xsl:when>
                    <xsl:when test="$height &gt;= 13 and $height &lt; 15">  <xsl:value-of select="concat('computed', $split_var, 'smaller than octavo', $split_var, 'octavo', $split_var, 'square')"/></xsl:when>
                    <xsl:when test="$height &gt;= 15 and $height &lt; 19">  <xsl:value-of select="concat('computed', $split_var, 'octavo', $split_var, 'square')"/></xsl:when>
                    <xsl:when test="$height &gt;= 19 and $height &lt;= 21"> <xsl:value-of select="concat('computed', $split_var, 'octavo', $split_var, 'quarto', $split_var, 'square')"/></xsl:when>
                    <xsl:when test="$height &gt; 21 and $height &lt; 28">   <xsl:value-of select="concat('computed', $split_var, 'quarto', $split_var, 'square')"/></xsl:when>
                    <xsl:when test="$height &gt;= 28 and $height &lt;= 31"> <xsl:value-of select="concat('computed', $split_var, 'quarto', $split_var, 'folio', $split_var, 'square')"/></xsl:when>
                    <xsl:when test="$height &gt; 31 and $height &lt;= 50">  <xsl:value-of select="concat('computed', $split_var, 'folio', $split_var, 'square')"/></xsl:when>
                    <xsl:when test="$height &gt; 50 and $height &lt;= 51">  <xsl:value-of select="concat('computed', $split_var, 'folio', $split_var, 'larger than folio', $split_var, 'square')"/></xsl:when>
                    <xsl:when test="$height &gt; 51">                       <xsl:value-of select="concat('computed', $split_var, 'larger than folio', $split_var, 'square')"/></xsl:when>
                </xsl:choose>
            </xsl:when>
            
            <!-- calculate long and narrow format -->
            <xsl:when test="$width &lt;= 1.8">
                <xsl:choose>
                    <xsl:when test="$height &lt; 13">                       <xsl:value-of select="concat('computed', $split_var, 'smaller than octavo', $split_var, 'long and narrow')"/></xsl:when>
                    <xsl:when test="$height &gt;= 13 and $height &lt; 15">  <xsl:value-of select="concat('computed', $split_var, 'smaller than octavo', $split_var, 'octavo', $split_var, 'long and narrow')"/></xsl:when>
                    <xsl:when test="$height &gt;= 15 and $height &lt; 19">  <xsl:value-of select="concat('computed', $split_var, 'octavo', $split_var, 'long and narrow')"/></xsl:when>
                    <xsl:when test="$height &gt;= 19 and $height &lt;= 21"> <xsl:value-of select="concat('computed', $split_var, 'octavo', $split_var, 'quarto', $split_var, 'long and narrow')"/></xsl:when>
                    <xsl:when test="$height &gt; 21 and $height &lt; 28">   <xsl:value-of select="concat('computed', $split_var, 'quarto', $split_var, 'long and narrow')"/></xsl:when>
                    <xsl:when test="$height &gt;= 28 and $height &lt;= 31"> <xsl:value-of select="concat('computed', $split_var, 'quarto', $split_var, 'folio', $split_var, 'long and narrow')"/></xsl:when>
                    <xsl:when test="$height &gt; 31 and $height &lt;= 50">  <xsl:value-of select="concat('computed', $split_var, 'folio', $split_var, 'long and narrow')"/></xsl:when>
                    <xsl:when test="$height &gt; 50 and $height &lt;= 51">  <xsl:value-of select="concat('computed', $split_var, 'folio', $split_var, 'larger than folio', $split_var, 'long and narrow')"/></xsl:when>
                    <xsl:when test="$height &gt; 51">                       <xsl:value-of select="concat('computed', $split_var, 'larger than folio', $split_var, 'long and narrow')"/></xsl:when>
                </xsl:choose>
            </xsl:when>
            
            <!-- calculate format -->
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$height &lt; 13">                       <xsl:value-of select="concat('computed', $split_var, 'smaller than octavo')"/></xsl:when>
                    <xsl:when test="$height &gt;= 13 and $height &lt; 15">  <xsl:value-of select="concat('computed', $split_var, 'smaller than octavo', $split_var, 'octavo')"/></xsl:when>
                    <xsl:when test="$height &gt;= 15 and $height &lt; 19">  <xsl:value-of select="concat('computed', $split_var, 'octavo')"/></xsl:when>
                    <xsl:when test="$height &gt;= 19 and $height &lt;= 21"> <xsl:value-of select="concat('computed', $split_var, 'octavo', $split_var, 'quarto')"/></xsl:when>
                    <xsl:when test="$height &gt; 21 and $height &lt; 28">   <xsl:value-of select="concat('computed', $split_var, 'quarto')"/></xsl:when>
                    <xsl:when test="$height &gt;= 28 and $height &lt;= 31"> <xsl:value-of select="concat('computed', $split_var, 'quarto', $split_var, 'folio')"/></xsl:when>
                    <xsl:when test="$height &gt; 31 and $height &lt;= 50">  <xsl:value-of select="concat('computed', $split_var, 'folio')"/></xsl:when>
                    <xsl:when test="$height &gt; 50 and $height &lt;= 51">  <xsl:value-of select="concat('computed', $split_var, 'folio', $split_var, 'larger than folio')"/></xsl:when>
                    <xsl:when test="$height &gt; 51">                       <xsl:value-of select="concat('computed', $split_var, 'larger than folio')"/></xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="identify_format">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="$value = '2' or $value = '2°'">
                <xsl:value-of select="concat('factual', $split_var, 'folio')"/>
            </xsl:when>
            <xsl:when test="$value = '4' or $value = '4°'">
                <xsl:value-of select="concat('factual', $split_var, 'quarto')"/>
            </xsl:when>
            <xsl:when test="$value = '8' or $value = '8°'">
                <xsl:value-of select="concat('factual', $split_var, 'octavo')"/>
            </xsl:when>
            <xsl:when test="contains(translate($value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ', 'abcdefghijklmnopqrstuvwxyzäöü'), 'oblong')">
                <xsl:value-of select="concat('factual', $split_var, 'oblong')"/>
            </xsl:when>
            <xsl:when test="contains(translate($value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ', 'abcdefghijklmnopqrstuvwxyzäöü'), 'folio')">
                <xsl:value-of select="concat('factual', $split_var, 'folio')"/>
            </xsl:when>
            <xsl:when test="contains(translate($value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ', 'abcdefghijklmnopqrstuvwxyzäöü'), 'quart')">
                <xsl:value-of select="concat('factual', $split_var, 'quarto')"/>
            </xsl:when>
            <xsl:when test="contains(translate($value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ', 'abcdefghijklmnopqrstuvwxyzäöü'), 'octav')">
                <xsl:value-of select="concat('factual', $split_var, 'octavo')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="origPlace"> <!-- Kerndaten: ENTSTEHUNGSORT / origPlace -->
        <xsl:param name="value"/>
        <xsl:variable name="place_norm" select="replace(replace(replace(replace($value, '\[S\.l\.\] ', ''), '\[S\.l\.\]', ''), '\[s\.l\.\]', ''), 's\.l\.', '')"/>
        <xsl:choose>
            <xsl:when test="$place_norm = 'Augsburg'">                  <xsl:value-of select="concat($place_norm, $split_var, 'Augsburg', $split_var, 'https://d-nb.info/gnd/4003614-5')"/></xsl:when>
            <xsl:when test="$place_norm = 'Bayern'">                    <xsl:value-of select="concat($place_norm, $split_var, 'Bayern', $split_var, 'https://d-nb.info/gnd/4005044-0')"/></xsl:when>
            <xsl:when test="$place_norm = 'Berlin'">                    <xsl:value-of select="concat($place_norm, $split_var, 'Berlin', $split_var, 'https://d-nb.info/gnd/4005728-8')"/></xsl:when>
            <xsl:when test="$place_norm = 'Deutschsprachiger Raum' or 
                            $place_norm = 'Deutsches Sprachgebiet'">    <xsl:value-of select="concat($place_norm, $split_var, 'Deutsches Sprachgebiet', $split_var, 'https://d-nb.info/gnd/4070370-8')"/></xsl:when>
            <xsl:when test="$place_norm = 'Deutschland'">               <xsl:value-of select="concat($place_norm, $split_var, 'Deutschland', $split_var, 'https://d-nb.info/gnd/4011882-4')"/></xsl:when>
            <xsl:when test="$place_norm = 'Frankreich'">                <xsl:value-of select="concat($place_norm, $split_var, 'Frankreich', $split_var, 'https://d-nb.info/gnd/4018145-5')"/></xsl:when>
            <xsl:when test="$place_norm = 'Italien'">                   <xsl:value-of select="concat($place_norm, $split_var, 'Italien', $split_var, 'https://d-nb.info/gnd/4027833-5')"/></xsl:when>
            <xsl:when test="$place_norm = 'Köln'">                      <xsl:value-of select="concat($place_norm, $split_var, 'Köln', $split_var, 'https://d-nb.info/gnd/4031483-2')"/></xsl:when>
            <xsl:when test="$place_norm = 'München' or 
                            $place_norm = '[München]' or 
                            $place_norm = 'München (?)' or 
                            $place_norm = 'München [u.a.]'">            <xsl:value-of select="concat($place_norm, $split_var, 'München', $split_var, 'https://d-nb.info/gnd/4127793-4')"/></xsl:when>
            <xsl:when test="$place_norm = 'Nürnberg'">                  <xsl:value-of select="concat($place_norm, $split_var, 'Nürnberg', $split_var, 'https://d-nb.info/gnd/4042742-0')"/></xsl:when>
            <xsl:when test="$place_norm = 'Oberitalien'">               <xsl:value-of select="concat($place_norm, $split_var, 'Oberitalien', $split_var, 'https://d-nb.info/gnd/4042547-2')"/></xsl:when>
            <xsl:when test="$place_norm = 'Paris'">                     <xsl:value-of select="concat($place_norm, $split_var, 'Paris', $split_var, 'https://d-nb.info/gnd/4044660-8')"/></xsl:when>
            <xsl:when test="$place_norm = 'Regensburg'">                <xsl:value-of select="concat($place_norm, $split_var, 'Regensburg', $split_var, 'https://d-nb.info/gnd/4048989-9')"/></xsl:when>
            <xsl:when test="$place_norm = 'Siebenbürgen'">              <xsl:value-of select="concat($place_norm, $split_var, 'Siebenbürgen', $split_var, 'https://d-nb.info/gnd/4054835-1')"/></xsl:when>
            <xsl:when test="$place_norm = 'Süddeutschland'">            <xsl:value-of select="concat($place_norm, $split_var, 'Süddeutschland', $split_var, 'https://d-nb.info/gnd/4078022-3')"/></xsl:when>
            <xsl:otherwise>                                             <xsl:value-of select="concat($place_norm, $split_var, $split_var, 'http://d-nb.info/gnd/')"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="origDate"> <!-- Kerndaten: ENTSTEHUNGSJAHR / orig_Date -->
        <!-- return: value§§§notBefore§§§notAfter§§§type -->
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="matches($value, '^\d{1,4}$')"> <!-- Bsp: '1812', '988' - wenn value eine Zahl mit 1-4 Nummern ist -->
                <xsl:variable name="notBefore" select="substring(concat('000', $value), string-length(concat('000', $value))-3, 4)"/>
                <xsl:value-of select="concat($value, $split_var, $notBefore, $split_var, $notBefore, $split_var)"/>
            </xsl:when>
            <xsl:when test="matches($value, '^\d{1,2}\.\sJh\.?$')"> <!-- Bsp: '16. Jh.', '9. Jh.' - wenn value ein ganzes Jahhundert beschreibt -->
                <xsl:variable name="jahrhundert" select="replace(replace($value, ' Jh', ''), '\.', '')"/>
                <xsl:variable name="begin" select="concat('00', format-number(number($jahrhundert)-1, '0'), '01')"/>
                <xsl:variable name="end" select="concat('00', $jahrhundert, '00')"/>
                <xsl:value-of select="concat($value, $split_var, substring($begin, string-length($begin)-3, 4), $split_var, substring($end, string-length($end)-3, 4), $split_var)"/>
            </xsl:when>
            <xsl:when test="matches($value, '^\d{1,2}\.\sJahrhundert\.?$')"> <!-- Bsp: '16. Jahrhundert' - wenn value ein ganzes Jahhundert beschreibt -->
                <xsl:variable name="jahrhundert" select="replace(replace($value, ' Jahrhundert', ''), '\.', '')"/>
                <xsl:variable name="begin" select="concat('00', format-number(number($jahrhundert)-1, '0'), '01')"/>
                <xsl:variable name="end" select="concat('00', $jahrhundert, '00')"/>
                <xsl:value-of select="concat($value, $split_var, substring($begin, string-length($begin)-3, 4), $split_var, substring($end, string-length($end)-3, 4), $split_var)"/>
            </xsl:when>
            <xsl:when test="matches($value, '^\d{1,2}\.?/\d{1,2}\.?\sJh\.?')"> <!-- Bsp: '17./18. Jh' -->
                <xsl:variable name="begin" select="concat('00', format-number(number(concat(tokenize(replace(replace($value, ' Jh', ''), '\.', ''), '/')[1], '01'))-10, '0'))"/>
                <xsl:variable name="notBefore" select="substring($begin, string-length($begin)-3, 4)"/>
                <xsl:variable name="end" select="concat('00', format-number(number(concat(tokenize(replace(replace($value, ' Jh', ''), '\.', ''), '/')[2], '00'))-90, '0'))"/>
                <xsl:variable name="notAfter" select="substring($end, string-length($end)-3, 4)"/>
                <xsl:value-of select="concat($value, $split_var, $notBefore, $split_var, $notAfter, $split_var)"/>
            </xsl:when>
            <xsl:when test="matches($value, '^Zwischen\s\d{3,4}\sund\s\d{3,4}$')"> <!-- 'Zwischen xxxx und xxxx' -->
                <xsl:variable name="begin" select="concat('00', tokenize(replace($value, 'Zwischen', ''), ' und ')[1])"/>
                <xsl:variable name="notBefore" select="substring($begin, string-length($begin)-3, 4)"/>
                <xsl:variable name="end" select="concat('00', tokenize(replace($value, 'Zwischen', ''), ' und ')[2])"/>
                <xsl:variable name="notAfter" select="substring($end, string-length($end)-3, 4)"/>
                <xsl:value-of select="concat($value, $split_var, $notBefore, $split_var, $notAfter, $split_var)"/>
            </xsl:when>
            <xsl:when test="matches($value, '^\d{3,4}\s?-\s?\d{3,4}$')"> <!-- Bsp: '1267 - 1309', '1034-1564' -->
                <xsl:variable name="begin" select="concat('00', tokenize(replace($value, '\s', ''), '-')[1])"/>
                <xsl:variable name="notBefore" select="substring($begin, string-length($begin)-3, 4)"/>
                <xsl:variable name="end" select="concat('00', tokenize(replace($value, '\s', ''), '-')[2])"/>
                <xsl:variable name="notAfter" select="substring($end, string-length($end)-3, 4)"/>
                <xsl:value-of select="concat($value, $split_var, $notBefore, $split_var, $notAfter, $split_var)"/>
            </xsl:when>
            <xsl:when test="matches($value, '^nach\s\d{3,4}$')"> <!-- Bsp: 'nach 800', 'nach 1700', ... -->
                <xsl:variable name="begin" select="concat('00', format-number(number(replace($value, 'nach ', ''))+1, '0'))"/>
                <xsl:variable name="notBefore" select="substring($begin, string-length($begin)-3, 4)"/>
                <xsl:variable name="end" select="concat('00', format-number(number(replace($value, 'nach ', ''))+15, '0'))"/>
                <xsl:variable name="notAfter" select="substring($end, string-length($end)-3, 4)"/>
                <xsl:value-of select="concat($value, $split_var, $notBefore, $split_var, $notAfter, $split_var)"/>
            </xsl:when>
            <xsl:when test="matches($value, '^vor\s\d{3,4}$')"> <!-- Bsp: 'vor 800', 'vor 1600', ... -->
                <xsl:variable name="begin" select="concat('00', format-number(number(replace($value, 'vor ', ''))-14, '0'))"/>
                <xsl:variable name="notBefore" select="substring($begin, string-length($begin)-3, 4)"/>
                <xsl:variable name="end" select="concat('00', format-number(number(replace($value, 'vor ', ''))-1, '0'))"/>
                <xsl:variable name="notAfter" select="substring($end, string-length($end)-3, 4)"/>
                <xsl:value-of select="concat($value, $split_var, $notBefore, $split_var, $notAfter, $split_var)"/>
            </xsl:when>
            <xsl:when test="matches($value, '^um\s\d{3,4}$') or matches($value, '^Um\s\d{3,4}$') or matches($value, '^ca.\s\d{3,4}$') or matches($value, '^Ca.\s\d{3,4}$')"> <!-- Bsp: 'Ca. 800', 'um 1523' -->
                <xsl:variable name="year" select="tokenize($value, '\s')[2]"/>
                <xsl:variable name="begin" select="concat('00', number($year)-14)"/>
                <xsl:variable name="notBefore" select="substring($begin, string-length($begin)-3, 4)"/>
                <xsl:variable name="end" select="concat('00', number($year)+15)"/>
                <xsl:variable name="notAfter" select="substring($end, string-length($end)-3, 4)"/>
                <xsl:value-of select="concat($value, $split_var, $notBefore, $split_var, $notAfter, $split_var)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($value, $split_var, $split_var, $split_var)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="norm_Lang"> <!-- Kerndaten: SPRACHE / textLang -->
        <!-- return: language§§§gnd-id§§§NORM -->
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="$value = 'ara'">    <xsl:value-of select="concat('arabisch',        $split_var, 'http://d-nb.info/gnd/4241223-7', $split_var, 'NORM-c582dec9-43ff-3b74-baa0-691df291cea6')"/></xsl:when>
            <xsl:when test="$value = 'arc'">    <xsl:value-of select="concat('aramäisch',       $split_var, 'http://d-nb.info/gnd/4085880-7', $split_var, 'NORM-909ba4ad-2bda-36b1-8aac-3c5b7f01abd5')"/></xsl:when>
            <xsl:when test="$value = 'arm'">    <xsl:value-of select="concat('armenisch',       $split_var, 'http://d-nb.info/gnd/4120142-5', $split_var, 'NORM-f926b3e2-22d7-3fee-9707-1b2256839701')"/></xsl:when> 
            <xsl:when test="$value = 'bre'">    <xsl:value-of select="concat('bretonisch',      $split_var, 'http://d-nb.info/gnd/4120162-0', $split_var, 'NORM-0cd00ec1-4f1d-35d4-9937-5d6a37d183a6')"/></xsl:when> 
            <xsl:when test="$value = 'bul'">    <xsl:value-of select="concat('bulgarisch',      $split_var, 'http://d-nb.info/gnd/4120165-6', $split_var, 'NORM-5523c88d-d347-31b7-8c61-7f632b7efdb7')"/></xsl:when>
            <xsl:when test="$value = 'cat'">    <xsl:value-of select="concat('katalanisch',     $split_var, 'http://d-nb.info/gnd/4120218-1', $split_var, 'NORM-5435c69e-d3bc-35b2-a4d5-80e393e373d3')"/></xsl:when>
            <xsl:when test="$value = 'ces'">    <xsl:value-of select="concat('tschechisch',     $split_var, 'http://d-nb.info/gnd/4061084-6', $split_var, 'NORM-95cc64dd-2825-39df-93ec-4ad683ecf339')"/></xsl:when>
            <xsl:when test="$value = 'chu'">    <xsl:value-of select="concat('kirchenslawisch', $split_var, 'http://d-nb.info/gnd/4132167-4', $split_var, 'NORM-a4dbfd6a-ef3b-3045-be61-aa0146debdf8')"/></xsl:when>
            <xsl:when test="$value = 'dan'">    <xsl:value-of select="concat('dänisch',         $split_var, 'http://d-nb.info/gnd/4113262-2', $split_var, 'NORM-5ca2aa84-5c8c-35ac-a6b0-16841f100d82')"/></xsl:when>
            <xsl:when test="$value = 'dut'">    <xsl:value-of select="concat('niederländisch',  $split_var, 'http://d-nb.info/gnd/4122614-8', $split_var, 'NORM-1a13105b-7e4e-35fb-ae7c-9515ac06aa48')"/></xsl:when>
            <xsl:when test="$value = 'ell'">    <xsl:value-of select="concat('neugriechisch',   $split_var, 'http://d-nb.info/gnd/4120278-8', $split_var, 'NORM-65c10911-d8b8-3912-99a2-1ebacf46da01')"/></xsl:when>
            <xsl:when test="$value = 'eng'">    <xsl:value-of select="concat('englisch',        $split_var, 'http://d-nb.info/gnd/4014777-0', $split_var, 'NORM-9cfefed8-fb94-37ba-a5cd-519d7d2bb5d7')"/></xsl:when>
            <xsl:when test="$value = 'fre' or 
                            $value = 'fra'">    <xsl:value-of select="concat('französisch',     $split_var, 'http://d-nb.info/gnd/4113615-9', $split_var, 'NORM-82a9e4d2-6595-387a-b6e4-42391d8c5bba')"/></xsl:when>
            <xsl:when test="$value = 'fry'">    <xsl:value-of select="concat('friesisch',       $split_var, 'http://d-nb.info/gnd/4120183-8', $split_var, 'NORM-3abf3fc2-c744-3732-9898-901330b4ceb1')"/></xsl:when>
            <xsl:when test="$value = 'geo'">    <xsl:value-of select="concat('georgisch',       $split_var, 'http://d-nb.info/gnd/4124679-2', $split_var, 'NORM-ecc174e3-e02c-32f3-8c14-fe860bf47ef2')"/></xsl:when>
            <xsl:when test="$value = 'ger' or 
                            $value = 'gmh' or 
                            $value = 'deu'">    <xsl:value-of select="concat('deutsch',         $split_var, 'http://d-nb.info/gnd/4113292-0', $split_var, 'NORM-5f02f088-9301-3d7b-a1ac-972c11bf3e7d')"/></xsl:when>
            <xsl:when test="$value = 'gle'">    <xsl:value-of select="concat('irisch',          $split_var, 'http://d-nb.info/gnd/4120207-7', $split_var, 'NORM-6044f05a-a3cc-3bb9-b13c-6a26b30036b6')"/></xsl:when>
            <xsl:when test="$value = 'grc'">    <xsl:value-of select="concat('griechisch',      $split_var, 'http://d-nb.info/gnd/4113791-7', $split_var, 'NORM-124c5435-5f39-3f0d-9b0f-653d105340b3')"/></xsl:when>
            <xsl:when test="$value = 'gre' or 
                            $value = 'ell'">    <xsl:value-of select="concat('neugriechisch',   $split_var, 'http://d-nb.info/gnd/4120278-8', $split_var, 'NORM-65c10911-d8b8-3912-99a2-1ebacf46da01')"/></xsl:when>
            <xsl:when test="$value = 'heb'">    <xsl:value-of select="concat('hebräisch',       $split_var, 'http://d-nb.info/gnd/4023922-6', $split_var, 'NORM-6f96cfdf-e5cc-3627-8adf-24b41725caa4')"/></xsl:when>
            <xsl:when test="$value = 'hrv'">    <xsl:value-of select="concat('kroatisch',       $split_var, 'http://d-nb.info/gnd/4033245-7', $split_var, 'NORM-12f367df-b34d-38dd-820d-530e29b6c89c')"/></xsl:when>
            <xsl:when test="$value = 'hun'">    <xsl:value-of select="concat('ungarisch',       $split_var, 'http://d-nb.info/gnd/4120374-4', $split_var, 'NORM-18bd9197-cb1d-333b-8352-f47535c00320')"/></xsl:when>
            <xsl:when test="$value = 'inc'">    <xsl:value-of select="concat('indisch',         $split_var, 'http://d-nb.info/gnd/4133531-4', $split_var, 'NORM-cf9f3fde-7326-31d8-a642-05f0e07a3695')"/></xsl:when>
            <xsl:when test="$value = 'isl' or 
                            $value = 'ice'">    <xsl:value-of select="concat('isländisch',      $split_var, 'http://d-nb.info/gnd/4120209-0', $split_var, 'NORM-a2a551a6-458a-3de2-a446-cc76d639a9e9')"/></xsl:when>
            <xsl:when test="$value = 'ita'">    <xsl:value-of select="concat('italienisch',     $split_var, 'http://d-nb.info/gnd/4114056-4', $split_var, 'NORM-0d149b90-e739-3297-b01c-90191ae775f0')"/></xsl:when>
            <xsl:when test="$value = 'jav'">    <xsl:value-of select="concat('javanisch',       $split_var, 'http://d-nb.info/gnd/4120210-7', $split_var, 'NORM-2181d277-b2d0-3e83-a999-12fd8b56f061')"/></xsl:when>
            <xsl:when test="$value = 'lat'">    <xsl:value-of select="concat('lateinisch',      $split_var, 'http://d-nb.info/gnd/4114364-4', $split_var, 'NORM-c9089f3c-9ada-3018-af6f-fb1ee8d6501c')"/></xsl:when>
            <xsl:when test="$value = 'mad'">    <xsl:value-of select="concat('maduresisch',     $split_var, 'http://d-nb.info/gnd/4458737-5', $split_var, 'NORM-7538ebc3-7ad0-3178-93e0-44b9b42bd8a4')"/></xsl:when>
            <xsl:when test="$value = 'may'">    <xsl:value-of select="concat('malaiisch',       $split_var, 'http://d-nb.info/gnd/4037194-3', $split_var, 'NORM-9a4b6f88-4971-3cb4-a517-2876b335baab')"/></xsl:when>
            <xsl:when test="$value = 'mnc'">    <xsl:value-of select="concat('mandschurisch',   $split_var, 'http://d-nb.info/gnd/4119929-7', $split_var, 'NORM-06b53047-cf29-3f72-8778-9ff5293ad2dc')"/></xsl:when>
            <xsl:when test="$value = 'myn'">    <xsl:value-of select="concat('maya-sprache',    $split_var, 'http://d-nb.info/gnd/4220899-3', $split_var, 'NORM-3070910e-4d32-3805-abcc-9a4c93566a71')"/></xsl:when>
            <xsl:when test="$value = 'mon'">    <xsl:value-of select="concat('mongolisch',      $split_var, 'http://d-nb.info/gnd/4114622-0', $split_var, 'NORM-197639b2-7805-3c51-9189-add5413712e3')"/></xsl:when>
            <xsl:when test="$value = 'oci'">    <xsl:value-of select="concat('okzitanisch',     $split_var, 'http://d-nb.info/gnd/4043439-4', $split_var, 'NORM-b4f90e11-4cba-38d8-8884-0ea9a0325a31')"/></xsl:when>
            <xsl:when test="$value = 'per'">    <xsl:value-of select="concat('persisch',        $split_var, 'http://d-nb.info/gnd/4065403-5', $split_var, 'NORM-fe3838c7-c11a-3406-9d95-6566e17360d5')"/></xsl:when>
            <xsl:when test="$value = 'pol'">    <xsl:value-of select="concat('polnisch',        $split_var, 'http://d-nb.info/gnd/4120314-8', $split_var, 'NORM-28840420-4e3d-3522-a930-8317344a285d')"/></xsl:when>
            <xsl:when test="$value = 'por'">    <xsl:value-of select="concat('portugiesisch',   $split_var, 'http://d-nb.info/gnd/4120316-1', $split_var, 'NORM-fc9fdf08-4e29-3f26-a270-390dc49061a2')"/></xsl:when>
            <xsl:when test="$value = 'que'">    <xsl:value-of select="concat('quechua',         $split_var, 'http://d-nb.info/gnd/4133214-3', $split_var, 'NORM-8cfbcfcd-27c8-3a9c-a364-8bb0386c654b')"/></xsl:when>
            <xsl:when test="$value = 'rus'">    <xsl:value-of select="concat('russisch',        $split_var, 'http://d-nb.info/gnd/4051038-4', $split_var, 'NORM-89484b14-b36a-3d53-a942-6a3d944d2983')"/></xsl:when>
            <xsl:when test="$value = 'sem'">    <xsl:value-of select="concat('äthiopisch',      $split_var, 'http://d-nb.info/gnd/4133282-9', $split_var, 'NORM-bd9a2916-f0e0-34a9-b61a-98a97b8db5dc')"/></xsl:when>
            <xsl:when test="$value = 'sin'">    <xsl:value-of select="concat('singhalesisch',   $split_var, 'http://d-nb.info/gnd/4107780-5', $split_var, 'NORM-ac5585d9-8646-3255-a99c-359140537783')"/></xsl:when>
            <xsl:when test="$value = 'sla'">    <xsl:value-of select="concat('slawisch',        $split_var, 'http://d-nb.info/gnd/4120036-6', $split_var, 'NORM-e3e48b96-d966-3ee1-b5cc-cdbc9d6f6d43')"/></xsl:when>
            <xsl:when test="$value = 'slv'">    <xsl:value-of select="concat('slowenisch',      $split_var, 'http://d-nb.info/gnd/4120336-7', $split_var, 'NORM-06a9ad3b-b612-3f43-8d91-f827a3ac1f90')"/></xsl:when>
            <xsl:when test="$value = 'spa'">    <xsl:value-of select="concat('spanisch',        $split_var, 'http://d-nb.info/gnd/4077640-2', $split_var, 'NORM-12470fe4-06d4-3017-996e-ab37dd65fc14')"/></xsl:when>
            <xsl:when test="$value = 'srp'">    <xsl:value-of select="concat('serbisch',        $split_var, 'http://d-nb.info/gnd/4133301-9', $split_var, 'NORM-62a165d5-9f8d-3f42-a2df-5f3c5aed8a2f')"/></xsl:when>
            <xsl:when test="$value = 'swe'">    <xsl:value-of select="concat('schwedisch',      $split_var, 'http://d-nb.info/gnd/4116437-4', $split_var, 'NORM-74354112-1c12-3113-af80-7d1582c74bea')"/></xsl:when>
            <xsl:when test="$value = 'syc'">    <xsl:value-of select="concat('syrisch',         $split_var, 'http://d-nb.info/gnd/4120349-5', $split_var, 'NORM-3b9379ae-655d-3268-83d1-44b64d005a62')"/></xsl:when>
            <xsl:when test="$value = 'tam'">    <xsl:value-of select="concat('tamil',           $split_var, 'http://d-nb.info/gnd/4120353-7', $split_var, 'NORM-fec8f2a3-f2e8-38cc-b17c-4d278b4fa469')"/></xsl:when>
            <xsl:when test="$value = 'tgl'">    <xsl:value-of select="concat('tagalog',         $split_var, 'http://d-nb.info/gnd/4120352-5', $split_var, 'NORM-72525cfd-a9e3-3ac4-b024-cabe7c6d45e3')"/></xsl:when>
            <xsl:when test="$value = 'tib'">    <xsl:value-of select="concat('tibetisch',       $split_var, 'http://d-nb.info/gnd/4117212-7', $split_var, 'NORM-060b5f3c-5859-31e1-96e9-323ff6eeb143')"/></xsl:when>
            <xsl:when test="$value = 'tur'">    <xsl:value-of select="concat('türkisch',        $split_var, 'http://d-nb.info/gnd/4120079-2', $split_var, 'NORM-e7d707a2-6e7f-3b6f-b52c-489c60e429b1')"/></xsl:when>
            <xsl:when test="$value = 'tut'">    <xsl:value-of select="concat('Altaische Sprachen', $split_var, 'http://d-nb.info/gnd/4120111-5', $split_var, 'NORM-77d8c068-b77e-3abd-a2ba-3f873706079c')"/></xsl:when>
            <xsl:when test="$value = 'ukr'">    <xsl:value-of select="concat('ukrainisch',      $split_var, 'http://d-nb.info/gnd/4120373-2', $split_var, 'NORM-6eecdc76-2106-38f3-9f52-e510dd061c29')"/></xsl:when>
            <xsl:when test="$value = 'wen'">    <xsl:value-of select="concat('sorbisch',        $split_var, 'http://d-nb.info/gnd/4116533-0', $split_var, 'NORM-a95a0b39-186f-387b-949f-87f20b44bdb5')"/></xsl:when>
            <xsl:when test="$value = 'yid'">    <xsl:value-of select="concat('jiddisch',        $split_var, 'http://d-nb.info/gnd/4028614-9', $split_var, 'NORM-9e355490-ae25-39e3-921d-a9eaa2826228')"/></xsl:when>
            <xsl:when test="$value = 'zho'">    <xsl:value-of select="concat('chinesisch',      $split_var, 'http://d-nb.info/gnd/4113214-2', $split_var, 'NORM-3ab67158-8c22-3448-9378-a52b9b542d31')"/></xsl:when>
            
            <!--    zxx = No linguistic content,
                    und = Undetermined,
                    mul = Multiple languages  -->
            <xsl:when test="$value = 'zxx' or   
                            $value = 'und' or 
                            $value = 'mul'">    <xsl:value-of select="concat('', $split_var, '', $split_var, '')"/></xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="norm_settlement">
        <!-- result: Ort§§§gnd-Ort§§§NORM-Ort§§§Einrichtung§§§gnd-Einrichtung§§§NORM-Einrichtung -->
        <xsl:param name="value"/>
        <xsl:variable name="ort">
            <xsl:choose>
                <xsl:when test="tokenize($value, ', ')[1] = 'München'">  <xsl:value-of select="concat('München', $split_var, 'https://d-nb.info/gnd/4127793-4', $split_var, 'NORM-d0a6343a-081a-3335-baa9-65ce4fd0845c')"/></xsl:when>
                <xsl:when test="tokenize($value, ', ')[1] = 'Berlin'">   <xsl:value-of select="concat('Berlin',  $split_var, 'https://d-nb.info/gnd/4005728-8', $split_var, 'NORM-ee1611b6-1f56-38e7-8c12-b40684dbb395')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="concat(tokenize($value, ', ')[1], $split_var, $split_var)"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="einrichtung">
            <xsl:choose>
                <xsl:when test="tokenize($value, ', ')[2] = 'Bayerische Staatsbibliothek'">  <xsl:value-of select="concat('Bayerische Staatsbibliothek', $split_var, 'https://d-nb.info/gnd/2031351-2', $split_var, 'NORM-83c5a34d-300e-3b8d-af1e-2d5582778963')"/></xsl:when>
                <xsl:when test="tokenize($value, ', ')[2] = 'Staatsbibliothek zu Berlin'">   <xsl:value-of select="concat('Staatsbibliothek zu Berlin',  $split_var, 'https://d-nb.info/gnd/5036103-X'), $split_var, 'NORM-774909e2-f687-30cb-a5c4-ddc95806d6be'"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="concat(tokenize($value, ', ')[2], $split_var, $split_var)"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat($ort, $split_var, $einrichtung)"/>
    </xsl:template>

</xsl:stylesheet>
