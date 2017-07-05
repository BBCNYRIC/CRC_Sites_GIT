<cfif NOT isdefined("FORM.elt")><cflocation url="http://www.cnyric.org" addtoken="No"><cfabort></cfif>

<cfif FORM.rankorder EQ ""><cfset FORM.rankorder=99></cfif>

<cfparam name="FORM.newwindow" default="no">


<!--- check to see if user is adding the element --->
<cfquery datasource="#datasource#">
	<cfif #FORM.elt# IS "ann">
	
	<!--- too long for database --->
	<cfif Len(FORM.addtext) GT 1052>
		<cfinclude template="../header.cfm">
		<cfinclude template="../navtable.cfm"><br>
			&nbsp;&nbsp;Your announcement text is too long.  Please limit announcement to 1000 characters including any link URL.  Use your Back button to return to the announcement page.
		
		<br><br><cfinclude template="../footer.cfm"></body></html>
	<cfabort>
	</cfif>
		INSERT INTO tpageann (tid, ann_text, ann_header, rankorder)
		VALUES (<cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">,
				<cfqueryparam value="#Trim(FORM.addtext)#" cfsqltype="CF_SQL_CHAR">,
				<cfqueryparam value="#Trim(FORM.ann_header)#" cfsqltype="CF_SQL_CHAR">,
				<cfqueryparam value="#Trim(FORM.rankorder)#" cfsqltype="CF_SQL_INTEGER">)
	<!--- <cfelseif #FORM.addtype# IS "cal">
		INSERT INTO schcal (tid, eventtext, eventdate)
		VALUES (<cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">,
				<cfqueryparam value="#Trim(FORM.addtext)#" cfsqltype="CF_SQL_CHAR">,
				<cfqueryparam value="#DateFormat(FORM.eventdate,'MM/DD/YYYY')#" cfsqltype="CF_SQL_DATE">) --->
	<cfelseif #FORM.elt# IS "link">
		INSERT INTO tpagelinks (tid, link_name, link_url, rankorder, newwindow)
		VALUES (<cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">, 
				<cfqueryparam value="#Trim(FORM.addtext)#" cfsqltype="CF_SQL_CHAR">, 
				<cfqueryparam value="#Trim(FORM.link_url)#" cfsqltype="CF_SQL_CHAR">,
				<cfqueryparam value="#Trim(FORM.rankorder)#" cfsqltype="CF_SQL_INTEGER">,
				<cfqueryparam value="#FORM.newwindow#" cfsqltype="CF_SQL_CHAR">)
	</cfif>
</cfquery>


<cflocation url="tmanage#FORM.elt#.cfm" addtoken="No">