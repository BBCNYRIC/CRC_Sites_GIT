<!--- if a teacher id number is not defined in the url, redirect to listall page --->
<cfif NOT isdefined("URL.teacher")><cflocation url="listall.cfm" addtoken="No"><cfabort></cfif>

<!--- query for page attributes --->
<cfquery name="common" datasource="#datasource#">
SELECT *
FROM pageatt LEFT JOIN teacher ON pageatt.tid = teacher.tid
WHERE pageatt.tid = <cfqueryparam value="#URL.teacher#" cfsqltype="CF_SQL_INTEGER">
<!--- let them view the page even if it's expired if they're logged in --->
<cfif NOT isDefined("session.auth.IsLoggedIn")>
	AND ISNULL(showDateFrom, '1/1/1900') <= <cfqueryparam value="#DateFormat(Now())#" cfsqltype="CF_SQL_DATE">
	AND ISNULL(showDateTo, '1/1/2025') >= <cfqueryparam value="#DateFormat(Now())#" cfsqltype="CF_SQL_DATE">
</cfif>
</cfquery>


<!--- if no records have been found, teacher does not have a page --->
<cfif common.recordcount eq 0>
<cfinclude template="header.cfm">
<cfinclude template="navtable.cfm"><br><br>

  <table width="90%" border="0" cellspacing="0" cellpadding="6" bgcolor="#f8f8f8" class="LL BL RL TL" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">An Error Has Occured</span></td>
          </tr>
          <tr> 
            <td align="center"> We cannot find the page you are looking for.  Please check to make sure the path is correct, or <a href="pagelist.cfm">view our sitemap</a>.</td>
          </tr>
        </table>
  <cfinclude template="footer.cfm">
<cfabort>
</cfif>


<!--- if page is password protected, get password --->
<cfif common.pppage EQ 'yes'>
<cfif NOT isdefined("session.pppageAuth.pageLoggedIn#URL.teacher#")>
	<cflocation url="pageLogin.cfm?pageid=#URL.teacher#" addtoken="No"><cfabort>
</cfif>
</cfif>




<!--- query for links --->
<cfquery name="links" datasource="#datasource#">
SELECT *
FROM tpagelinks ln
WHERE ln.tid = <cfqueryparam value="#URL.teacher#" cfsqltype="CF_SQL_INTEGER">
ORDER BY rankorder, link_name</cfquery>

<!--- query for announcements --->
<cfquery name="ann" datasource="#datasource#">
SELECT *
FROM tpageann an
WHERE an.tid = <cfqueryparam value="#URL.teacher#" cfsqltype="CF_SQL_INTEGER">
ORDER BY rankorder, ann_header</cfquery>

<!--- query for links to files the teacher has uploaded --->
<cfquery name="filez" datasource="#datasource#">
SELECT *
FROM tfiles tf
WHERE tf.tid = <cfqueryparam value="#URL.teacher#" cfsqltype="CF_SQL_INTEGER">
	AND showLink = 'yes'
ORDER BY rankorder, file_id DESC</cfquery>



<!--- if its a teacher page, set a flag for the navtable.cfm template, otherwise do the regular query for left side nav --->
<!--- if it's not void, then its either tvoid or a regular user login, so it's a teacher page --->
<cfif common.fname NEQ 'VOID'>
	<cfset getaccgp.accessgroup = 'teacherpage'>
<cfelse>

<!--- for the left side listing --->
<cfquery datasource="#datasource#" name="getaccgp">
SELECT contacts.accessgroup, contacts.description, accessgroup.groupname
FROM contacts LEFT JOIN accessgroup ON contacts.accessgroup = accessgroup.groupid
WHERE tid = <cfqueryparam value="#URL.teacher#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

</cfif>


<!--- if they're logged in we can display a link to edit the page, do access check here before navtable.cfm potentially messes with our contacts.accessgroup variable --->
<cfif isDefined("session.auth.IsLoggedIn")>
	<!--- if they have access to this category --->
	<cfif listfindnocase(#session.auth.accesscode#, #getaccgp.accessgroup#) OR (#common.owner# EQ #session.auth.loggedInId#) OR (#common.tid# EQ #session.auth.loggedInId#)>
		<cfset variables.showEditLink = 'true'>
	</cfif>
</cfif>

<!--- set var to show social sharing icons on news items --->
<cfif getaccgp.accessgroup EQ 10>
	<cfset variables.showSocialShare = 'yes'>
	<cfelse><cfset variables.showSocialShare = 'no'>
</cfif>


<cfinclude template="header.cfm">
<cfinclude template="navtable.cfm">

<!--- if they're logged in we can display a link to edit the page --->
<cfif isDefined("variables.showEditLink")>
<cfoutput>
<div align="left"><a href="protected/teditpage.cfm?numid=#URL.teacher#">Edit this page</a><br></div>
</cfoutput>
</cfif>



<table width="100%" border="0" cellspacing="0" cellpadding="10" align="center">

<cfif variables.showSocialShare EQ 'yes'>
<script type="text/javascript">var switchTo5x=true;</script>
<script type="text/javascript" src="http://w.sharethis.com/button/buttons.js"></script>
<script type="text/javascript">stLight.options({publisher: "cb5a94f1-bf46-4792-b71e-a1a45c324817", doNotHash: false, doNotCopy: false, hashAddressBar: false});</script>

<tr><td><span class='st_facebook' displayText='Facebook'></span>
<span class='st_twitter' displayText='Tweet'></span>
<span class='st_linkedin' displayText='LinkedIn'></span>
<span class='st_pinterest' displayText='Pinterest'></span>
<span class='st_email' displayText='Email'></span></td></tr>

</cfif>

<tr><td valign="top" bgcolor="ffffff">


<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" valign="top">
  <tr>
  <cfif common.righttable EQ 'yes' AND common.bumprighttable EQ 'yes'>
  <td colspan="3">
  <cfelse>
  <td>
  </cfif>
  
  
  <cfoutput query="common">
  
  <cfif common.title NEQ ''>
  <div class="header">#title#</div><hr width="100%" color="##999999"><br></cfif>
  #body#</cfoutput>
  
  </td></tr>
  
  <!--- put colored line all the way across --->
  <cfif common.righttable EQ 'yes' AND common.bumprighttable EQ 'yes'>
  <tr><td bgcolor="006633" height="6" colspan="3"></td></tr>
  </cfif>
  
  <!--- if using the right side table, put in second text area now --->
  <cfif common.righttable EQ 'yes'>
  <tr><td valign="top">
  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="left" bgcolor="#ffffff">
  
  <!--- set order of body and news section.  only do news if right table is bumped --->
<cfloop index="i" from="1" to="5">

	<cfif common.textArea2Rank EQ #i#>
		<cfinclude template="teacherpage_body2.cfm">
	</cfif>
	<cfif common.newsfeedRank EQ #i# AND common.bumprighttable EQ 'yes'>
		<cfinclude template="teacherpage_newsfeed.cfm">
	</cfif>

</cfloop>
  
	</table>
  
  </td>
  
  <!--- if bumping right table down, do the include here --->
  <cfif common.bumprighttable EQ 'yes'>
  <!--- spacer --->
  <td width="20"></td>
  <td valign="top" bgcolor="#ffffff" width="25%" height="400">
	<!--- begin right side table for ann, links, files --->
	<table width="100%" border="0" cellspacing="0" cellpadding="3" align="left" bgcolor="#ffffff">

	
	<!--- set order of announcements, links, and files section --->
<cfloop index="i" from="1" to="5">

	<cfif common.annRank EQ #i#>
		<cfinclude template="teacherpage_ann_sidebar.cfm">
	</cfif>
	<cfif common.linksRank EQ #i#>
		<cfinclude template="teacherpage_links_sidebar.cfm">
	</cfif>
	<cfif common.filesRank EQ #i#>
		<cfinclude template="teacherpage_files_sidebar.cfm">
	</cfif>

</cfloop>
	
</table><!--- end right side table for ann, links, files --->
	</td>
  
  </cfif>
  </tr>
  </cfif>
  
<!--- if they dont want right side table, put ann, links, files here --->
<cfif common.righttable NEQ 'yes'>


<!--- set order of announcements, links, and files section --->
<cfloop index="i" from="1" to="5">

	<cfif common.annRank EQ #i#>
		<cfinclude template="teacherpage_ann.cfm">
	</cfif>
	<cfif common.linksRank EQ #i#>
		<cfinclude template="teacherpage_links.cfm">
	</cfif>
	<cfif common.filesRank EQ #i#>
		<cfinclude template="teacherpage_files.cfm">
	</cfif>
	<cfif common.textArea2Rank EQ #i#>
		<cfinclude template="teacherpage_body2.cfm">
	</cfif>
	<cfif common.newsfeedRank EQ #i#>
		<cfinclude template="teacherpage_newsfeed.cfm">
	</cfif>

</cfloop>



</cfif>

<!--- if using right table, check here for news feed --->
<cfif common.righttable EQ 'yes' AND common.bumprighttable NEQ 'yes'> 
  <cfinclude template="teacherpage_newsfeed.cfm">
</cfif>

  
</table>




</td>


<!--- put ann, links, files in the right table --->
<cfif common.righttable EQ 'yes' AND common.bumprighttable NEQ 'yes'> 
<td valign="top" bgcolor="#ffffff" width="25%" height="400" class="LL">
	<!--- begin right side table for ann, links, files --->
	<table width="100%" border="0" cellspacing="0" cellpadding="3" align="left" bgcolor="#ffffff">

	
	<!--- set order of announcements, links, and files section --->
<cfloop index="i" from="1" to="5">

	<cfif common.annRank EQ #i#>
		<cfinclude template="teacherpage_ann_sidebar.cfm">
	</cfif>
	<cfif common.linksRank EQ #i#>
		<cfinclude template="teacherpage_links_sidebar.cfm">
	</cfif>
	<cfif common.filesRank EQ #i#>
		<cfinclude template="teacherpage_files_sidebar.cfm">
	</cfif>
	

</cfloop>

		
		
		
</table><!--- end right side table for ann, links, files --->
	</td>		
		
		</cfif>
</tr>

<!--- <tr><td align="center">
<cfoutput>Last updated on #DateFormat(common.lastupdate,'M/D/YYYY')#</cfoutput>
</td></tr> --->


</table>

<cfinclude template="footer.cfm">