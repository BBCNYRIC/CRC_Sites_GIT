

<!--- <cfquery datasource="#datasource#" name="newslinks">
SELECT contacts.description, contacts.tid, teacher.homepage, pageatt.title
FROM contacts, teacher, pageatt
WHERE teacher.tid = contacts.tid
	AND pageatt.tid = contacts.tid
	AND teacher.fname <> 'TVOID'
	AND contacts.hidepage = 'no'
	AND contacts.accessgroup = 10
ORDER BY contacts.rankorder, contacts.description
</cfquery> --->

<!--- query for page attributes --->
<cfquery name="common" datasource="#datasource#">
SELECT *
FROM pageatt pa
WHERE pa.tid = <cfqueryparam value="918" cfsqltype="CF_SQL_INTEGER"></cfquery>

<cfset getaccgp.accessgroup = 13>
<cfinclude template="header.cfm">
<cfinclude template="navtable.cfm"><br>

<table width="100%" border="0" cellspacing="0" cellpadding="5">

<tr>

<td valign="top">
<table cellpadding="10"><tr><td><cfoutput>#common.body#</cfoutput></td></tr></table>


</td>


</tr>

<tr><td height="1" bgcolor="#000000" colspan="2"></td></tr>

<tr><td colspan="2">
<!--- district news table --->
<table border="0" cellspacing="0" cellpadding="3">
<!--- <tr><td colspan="2"><h3>Professional Development News and Opportunities</h3></td></tr> --->


<tr bgcolor="ffffff"><td><img src="http://www.marcellusschools.org/images/spacer.gif" width="11" height="1" border="0"></td>
<td><cfinclude template="readXMLfullPD.cfm"></td></tr>

</table>
</td></tr>


</table>

<br><br><cfinclude template="footer.cfm">
