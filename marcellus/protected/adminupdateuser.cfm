<cfif session.auth.authlevel LT 3>
You dont have access to this page<cfabort></cfif>

<cfset variables.secretkey = "apwhashkey">

<cfif NOT isdefined("FORM.tid")>
	<cflocation url="adminmain.cfm" addtoken="No">
	<cfabort>
</cfif>

<!--- if this form has been submited, update the record --->
<cfif isdefined("FORM.updated")>


<!--- check for a duplicate username --->
<cfquery name="checkdups" datasource="#datasource#">
SELECT userlogin
FROM contacts
WHERE userlogin = <cfqueryparam value="#FORM.username#" cfsqltype="CF_SQL_CHAR">
	AND tid <> <cfqueryparam value="#FORM.tid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>
<!--- if there is a dupe, tell the user --->
<cfif checkdups.RecordCount GT 0>
<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br>
  <table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">Invalid username:</span></td>
          </tr>
          <tr> 
            <td align="center"> That username has already been taken.  Use your browser's back button to choose a different username.</td>
          </tr>
        </table>
<cfabort>
</cfif>

<cfquery datasource="#datasource#">
UPDATE contacts
SET userlogin = <cfqueryparam value="#Trim(FORM.username)#" cfsqltype="CF_SQL_CHAR">,
	userpassword = <cfqueryparam value="#encrypt(FORM.pwd, variables.secretkey)#" cfsqltype="CF_SQL_CHAR">,
	authlevel = <cfqueryparam value="#FORM.usertype#" cfsqltype="CF_SQL_INTEGER">,
	accesscode = <cfif isdefined("FORM.acccode")><cfqueryparam value="#FORM.acccode#" cfsqltype="CF_SQL_CHAR"><cfelse>0</cfif>
WHERE tid = <cfqueryparam value="#FORM.tid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<cfquery datasource="#datasource#">
UPDATE teacher
SET fname = <cfqueryparam value="#Trim(preserveSingleQuotes(FORM.fname))#" cfsqltype="CF_SQL_CHAR">,
	lname = <cfqueryparam value="#Trim(preserveSingleQuotes(FORM.lname))#" cfsqltype="CF_SQL_CHAR">,
	email = <cfqueryparam value="#Trim(FORM.email)#" cfsqltype="CF_SQL_CHAR">,
	homepage = <cfqueryparam value="#Trim(FORM.homepage)#" cfsqltype="CF_SQL_CHAR">,
	phone = <cfqueryparam value="#Trim(FORM.phone)#" cfsqltype="CF_SQL_CHAR">,
	building = <cfqueryparam value="#Trim(FORM.building)#" cfsqltype="CF_SQL_CHAR">,
	course = <cfqueryparam value="#Trim(FORM.course)#" cfsqltype="CF_SQL_CHAR">,
	classroom = <cfqueryparam value="#Trim(FORM.classroom)#" cfsqltype="CF_SQL_CHAR">
WHERE tid = <cfqueryparam value="#FORM.tid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>



</cfif>


<!--- if wants to modify a record, list all the users' info.  this should be coming from the select box in adminmain --->
<cfquery name="getuserinfo" datasource="#datasource#">
SELECT *
FROM contacts, teacher
WHERE contacts.tid = <cfqueryparam value="#FORM.tid#" cfsqltype="CF_SQL_INTEGER">
AND teacher.tid = <cfqueryparam value="#FORM.tid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>


<!--- set blank params if above query is not run ie we are adding, not updating --->

<!--- <cfparam name="getuserinfo.userlogin" default="">
<cfparam name="getuserinfo.userpassword" default="">
<cfparam name="getuserinfo.authlevel" default="1"> --->

<!--- query for all access categories --->
<cfquery name="getaccesscats" datasource="#datasource#">
SELECT *
FROM accessgroup
ORDER BY groupname
</cfquery>

<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br>

<cfform name="form1" method="post" action="#CGI.SCRIPT_NAME#" enctype="multipart/form-data">

<input type="hidden" name="updated" value="yes">
<cfoutput><input type="hidden" name="tid" value=#tid#></cfoutput>
<table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">Update User</span></td>
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
		  
		  
		  <cfif session.auth.authlevel EQ 3>
		  <tr> 
            <td align="right"></td>
            <td align="left"><a href="adminLoginTeacher.cfm?tid=<cfoutput>#getuserinfo.tid#</cfoutput>">Log in as this user</a></td>
          </tr>
		  </cfif>
		  
		  
		  <tr> 
            <td align="right"> User type: </td>
            <td align="left">  <select name="usertype">
				
				<cfoutput>
				<option value="1"  <cfif #getuserinfo.authlevel# IS 1> selected </cfif>>Teacher </option>
				<option value="2" <cfif #getuserinfo.authlevel# IS 2> selected </cfif>>School administrator </option>
				<option value="3" <cfif #getuserinfo.authlevel# IS 3> selected </cfif>>Master administrator </option>
				</cfoutput>
			
				</select> </td>
          </tr>
          <tr> 
            <td align="right"> Username: </td>
            <td align="left"> <cfinput type="text" class="gl_textbox" name="username" value="#getuserinfo.userlogin#" message="Please enter a user name" required="Yes" size="50"> </td>
          </tr>
		  <tr> 
            <td align="right"> Password: </td>
            <td align="left"> <cfinput size="50" name="pwd" value="#decrypt(getuserinfo.userpassword, "apwhashkey")#" message="Please enter a password" required="Yes" class="gl_textbox"> </td>
          </tr>
		  
		  <tr> 
            <td align="right"> First name: </td>
            <td align="left"> <cfinput type="text" class="gl_textbox" name="fname" value="#getuserinfo.fname#" message="Please enter a first name" required="Yes" size="50"> </td>
          </tr>
		  
		  <tr> 
            <td align="right"> Last name: </td>
            <td align="left"> <cfinput type="text" class="gl_textbox" name="lname" value="#getuserinfo.lname#" message="Please enter a last name" required="Yes" size="50"> </td>
          </tr>
		  
		  <tr> 
            <td align="right"> Email: </td>
            <td align="left"> <cfinput size="50" name="email" value="#getuserinfo.email#" class="gl_textbox"> </td>
          </tr>
		  
		  <tr> 
            <td align="right" valign="top"> Homepage: </td>
            <td align="left"> <cfinput size="50" name="homepage" value="#getuserinfo.homepage#" class="gl_textbox">
			<br><font size="-2">*Enter "default" if using a page created with tempEDIT</font> </td>
          </tr>
		  
		  <tr> 
            <td align="right"> Phone: </td>
            <td align="left"> <cfinput size="50" name="phone" value="#getuserinfo.phone#" class="gl_textbox"> </td>
          </tr>
		  
		  <tr> 
            <td align="right"> Building: </td>
            <td align="left"> <cfinput size="50" name="building" value="#getuserinfo.building#" class="gl_textbox">
			
			<!--- <cfoutput> <select name="building">
			<option value="" selected>Choose a school</option>
			<option value="do" <cfif FindNoCase('do', getuserinfo.building)>selected</cfif>>District Office</option>
			<option value="elementary" <cfif FindNoCase('elementary', getuserinfo.building)>selected</cfif>>Elementary School</option>
			<option value="middle" <cfif FindNoCase('middle', getuserinfo.building)>selected</cfif>>Middle School</option>
			<option value="highschool" <cfif FindNoCase('high', getuserinfo.building)>selected</cfif>>High school</option>
			</select> </cfoutput> ---></td>
          </tr>
		  
		  <tr> 
            <td align="right"> Course/Job title: </td>
            <td align="left"> <cfinput size="50" name="course" value="#getuserinfo.course#" class="gl_textbox"></td>
          </tr>
		  
		  <tr> 
            <td align="right"> Classroom: </td>
            <td align="left"> <cfinput size="50" name="classroom" value="#getuserinfo.classroom#" class="gl_textbox"> </td>
          </tr>
		  
		  
		  <cfif #getuserinfo.authlevel# GT 1>
		  <tr> 
            <td align="right" valign="top"> Give user access to: </td>
            <td align="left"> <cfoutput query="getaccesscats">
					<input type="checkbox" name="acccode" value="#groupid#" <cfif ListFind(#getuserinfo.accesscode#, #groupid#) NEQ 0>checked</cfif>> #groupname# <br>
				 </cfoutput> </td>
          </tr> </cfif>
		  
		  
		  <tr> 
            <td align="right"> <a href="adminremuser.cfm?teacher_id=<cfoutput>#getuserinfo.tid#</cfoutput>">Delete this user</a> </td>
          </tr>
		  
          <tr> 
            <td>&nbsp;</td>
            <td> <input type="submit" class="gl_submit" name="Submit" value="Save Changes"> 
			     <input type="reset" class="gl_submit" name="reset" value="Reset All Fields"></td>
          </tr>
        </table>
</cfform>
<br><br><cfinclude template="../footer.cfm"></body>
</html>