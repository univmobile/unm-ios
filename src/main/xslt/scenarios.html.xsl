<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" doctype-public="html"/>

<xsl:template match="/scenarios">
<html lang="fr" dir="ltr">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="Content-Language" content="fr"/>
<title>UnivMobile iOS — Scénarios</title>
<style type="text/css">
body {
	position: relative;
}
h1,
h2 {
	font-family: Arial, Helvetica, sans-serif;
}
h1 {
	margin-top: 0.2em;
}
#div-detail {
	position: absolute;
	top: 0;
	right: 0;
	width: 640px;
	height: 1136px;
	text-align: right;
}
div.device {
	position: relative;
	width: 80px;
	height: 164px;
}
div.device img.screenshot {
	width: 64px;
	height: 113.6px;
	position: absolute;
	top: 25px;
	left: 8px;
}
div.device.smaller img.screenshot {
	width: 32px;
	height: 56.8px;
}
div.device div.iPod {
	position: absolute;
	top: 2px;
	left: 2px;
	background-image: url('img/iPod_touch_Vert_Blu_sRGB.png');
	background-size: 91px 175px;
	background-repeat: no-repeat;
	background-position: -8px -8px;
	width: 76px;
	height: 160px;
}
table {
	border-collapse: collapse;
	border: none;
}
div.scenario table td {
	vertical-align: top;
}
div.step,
div.transition {
	display: inline-block;
}
div.shortLabel {
	text-align: center;
	font-family: Arial, Helvetica, sans-serif;
	font-size: small;
}
div.transition div.shortLabel {
	font-style: italic;
}
div.transition {
	opacity: 0.3;
	margin: 0 0 0 1em;
}
div.arrow {
	display: inline-block;
	margin: 0;
	position: relative;
	top: -90px;
}
#div-detail table {
	border-collapse: collapse;
	position: absolute;
	right: 0;
}
#div-detail table td {
	padding-left: 2em;
	padding-bottom: 1.2em;
}
#div-detail .screen_4_inch img {
	width: 192px;
	height: 340.8px;
}
#div-detail .screen_3_5_inch img {
	width: 192px;
	height: 288px;
}
#div-detail div.label {
	background-color: #000;
	color: #fff;
	display: inline-block;
	padding: 0px 3px;
	font-family: Arial, Helvetica, sans-serif;
	font-size: x-small;
	border: 1px solid #000;
}
#div-detail div.img {
	background-color: #ccc;
	border: 1px solid #000;
}
div.nav a {
	font-family: Arial, Helvetica, sans-serif;
	font-size: small;
	text-decoration: none;
}
</style>
<script language="javascript">

function displayDetail(src) {

	document.getElementById('img-detail-iOS7-4inch').src =
		'img/iOS_7.0/Retina_4-inch/' + src;

	document.getElementById('img-detail-iOS6-4inch').src =
		'img/iOS_6.1/Retina_4-inch/' + src;

	document.getElementById('img-detail-iOS7-3_5inch').src =
		'img/iOS_7.0/Retina_3.5-inch/' + src;

	document.getElementById('img-detail-iOS6-3_5inch').src =
		'img/iOS_6.1/Retina_3.5-inch/' + src;
}

window.onload = function() {

	displayDetail('001.png');
};

</script>
</head>
<body>

<div id="div-detail">
<table>
<tr>
<td class="iOS7 screen_4_inch">
<div class="label">
	Retina 4-inch iOS 7.0
</div>
<div class="img">
	<img id="img-detail-iOS7-4inch" src="img/blank.png"/>	
</div>
</td>
<td class="iOS6 screen_4_inch">
<div class="label">
	Retina 4-inch iOS 6.1
</div>
<div class="img">
	<img id="img-detail-iOS6-4inch" src="img/blank.png"/>	
</div>
</td>
</tr>
<tr>
<td class="iOS7 screen_3_5_inch">
<div class="label">
	Retina 3.5-inch iOS 7.0
</div>
<div class="img">
	<img id="img-detail-iOS7-3_5inch" src="img/blank.png"/>	
</div>
</td>
<td class="iOS6 screen_3_5_inch">
<div class="label">
	Retina 3.5-inch iOS 6.1
</div>
<div class="img">
	<img id="img-detail-iOS6-3_5inch" src="img/blank.png"/>	
</div>
</td>
</tr>
</table>
<img id="img-detail" src="img/blank.png"/>
</div>

<div class="nav">
<a href="index.html">Back to the Maven Generated Site</a>
</div>

<h1>UnivMobile iOS — Scénarios</h1>
<div id="div-scenarios">
<xsl:for-each select="scenario">

<h2>
	<xsl:value-of select="@id"/>.
	<xsl:value-of select="@title"/>
</h2>

<div class="scenario">
<table>
<tbody>
<tr>
<td>
<div class="begin step">

<xsl:for-each select="begin">

	<xsl:call-template name="device">
		<xsl:with-param name="screenshot" select="@screenshot"/>
	</xsl:call-template>

	<xsl:call-template name="shortLabel"/>

</xsl:for-each>

</div>
</td>
<td>

<xsl:for-each select="next">

<xsl:if test="@transitionScreenshot or @transitionLabel">
	
	<div class="arrow">→</div>
	
	<div class="transition">
	
	<xsl:if test="@transitionScreenshot">
		<xsl:call-template name="device">
			<xsl:with-param name="screenshot" select="@transitionScreenshot"/>
		</xsl:call-template>
	</xsl:if>

	<xsl:call-template name="shortLabel">
		<xsl:with-param name="shortLabel" select="@transitionShortLabel"/>
	</xsl:call-template>
	
	</div>
</xsl:if>

<div class="arrow">…</div>

<div class="step">

	<xsl:call-template name="device">
		<xsl:with-param name="screenshot" select="@screenshot"/>
	</xsl:call-template>

	<xsl:call-template name="shortLabel"/>

</div>

</xsl:for-each>

</td>
</tr>
</tbody>
</table>

</div>

</xsl:for-each>

</div>

</body>
</html>
</xsl:template>

<xsl:template name="device">
<xsl:param name="screenshot" select="'001.png'"/>

<div class="device" onclick="displayDetail('{$screenshot}');">
	<img class="screenshot" src="img/iOS_7.0/Retina_4-inch/{$screenshot}"/>
	<div class="iPod"/>
</div>

</xsl:template>

<xsl:template name="shortLabel">
<xsl:param name="shortLabel" select="@shortLabel"/>

<xsl:if test="$shortLabel">
<div class="shortLabel">
	<xsl:choose>
	<xsl:when test="name($shortLabel) = 'transitionShortLabel'">
		(<xsl:value-of select="$shortLabel"/>)
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="$shortLabel"/>
	</xsl:otherwise>
	</xsl:choose>
</div>
</xsl:if>

</xsl:template>

</xsl:stylesheet>