
<!--- here we do the query for left side links --->
<!--- <cfparam name="getaccgp.accessgroup" default="0">
<cfquery datasource="#datasource#" name="getnews">
SELECT contacts.description, teacher.template, contacts.tid, teacher.homepage
FROM contacts, teacher
WHERE teacher.tid = contacts.tid
	AND contacts.accessgroup = <cfif getaccgp.accessgroup NEQ 0>#getaccgp.accessgroup#<cfelse>2</cfif>
	AND userlogin <> 'TVOID'
	AND contacts.hidepage = 'no'
ORDER BY contacts.rankorder, contacts.description
</cfquery> --->
<td align=left valign=top width="0" bgcolor="006633">
	<!--- <table bgcolor="#006633" border=0 width="100%">
<tr><td><img src="http://www.marcellusschools.org/images/spacer.gif" width="160" height="1" border="0"></td></tr>
<cfoutput query="getnews">
<tr>
<cfif homepage IS "default">
		<a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=#tid#" class=sidenav>
	<cfelse><a href="#homepage#" class=sidenav></cfif>
	<td>

&nbsp;
	<cfif homepage IS "default">
		<a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=#tid#" class=sidenav>
	<cfelse><a href="#homepage#" class=sidenav></cfif>
		#description#</a></td></a></tr>
</cfoutput></table> --->


<!--- rest of this should be in header --->
</td>
	
	<!--- black line --->
	<td width=2 align=left bgcolor=#333333></td>
	
	<td valign=top align=left bgcolor=#ffffff>
	<!--- main content area --->
	
	
	<table width="100%" border="0" cellspacing="0" cellpadding="2" align="left"><tr><td>
<!--- content here --->