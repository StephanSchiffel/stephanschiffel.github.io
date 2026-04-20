<?xml version="1.0" encoding="ISO-8859-1"?>

<!--
	template style sheet

	use with:
		<xsl:call-template name="template">
			<xsl:with-param name="stateWidth">250</xsl:with-param>
		</xsl:call-template name="template">

	The template assumes that there is a template with name "print_state" that prints the state in the surrounding div.
	print_state is in the context /match/state
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="sitespecific.xsl"/> <!-- $stylesheetURL, makeStepLinkURL and makePlayLinkURL template -->
	
	<xsl:import href="title.xsl"/>
	<xsl:import href="header.xsl"/>
	<xsl:import href="footer.xsl"/>
	<xsl:import href="history.xsl"/>
	<xsl:import href="playerInfo.xsl"/>
	<xsl:import href="playClock.xsl"/>
	<xsl:import href="state.xsl"/>
	
	<xsl:template name="main" match="/">
		
		<html>

			<head>
				<link rel="stylesheet" type="text/css" href="formate.css">
					<xsl:attribute name="href"><xsl:value-of select="$stylesheetURL"/>generic/css/main.css</xsl:attribute>
				</link>
				<xsl:call-template name="title"/>
				<script>
					<xsl:text disable-output-escaping="yes">var startclock=</xsl:text><xsl:value-of select="/match/startclock"/><xsl:text disable-output-escaping="yes">;</xsl:text>
					<xsl:text disable-output-escaping="yes">var playclock=</xsl:text><xsl:value-of select="0+/match/playclock"/><xsl:text disable-output-escaping="yes">;</xsl:text>
					<xsl:text disable-output-escaping="yes">var matchtimestamp=</xsl:text><xsl:value-of select="/match/timestamp"/><xsl:text disable-output-escaping="yes">;</xsl:text>
					<xsl:text disable-output-escaping="yes">var lastStepInMatch=</xsl:text><xsl:value-of select="count(/match/history/step)+1"/><xsl:text disable-output-escaping="yes">;</xsl:text>
					<xsl:text disable-output-escaping="yes">var gameIsOver=</xsl:text>
						<xsl:choose>
							<xsl:when test="/match/scores/reward">
								<xsl:text disable-output-escaping="yes">true;</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text disable-output-escaping="yes">false;</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					<xsl:text disable-output-escaping="yes">playing=</xsl:text><xsl:value-of select="$playing"/><xsl:text disable-output-escaping="yes">;</xsl:text>

				// &lt;!--
				<![CDATA[
					var currentStateStep = lastStepInMatch;
					function showState(step) {
						var previousStateStep = currentStateStep;
						var nbStates = document.getElementsByClassName("state").length;
						console.log("showState(" + step + ") current=" + currentStateStep + ", nbStates = " + nbStates);
						if (step == 'initial') {
							currentStateStep = 1;
						} else if (step == 'previous') {
							currentStateStep -= 1;
						} else if (step == 'next') {
							currentStateStep += 1;
						} else if (step == 'final') {
							currentStateStep = nbStates;
						} else {
							currentStateStep = step;
						}
						if (currentStateStep < 1) {
							currentStateStep = 1;
							return false;
						}
						if (currentStateStep > nbStates) {
							if (!gameIsOver) {
								// that means we might have to reload the document to get to the next state
								console.log("reloading page to get to state " + currentStateStep + " where last state in file is " + nbStates);
								document.location.reload(); // TODO: make sure that the next state is shown after reload, right now we show the most recent state
							}
							currentStateStep = nbStates; 
							clock();
							return false;
						}
						document.getElementById("state_" + previousStateStep).style.display = 'none';
						document.getElementById("state_" + currentStateStep).style.display = 'inline';
						document.getElementById("currentstep").textContent = currentStateStep;
						
						for (row of document.getElementsByClassName("move_step")) {
							if (row.id.split("_")[1] == currentStateStep - 1) {
								row.style.backgroundColor = "lightblue";
							} else {
								row.style.backgroundColor = null;
							}
							
							//for (var i=0; i<row.cells.length; i++) {
							//	row.cells[i].style.backgroundColor = "grey";
							//}
						}
						clock();
						return true;
					}

					var timerID = null;
					var secondsPerStep = 1;
					function togglePlay() {
						if (document.getElementById('navigation_play').title == 'pause') {
							// state is on play (because "pause" is shown)
							if(timerID != null) {
								clearTimeout(timerID);
								timerID = null;
							}								
							document.getElementById('navigation_play').title = 'auto play';
							imgSrc = document.getElementById('navigation_img_play').src;
							imgSrc = imgSrc.replace(/pause\.png/, "play.png"); 
							document.getElementById('navigation_img_play').src = imgSrc;
						} else {
							document.getElementById('navigation_play').title = 'pause';
							imgSrc = document.getElementById('navigation_img_play').src;
							imgSrc = imgSrc.replace(/play\.png/, "pause.png"); 
							document.getElementById('navigation_img_play').src = imgSrc;
							autoShowNextState(secondsPerStep);
						}
					}
					
					function autoShowNextState(seconds) {
							if (showState('next')) { // next state actually exists
								timerID = setTimeout("autoShowNextState("+seconds+");", seconds*1000);
							} else {
								togglePlay();
							}
					}

					var HTTP_GET_VARS = new Array();
					var strGET = document.location.search.substr(1,document.location.search.length);
					if(strGET!='') {
						gArr=strGET.split('&');
						for(i=0;i<gArr.length;++i) {
							v='';vArr=gArr[i].split('=');
							if(vArr.length>1) { v=vArr[1]; }
							HTTP_GET_VARS[unescape(vArr[0])]=unescape(v);
						}
					}
					
					function GET(v) {
						if(!HTTP_GET_VARS[v]){return 'undefined';}
						return HTTP_GET_VARS[v];
					}

					if ( GET('seconds') != 'undefined' ) {
						secondsPerStep = GET('seconds');
						togglePlay(); // state is "pause" by default so toggling will start the "auto play"
					}

					]]>
					// --&gt;
				</script>
			</head>

			<body onload="showState('final');">
				
				<xsl:call-template name="header" />
				
				<table>
					<tr>
						<td style="padding: 10px; vertical-align: top;">
							<xsl:for-each select="match/states/state">
								<div class="state" style="display:none">
									<xsl:attribute name="id">state_<xsl:value-of select="position()"/></xsl:attribute>
									<xsl:call-template name="print_state"/>
								</div>
							</xsl:for-each>
							
						</td>
						<td style="padding: 10px; vertical-align: top;">
							<xsl:call-template name="playClock" />
							<!--<br/>-->
							<xsl:call-template name="playerInfo"/>
							<!--<br/>-->
							<xsl:call-template name="history"/>
						</td>
					</tr>
				</table>

				<xsl:call-template name="footer"/>
			</body>
		</html>

	</xsl:template>

</xsl:stylesheet>
