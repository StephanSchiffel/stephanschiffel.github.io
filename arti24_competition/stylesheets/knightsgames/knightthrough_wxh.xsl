<?xml version="1.0" encoding="ISO-8859-1"?>

<!--
	similar to chess_like but uses knights as pieces
	works for  knightthrough version that have (width x) and (height y) exposed in the state
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="knightsgames_inc.xsl"/>
	
	<xsl:template name="print_state">
		<xsl:call-template name="print_chess_state">
			<xsl:with-param name="Width" select="./fact[prop-f='WIDTH']/arg"/>
			<xsl:with-param name="Height" select="./fact[prop-f='HEIGHT']/arg"/>
			<xsl:with-param name="DefaultCellContent">no</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
</xsl:stylesheet>
