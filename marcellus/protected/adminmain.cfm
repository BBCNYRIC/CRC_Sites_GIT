
<cfif session.auth.authlevel EQ 3>

<!--- query for all contacts for drop down box --->
<cfquery name="getusers" datasource="#datasource#">
SELECT *
FROM contacts, teacher
WHERE teacher.tid = contacts.tid
	AND contacts.userlogin <> 'VOID'
	AND contacts.userlogin <> 'TVOID'
ORDER BY teacher.lname
</cfquery>

</cfif>


<cfif session.auth.authlevel GTE 2>


<cfinclude template="../../cfGlobalCode/compareLists.cfm">


<!--- query for all pages for drop down box --->
<cfquery name="getpages" datasource="#datasource#">
SELECT *
FROM contacts, teacher, accessgroup
WHERE teacher.tid = contacts.tid
	AND contacts.userlogin = 'VOID'
	AND accessgroup.groupid = contacts.accessgroup
	AND groupid <> 10
	<!--- if they're a 2, they only see their own group --->
	<cfif session.auth.authlevel EQ 2>
	AND contacts.accessgroup IN(#session.auth.accesscode#)</cfif>
ORDER BY accessgroup.groupname, contacts.description
</cfquery>

<!--- query for all news articles for drop down box --->
<cfquery name="getpagesNews" datasource="#datasource#">
SELECT *
FROM contacts
WHERE accessgroup = 10
ORDER BY description
</cfquery>

</cfif>


<!--- get other teacher pages and their home account page --->
<cfquery datasource="#datasource#" name="getTeacherPages">
SELECT contacts.description, contacts.tid, hidepage
FROM teacher, contacts
WHERE teacher.tid = contacts.tid
	AND (
	(owner = <cfqueryparam value="#session.auth.loggedInId#" cfsqltype="CF_SQL_INTEGER">
	AND fname = 'TVOID')
	OR contacts.tid = <cfqueryparam value="#session.auth.loggedInId#" cfsqltype="CF_SQL_INTEGER">
	)
ORDER BY contacts.description
</cfquery>



<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br>

<table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><img src="http://www.cnyric.org/images/tempedit_admin.gif" width="260" height="56" alt="" border="0"></td>
          </tr>
		  
		  <!--- navbar --->
		  <tr><td bgcolor="#ffffff" class="BL noPadCell" colspan="3">
		  
		 <table border="0" cellspacing="0" cellpadding="0"><tr>
		 <td><img src="http://www.cnyric.org/images/tempedit_navbar_jumpto.gif" alt="" border="0"></td>
		 <td><a href="teditpage.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_tempedit.gif" alt="" border="0"></a></td>
		 <td><a href="adminAddPage.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_addpage.gif" alt="" border="0"></a></td>
		 <cfif ListFind(session.auth.accesscode,10)><td><a href="adminAddNews.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_addnews.gif" alt="" border="0"></a></td></cfif>
		 <td><a href="../logout.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_logout.gif" alt="" border="0"></a></td>
		 </tr></table>
		 </td></tr>
		 <!--- spacer row --->
		  <tr><td height="20"></td></tr>
		  
		  <!--- end navbar --->
		  
		 
		  
		  <cfif session.auth.authlevel GT 1>
		  <tr> 
		  		<td align="left">
				<form name="modify" action="adminupdatePage.cfm" method="post">
				Select a Page to Modify:<br>
		  		<select name="tid">
				<cfoutput query="getpages">
					<option value="#tid#">#groupname#: #description#: <cfif hidepage EQ 'yes'>(hidden)</cfif> id:#tid#</option>
				</cfoutput>
                <input type="submit" class="gl_submit" value="  Go  ">
    			</form>
				</td>
          </tr>
		  </cfif>
		  
		  
		  
		  <cfif ListFind(session.auth.accesscode,10)>
		  
		  <tr> 
		  		<td align="left">
				<form name="modify" action="adminupdateNews.cfm" method="post">
				Select a News Story to Modify:<br>
		  		<select name="tid">
				<cfoutput query="getpagesNews">
				
				<!--- compare newscat list with session.accesscode to see if they have access to this category.  compareLists() function included above --->
				<cfif compareLists(session.auth.accesscode,newscat) NEQ 0 OR findNoCase('null',newscat)>

					<option value="#tid#">
						<cfif listFindNoCase(newscat,'2')>District News: 
						<cfelseif listFindNoCase(newscat,'44')>Spotlight: 
						<cfelse>NO CATEGORY SPECIFIED: 
						
						</cfif>
					#description#: <cfif hidepage EQ 'yes'>(hidden)</cfif> id:#tid#</option>
					
				</cfif>
				
				</cfoutput>
                <input type="submit" class="gl_submit" value="  Go  ">
    			</form>
				</td>
          </tr>
		  </cfif>
		  
		  <cfif session.auth.authlevel EQ 3>
		  <tr> 
            <td align="left"> <a href="adminadduser.cfm">Add a User</a> </td>
          </tr>
		  
		  
          <tr> 
		  		<td align="left">
				<form name="modify2" action="adminupdateuser.cfm" method="post">
		  		<select name="tid">
				<cfoutput query="getusers">
					<option value="#tid#">#lname#, #fname#: id:#tid#</option>
				</cfoutput>
                <input type="submit" class="gl_submit" value="Modify user">
    			</form>
				</td>
          </tr>
		  
		   <tr> 
            <td align="left"> <a href="viewusers.cfm">View user access levels</a> </td>
          </tr>
		  
		  </cfif>
		   
		  
		  
		  
		  <cfif #session.auth.loggedInId# EQ 39>
		  <tr>
            <td align="left"> <a href="addCategory.cfm">Add Category (Josh Only)</a> </td>
		  </tr></cfif>
		  
		  <cfif session.auth.authlevel GT 1>
		  <tr>
            <td align="left"> <a href="../pagelistall.cfm">View all pages on site</a> </td>
		  </tr>
		  </cfif>
		  
		  
		  <tr>
            <td align="left"> <a href="http://www.cnyric.org/teacherpage.cfm?teacher=1467" target="_blank">tempEDIT training docs</a> </td>
		  </tr>
		  
		  <!--- if they have teacher subpages, or if they're a teacher we still need to show them the home account page --->
		  <cfif getTeacherPages.recordcount GT 1 OR session.auth.authlevel EQ 1>
		  <tr> 
		  		<td align="left">
				<form name="modifyTpages" action="tupdatePage.cfm" method="post">
				Select a Page to Modify:<br>
		  		<select name="tid">
				<!--- first option is their home account, limited access to delete this one --->
				<!--- <option value="#session.auth.loggedInId#">#description#: <cfif hidepage EQ 'yes'>(hidden)</cfif></option> --->
				<cfoutput query="getTeacherPages">
					<option value="#tid#">My Pages - #description#<cfif hidepage EQ 'yes'> (hidden)</cfif></option>
				</cfoutput>
                <input type="submit" class="gl_submit" value="  Go  ">
    			</form>
				</td>
          </tr>
		  </cfif>
		  

		  
        </table>

<br><br><cfinclude template="../footer.cfm"></body>
</html>