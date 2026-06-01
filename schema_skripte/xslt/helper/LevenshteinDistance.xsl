<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:my="http://www.jenitennison.com/xslt"
	xmlns:test="http://www.jenitennison.com/xslt/unit-test"
	exclude-result-prefixes="xs my test">

<xsl:param name="length" as="xs:integer" select="5" />

<xsl:output method="text" />

<xsl:template match="/" name="main">
	<xsl:variable name="string" as="xs:string" select="unparsed-text('')" />
	<xsl:variable name="s1" select="substring($string, 1, $length)" />
	<xsl:variable name="s2" select="substring($string, 5, $length)" />
	<xsl:call-template name="my:LevenshteinDistanceB">
		<xsl:with-param name="string1" select="$s1" />
		<xsl:with-param name="string2" select="$s2" />
	</xsl:call-template>
	<!--
	<xsl:sequence 
		select="my:LevenshteinDistanceB($s1, $s2)" />
	-->
</xsl:template>
	
<xsl:function name="my:LevenshteinDistanceA" as="xs:integer">
	<xsl:param name="string1" as="xs:string" />
	<xsl:param name="string2" as="xs:string" />
	<xsl:sequence select="my:LevenshteinDistanceA(string-to-codepoints($string1),
		                                            string-to-codepoints($string2),
		                                            string-length($string1),
		                                            string-length($string2))" />
</xsl:function>

<test:tests>
	<test:title>Function implementation (B)</test:title>
	<test:test>
		<test:title>Empty strings</test:title>
		<test:param name="string1" select="''" />
		<test:param name="string2" select="''" />
		<test:expect select="0" />
	</test:test>
	<test:test>
		<test:title>Identical strings</test:title>
		<test:param name="string1" select="'foo'" />
		<test:param name="string2" select="'foo'" />
		<test:expect select="0" />
	</test:test>
	<test:test>
		<test:title>Insertions</test:title>
		<test:param name="string1" select="'f'" />
		<test:param name="string2" select="'foo'" />
		<test:expect select="2" />
	</test:test>
	<test:test>
		<test:title>Deletions</test:title>
		<test:param name="string1" select="'foo'" />
		<test:param name="string2" select="'f'" />
		<test:expect select="2" />
	</test:test>
	<test:test>
		<test:title>Substitutions</test:title>
		<test:param name="string1" select="'foo'" />
		<test:param name="string2" select="'fee'" />
		<test:expect select="2" />
	</test:test>
</test:tests>
<xsl:function name="my:LevenshteinDistanceB" as="xs:integer">
	<xsl:param name="string1" as="xs:string" />
	<xsl:param name="string2" as="xs:string" />
	<xsl:choose>
		<xsl:when test="$string1 = ''">
			<xsl:sequence select="string-length($string2)" />
		</xsl:when>
		<xsl:when test="$string2 = ''">
			<xsl:sequence select="string-length($string1)" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:sequence select="my:LevenshteinDistanceB(string-to-codepoints($string1),
				                                            string-to-codepoints($string2),
				                                            1, 1,
				                                            for $p in (0 to string-length($string1)) return $p,
				                                            1)" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:function>

<xsl:function name="my:LevenshteinDistanceA" as="xs:integer">
	<xsl:param name="chars1" as="xs:integer+" />
	<xsl:param name="chars2" as="xs:integer+" />
	<xsl:param name="i1" as="xs:integer" />
	<xsl:param name="i2" as="xs:integer" />
	<xsl:choose>
		<xsl:when test="$i1 = 0">
			<xsl:sequence select="$i2" />
		</xsl:when>
		<xsl:when test="$i2 = 0">
			<xsl:sequence select="$i1" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="char1" as="xs:integer" select="$chars1[$i1]" />
			<xsl:variable name="char2" as="xs:integer" select="$chars2[$i2]" />
			<xsl:variable name="deletion" as="xs:integer"
				select="my:LevenshteinDistanceA($chars1, $chars2, $i1 - 1, $i2) + 1" />
			<xsl:variable name="insertion" as="xs:integer"
				select="my:LevenshteinDistanceA($chars1, $chars2, $i1, $i2 - 1) + 1" />
			<xsl:variable name="substitution" as="xs:integer"
				select="my:LevenshteinDistanceA($chars1, $chars2, $i1 - 1, $i2 - 1) +
				        (if ($char1 eq $char2) then 0 else 1)" />
			<xsl:sequence select="min(($deletion, $insertion, $substitution))" />
		</xsl:otherwise>
	</xsl:choose>	
</xsl:function>

<xsl:function name="my:LevenshteinDistanceB" as="xs:integer">
	<xsl:param name="chars1" as="xs:integer+" />
	<xsl:param name="chars2" as="xs:integer+" />
	<xsl:param name="i1" as="xs:integer" />
	<xsl:param name="i2" as="xs:integer" />
	<xsl:param name="lastRow" as="xs:integer+" />
	<xsl:param name="thisRow" as="xs:integer+" />
	<xsl:choose>
		<xsl:when test="$i1 > count($chars1)">
			<xsl:choose>
				<xsl:when test="$i2 = count($chars2)">
					<xsl:sequence select="exactly-one($thisRow[last()])" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:sequence select="my:LevenshteinDistanceB($chars1, $chars2, 1, $i2 + 1, $thisRow, ($i2 + 1))" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="cost" 
				select="min(($lastRow[$i1 + 1] + 1,
				             $thisRow[last()] + 1,
				             $lastRow[$i1] +
				               (if ($chars1[$i1] eq $chars2[$i2]) then 0 else 1)))" />
			<xsl:sequence select="my:LevenshteinDistanceB($chars1, $chars2, $i1 + 1, $i2, $lastRow, ($thisRow, $cost))" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:function>
	
<test:tests>
	<test:title>Template implementation</test:title>
	<test:test>
		<test:title>Empty strings</test:title>
		<test:param name="string1" select="''" />
		<test:param name="string2" select="''" />
		<test:expect select="0" />
	</test:test>
	<test:test>
		<test:title>Identical strings</test:title>
		<test:param name="string1" select="'foo'" />
		<test:param name="string2" select="'foo'" />
		<test:expect select="0" />
	</test:test>
	<test:test>
		<test:title>Insertions</test:title>
		<test:param name="string1" select="'f'" />
		<test:param name="string2" select="'foo'" />
		<test:expect select="2" />
	</test:test>
	<test:test>
		<test:title>Deletions</test:title>
		<test:param name="string1" select="'foo'" />
		<test:param name="string2" select="'f'" />
		<test:expect select="2" />
	</test:test>
	<test:test>
		<test:title>Substitutions</test:title>
		<test:param name="string1" select="'foo'" />
		<test:param name="string2" select="'fee'" />
		<test:expect select="2" />
	</test:test>
</test:tests>
<xsl:template name="my:LevenshteinDistanceB">
	<xsl:param name="string1" as="xs:string" select="''" />
	<xsl:param name="string2" as="xs:string" select="''" />
	<xsl:param name="chars1" as="xs:integer*" select="string-to-codepoints($string1)" />
	<xsl:param name="chars2" as="xs:integer*" select="string-to-codepoints($string2)" />
	<xsl:param name="i1" as="xs:integer" select="1" />
	<xsl:param name="i2" as="xs:integer" select="1" />
	<xsl:param name="lastRow" as="xs:integer+" select="for $p in (0 to string-length($string1)) return $p" />
	<xsl:param name="thisRow" as="xs:integer+" select="1" />
	<xsl:choose>
		<xsl:when test="count($chars1) = 0 or $i2 > count($chars2)">
			<xsl:sequence select="$lastRow[last()]" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="cost" as="xs:integer"
				select="min(($lastRow[$i1 + 1] + 1,
				             $thisRow[last()] + 1,
				             $lastRow[$i1] +
				               (if ($chars1[$i1] eq $chars2[$i2]) then 0 else 1)))" />
			<xsl:variable name="nextRow" as="xs:boolean" 
				select="$i1 = count($chars1)" />
			<xsl:call-template name="my:LevenshteinDistanceB">
				<xsl:with-param name="chars1" select="$chars1" />
				<xsl:with-param name="chars2" select="$chars2" />
				<xsl:with-param name="i1" select="if ($nextRow) then 1 else ($i1 + 1)" />
				<xsl:with-param name="i2" select="if ($nextRow) then ($i2 + 1) else $i2" />
				<xsl:with-param name="lastRow" select="if ($nextRow) then ($thisRow, $cost) else $lastRow" />
				<xsl:with-param name="thisRow" select="if ($nextRow) then $i2 + 1 else ($thisRow, $cost)" />
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
