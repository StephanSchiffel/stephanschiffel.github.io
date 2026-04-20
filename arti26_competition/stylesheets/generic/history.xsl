<?xml version="1.0" encoding="ISO-8859-1"?>

<!--
	- Widget for writing move history to the screen.
	- For use within <body>.
	- needs css/main.css and sitespecific.xsl
	
	TODO: make height dynamic
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="variables.xsl"/>

	<xsl:template name="history">
		
		<div class="history">

			<span class="heading">History: </span>
			<div class="underline"/>
			
			<style type="text/css" media="all">
				td:last-child {padding-right: 20px;} /*prevent Mozilla scrollbar from hiding cell content*/
			</style>
			
			<div style="overflow: auto; max-height: 420px; overflow-x: hidden;">
				<table>
					<thead>
						<tr>
							<td></td>
							<xsl:for-each select="match/role">
								<th>
									<span class="heading">
										<xsl:value-of select="."/>
									</span>
								</th>
							</xsl:for-each>
							<th><span class="heading">Errors</span></th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="match/history/step">
							<xsl:sort select="number(step-number)" order="descending" data-type="number"/>
							<tr class="move_step">
								<xsl:attribute name="id">move_<xsl:value-of select="./step-number"/></xsl:attribute>
								<td>
									<span class="heading">
									<a>
										<xsl:attribute name="href">
											<xsl:call-template name="makeStepLinkURL">
												<xsl:with-param name="step" select="./step-number"/>
												<xsl:with-param name="role" select="$role"/>
											</xsl:call-template>
										</xsl:attribute>
										<xsl:value-of select="./step-number"/>.
									</a>
									</span>
								</td>
								<xsl:for-each select="./move">
									<td>
										<span class="content"><xsl:value-of select="."/></span>
									</td>
								</xsl:for-each>
								<td>
									<xsl:for-each select="./error">
										<span class="error">
											<xsl:attribute name="title"><xsl:value-of select="msg"/></xsl:attribute>
											<xsl:value-of select="type"/>
											<xsl:if test="player">
												by <xsl:value-of select="player"/>
											</xsl:if>
										</span><br/>
									</xsl:for-each>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
			</div>

		</div>

	</xsl:template>
</xsl:stylesheet>

