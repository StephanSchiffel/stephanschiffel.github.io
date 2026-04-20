<?xml version="1.0" encoding="ISO-8859-1"?>

<!--
	- Widget for drawing play-clock information.
	- Assumes data will be found in
		<match><startclock>...
		<match><playclock>...
		<match><timestamp>...
	- For use within <body>.
	- needs css/main.css and sitespecific.xsl
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:import href="variables.xsl"/>
	
	<xsl:template name="playClock">
		
		<script language="JavaScript" type="text/javascript">
			<![CDATA[
				<!--
					var deadlineForCurrentStep;

					var playClockTimeout = null;

					function clock() {
						if (playClockTimeout) clearTimeout(playClockTimeout);
						if (gameIsOver) {
							document.getElementById("timer").innerHTML="Inactive (Game Over)";
						} else if (currentStateStep != lastStepInMatch) { // we are not looking at the most recent state in the game
							document.getElementById("timer").innerHTML="Inactive (Not the current step)";
						} else {
							deadlineForCurrentStep = matchtimestamp; // in ms
							if(lastStepInMatch == 1) { // we only have the initial state
								deadlineForCurrentStep = deadlineForCurrentStep + (startclock + playclock)*1000;
							} else {
								deadlineForCurrentStep = deadlineForCurrentStep + playclock*1000;
							}
							var now = new Date();
							var seconds_left = Math.round((deadlineForCurrentStep-now.getTime())/1000);
							console.log("clock: deadlineForCurrentStep = " + deadlineForCurrentStep + ", now = " + now.getTime() + ", seconds_left = " + seconds_left);
							if(seconds_left > 0){
								loop();
							}else if(seconds_left > -30) { // game is not over, but was played recently, so we'll just wait a bit longer for the next state
								document.getElementById("timer").innerHTML=""+seconds_left+" (Waiting for next state)";
								playClockTimeout = setTimeout("showState('next');", 2000);
							}else{ // last step of the game is long ago
								document.getElementById("timer").innerHTML="Inactive (Game has stopped)";
							}
						}
					}
					
					function loop() { // updates the countdown timer and eventually causes a reload of the page when the time is up
						var now = new Date();
						var seconds_left = Math.round((deadlineForCurrentStep-now.getTime())/1000);
						document.getElementById("timer").innerHTML=seconds_left;
						if (seconds_left <= 0) {
							playClockTimeout = setTimeout("showState('next');", 1000);
						} else {
							playClockTimeout = setTimeout("loop()", 1000);
						}
					}
					
					function shownextstep() {
						if (playing == 0) {
							showState('next');
						} else {
							document.location.reload();
						}
					}

					// document.body.setAttribute('onLoad', 'clock()');
				// -->
			]]>
		</script>

		<div class="playClock">

			<span class="heading">
				<xsl:choose>
					<xsl:when test="$currentStep=1 and not(/match/ready/timestamp)">Start Clock:</xsl:when>
					<xsl:otherwise>Play Clock:</xsl:otherwise>
				</xsl:choose>
			</span>
			<div class="underline"/>

			<table>
				<tr>
					<td>
						<span class="heading">Remaining:</span>
					</td>
					<td>
						<span class="content" id="timer"></span>
					</td>
				</tr>
			</table>
		</div>

	</xsl:template>
</xsl:stylesheet>
