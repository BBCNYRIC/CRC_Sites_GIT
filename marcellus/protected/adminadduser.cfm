<cfif session.auth.authlevel LT 3>
You dont have access to this page<cfabort></cfif>

<cfset variables.secretkey = "apwhashkey">

<!--- if this form has been submited, update the record --->
<cfif isdefined("FORM.updated")>

<!--- check for a duplicate username --->
<cfquery name="checkdups" datasource="#datasource#">
SELECT userlogin
FROM contacts
WHERE userlogin = <cfqueryparam value="#FORM.username#" cfsqltype="CF_SQL_CHAR">
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
        </table></td>
    </tr>
  </table>
<cfabort>
</cfif>

<cftransaction>
<cflock timeout="10" throwontimeout="No" type="EXCLUSIVE"> 

<!--- insert account information in contacts --->
<cfquery datasource="#datasource#">
INSERT INTO contacts(userlogin, userpassword, authlevel, accesscode, hidepage, description)
VALUES (<cfqueryparam value="#Trim(FORM.username)#" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="#encrypt(FORM.pwd, variables.secretkey)#" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="#FORM.usertype#" cfsqltype="CF_SQL_INTEGER">,
		<cfif isdefined("FORM.acccode")><cfqueryparam value="#FORM.acccode#" cfsqltype="CF_SQL_CHAR"><cfelse>0</cfif>,
		'no',
		'Home Page')
</cfquery>

<cfquery datasource="#datasource#" name="gettid">
SELECT tid
FROM contacts
WHERE userlogin = <cfqueryparam value="#Trim(FORM.username)#" cfsqltype="CF_SQL_CHAR">
</cfquery>

 <!--- insert personal info into teachers --->
<cfquery datasource="#datasource#">
INSERT INTO teacher(tid, fname, lname, email, homepage, phone, course, building, classroom, description)
VALUES (<cfoutput query="gettid"><cfqueryparam value="#tid#" cfsqltype="CF_SQL_INTEGER"></cfoutput>,
		<cfqueryparam value="#Trim(preserveSingleQuotes(FORM.fname))#" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="#Trim(preserveSingleQuotes(FORM.lname))#" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="#Trim(FORM.email)#" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="#Trim(FORM.homepage)#" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="#Trim(FORM.phone)#" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="#Trim(FORM.course)#" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="#Trim(FORM.building)#" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="#Trim(FORM.classroom)#" cfsqltype="CF_SQL_CHAR">,
		'Home Page')
</cfquery>

<!--- add an entry for their web page table --->
<cfquery datasource="#datasource#">
INSERT INTO pageatt(tid)
VALUES (<cfoutput query="gettid"><cfqueryparam value="#tid#" cfsqltype="CF_SQL_INTEGER"></cfoutput>)
</cfquery>



</cflock>
</cftransaction>

</cfif>

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
<table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">Add a User</span></td>
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
            <td align="right"> User type: </td>
            <td align="left">  <select name="usertype">
				
				<cfoutput>
				<option value="1">Teacher </option>
				<option value="2">School administrator </option>
				<option value="3">Master administrator </option>
				</cfoutput>
			
				</select> </td>
          </tr>
		  
          <tr> 
            <td align="right"> Username: </td>
            <td align="left"> <cfinput type="text" class="gl_textbox" name="username" message="Please enter a username" required="Yes" size="50"> </td>
          </tr>
		  <tr> 
            <td align="right"> Password: </td>
            <td align="left"> <cfinput type="text" class="gl_textbox" name="pwd" message="Please enter a password" required="Yes" size="50"> </td>
          </tr>
		  
		  <tr> 
            <td align="right"> First name: </td>
            <td align="left"> <cfinput type="text" class="gl_textbox" name="fname" message="Please enter a first name" required="Yes" size="50"> </td>
          </tr>
		  
		  <tr> 
            <td align="right"> Last name: </td>
            <td align="left"> <cfinput type="text" class="gl_textbox" name="lname" message="Please enter a last name" required="Yes" size="50"> </td>
          </tr>
		  
		  <tr> 
            <td align="right"> Email: </td>
            <td align="left"> <cfinput size="50" name="email" value="" class="gl_textbox"> </td>
          </tr>
		  
		  <tr> 
            <td align="right" valign="top"> Homepage: </td>
            <td align="left"> <cfinput size="50" name="homepage" value="default" class="gl_textbox"> <br><font size="-2">*Leave as default if using a page created with tempEDIT</font></td>
          </tr>
		  
		  <tr> 
            <td align="right"> Phone: </td>
            <td align="left"> <cfinput size="50" name="phone" value="" class="gl_textbox"> </td>
          </tr>
		  
		  <tr> 
            <td align="right"> Building: </td>
            <td align="left"> <cfinput size="50" name="building" value="" class="gl_textbox"><!--- <select name="building">
			<option value="" selected>Choose a school</option>
			<option value="do">District Office</option>
			<option value="elementary">Elementary School</option>
			<option value="middle">Middle School</option>
			<option value="highschool">High School</option></select> ---> </td>
          </tr>
		  
		  <tr> 
            <td align="right"> Course/Job title: </td>
            <td align="left"> <cfinput size="50" name="course" value="" class="gl_textbox"> </td>
          </tr>
		  
		  <tr> 
            <td align="right"> Classroom: </td>
            <td align="left"> <cfinput size="50" name="classroom" value="" class="gl_textbox"> </td>
          </tr>
		  
		 
		  
		  <tr> 
            <td align="right" valign="top"> Give user access to:<!--- <br> <font size="-2" color=#ff0000>(Only use this if adding a school or master administrator)</font> ---> </td>
            <td align="left"> <cfoutput query="getaccesscats">
					<input type="checkbox" name="acccode" value="#groupid#"> #groupname# <br>
				 </cfoutput> </td>
          </tr>
		  
		  
          <tr> 
            <td>&nbsp;</td>
            <td> <input type="submit" class="gl_submit" name="Submit" value="Add this user"> 
			     <input type="reset" class="gl_submit" name="reset" value="Reset All Fields"></td>
          </tr>
        </table>
</cfform>
<br><br><cfinclude template="../footer.cfm"></body>
</html>