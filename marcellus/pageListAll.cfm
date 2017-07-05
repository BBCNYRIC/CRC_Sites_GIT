<cfquery datasource="#datasource#" name="getlist">
SELECT *
FROM contacts, teacher, accessgroup, pageatt
WHERE teacher.tid = contacts.tid
	AND pageatt.tid = contacts.tid
	AND accessgroup.groupid = contacts.accessgroup
	AND contacts.userlogin = 'VOID'
	AND iscat = 'yes'
	AND ISNULL(pageatt.showDateFrom, '1/1/1900') <= <cfqueryparam value="#DateFormat(Now())#" cfsqltype="CF_SQL_DATE">
	AND ISNULL(pageatt.showDateTo, '1/1/2025') >= <cfqueryparam value="#DateFormat(Now())#" cfsqltype="CF_SQL_DATE">
ORDER BY accessgroup.groupname,rankorder, contacts.description
</cfquery>

<cfinclude template="header.cfm">
<cfinclude template="navtable.cfm">
<table width="90%" border="0" cellspacing="0" cellpadding="6" align="left">

	
	<cfoutput query="getlist" group="accessgroup">
	<tr><td align="left">
	#groupname# - <br>
	<blockquote>
	<cfoutput>
	
	<cfif homepage IS "default">
		<a href="/teacherpage.cfm?teacher=#tid#">
	<cfelse><a href="#homepage#"></cfif>
	#description#</a> <cfif hidepage EQ 'yes'>(hidden)</cfif><br>
	</cfoutput></blockquote>
	</td></tr>
	</cfoutput>
	
<!--- <div align="center">The OCS website has <cfoutput>#NumberFormat(totalhits.hitcounttot,',')#</cfoutput> hits.</div> --->
</table>
<cfinclude template="footer.cfm"></body>
</html>
