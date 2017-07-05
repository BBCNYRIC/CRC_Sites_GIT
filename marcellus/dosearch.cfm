
<cfif isdefined("form.searchcr")>

<cfset variables.searchcr = #FORM.searchcr#>

<!--- Get teacher list from database --->
<cfquery name="teachers" datasource="#datasource#" cachedWithin="#CreateTimeSpan(0,6,0,0)#">
SELECT body, title, description, heading1, heading2, filesheading, homepage, pageatt.tid, lastupdate
FROM pageatt, teacher
WHERE pageatt.tid = teacher.tid
</cfquery>
<cfelse><cflocation url="search.cfm" AddToken="No">
</cfif>

<cfinclude template="header.cfm">
<cfinclude template="navtable.cfm"><br>

<table width="100%" border="0" cellpadding="5">
<tr>
<cfform action="dosearch.cfm" name="searchform" id="searchform">

<td nowrap valign="center"><img src="http://www.cnyric.org/images/binocularsicon.png" align="absMiddle" width="67" height="42"> <font size="4">Search Results</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Search again: <cfinput type="Text" name="searchcr" size="35" required="yes" message="Please enter search criteria" value="#FORM.searchcr#">
<input type="submit" name="submit" value="Search" class="gl_submit">

</td></cfform>
</tr>

<tr>
<td class="righttable"><div align="center"><b>----- Exact Matches -----</b></div></td>
</tr>

<cfset variables.usedPages = "">
<cfset variables.bgcolorSwitch = "1">

<!--- our first run through will search for the whole search string, these will be our best matches --->
<cfoutput query="teachers">

<!--- do the search --->
<cfif findNoCase(#variables.searchcr#,#REReplaceNoCase(body,"<[^>]*>","","ALL")#)
   OR findNoCase(#variables.searchcr#,#REReplaceNoCase(title,"<[^>]*>","","ALL")#)
   OR findNoCase(#variables.searchcr#,description)
   OR findNoCase(#variables.searchcr#,heading1)
   OR findNoCase(#variables.searchcr#,heading2)
   OR findNoCase(#variables.searchcr#,filesheading)>

<!--- we have found a match, add this record to our list of hit --->
<cfset variables.usedPages = #listAppend(variables.usedPages,tid)#>

<cfif variables.bgcolorSwitch EQ "1">
	<cfset variables.bgcolor = "ffffff">
	<cfset variables.bgcolorSwitch = "2">
<cfelse>
	<cfset variables.bgcolor = "e2e2e2">
	<cfset variables.bgcolorSwitch = "1">
</cfif>

<tr bgcolor="#variables.bgcolor#" class="staffListTableRow">
<td>
<!--- output correct link to teachers homepage --->
<cfif teachers.homepage NEQ "">

<!--- set length of the body text, with html chars stripped for later use --->
<cfset bodyLen = Len(REReplaceNoCase(body,"<[^>]*>","","ALL"))>

	<cfif teachers.homepage IS "default">
		<a href="teacherpage.cfm?teacher=#tid#">		
	<cfelse><a href="#homepage#"></cfif>
	
	<!--- if title is defined, use it --->
	<cfif description NEQ "">#description#
	<cfelseif title NEQ "">#REReplaceNoCase(title,"<[^>]*>","","ALL")#

	<cfelse>
		<cfif body EQ "">Webpage
		<cfelse>
				<!--- if body is all html code --->
			<cfif bodyLen NEQ 0>
			#Left(REReplaceNoCase(body,"<[^>]*>","","ALL"),Min(50,bodyLen))#
			<cfelse>Webpage</cfif>
		</cfif>
	</cfif></a><br>
	
	<cfif lastupdate NEQ ""><font size="-2" color="##999999">Last updated on #DateFormat(lastupdate,'M/D/YYYY')#</font><br></cfif>
	
	<cfif bodyLen NEQ 0>
		<font size="-1">#Left(REReplaceNoCase(body,"<[^>]*>","","ALL"),Min(300,bodyLen))# ...</font><br><br>
	</cfif>
	
</cfif></td>
</tr>
</cfif>
</cfoutput>

<cfif variables.usedPages EQ "">
<tr bgcolor="#ffffff"><td>No exact matches found</td></tr></cfif>

<!--- no need to do a secondary search on one word searches --->
<cfif listLen(variables.searchcr,' ') GT 1>
<tr>
<td class="righttable"><div align="center"><b>----- Partial Matches -----</b></div></td>
</tr>


<!--- our second run through will search for each word in the search string individually, these are our secondary matches --->

<cfoutput query="teachers">

<!--- first make sure we didn't already include this record in our first run through --->
<cfif NOT #listContains(variables.usedPages,tid)#>

<cfset variables.useInResults = "no">

<!--- do the search --->
<cfloop index="i" list="#variables.searchcr#" delimiters=" ">
<!--- if we find a match, set a var to include this record in our results --->
	<cfif findNoCase(#i#,#REReplaceNoCase(body,"<[^>]*>","","ALL")#)>
		<cfset variables.useInResults = "yes"></cfif>
</cfloop>
<cfloop index="i" list="#variables.searchcr#" delimiters=" ">
<!--- if we find a match, set a var to include this record in our results --->
	<cfif findNoCase(#i#,#REReplaceNoCase(title,"<[^>]*>","","ALL")#)>
		<cfset variables.useInResults = "yes"></cfif>
</cfloop>
<cfloop index="i" list="#variables.searchcr#" delimiters=" ">
<!--- if we find a match, set a var to include this record in our results --->
	<cfif findNoCase(#i#,#description#)>
		<cfset variables.useInResults = "yes"></cfif>
</cfloop>
<cfloop index="i" list="#variables.searchcr#" delimiters=" ">
<!--- if we find a match, set a var to include this record in our results --->
	<cfif findNoCase(#i#,#heading1#)>
		<cfset variables.useInResults = "yes"></cfif>
</cfloop>
<cfloop index="i" list="#variables.searchcr#" delimiters=" ">
<!--- if we find a match, set a var to include this record in our results --->
	<cfif findNoCase(#i#,#heading2#)>
		<cfset variables.useInResults = "yes"></cfif>
</cfloop>
<cfloop index="i" list="#variables.searchcr#" delimiters=" ">
<!--- if we find a match, set a var to include this record in our results --->
	<cfif findNoCase(#i#,#filesheading#)>
		<cfset variables.useInResults = "yes"></cfif>
</cfloop>

<cfif variables.useInResults EQ "yes">

<cfif variables.bgcolorSwitch EQ "1">
	<cfset variables.bgcolor = "ffffff">
	<cfset variables.bgcolorSwitch = "2">
<cfelse>
	<cfset variables.bgcolor = "e2e2e2">
	<cfset variables.bgcolorSwitch = "1">
</cfif>

<tr bgcolor="#variables.bgcolor#" class="staffListTableRow">
<td>
<!--- output correct link to teachers homepage --->
<cfif teachers.homepage NEQ "">

<!--- set length of the body text, with html chars stripped for later use --->
<cfset bodyLen = Len(REReplaceNoCase(body,"<[^>]*>","","ALL"))>

	<cfif teachers.homepage IS "default">
		<a href="teacherpage.cfm?teacher=#tid#">		
	<cfelse><a href="#homepage#"></cfif>
	
	<!--- if title is defined, use it --->
	<cfif description NEQ "">#description#
	<cfelseif title NEQ "">#REReplaceNoCase(title,"<[^>]*>","","ALL")#

	<cfelse>
		<cfif body EQ "">Webpage
		<cfelse>
			<cfset bodyLen = Len(REReplaceNoCase(body,"<[^>]*>","","ALL"))>
				<!--- if body is all html code --->
			<cfif bodyLen NEQ 0>
			#Left(REReplaceNoCase(body,"<[^>]*>","","ALL"),Min(50,bodyLen))#
			<cfelse>Webpage</cfif>
		</cfif>
	</cfif></a><br>
	
	<cfif lastupdate NEQ ""><font size="-2" color="##999999">Last updated on #DateFormat(lastupdate,'M/D/YYYY')#</font><br></cfif>
	
	<cfif bodyLen NEQ 0>
		<font size="-1">#Left(REReplaceNoCase(body,"<[^>]*>","","ALL"),Min(300,bodyLen))# ...</font><br><br>
	</cfif>
	
</cfif></td>
</tr>
</cfif>

</cfif>

</cfoutput></cfif>

</table>

	

<cfinclude template="footer.cfm"></body>
</html>
