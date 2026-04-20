<?xml version="1.0" encoding="ISO-8859-1"?>

<!--
	- Widget for drawing the generic game-master header.
	- For use within <body>.
	- needs css/main.css and sitespecific.xsl
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="variables.xsl"/>

	<xsl:template name="header">
		<div class="header" id="header">
			<xsl:call-template name="print_match_info"/>
			<xsl:call-template name="make_navigation_links"/>
			<div class="underline" style="clear:left;"/>
		</div>
	</xsl:template>

	<xsl:template name="print_match_info">
		<span class="heading">Match:</span><span class="content"><xsl:value-of select="/match/match-id"/></span>, 
		<span class="heading">Step:</span><span class="content" id="currentstep"><xsl:value-of select="$currentStep"/></span>
		<xsl:if test="$gdlVersion=2">,
			<span class="heading">Seen by:</span><span class="content">
				<script language="JavaScript" type="text/javascript">
					// &lt;!--
							function change_viewpoint(role) {
								newLocation = "<xsl:call-template name="makeStepLinkURL"><xsl:with-param name="step" select="$currentStep"/><xsl:with-param name="role" select="'THEROLE'"/></xsl:call-template>";
								newLocation = newLocation.replace("THEROLE", role);
								location.replace(newLocation);
							}
					// --&gt;
				</script>
				<select name="view_of_role" size="1" onchange="javascript:change_viewpoint(this.value)">
					<xsl:if test="not(match/role[translate(., 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')='RANDOM'])">
						<xsl:call-template name="add_view_point_option">
							<xsl:with-param name="option_role" select="'RANDOM'"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:for-each select="match/role">
						<xsl:call-template name="add_view_point_option">
							<xsl:with-param name="option_role" select="."/>
						</xsl:call-template>
					</xsl:for-each>
				</select>
			</span>
		</xsl:if>
		<br/>
	</xsl:template>

	<xsl:template name="add_view_point_option">
		<xsl:param name="option_role"/>
		<xsl:variable name="lo" select="'abcdefghijklmnopqrstuvwxyz'"/>
		<xsl:variable name="up" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
		<option>
			<xsl:if test="translate($role, $lo, $up) = translate($option_role, $lo, $up)">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value"><xsl:value-of select="translate($option_role, $lo, $up)"/></xsl:attribute>
			<xsl:choose>
				<xsl:when test="translate($option_role, $lo, $up) = 'RANDOM'">complete information</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="translate($option_role, $lo, $up)"/>
				</xsl:otherwise>
			</xsl:choose>
		</option>
	</xsl:template>

	<xsl:template name="make_navigation_links">
		<xsl:call-template name="make_tab">
			<xsl:with-param name="which">initial</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="make_tab">
			<xsl:with-param name="which">previous</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="make_tab">
			<xsl:with-param name="which">play</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="make_tab">
			<xsl:with-param name="which">next</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="make_tab">
			<xsl:with-param name="which">final</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="make_tab">
		<xsl:param name="which"/>

		<div class="bartab">
			<a>
				
				<xsl:attribute name="id">navigation_<xsl:value-of select="$which"/></xsl:attribute>
				
				<xsl:variable name="linkStep">
					<xsl:choose>
						<xsl:when test="$which='initial'">1</xsl:when>
						<xsl:when test="$which='previous'"><xsl:value-of select="$currentStep - 1"/></xsl:when>
						<xsl:when test="$which='next'"><xsl:value-of select="$currentStep + 1"/></xsl:when>
						<xsl:when test="$which='final'">final</xsl:when>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:if test="$which='initial' or $which='previous' or $which='final' or $which='next'">
					<xsl:attribute name="href">
						<xsl:call-template name="makeStepLinkURL">
							<xsl:with-param name="step">'<xsl:value-of select="$which"/>'</xsl:with-param>
							<xsl:with-param name="role" select="$role"/>
						</xsl:call-template>
					</xsl:attribute>
				</xsl:if>
				
				<xsl:if test="$which = 'play'">
					<xsl:attribute name="href">javascript:togglePlay();</xsl:attribute>
				</xsl:if>
				
				<xsl:attribute name="title">
					<xsl:choose>
						<xsl:when test="$which='initial'">initial state</xsl:when>
						<xsl:when test="$which='previous'">previous state</xsl:when>
						<xsl:when test="$which='play'">auto play</xsl:when>
						<xsl:when test="$which='next'">next state</xsl:when>
						<xsl:when test="$which='final'">final state</xsl:when>
						<xsl:otherwise>state <xsl:value-of select="$linkStep"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>

				<xsl:variable name="imageName">
					<xsl:choose>
						<xsl:when test="$which='initial'">gnome-go-first</xsl:when>
						<xsl:when test="$which='previous'">gnome-go-previous</xsl:when>
						<xsl:when test="$which='play'">play</xsl:when>
						<xsl:when test="$which='next'">gnome-go-next</xsl:when>
						<xsl:when test="$which='final'">gnome-go-last</xsl:when>
					</xsl:choose>
				</xsl:variable>

				<img width="30" height="30">
					<xsl:attribute name="id">navigation_img_<xsl:value-of select="$which"/></xsl:attribute>
					<xsl:attribute name="src"><xsl:value-of select="$stylesheetURL"/>/generic/images/<xsl:value-of select="normalize-space($imageName)"/>.png</xsl:attribute>
				</img>
			</a>
		</div>
	</xsl:template>
	
</xsl:stylesheet>
