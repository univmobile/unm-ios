<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" doctype-public="html"/>

<xsl:template match="/ios-installation-page">
<html lang="fr" dir="ltr">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="Content-Language" content="fr"/>
<title>UnivMobile iOS — Installations ad hoc</title>
<style type="text/css">
h1,
h2,
body {
	font-family: Arial, Helvetica, sans-serif;
}
h1 {
	margin-top: 0.2em;
}
div.nav a {
	font-family: Arial, Helvetica, sans-serif;
	font-size: small;
	text-decoration: none;
}
td.git-commit {
	font-family: Monaco, 'Courier New', monospace;
	font-size: small;
}
table {
	border-collapse: collapse;
}
#table-installations,
#table-installations tr {
	border: 1px solid #000;
}
#table-installations th.date,
#table-installations td.date {
	padding-left: 2em;
}
#table-installations th.git-commit,
#table-installations td.git-commit {
	padding-right: 2em;
}
#table-installations th,
#table-installations td {
	padding-left: 1em;
	padding-right: 1em;
}
#table-installations td {
	padding-top: 0.5em;
	padding-bottom: 0.5em;
}
#table-installations td {
	white-space: nowrap;
}
#table-installations a {
	background-color: #eef;
	text-decoration: none;
}
#table-installations thead {
	background-color: #ddd;
	color: #333;
	font-size: small;
}
</style>
<script language="javascript">
</script>
</head>
<body>

<div class="nav">
<a href="https://github.com/univmobile/unm-ios/">Back to the GitHub Repository</a>
</div>

<h1>UnivMobile iOS — Installations ad hoc</h1>

<table id="table-installations">
<thead>
<tr>
<th class="date">Date</th>
<th class="label">Label</th>
<th class="git-commit">Git commit</th>
</tr>
</thead>
<tbody>
<xsl:for-each select="ios-installation">

<xsl:variable name="git-commit" select="@git-commit"/>

<!--
<xsl:variable name="plistHref" select="concat(
	'http://univmobile.vswip.com/ios/', $git-commit, '/UnivMobile.plist'
)"/>
-->

<xsl:variable name="plistHref" select="@plistHref"/>

<xsl:if test="not($plistHref) or normalize-space($plistHref) = ''">
<xsl:message terminate="yes">Cannot find @plistHref for ios-installation:
Git commit=<xsl:value-of select="$git-commit"/>
</xsl:message>
</xsl:if>

<xsl:variable name="href" select="concat(
	'itms-services://?action=download-manifest',
	'&amp;url=itms-services://?action=download-manifest',
	'&amp;url=', $plistHref
)"/>

<tr>
	<td class="date">
	<a href="{$href}">
	<xsl:value-of select="@date"/>
	</a>
	</td>
	<td class="label">
	<xsl:value-of select="@label"/>
	</td>
	<td class="git-commit">
	<xsl:value-of select="$git-commit"/>
	</td>
</tr>
</xsl:for-each>
</tbody>
</table>

</body>
</html>

</xsl:template>

</xsl:stylesheet>