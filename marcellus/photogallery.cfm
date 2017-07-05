
<cfparam name=URL.teacher default="39">
<cfquery datasource="#datasource#" name="athimages">
SELECT *
FROM tfiles
WHERE (filetype = 'gif' OR 
		filetype = 'jpg' OR 
		filetype = 'jpeg' OR 
		filetype = 'tif')
	AND tid = <cfqueryparam value="#URL.teacher#" cfsqltype="CF_SQL_INTEGER">
	AND linkname=''
</cfquery>


<cfset rowsperpage = 15>
<cfparam name="URL.startrow" default="1" type="numeric">
<cfset totalrows = athimages.recordcount>
<cfset endrow = Min(URL.startrow + rowsperpage - 1, totalrows)>
<cfset startrownext = endrow + 1>
<cfset startrowback = URL.startrow - rowsperpage>

<cfinclude template="header.cfm">
<cfinclude template="navtable.cfm">


	
	<table width="100%" border="0" cellspacing="0" cellpadding="10" align="center"><tr><td valign="top">
<table width="100%" border="0" cellspacing="0" cellpadding="3" align="center">
	
	<tr><td colspan=5><cfoutput>Displaying #URL.startrow# to #endrow# of #totalrows# pictures</cfoutput></td></tr>
	
<cfloop query="athimages" startrow="#URL.startrow#" endrow=#endrow#>
<cfoutput><cfif (#currentrow#-1) MOD 5 EQ 0><tr></cfif>
<td>
<a href="picexpand.cfm?img_id=#file_id#&teacher=#URL.teacher#">
<img src="http://www.marcellusschools.org/tfiles/folder#URL.teacher#/#URLEncodedFormat(filename)#" width="100" height="100" alt="Click to expand" border=1>
</a></td>
<cfif #currentrow# MOD 5 EQ 0></tr></cfif>

</cfoutput>
</cfloop>
	
	<tr><td>
	<cfoutput>
	<cfif startrowback GT 0>
		<a href="#CGI.SCRIPT_NAME#?startrow=#startrowback#&teacher=#URL.teacher#">Back</a>&nbsp;&nbsp;&nbsp;&nbsp;</cfif>
	<cfif startrownext LTE totalrows>
		<a href="#CGI.SCRIPT_NAME#?startrow=#startrownext#&teacher=#URL.teacher#">Next</a></cfif></cfoutput>
	</td></tr>
	
	<tr><td colspan=5>Jump to page:&nbsp;&nbsp;&nbsp;&nbsp;
	<cfset thispage=1>
	<cfloop from="1" to="#totalrows#" step="#rowsperpage#" index="pagerow">
		<cfset iscurrentpage = (pagerow GTE URL.startrow) AND (pagerow LTE endrow)>
		<cfif iscurrentpage>
			<cfoutput>#thispage#&nbsp;&nbsp;</cfoutput>
		<cfelse>
			<cfoutput><a href="#CGI.SCRIPT_NAME#?startrow=#pagerow#&teacher=#URL.teacher#">#thispage#</a>&nbsp;&nbsp;</cfoutput>
		</cfif>
		<cfset thispage = thispage + 1>
	</cfloop>
	</td></tr>
	
	</table>

</td></tr></table>
	
	

<cfinclude template="footer.cfm"></body>
</html>
