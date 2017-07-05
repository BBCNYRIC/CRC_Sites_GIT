<cfquery datasource="#datasource#" name="getlist">
SELECT *
FROM contacts, teacher, accessgroup, pageatt
WHERE teacher.tid = contacts.tid
	AND pageatt.tid = contacts.tid
	AND accessgroup.groupid = contacts.accessgroup
	AND contacts.userlogin = 'VOID'
	AND contacts.hidepage = 'no'
	AND iscat = 'yes'
	AND ISNULL(pageatt.showDateFrom, '1/1/1900') <= <cfqueryparam value="#DateFormat(Now())#" cfsqltype="CF_SQL_DATE">
	AND ISNULL(pageatt.showDateTo, '1/1/2025') >= <cfqueryparam value="#DateFormat(Now())#" cfsqltype="CF_SQL_DATE">
ORDER BY accessgroup.groupname,rankorder, contacts.description
</cfquery>

<cfinclude template="header.cfm">
<cfinclude template="navtable.cfm">


	
	<cfoutput query="getlist" group="accessgroup">
	#groupname# - <br>
	<blockquote>
	<cfoutput>
	
	<cfif homepage IS "default">
		<a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=#tid#">
	<cfelse><a href="#homepage#"></cfif>
	#description#</a><br>
	</cfoutput></blockquote></cfoutput>
	


<cfinclude template="footer.cfm"></body>
</html>
