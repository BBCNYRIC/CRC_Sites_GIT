

<cfif common.newsFeedList NEQ '' AND common.newsFeedList NEQ ',,'>

<!--- query for news items --->
<cfquery name="newslinks" datasource="#datasource#" maxrows=5>
SELECT contacts.description, contacts.tid, teacher.homepage, pageatt.title, pageatt.body, contacts.newscat, pageatt.showDateFrom, pageatt.showDateTo
FROM contacts, teacher, pageatt
WHERE teacher.tid = contacts.tid
	AND pageatt.tid = contacts.tid
	AND ISNULL(pageatt.showDateFrom, '1/1/1900') <= <cfqueryparam value="#DateFormat(Now())#" cfsqltype="CF_SQL_DATE">
	AND ISNULL(pageatt.showDateTo, '1/1/2025') >= <cfqueryparam value="#DateFormat(Now())#" cfsqltype="CF_SQL_DATE">
	AND teacher.fname <> 'TVOID'
	AND contacts.accessgroup = 10
	AND contacts.hidepage = 'no'
	
	AND (
	<cfloop index="i" list="#common.newsFeedList#">
	newscat LIKE <cfqueryparam value="%,#i#,%" cfsqltype="CF_SQL_CHAR"> OR
	</cfloop>0=1)
	
ORDER BY contacts.tid DESC, contacts.rankorder, contacts.description
</cfquery>
<!--- <cfdump var="#newslinks#"> --->

<!--- if bumping right table down, dont put bar across --->
<cfif common.righttable NEQ 'yes'>
<tr><td bgcolor="006633" height="6"></td></tr></cfif>
<tr><td height="16"></td></tr>
<tr><td>

<div class="bulletText">
School News
</div>

<div class="paddedArea">
<cfif newslinks.recordcount EQ 0>
No news stories at this time</cfif>

<cfoutput query="newslinks">
<!--- query for thumbnail image --->
<cfquery datasource="#datasource#" name="getimage">
SELECT *
FROM tfiles
WHERE filename = 'newsthumbnail.jpg'
	AND tid = <cfqueryparam value="#tid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>


<table cellpadding="5"><tr><td align="left">
<cfif getimage.recordcount EQ 1>
<img border="1" width="110" height="110" hspace="0" vspace="0" align="left" src="tfiles/folder#tid#/newsthumbnail.jpg" />
<cfelse>
<img src="tfiles/folder1144/mustangGreySq.gif" alt="" width="110" height="110" hspace="0" vspace="0" border="1" align="left">
</cfif>
</td><td valign="top">

<cfif homepage IS "default">
<a href="teacherpage.cfm?teacher=#tid#" class="newsPageFontHead">
<cfelse>
<a href="#homepage#" class="newsPageFontHead"></cfif>
#description#</a>: 

		
<!--- this strips out html coding --->
<cfset variables.cleantext = #REReplace(body,"</?\w+(\s*[\w:]+\s*=\s*(""[^""]*""|'[^']*'))*\s*/?>"," ","all")# />

<!--- now get the first space after 300 chars --->
<cfset variables.charNum = Find(" ",variables.cleantext,500)>


<!--- make sure our cleaned text is actually long enough to get 300 + chars out of --->
<cfif variables.charnum NEQ 0>
	<span class="newsPageFont">#Left(variables.cleantext,variables.charNum)# ... </span>
<cfelse><span class="newsPageFont">#variables.cleantext#</span></cfif>


<cfif homepage IS "default">
<a href="teacherpage.cfm?teacher=#tid#" class="newsPageFont">
<cfelse>
<a href="#homepage#" class="newsPageFont"></cfif>
more &gt;&gt;</a></td></tr></table>

</cfoutput>
	
</div>
<br><br>
		
</td></tr>
<tr><td>&nbsp;&nbsp;&nbsp;<a href="districtNews.cfm" class="newsHead">View more stories &gt;&gt;</a><br><br></td></tr>


<!--- if bumping right table down, dont put bar across --->
<cfif common.righttable EQ 'yes'>
<tr><td bgcolor="006633" height="6"></td></tr></cfif>

</cfif>