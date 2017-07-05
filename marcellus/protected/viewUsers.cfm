<cfif session.auth.authlevel LT 3>
You dont have access to this page<cfabort></cfif>

	
<!--- query for all contacts for drop down box --->
<cfquery name="getusers" datasource="#datasource#">
SELECT teacher.fname, teacher.lname, contacts.accesscode, contacts.userlogin, contacts.authlevel
FROM contacts, teacher
WHERE teacher.tid = contacts.tid
	AND contacts.userlogin <> 'VOID'
	AND contacts.userlogin <> 'TVOID'
	AND contacts.accesscode NOT LIKE '%null%'
	AND contacts.authlevel <> 1
ORDER BY teacher.lname
</cfquery>




<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm">
<br>

<table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">View Admin Rights</span></td>
          </tr>
		  
		  <!--- navbar --->
		  <tr><td bgcolor="#ffffff" class="BL noPadCell" colspan="3">
		  
		 <table border="0" cellspacing="0" cellpadding="0"><tr>
		 <td><img src="http://www.cnyric.org/images/tempedit_navbar_jumpto.gif" alt="" border="0"></td>
		 <td><a href="adminmain.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_admin.gif" alt="" border="0"></a></td>
		 <td><a href="teditpage.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_tempedit.gif" alt="" border="0"></a></td>
		 <td><a href="adminAddPage.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_addpage.gif" alt="" border="0"></a></td>
		 <td><a href="../logout.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_logout.gif" alt="" border="0"></a></td>
		 </tr></table>
		 </td></tr>
		 <!--- spacer row --->
		  <tr><td height="20"></td></tr>
		  
		  <!--- end navbar --->
		 
		  
		  
          <tr> 
		  		<td align="left">
				
				<table width="100%" border="0" cellspacing="0" cellpadding="6" bgcolor="#f8f8f8" class="LL BL RL TL">
				<tr bgcolor="d2d2d2"><td class="BL">User name</td><td class="BL">Has Access To</td><td class="BL">Access Level</td></tr>
				<cfoutput query="getusers">
				<tr <cfif currentrow MOD 2 EQ 1> bgcolor="ffffff"</cfif>>
				<td valign="top" class="BL">#lname#, #fname# (#userlogin#)</td>
				<td class="BL">
				
				<cfloop index="i" list="#accesscode#">
				
				<!--- query for all contacts for drop down box --->
				<cfquery name="getgroupname" datasource="#datasource#">
				SELECT groupname
				FROM accessgroup
				WHERE groupid = #i#
				</cfquery>
				
				#getgroupname.groupname#<br>
				</cfloop>
				
				
					</td>
					<td class="BL" valign="top"><cfif authlevel EQ 2>School Admin<cfelseif authlevel EQ 3>Master Admin</cfif></td>
					</tr>
				</cfoutput>
               </table>
				
				
				</td>
          </tr>
		  
		  
		  
		  
		 
		  
		  
		  
		  
        </table>

<br><br><cfinclude template="../footer.cfm"></body>
</html>