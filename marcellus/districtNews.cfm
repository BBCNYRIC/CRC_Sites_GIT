

<!--- query for news items --->
<cfquery datasource="#datasource#" name="newslinks">
SELECT contacts.description, contacts.tid, teacher.homepage, pageatt.title, pageatt.body, contacts.newscat, pageatt.showDateFrom, pageatt.showDateTo
FROM contacts, teacher, pageatt
WHERE teacher.tid = contacts.tid
	AND pageatt.tid = contacts.tid
	AND ISNULL(pageatt.showDateFrom, '1/1/1900') <= <cfqueryparam value="#DateFormat(Now())#" cfsqltype="CF_SQL_DATE">
	AND ISNULL(pageatt.showDateTo, '1/1/2025') >= <cfqueryparam value="#DateFormat(Now())#" cfsqltype="CF_SQL_DATE">
	AND teacher.fname <> 'TVOID'
	AND contacts.accessgroup = 10
	AND contacts.hidepage = 'no'
	AND newscat LIKE <cfqueryparam value="%,2,%" cfsqltype="CF_SQL_CHAR">
	<!--- <cfif isdefined("FORM.newscat")>
	AND (
	<cfloop index="i" list="#FORM.newscat#">
	newscat LIKE <cfqueryparam value="%,#i#,%" cfsqltype="CF_SQL_CHAR"> OR
	</cfloop>0=1)
	</cfif> --->
ORDER BY contacts.tid DESC
</cfquery>


<cfinclude template="header.cfm">
<cfinclude template="navtable.cfm"><br>



<table width="100%" border="0" cellspacing="5" cellpadding="0" class="LL BL">

<tr><td>
<!--- next n records code --->
<cfparam name="URL.currentPage" type="numeric" default="1">

<cfif URL.currentPage NEQ 1>
<a href="districtNews.cfm?currentPage=<cfoutput>#Evaluate(URL.currentPage - 1)#</cfoutput>">&lt;&lt; Previous</a>&nbsp;&nbsp;&nbsp;&nbsp;</cfif>

<cfif newslinks.recordcount GT (URL.currentPage * 20)>
<a href="districtNews.cfm?currentPage=<cfoutput>#IncrementValue(URL.currentPage)#</cfoutput>">Next &gt;&gt;</a></cfif>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Viewing <cfoutput>#Evaluate(URL.currentPage * 20 - 19)# - #Min((Evaluate(URL.currentPage * 20)),newslinks.RecordCount)# of #newslinks.RecordCount# stories</cfoutput>
</td></tr>


<tr><td valign="top" width="95%">

<cfif newslinks.recordcount EQ 0>
No news stories at this time</cfif>
<cfoutput query="newslinks" startrow="#Evaluate(URL.currentPage * 20 - 19)#" maxrows=20>
<!--- query for thumbnail image --->
<cfquery datasource="#datasource#" name="getimage">
SELECT *
FROM tfiles
WHERE filename = 'newsthumbnail.jpg'
	AND tid = <cfqueryparam value="#tid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>


<table cellpadding="5"><tr><td align="left">
<cfif getimage.recordcount EQ 1>
<img border="1" hspace="10" vspace="2" width="110" height="110" align="left" src="/tfiles/folder#tid#/newsthumbnail.jpg" />
<cfelse>
<img src="tfiles/folder1144/mustangGreySq.gif" alt="" width="110" height="110" hspace="10" vspace="2" border="1" align="left" class="mainBoxShadow">
</cfif>

<a href="/teacherpage.cfm?teacher=#tid#" class="newsHead">#description#</a>: 
		
<!--- this strips out html coding --->
<cfset variables.cleantext = #REReplace(body,"</?\w+(\s*[\w:]+\s*=\s*(""[^""]*""|'[^']*'))*\s*/?>"," ","all")# />

<!--- now get the first space after 300 chars --->
<cfset variables.charNum = Find(" ",variables.cleantext,800)>


<!--- make sure our cleaned text is actually long enough to get 300 + chars out of --->
<cfif variables.charnum NEQ 0>
	<span class="newsfont">#Left(variables.cleantext,variables.charNum)# ... </span>
<cfelse><span class="newsfont">#variables.cleantext#</span></cfif>

<a href="/teacherpage.cfm?teacher=#tid#" class="whitetablefont">more &gt;&gt;</a></td></tr></table>

</cfoutput>

<br><br><br>
</td><!--- end news stories cell --->
</tr>

<tr><td>
<!--- next n records code --->
<cfif URL.currentPage NEQ 1>
<a href="districtNews.cfm?currentPage=<cfoutput>#Evaluate(URL.currentPage - 1)#</cfoutput>">&lt;&lt; Previous</a>&nbsp;&nbsp;&nbsp;&nbsp;</cfif>

<cfif newslinks.recordcount GT (URL.currentPage * 20)>
<a href="districtNews.cfm?currentPage=<cfoutput>#IncrementValue(URL.currentPage)#</cfoutput>">Next &gt;&gt;</a></cfif>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Viewing <cfoutput>#Evaluate(URL.currentPage * 20 - 19)# - #Min((Evaluate(URL.currentPage * 20)),newslinks.RecordCount)# of #newslinks.RecordCount# stories</cfoutput>
</td></tr>


</table>




<br><br><cfinclude template="footer.cfm"></body>
</html>