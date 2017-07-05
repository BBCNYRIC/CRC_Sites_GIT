
<cfparam name="getaccgp.accessgroup" default="0">
<cfparam name="variables.URLadd2" default="">

<!--- if its a teacher page, query for their other pages, otherwise query pages for that group --->
<cfif getaccgp.accessgroup EQ 'teacherpage'><!--- var set in districtpage.cfm --->

<!--- <cfdump var="#common#">
<cfoutput>sdfsdf#common.owner#</cfoutput><cfabort> --->

<cfquery datasource="#datasource#" name="getcats">
SELECT contacts.description, contacts.tid, teacher.homepage, pageatt.tid, pageatt.showDateFrom, pageatt.showDateTo, pageatt.newwindow
FROM contacts, teacher, pageatt
WHERE teacher.tid = contacts.tid
	AND pageatt.tid = contacts.tid
	AND contacts.hidepage = 'no'
	AND ISNULL(pageatt.showDateFrom, '1/1/1900') <= <cfqueryparam value="#DateFormat(Now())#" cfsqltype="CF_SQL_DATE">
	AND ISNULL(pageatt.showDateTo, '1/1/2025') >= <cfqueryparam value="#DateFormat(Now())#" cfsqltype="CF_SQL_DATE">
	
	<!--- if its a teacher subpage --->
	<cfif common.fname EQ 'TVOID'>
	AND (teacher.owner = <cfqueryparam value="#common.owner#" cfsqltype="CF_SQL_INTEGER">
	OR teacher.tid = <cfqueryparam value="#common.owner#" cfsqltype="CF_SQL_INTEGER">)
	<!--- otherwise its the teachers main account --->
	<cfelse>
	AND (teacher.owner = <cfqueryparam value="#common.tid#" cfsqltype="CF_SQL_INTEGER">
	OR teacher.tid = <cfqueryparam value="#common.tid#" cfsqltype="CF_SQL_INTEGER">)
	</cfif>
	
ORDER BY contacts.rankorder, contacts.description
</cfquery>


<!--- not a teacher page --->
<cfelse>

<!--- here we do the query for left side links --->

<!--- if its the district news cat, show the main links instead of all the news stories --->
<cfif getaccgp.accessgroup EQ 10>
	<cfset getaccgp.accessgroup = 2></cfif>


<!--- its a protected page, set extra URL variable --->
<cfif getaccgp.accessgroup EQ 999>
	<cfset variables.URLadd2 = "protected/">
<!--- <cfelse>
	<cfset variables.URLadd2 = ""> --->
</cfif>

<cfquery datasource="#datasource#" name="getcats">
SELECT contacts.description, teacher.template, contacts.tid, teacher.homepage, pageatt.tid, pageatt.showDateFrom, pageatt.showDateTo, pageatt.newwindow
FROM contacts, teacher, pageatt
WHERE teacher.tid = contacts.tid
	AND pageatt.tid = contacts.tid
	AND teacher.fname <> 'TVOID'
	AND contacts.hidepage = 'no'
	AND ISNULL(pageatt.showDateFrom, '1/1/1900') <= <cfqueryparam value="#DateFormat(Now())#" cfsqltype="CF_SQL_DATE">
	AND ISNULL(pageatt.showDateTo, '1/1/2025') >= <cfqueryparam value="#DateFormat(Now())#" cfsqltype="CF_SQL_DATE">
	AND contacts.accessgroup = <cfif getaccgp.accessgroup NEQ 0>#getaccgp.accessgroup#<cfelse>2</cfif>
ORDER BY contacts.rankorder, contacts.description
</cfquery>

</cfif>


<table width="200" height="400" border="0" align="left" cellpadding="0" cellspacing="0">
  <tr>
  <td valign="top" width="<cfif getcats.recordcount NEQ 0>20</cfif>0">
  <!--- navigation table --->
  
  
<cfif getcats.recordcount NEQ 0>
<!--- left side table --->
<table width="200" cellspacing="0" cellpadding="5">
<!--- <tr><td><img src="/images/spacer.gif" width="170" height="1" alt="" border="0">
<strong><font color="#b80808">Quicklinks</font></strong></td></tr> --->
		
		<cfoutput query="getcats">
		<tr><td valign="middle" width="200" align="right">
		
<cfif homepage IS "default">
		<a href="/teacherpage.cfm?teacher=#tid#" class="mainpagenav2" <cfif newwindow EQ 'yes'>target="_blank"</cfif>>
<cfelse><a href="#homepage#" class="mainpagenav2" <cfif newwindow EQ 'yes'>target="_blank"</cfif>></cfif>
<img src="/images/spacer.gif" width="12" height="1" border="0">#description# ::</a>

		</td>
		<td width="10"></td>
		</tr></cfoutput>

</table></cfif>
	
	
	
	
	</td></tr></table>
  
</td><!--- end td for navigation --->
<td valign="top" bgcolor="ffffff" align="left"><!--- td for content --->
  
  <!--- actual content here --->