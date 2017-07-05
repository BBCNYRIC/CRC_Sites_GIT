

<!--- make sure our variable for when the database was last looked at exists.  default to -2 days, so it will be triggered now to refresh --->
<cfparam name = "application.staffDBcreated" default = #DateAdd('D',-1,Now())#>
 <!--- <cfoutput>#application.staffDBcreated# -  </cfoutput> --->

<!--- if database hasn't been refreshed in a day or more, refresh it now --->
<cfif #DateDiff('D',Now(),application.staffDBcreated)# LT 0>

<!--- read in date, cf automatically puts results in a query --->
<cfhttp method="get" url="http://www.marcellusschools.org/tfiles/folder1623/staff.csv" name="application.csvData">

<cfset application.staffDBcreated = #Now()#>


</cfif><!--- <cfoutput>#application.staffDBcreated# -  </cfoutput> --->


<!--- <cfdump var="#application.csvData#"><cfabort> --->


<!--- set search variables in session scope so we can keep them across next n records clicks --->
<cfif isdefined("FORM.fname")>
	<cfset session.formdataFname = #LCase(FORM.fname)#></cfif>
<cfif isdefined("FORM.lname")>
	<cfset session.formdataLname = #LCase(FORM.lname)#></cfif>
<cfif isdefined("FORM.location")>
	<cfset session.formdataLocation = #LCase(FORM.location)#></cfif>
<!--- <cfif isdefined("FORM.dept")>
	<cfset session.formdataPosition = #LCase(FORM.dept)#></cfif> --->
<cfif isdefined("URL.building")>
	<cfset session.formdataLocation = #LCase(URL.building)#></cfif>
	
	
<!--- clear search criteria --->
<cfif isdefined("URL.cleardata")>
	<cfset StructDelete(Session, "formdataFname")>
	<cfset StructDelete(Session, "formdataLname")>
	<cfset StructDelete(Session, "formdataPosition")>
	<cfset StructDelete(Session, "formdataLocation")>
</cfif>

<!--- query our application query for our specific data --->
<cfquery name="staffQuery" dbtype="query" cachedWithin="#CreateTimeSpan(0,1,0,0)#">
SELECT *
FROM application.csvData
WHERE 0=0
<cfif isdefined("session.formdataFname")>
	AND lower(FirstName) LIKE <cfqueryparam value="%#session.formdataFname#%" cfsqltype="CF_SQL_CHAR"> </cfif>
<cfif isdefined("session.formdataLname")>
	AND lower(LastName) LIKE <cfqueryparam value="%#session.formdataLname#%" cfsqltype="CF_SQL_CHAR"> </cfif>
<cfif isdefined("session.formdataLocation")>
	AND lower(bldg) LIKE <cfqueryparam value="%#session.formdataLocation#%" cfsqltype="CF_SQL_CHAR"> </cfif>
<!--- <cfif isdefined("session.formdataPosition")>
	AND lower(Position) LIKE <cfqueryparam value="%#session.formdataPosition#%" cfsqltype="CF_SQL_CHAR"> </cfif> --->
ORDER BY 
<cfif isdefined("URL.sort")>
	<cfswitch expression=#URL.sort#>
		<cfcase value="lastname">LastName</cfcase>
		<cfcase value="building">bldg</cfcase>
		
		<cfdefaultcase>LastName, FirstName</cfdefaultcase>
	</cfswitch>
<cfelse>LastName, FirstName
</cfif>

</cfquery>

<!--- <cfdump var="#staffQuery#"> --->


<!--- query our application query for our specific data --->
<cfquery name="locQuery" dbtype="query" cachedWithin="#CreateTimeSpan(1,0,0,0)#">
SELECT DISTINCT bldg
FROM application.csvData
WHERE bldg <> ''
ORDER BY bldg
</cfquery>


<cfinclude template="header.cfm">
<cfinclude template="navtable.cfm"><br>






<!--- <table border="0" cellspacing="0" width="95%" align="center"><tr><td>Click on a column heading to sort by that column</td></tr></table> --->

<table width="99%" border="0" cellspacing="0" cellpadding="3" align="center" class="LL RL TL">

<tr><td align="left">



<!--- set other vars in case they arent set --->
<cfparam name="session.formdataFname" default="">
<cfparam name="session.formdataLname" default="">
<cfparam name="session.formdataLocation" default="">
<cfparam name="session.formdataPosition" default="">



<!--- <cfdump var="#session#"> --->


<table id="hidetext" bgcolor="e2e2e2" class="TL BL RL LL" width="100%" border="0">
<!--- search table --->
<cfform action="#CGI.SCRIPT_NAME#" method="POST">
<tr><td>
First name&nbsp;&nbsp; <cfinput type="Text" name="fname" value="#session.formdataFname#" required="No" size="15" maxlength="50" class="gl_textbox"></td>
<td>
Last name&nbsp;&nbsp; <cfinput type="Text" name="lname" value="#session.formdataLname#" required="No" size="15" maxlength="50" class="gl_textbox"></td>
<td>
Location&nbsp;&nbsp;
<select name="location">
<option value="">Any</option>
<cfoutput query="locQuery">
<option value="#bldg#" <cfif isdefined("session.formdataLocation")><cfif session.formdataLocation EQ #bldg#>selected</cfif></cfif>>#bldg#</option>
</cfoutput>
</select>
<!--- <select name="location">
<option value="">Any</option>
<option value="Baker">Baker High School</option>
<option value="Durgee">Durgee Junior High School</option>
<option value="Elden">Elden Elementary</option>
<option value="McNamara">McNamara Elementary</option>
<option value="Palmer">Palmer Elementary</option>
<option value="Ray">Ray Middle School</option>
<option value="Reynolds">Reynolds Elementary</option>
<option value="VanBuren">VanBuren Elementary</option>
<option value="Administrative">Administrative Office</option>
</select> --->
</td><!--- <td>

Department&nbsp;&nbsp; 
<select name="dept">
<option value="">Any</option>
<cfoutput query="deptQuery">
<option value="#department#">#department#</option>
</cfoutput>
</select>

</td> ---></tr>

<tr><td colspan="2"><input type="submit" class="gl_submit" value="  Search  ">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="getstaff.cfm?cleardata=t"><font size="-2">Clear search criteria</font></a>
</td></tr>
</cfform>




</table>

</td></tr>


<tr><td>

<cfif isdefined("URL.sort")>
	<cfset variables.URLSortAddOn = "&sort=#URL.sort#">
<cfelse><cfset variables.URLSortAddOn = "">
</cfif>

<!--- next n records code --->
<cfparam name="URL.currentPage" type="numeric" default="1">

<cfif URL.currentPage NEQ 1>
<a href="getstaff.cfm?currentPage=<cfoutput>#Evaluate(URL.currentPage - 1)##variables.URLSortAddOn#</cfoutput>">&lt;&lt; Previous</a>&nbsp;&nbsp;&nbsp;&nbsp;</cfif>

<cfif staffQuery.recordcount GT (URL.currentPage * 50)>
<a href="getstaff.cfm?currentPage=<cfoutput>#IncrementValue(URL.currentPage)##variables.URLSortAddOn#</cfoutput>">Next &gt;&gt;</a></cfif>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Viewing <cfoutput>#Evaluate(URL.currentPage * 50 - 49)# - #Min((Evaluate(URL.currentPage * 50)),staffQuery.RecordCount)# of #staffQuery.RecordCount# results</cfoutput>
</td></tr>
</table>

<table width="99%" border="0" cellspacing="0" cellpadding="5" align="center" class="LL RL TL BL">

<cfif isdefined("URL.building")><cfset variables.urlinj = "&building=#URL.building#"><cfelse><cfset variables.urlinj = ""></cfif>
<tr bgcolor="#d2d2d2">
<cfoutput><td align="left"><strong><a href="#CGI.SCRIPT_NAME#?sort=lastname#variables.urlinj#">Name</a></strong></td>
<td align="left"><strong><a href="#CGI.SCRIPT_NAME#?sort=building#variables.urlinj#">Location</a></strong></td>
<td align="left" nowrap><strong>Job Position</strong></td></cfoutput>
<!--- <td align="left"><strong>Phone</strong></td> --->
<td align="left"><strong>Email</strong></td>
<!--- <td align="left"><strong>Department</strong></td> --->
<!--- <td align="left"><strong>Website</strong></td> --->
</tr>

<cfoutput query="staffQuery" startrow="#Evaluate(URL.currentPage * 50 - 49)#" maxrows=50>
	<cfif CurrentRow MOD 2 IS 1>
	<cfset bgcolor="f2f2f2">
	<cfelse><cfset bgcolor="ffffff"></cfif>
<tr class="staffListTableRow" bgcolor="#bgcolor#">

<td align="left" nowrap>#LastName#, #FirstName#</td>
<td align="left">#bldg#</td>
<td align="left">#type#</td>
<!--- <td align="left" nowrap>#ReplaceNoCase(workphone,'315/','')#</td> --->

<td align="left"><cfif (email NEQ "") AND (Find('@', email))>
<cfset variables.emailfirst="#Mid(email, 1, (Find('@', email)-1))#">
<cfset variables.emaillast="#Mid(email, Find('@', email), Len(email))#">

<script language="JavaScript">
<!--
document.write("<a href=mailto:");
document.write("#variables.emailfirst#");
document.write("#variables.emaillast#>");
//-->
</script>
#variables.emailfirst#
</a>
</cfif></td>

<!--- <td align="left">#DEPARTMENT#</td> --->

<!--- <td align="left"><cfif (email NEQ "") AND (Find('@', email))>

<!--- need to query our database to get their website link because we can't use JOIN in a query of queries --->
<cfquery name="getPageID" datasource="#datasource#">
SELECT teacher.homepage, contacts.tid
FROM teacher LEFT JOIN contacts ON contacts.tid = teacher.tid
WHERE userlogin = <cfqueryparam value="#variables.emailfirst#" cfsqltype="CF_SQL_CHAR">
</cfquery>

<cfif getPageID.recordcount EQ 1>

<cfif #getPageID.homepage# EQ 'default'>
<a href="teacherpage.cfm?teacher=#getPageID.tid#">Website</a>
<cfelseif #getPageID.homepage# NEQ ''>
<a href="#getPageID.homepage#">Website</a>
</cfif>

</cfif>

</cfif></td> --->

</tr>
</cfoutput>

<!--- next n records code --->
<tr bgcolor="d2d2d2"><td colspan="6">

<cfif URL.currentPage NEQ 1>
<a href="getstaff.cfm?currentPage=<cfoutput>#Evaluate(URL.currentPage - 1)##variables.URLSortAddOn#</cfoutput>">&lt;&lt; Previous</a>&nbsp;&nbsp;&nbsp;&nbsp;</cfif>

<cfif staffQuery.recordcount GT (URL.currentPage * 50)>
<a href="getstaff.cfm?currentPage=<cfoutput>#IncrementValue(URL.currentPage)##variables.URLSortAddOn#</cfoutput>">Next &gt;&gt;</a></cfif>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Viewing <cfoutput>#Evaluate(URL.currentPage * 50 - 49)# - #Min((Evaluate(URL.currentPage * 50)),staffQuery.RecordCount)# of #staffQuery.RecordCount# results</cfoutput>
</td></tr>


</table>


<br><br><cfinclude template="footer.cfm">
</body></html>
