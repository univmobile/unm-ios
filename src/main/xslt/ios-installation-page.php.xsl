<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" doctype-public="html"/>

<xsl:variable name="ios-installations"
	select="ios-installation-page/ios-installation"/>
	
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

<xsl:message>OK - No duplicates in: dates, git commits, plistHrefs.</xsl:message>

<!-- INSPECT PLISTS -->

<!-- TODO: This code works only onl David’s environment.

<xsl:for-each select="$ios-installations">
<xsl:variable name="git-commit" select="@git-commit"/>
<xsl:variable name="plist" select="document(concat(
	'/Users/dandriana/Dropbox/UnivMobile/ios/', $git-commit, '/UnivMobile.plist'
))/plist"/>
<xsl:if test="$plist">
<xsl:variable name="ipaURL" select="$plist/dict/array[1]/dict[1]/array[1]/dict
		[1]/key[. = 'url']/following-sibling::string"/>
<xsl:if test="not($ipaURL = concat('http://univmobile.vswip.com/ios/',
		$git-commit, '/UnivMobile.ipa'))">
<xsl:message terminate="yes">Incorrect ipaURL: <xsl:value-of
	select="$ipaURL"/> for commit-id: <xsl:value-of
	select="$git-commit"/></xsl:message>
</xsl:if>
</xsl:if>
</xsl:for-each>

<xsl:message>OK - All plist/ipaURLs have been checked.</xsl:message>

-->

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
	margin: 0;
	padding: 0;
}
div.nav {
	display: none;
}
table {
	font-size: 100%;
	border-collapse: collapse;
}
td {
	padding: 0;
}
td.date {
	white-space: nowrap;
}
#table-installations tr {
	border-top: 1px solid #000;
}
#table-installations tr.cell-bottom {
	border-top: none;
}
#table-installations,
#table-installations tr.cell-bottom {
	border-top: none;
	border-bottom: 1px solid #000;
}
h1,
h2,
body {
}
h1 {
	margin: 8px 0 0;
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
	xdisplay: none;
}
td.label,
th.label {
	xdisplay: none;
}
thead {
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
tr.cell-bottom td.git-commit {
	xdisplay: table-cell;
	padding-top: 0.5em;
}
td.git-commit,
div.git-commit,
li.git-commit {
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
#table-installations ul {
	background-image:
	 -webkit-linear-gradient(bottom, #fff, #ccf);
	list-style-type: none;
	padding: 0 10px;
	margin: 0;
}
#table-installations li {
	padding: 0;
	margin: 0;
}
li.build-displayName.empty {
	display: none;
}
li.build-displayName,
li.date {
	xdisplay: inline-block;
}
li.build-displayName span.label {
	xpadding-left: 1em;
}
#table-installations td {
	padding: 0;
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
	display: block;
}
#table-installations thead {
	background-color: #ddd;
	color: #333;
	font-size: small;
}
tr.cell-bottom {
	display: none;
}
td.git-commit,
div.git-commit,
li.git-commit {
	font-size: small;
}
div.mention {
	display: none;
}
td.build-displayName span.label {
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
	xbackground-color: #eef;
	text-decoration: none;
}
#table-installations td {
	vertical-align: top;
}
td.git-commit,
div.git-commit,
li.git-commit {
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

<!-- 
<div class="nav">
<a href="https://github.com/univmobile/unm-ios/">Back to the GitHub Repository</a>
</div>

<div class="nav">
<a href="http://univmobile.vswip.com/nexus/content/sites/pub/unm-ios/0.0.1-SNAPSHOT/scenarios.html">UnivMobile iOS — Scénarios</a>
</div>
-->

<div class="nav">
<a href="http://univmobile.vswip.com/">
	Jenkins — Intégration continue
</a>
</div>

<div class="nav">
<a href="http://univmobile.vswip.com/job/unm-devel-it/lastSuccessfulBuild/artifact/unm-devel-it/target/unm-ci-dump.html">
	UnivMobile iOS — Intégration continue
</a>
</div>

<div class="nav">
<a href="http://univmobile.vswip.com/job/unm-devel-it/lastSuccessfulBuild/artifact/unm-devel-it/target/unm-ios-it-scenarios-dump.html">
	UnivMobile iOS — Scénarios
</a>
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
<th class="build-displayName">Build</th>
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
<xsl:text disable-output-escaping="yes">
<![CDATA[<?php if ($ios) { ?>]]>
</xsl:text>

<td>
<ul>
<xsl:call-template name="cells">
<xsl:with-param name="item-element" select="'li'"/>
<xsl:with-param name="href" select="$href"/>
</xsl:call-template>
</ul>
</td>

<xsl:text disable-output-escaping="yes">
<![CDATA[<?php } else { ?>]]>
</xsl:text>

<xsl:call-template name="cells">
<xsl:with-param name="item-element" select="'td'"/>
<xsl:with-param name="href" select="$href"/>
</xsl:call-template>

<xsl:text disable-output-escaping="yes">
<![CDATA[<?php } ?>]]>
</xsl:text>
	
</tr>
<!--  
<tr class="cell-bottom">
	<td colspan="3">
	<xsl:value-of select="@label"/>	
	<div class="git-commit">
	<xsl:value-of select="$git-commit"/>
	</div>
	</td>
</tr>
-->
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

<xsl:template name="cells">
<xsl:param name="item-element" select="'td'"/>
<xsl:param name="href"/>
	
	<xsl:element name="{$item-element}">
	<xsl:attribute name="class">date</xsl:attribute>
		<a href="{$href}">
		<xsl:value-of select="@date"/>
		</a>
	</xsl:element>

	<xsl:element name="{$item-element}">
	<xsl:choose>
	<xsl:when test="@build-displayName">
		<xsl:attribute name="class">build-displayName</xsl:attribute>
		<span class="label">Build </span>
		<xsl:value-of select="@build-displayName"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:attribute name="class">build-displayName empty</xsl:attribute>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:element>
	
	<xsl:element name="{$item-element}">
	<xsl:attribute name="class">label</xsl:attribute>
		<xsl:value-of select="@label"/>
	</xsl:element>
	
	<xsl:element name="{$item-element}">
	<xsl:attribute name="class">git-commit</xsl:attribute>
		<xsl:value-of select="@git-commit"/>
	</xsl:element>

</xsl:template>

</xsl:stylesheet>