
<cfsetting requestTimeOut = "10">

<!--- set a variable to tell us later if we had an error here.  This is done because the xml feed fails often --->
<cfset variables.feedFail = "pass">

<cftry>
<!--- <cfif #CGI.REMOTE_ADDR# LIKE '170.158.52'><cfabort></cfif> --->
<cfhttp url="http://marcellusschoolnews.blogspot.com/feeds/posts/default" method="GET" resolveurl="false">

<cfcatch type="Any">
<cfset variables.feedFail="failed"></cfcatch>
</cftry>


<cfset myXMLcontent = CFHTTP.FileContent>
<cfset mydoc = XmlParse(myXMLcontent)>

<!--- <cfdump var="#mydoc#"> --->


<cftry>
<cfset numItems = mydoc.feed.totalResults>

<cfcatch type="Any">
<cfset variables.feedFail="failed"></cfcatch>
</cftry>

  <table width="100%" border="0" cellspacing="0" cellpadding="10">
    <tr> 
      <td>	

<cfif variables.feedFail EQ 'pass'>

<!--- Process the news items into a query object --->
<cfset storyquery = QueryNew("link, title, author, publishdate, content") >
<cfset temp = QueryAddRow(storyquery, 3<!--- #numItems# --->)>
<cfloop index="i" from = "1" to = "3"<!--- #numItems# --->>
<!--- there are multiple links in each entry, we want the last one, hence the arraylen() --->
    <cfset temp = QuerySetCell(storyquery, "link",
       #mydoc.feed.entry[i].link[ArrayLen(mydoc.feed.entry[i].link)].XMLAttributes.href#,#i#)>
	<cfset temp = QuerySetCell(storyquery, "title",
        #mydoc.feed.entry[i].title.XMLText#,#i#)>
	<cfset temp = QuerySetCell(storyquery, "author",
        #mydoc.feed.entry[i].author.name.XMLText#,#i#)>
		
		<!--- the dates passed tend not to be valid --->
  <cfif NOT isDate(mydoc.feed.entry[i].updated.XMLText)>
  
  <!--- split the date at the character 'T', for some reason they append this onto their dates --->
  <cfset variables.mytime = Left(mydoc.feed.entry[i].updated.XMLText,FindNoCase('t',mydoc.feed.entry[i].updated.XMLText)-1)>		
		
	<cfset temp = QuerySetCell(storyquery, "publishdate",
        #DateFormat(variables.mytime,'M/D/YYYY')#,#i#)>
		
		<cfelse>
	<cfset temp = QuerySetCell(storyquery, "publishdate",
        #DateFormat(mydoc.feed.entry[i].updated.XMLText,'M/D/YYYY')#,#i#)>
		
		</cfif>
		
		
		<cftry>
	<cfset temp = QuerySetCell(storyquery, "content",
        #mydoc.feed.entry[i].content.XMLText#,#i#)>

<cfcatch type="Any">
	<cfset temp = QuerySetCell(storyquery, "content",
        #mydoc.feed.entry[i].summary.XMLText#,#i#)></cfcatch>
</cftry>
	
    
</cfloop>

<font color="#808080" size="-2">This is a list of news, events, and highlights from Marcellus CSD.<br><br></font>


<cfquery name="displayQuery" dbType="query">
SELECT *
FROM storyquery
ORDER BY publishdate DESC
</cfquery>

<cfoutput query="displayQuery" maxrows=8>

<a href="#link#" target="_blank"><strong>#title#</strong></a>
<br>
<font color="##808080" size="-2"> by #author# on <em>#DateFormat(publishdate,'M/D/YYYY')#</em></font> <br>

<!--- this strips out html coding --->
<cfset variables.cleantext = #REReplace(content,"</?\w+(\s*[\w:]+\s*=\s*(""[^""]*""|'[^']*'))*\s*/?>"," ","all")# />

<!--- now get the first space after 300 chars --->
<cfset variables.charNum = Find(" ",variables.cleantext,300)>


<!--- make sure our cleaned text is actually long enough to get 300 + chars out of --->
<cfif variables.charnum NEQ 0>
#Left(variables.cleantext,variables.charNum)# ... 
<cfelse>#variables.cleantext#</cfif>

<font size="-2"><a href="#link#">More</a></font><hr>

</cfoutput>
<br><font size="-2"><a href="http://marcellusschoolnews.blogspot.com/">See All Stories</a></font>

<cfelse>
No news at this time
</cfif>
</td>
    </tr>
  </table>
