<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  exclude-result-prefixes="sch">
  <xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="sch:pattern[1]">
    <pattern id="duplicate-xml-ids" xmlns="http://purl.oclc.org/dsdl/schematron">
      <rule context="/">
        <assert test="count(//*[@xml:id ne '']/@xml:id) eq count(distinct-values(//*[@xml:id ne '']/@xml:id))">
          'xml:id' must be unique <value-of select=" for $xml-id in distinct-values(//*[@xml:id ne '']/@xml:id)return if(count(//*[@xml:id eq $xml-id]/@xml:id) gt 1) then concat('&quot;', $xml-id, '&quot; : (', count(//*[@xml:id eq $xml-id]/@xml:id), '), Xpath: [', string-join(//*[@xml:id eq $xml-id]/name(), ', '), ']; ') else  '' "/>
        </assert>
      </rule>
    </pattern>
    <xsl:copy-of select="."/>
  </xsl:template>

</xsl:stylesheet>
