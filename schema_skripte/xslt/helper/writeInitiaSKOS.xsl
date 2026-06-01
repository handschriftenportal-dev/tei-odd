<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:tei="https://www.tei-c.org/ns/1.0"
    xmlns:uuid="http://www.uuid.org"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:output method="text" indent="no" encoding="UTF-8"/>
    <xsl:variable name="crlf" select=" '&#xA0;' "/>
    
    <xsl:template match="/">
        <xsl:text>@prefix rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt; .
@prefix xsd: &lt;http://www.w3.org/2001/XMLSchema#&gt; .
@prefix skos: &lt;http://www.w3.org/2004/02/skos/core#&gt; .
@prefix owl: &lt;http://www.w3.org/2002/07/owl#&gt; .
@prefix rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt; .
@prefix dct: &lt;http://purl.org/dc/terms/&gt; .
@prefix hspv: &lt;https://normdaten.staatsbibliothek-berlin.de/vocabulary/hspv/&gt; .
@prefix hspo: &lt;https://normdaten.staatsbibliothek-berlin.de/ontology/hspo/&gt; .

# Datatypes, used to type different kinds of notations 
hspo:MXMLID a rdfs:Datatype ;
	rdfs:comment "ID from the MXML-Data" .
hspo:HspID a rdfs:Datatype ;
	rdfs:comment "UUID used as ID in the Handschriftenportal Authority Data Module" .

hspv:INIT a skos:ConceptScheme ;
	skos:prefLabel "Textinitien"@de , "text initia"@en ;
	skos:definition "Normalisierte Textinitien im Handschriftenportal"@de .

</xsl:text>
        <xsl:for-each select="item">
            <xsl:call-template name="writeInitium">
                <xsl:with-param name="value" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    
    <xsl:template name="writeInitium">
        <xsl:param name="value"/>
        <xsl:param name="replace">&apos;</xsl:param>
        <xsl:param name="by">^</xsl:param>
        
        <xsl:variable name="removeStar"                 select="replace($value,                 '^\*\s*',       '',         'i;j')"/>
        <xsl:variable name="removeRubricBracket"        select="replace($removeStar,            '[&lt;&gt;]',   '',         'i;j')"/>
        <xsl:variable name="normalizeElipsis"           select="replace($removeRubricBracket,   '\.\s*\.\s*\.', '&#x2026;', 'i;j')"/>
        <xsl:variable name="removeTrailingElipsis"      select="replace($normalizeElipsis,      '&#x2026;\s*$', '',         'i;j')"/>
        <xsl:variable name="normalizeBibleCitation1"    select="replace($removeTrailingElipsis, '([\p{L}\p{P}\s]+) [\-&#x2013;&#x2014;&#x2026;] [\(\[]([\p{L}\d,\-&#x2013;&#x2014;]+)[\)\]][,\. ]+', '$1 &#x2013; ($2). ', 'i;j')"/>
        
        <xsl:variable name="normalizeWhitespace"        select="normalize-space($normalizeBibleCitation1)"/>
        <xsl:variable name="uuid" select=" 'uuid' "/>

        <xsl:value-of select="concat(
            'hspv:INIT-',$uuid,' a skos:Concept ;',
            $crlf,'skos:notation &quot;INIT-',$uuid,'&quot;;',
            $crlf,'skos:prefLabel &quot;',$normalizeWhitespace,'&quot; ;',
            $crlf,'skos:altLabel &quot;',$value,'&quot; ;',
            $crlf,'dct:language &quot;NORM-c9089f3c-9ada-3018-af6f-fb1ee8d6501c&quot; ;',
            $crlf,'skos:inScheme hspv:INIT ;',
            $crlf, $crlf
            )" disable-output-escaping="yes"/>
        <!--
	skos:notation "MXML-12345"^^hspo:MXMLID ;
	dct:language "NORM-5f02f088-9301-3d7b-a1ac-972c11bf3e7d" ;
	skos:closeMatch hspv:INIT-UUIDabcde ;
	skos:exactMatch hspv:INIT-UUIDfghijk ;
	   -->
    </xsl:template>
    
    
</xsl:stylesheet>