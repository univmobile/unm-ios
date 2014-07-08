<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" doctype-public="html"/>

<xsl:template match="/ios-installation-page">

<!-- XML VALIDATION -->

<xsl:variable name="duplicate-dates"
	select="ios-installation/@date[. = preceding::ios-installation/@date]"/>
<xsl:variable name="duplicate-git-commits"
	select="ios-installation/@git-commit[. = preceding::ios-installation/@git-commit]"/>
<xsl:variable name="duplicate-plistHrefs"
	select="ios-installation/@plistHref[. = preceding::ios-installation/@plistHref]"/>

<xsl:if test="$duplicate-dates or $duplicate-git-commits or $duplicate-plistHrefs">
<xsl:message terminate="yes">Duplicate elements:
<xsl:for-each select="$duplicate-dates">Date: <xsl:value-of select="."/>
</xsl:for-each>
<xsl:for-each select="$duplicate-git-commits">Git Commit: <xsl:value-of select="."/>
</xsl:for-each>
<xsl:for-each select="$duplicate-plistHrefs">plistHref: <xsl:value-of select="."/>
</xsl:for-each>
</xsl:message>
</xsl:if>

<!-- HTML OUTPUT -->	

<xsl:text disable-output-escaping="yes">
<![CDATA[
<?php

$user_agent = $_SERVER['HTTP_USER_AGENT'];

$ios = false;

if (strstr($user_agent, '(iPod;') !== false) $ios = true;
if (strstr($user_agent, '(iPad;') !== false) $ios = true;
if (strstr($user_agent, ' Mobile') !== false) $ios = true;

$title = 'UnivMobile';
if (!$ios) $title .= ' iOS ';
$title .= ' — Installations ad hoc';

?>
]]>
</xsl:text>
<html lang="fr" dir="ltr">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="Content-Language" content="fr"/>
<title>
<xsl:text disable-output-escaping="yes">
<![CDATA[<?php echo $title; ?>]]>
</xsl:text>
</title>
<xsl:text disable-output-escaping="yes">
<![CDATA[<?php if ($ios) { ?>]]>
</xsl:text>

<style type="text/css">
body {
	background-color: #fff;
	font-family: 'Helvetica Neue';
	font-size: 100%;
}
div.nav {
	display: none;
}
table {
	font-size: 100%;
}
td.date {
	white-space: nowrap;
}
#table-installations tr {
	border-top: 1px solid #000;
}
#table-installations tr.git-commit {
	border-top: none;
}
#table-installations,
#table-installations tr.git-commit {
	border-top: none;
	border-bottom: 1px solid #000;
}
h1,
h2,
body {
}
h1 {
	margin: 0;
	text-align: center;
}
h1 span {
	xdisplay: block;
	font-size: 50%; 
}
h1 span.dash {
	xdisplay: none;
}
td.git-commit,
th.git-commit {
	display: none;
}
thead th {
	text-align: left;
	padding-left: 1em;
}
#table-installations {
	width: 100%;
}
#table-body {
	margin: auto;
}
tr.git-commit td.git-commit {
	display: table-cell;
	padding-top: 0.5em;
}
td.git-commit {
	font-size: 75%;
	color: #999;
}
div.mention {
	font-style: italic;
	margin: 0 0 1em 0;
	font-size: small;
	text-align: center;
	color: #aaa;
}
</style>
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0;"/>

<xsl:text disable-output-escaping="yes">
<![CDATA[<?php } else { ?>]]>
</xsl:text>

<style type="text/css">
h1,
h2,
body {
	font-family: Arial, Helvetica, sans-serif;
	position: relative;
}
#table-body {
	border-collapse: collapse;
	margin: auto;
}
h1 {
	margin-top: 0.2em;
}
div.nav {
	display: inline-block;
	margin-right: 4em;
}
div.nav a {
	font-family: Arial, Helvetica, sans-serif;
	font-size: small;
	text-decoration: none;
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
tr.git-commit {
	display: none;
}
td.git-commit {
	font-size: small;
}
div.mention {
	display: none;
}
</style>

<xsl:text disable-output-escaping="yes">
<![CDATA[<?php } ?>]]>
</xsl:text>

<style type="text/css">
#table-installations thead {
	background-color: #ddd;
	color: #333;
	font-size: small;
}
table {
	border-collapse: collapse;
}
#table-installations a {
	background-color: #eef;
	text-decoration: none;
}
#table-installations td {
	vertical-align: top;
}
td.git-commit {
	font-family: Monaco, 'Courier New', monospace;
}
</style>

<script language="javascript">
</script>
</head>
<body>
<table id="table-body">
<tbody>
<tr>
<td>

<div class="nav">
<a href="https://github.com/univmobile/unm-ios/">Back to the GitHub Repository</a>
</div>
<div class="nav">
<a href="http://univmobile.vswip.com/nexus/content/sites/pub/unm-ios/0.0.1-SNAPSHOT/scenarios.html">UnivMobile iOS — Scénarios</a>
</div>
<div class="nav">
<a href="http://univmobile.vswip.com/">Jenkins — Intégration continue</a>
</div>

<h1>
<span>
<xsl:text disable-output-escaping="yes">
<![CDATA[<?php echo $title; ?>]]>
</xsl:text>
</span>
</h1>

<div class="mention">
L’UDID de votre mobile iOS doit être autorisé pour pouvoir
installer l’application en mode test.
</div>

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
<xsl:sort select="@date" order="descending"/>

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
<tr class="git-commit">
	<td colspan="2" class="git-commit">
	<xsl:value-of select="$git-commit"/>
	</td>
</tr>
</xsl:for-each>
</tbody>
</table>

</td>
</tr>
</tbody>
</table>
</body>
</html>

</xsl:template>

</xsl:stylesheet>