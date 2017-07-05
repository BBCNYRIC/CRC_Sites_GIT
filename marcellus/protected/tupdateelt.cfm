<cfif NOT isdefined("FORM.elttype")><cflocation url="http://www.cnyric.org" addtoken="No"><cfabort></cfif>


<cfif FORM.rankorder EQ ""><cfset FORM.rankorder=99></cfif>


<cfif #FORM.elttype# IS "ann">

<!--- too long for database --->
	<cfif Len(FORM['ann_text' & FORM.ann_id]) GT 1052>
		<cfinclude template="../header.cfm">
		<cfinclude template="../navtable.cfm"><br>
			&nbsp;&nbsp;Your announcement text is too long.  Please limit announcement to 1000 characters including any link URL.  Use your Back button to return to the announcement page.
		
		<br><br><cfinclude template="../footer.cfm"></body></html>
	<cfabort>
	</cfif>

<cfquery datasource="#datasource#">
UPDATE tpageann
SET ann_header=<cfqueryparam value="#FORM.ann_header#" cfsqltype="CF_SQL_CHAR">,
	ann_text=<cfqueryparam value="#FORM['ann_text' & FORM.ann_id]#" cfsqltype="CF_SQL_CHAR">,
	rankorder=<cfqueryparam value="#FORM.rankorder#" cfsqltype="CF_SQL_INTEGER">
WHERE ann_id = <cfqueryparam value="#FORM.ann_id#" cfsqltype="CF_SQL_INTEGER">
	AND tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>
<cflocation url="tmanageann.cfm" addtoken="No">

<cfelseif #FORM.elttype# IS "link">
<cfquery datasource="#datasource#">
UPDATE tpagelinks
SET link_name=<cfqueryparam value="#FORM.link_name#" cfsqltype="CF_SQL_CHAR">,
	link_url=<cfqueryparam value="#FORM.link_url#" cfsqltype="CF_SQL_CHAR">,
	rankorder=<cfqueryparam value="#FORM.rankorder#" cfsqltype="CF_SQL_INTEGER">
WHERE link_id = <cfqueryparam value="#FORM.link_id#" cfsqltype="CF_SQL_INTEGER">
	AND tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>
<cflocation url="tmanagelink.cfm" addtoken="No">

<cfelseif #FORM.elttype# IS "file">

<cfparam name="FORM.showLink" default="No">

<cfquery datasource="#datasource#">
UPDATE tfiles
SET linkname=<cfqueryparam value="#FORM.linkname#" cfsqltype="CF_SQL_CHAR">,
	rankorder=<cfqueryparam value="#FORM.rankorder#" cfsqltype="CF_SQL_INTEGER">,
	showLink=<cfqueryparam value="#FORM.showLink#" cfsqltype="CF_SQL_CHAR">
WHERE file_id = <cfqueryparam value="#FORM.file_id#" cfsqltype="CF_SQL_INTEGER">
	AND tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<!--- if they are resizing an image --->
<cfif isdefined("FORM.piclist")>
<cfinclude template="resizeImages.cfm">

</cfif>

<cflocation url="tmanagefile.cfm" addtoken="No">

<!--- <cfelseif #FORM.elttype# IS "cal">
<cfquery datasource="#datasource#">
UPDATE schcal
SET eventtext=<cfqueryparam value="#FORM.eventtext#" cfsqltype="CF_SQL_CHAR">,
	eventdate=<cfqueryparam value="#DateFormat(FORM.eventdate,'MM/DD/YYYY')#" cfsqltype="CF_SQL_DATE">
WHERE eventID = <cfqueryparam value="#FORM.eventID#" cfsqltype="CF_SQL_INTEGER">
	AND tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>
<cflocation url="tmanagecal.cfm" addtoken="No"> --->

<cfelse>
<cflocation url="teditpage.cfm" addtoken="No">
</cfif>

