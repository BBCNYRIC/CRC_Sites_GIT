<!--- random photo --->
			
	<!--- set a var to keep track of which ones we've already used --->
	<cfparam name="variables.used" default="">
	<cfparam name="variables.picnum" default="0">
	<!--- get all pics in the directory --->
	<cfdirectory action="list" directory="F:\Inetpub\wwwroot\CRC_SITES\Marcellus\tfiles\folder502" name="getimg">
<cfif getimg.recordcount GTE 5>
	<cfloop condition="variables.picnum LT 5">
		
	<!--- get a random number --->
	<cfset variables.randnum = RandRange(1, #getimg.recordcount#)>
	<cfoutput query="getimg">
		<cfif (#variables.randnum# EQ #currentrow#) AND (NOT Find(",#currentrow#,", #variables.used#))>
		<img src="http://www.marcellusschools.org/tfiles/folder502/#name#" alt="" border=1 height=130 width=130>
			<!--- how many pics we have so far --->
		<cfset "variables.picnum" = #variables.picnum# + 1>
			<!--- add pic we just used to our list --->
		<cfset "variables.used" = Insert(",#currentrow#,", #variables.used#, 0)>
		 </cfif>
	</cfoutput>
	</cfloop>
</cfif>

	
<!--- 	<img src="http://www.marcellusschools.org/tfiles/folder484/girlslax.jpg" alt="" border=1 height=130 width=130>
		<img src="http://www.marcellusschools.org/tfiles/folder484/irby.JPG" alt="" border=1 height=130 width=130>
		<img src="http://www.marcellusschools.org/tfiles/folder484/jackiec.JPG" alt="" border=1 height=130 width=130>
		<img src="http://www.marcellusschools.org/tfiles/folder484/football.JPG" alt="" border=1 height=130 width=130>
		<img src="http://www.marcellusschools.org/tfiles/folder484/marlene.jpg" alt="" border=1 height=130 width=130> --->

	<!--- <img src="http://www.marcellusschools.org/images/title.gif" width="710" height="130" border=0> --->