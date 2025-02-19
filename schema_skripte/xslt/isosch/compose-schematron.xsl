<!--
Copyright (C) by David Maus <dmaus@dmaus.name>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-->
<xsl:transform version="3.0" expand-text="yes"
               xpath-default-namespace="http://www.tei-c.org/ns/1.0"
               xmlns:oddp="http://dmaus.name/ns/2023/oddp"
               xmlns:sch="http://purl.oclc.org/dsdl/schematron"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:mode on-no-match="shallow-skip"/>

  <xsl:output indent="yes"/>

  <xsl:param name="queryBinding" as="xs:string">xslt2</xsl:param>
  <xsl:param name="inferNamespaceDeclarations" as="xs:boolean" select="false()"/>

  <xsl:key name="oddp:schematronElement" match="sch:*" use="local-name()"/>
  <xsl:key name="oddp:schematronElement" match="xsl:function | xsl:key" use="local-name()"/>

  <xsl:template match="schemaSpec" as="element(sch:schema)?">

    <xsl:variable name="inferredNamespaceDeclarations" as="element(sch:ns)*">
      <xsl:if test="$inferNamespaceDeclarations">
        <xsl:call-template name="oddp:infer-namespace-declarations">
          <xsl:with-param name="context" as="element()" select="."/>
        </xsl:call-template>
      </xsl:if>
    </xsl:variable>

    <xsl:where-populated>
      <sch:schema queryBinding="{$queryBinding}">
        <xsl:for-each-group select="(key('oddp:schematronElement', 'ns', .), $inferredNamespaceDeclarations)"
                            group-by="(@prefix, @uri)" composite="true">
          <xsl:sequence select="current-group()[1]"/>
        </xsl:for-each-group>

        <xsl:sequence select="key('oddp:schematronElement', 'phase', .)"/>

        <xsl:sequence select="key('oddp:schematronElement', 'function', .)"/>
        <xsl:sequence select="key('oddp:schematronElement', 'key', .)"/>

        <xsl:apply-templates/>

        <xsl:where-populated>
          <sch:diagnostics>
            <xsl:sequence select="key('oddp:schematronElement', 'diagnostic', .)"/>
          </sch:diagnostics>
        </xsl:where-populated>

        <xsl:where-populated>
          <sch:properties>
            <xsl:sequence select="key('oddp:schematronElement', 'property', .)"/>
          </sch:properties>
        </xsl:where-populated>

      </sch:schema>
    </xsl:where-populated>

  </xsl:template>

  <xsl:template match="sch:pattern" as="element(sch:pattern)">
    <xsl:copy>
      <xsl:sequence select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="sch:let" as="element(sch:let)">
    <xsl:sequence select="."/>
  </xsl:template>

  <xsl:template match="sch:param" as="element(sch:param)">
    <xsl:sequence select="."/>
  </xsl:template>

  <xsl:template match="constraintSpec[@scheme eq 'schematron']/constraint[exists(sch:rule)]" as="element(sch:pattern)">
    <sch:pattern id="{../@ident}">
      <xsl:apply-templates/>
    </sch:pattern>
  </xsl:template>

  <xsl:template match="sch:rule" as="element(sch:rule)">
    <xsl:copy>
      <xsl:sequence select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="sch:rule/sch:assert | sch:rule/sch:report" as="element()">
    <xsl:sequence select="."/>
  </xsl:template>

  <xsl:template name="oddp:infer-namespace-declarations" as="element(sch:ns)*">
    <xsl:param name="context" as="element()" required="yes"/>

    <xsl:for-each select="in-scope-prefixes($context)[not(. = ('', 'xml'))]">
      <sch:ns prefix="{.}" uri="{namespace-uri-for-prefix(., $context)}"/>
    </xsl:for-each>

  </xsl:template>

</xsl:transform>
