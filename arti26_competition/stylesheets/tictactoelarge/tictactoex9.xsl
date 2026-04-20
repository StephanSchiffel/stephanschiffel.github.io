<?xml version="1.0" encoding="ISO-8859-1"?>

<!--
	similar to chess_like but doesn't print green cells
	works for *othello*, ...
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../generic/template.xsl"/>
	<xsl:import href="../generic/chess_board.xsl"/>
	<xsl:import href="../generic/state.xsl"/>
	
	<xsl:template name="print_state">
		<xsl:call-template name="chess_board">
			<xsl:with-param name="Width" select="'9'"/>
			<xsl:with-param name="Height" select="'9'"/>
			<xsl:with-param name="checkered">alldark</xsl:with-param>
			<xsl:with-param name="DefaultCellContent">no</xsl:with-param>
			<xsl:with-param name="DefaultCell">no</xsl:with-param>
			<xsl:with-param name="CellFluentName">CELL</xsl:with-param>
			<xsl:with-param name="xArgIdx">1</xsl:with-param>
			<xsl:with-param name="yArgIdx">2</xsl:with-param>
		</xsl:call-template>
		
		<!-- show remaining fluents -->
		<xsl:call-template name="state">
			<xsl:with-param name="excludeFluent" select="'CELL'"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="make_cell">
		<xsl:param name="col"/>
		<xsl:param name="row"/>
		<xsl:param name="defaultClass"/>
		<div>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="fact[prop-f='CELL' and ((arg[2]='1' or arg[2]='3') and (arg[1]='1' or arg[1]='3')) or (arg[1]='2' and arg[2]='2')]">cellLight</xsl:when>
					<xsl:otherwise><xsl:value-of select="$defaultClass"/></xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</div>
	</xsl:template>
	
	<xsl:template name="make_cell_content">
		<xsl:param name="content"/>
		<xsl:param name="piece"/>
		<xsl:param name="background"/>
		<xsl:param name="alt"/>
		<xsl:param name="xArg"/>
		<xsl:param name="yArg"/>

		<xsl:variable name="color">
			<xsl:choose>
				<xsl:when test="(($yArg &lt; 4 or $yArg &gt; 6) and ($xArg &lt; 4 or $xArg &gt; 6)) or ($xArg &gt; 3 and $xArg &lt; 7 and $yArg &gt; 3 and $yArg &lt; 7)">light</xsl:when>
				<xsl:otherwise>dark</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<xsl:choose>
			<xsl:when test="$content='b'">
				<xsl:call-template name="make_chess_img">
					<xsl:with-param name="piece" select="'O8'"/>
					<xsl:with-param name="background" select="$color"/>
					<xsl:with-param name="alt" select="$alt"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="make_chess_img">
					<xsl:with-param name="piece" select="$piece"/>
					<xsl:with-param name="background" select="$color"/>
					<xsl:with-param name="alt" select="$alt"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>