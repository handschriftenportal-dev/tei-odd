<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:h1="http://www.startext.de/HiDA/DefService/XMLSchema" xmlns:rtftools="http://www.startext.de/rtftools" exclude-result-prefixes="h1 rtftools">

<xsl:include href="RTF-Tools.xsl"/>
<xsl:param name="pi"></xsl:param><!-- supply a link to stylesheet here -->

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<!-- #################################################################### -->
	<!-- root -->
	<xsl:template match="/">
		<xsl:if test="$pi"><xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="<xsl:value-of select="$pi"/>"</xsl:processing-instruction></xsl:if>
		<xsl:apply-templates select="h1:DocumentSet"/>
	</xsl:template>
	<!-- #################################################################### -->


	<!-- #################################################################### -->
	<xsl:template match="h1:DocumentSet">
		<xsl:copy>
			<xsl:apply-templates select="h1:Document"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="h1:Document">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="h1:Block">
		<xsl:copy>	
			<xsl:apply-templates select="node() | @*"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="node()">
		<xsl:copy>	
			<xsl:choose>
				<xsl:when test="h1:Block">
					<xsl:attribute name="Type">
						<xsl:value-of select="@Type"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="Type">
						<xsl:value-of select="@Type"/>
					</xsl:attribute>
					<xsl:choose>
						<xsl:when test="contains(@Value, 'rtf')">
							<xsl:attribute name="Value">
								 <xsl:value-of select="rtftools:removeRTF(string( @Value ) )"/>
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="Value">
								<xsl:value-of select="@Value"/>
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="node()"/> 
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@*">
		<xsl:copy>
			<xsl:attribute name="{name()}">
				<xsl:value-of select="."/>
			</xsl:attribute>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
