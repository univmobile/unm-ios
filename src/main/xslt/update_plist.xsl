<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="jsonBaseURL" select="'http://localhost:8380/unm-backend/json/'"/>

<xsl:template match="*">

	<xsl:copy>
	<xsl:copy-of select="@*"/>
	
		<xsl:apply-templates/>
	
	</xsl:copy>

</xsl:template>

<xsl:template match="string[preceding-sibling::key[1] = 'UNMJsonBaseURL']">

	<xsl:copy>
	<xsl:copy-of select="@*"/>
	
		<xsl:value-of select="$jsonBaseURL"/>
	
	</xsl:copy>
	
</xsl:template>

</xsl:stylesheet>