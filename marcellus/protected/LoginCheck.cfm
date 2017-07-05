<!--- 
  Filename:     LoginCheck.cfm
  Created by:   jseitz
  Purpose:      Validates a user's password entries
  Please Note:  Included by LoginForm.cfm
--->


<!--- Make sure we have Login name and Password --->
<cfparam name="Form.UserLogin" TYPE="string">
<cfparam name="Form.UserPassword" TYPE="string">

<cfparam name="session.loginfailnum" default=0>
<cfparam name="session.loginfailure" default=" ">

<!--- Find record with this Username/Password --->
<!--- If no rows returned, password not valid --->
<cfset variables.key="apwhashkey">
<CFQUERY NAME="GetUser" DATASOURCE="#datasource#">
  SELECT contacts.tid, authlevel, accesscode, accessgroup, building, userlogin
  FROM contacts, teacher
  WHERE userlogin    = <cfqueryparam value="#Form.UserLogin#" cfsqltype="CF_SQL_CHAR">
    AND userpassword = <cfqueryparam value="#encrypt(Form.UserPassword, variables.key)#" cfsqltype="CF_SQL_CHAR">
	AND contacts.tid = teacher.tid
	AND userlogin <> 'TVOID'
	AND userlogin <> 'VOID'
</CFQUERY>

<!--- If the username and password are correct --->
<CFIF GetUser.RecordCount EQ 1>
  <!--- Remember user's logged-in status, plus --->
  <!--- unique id and auth level, in structure --->
  
  <CFSET session.auth = StructNew()>
  <CFSET session.auth.IsLoggedIn = "Yes">
  <CFSET session.auth.uid  = GetUser.tid>
  <CFSET session.auth.fullUserName  = GetUser.userlogin>
  <CFSET session.auth.loggedInId  = GetUser.tid>
  <CFSET session.auth.authlevel  = GetUser.authlevel>
  <cfset session.auth.accesscode = getuser.accesscode>
  <cfset session.auth.accessgroup = getuser.accessgroup>
  <cfset session.auth.school = getuser.building>
  <cfset session.loginfailure = "">
  <cfset session.loginfailnum = 0>
 
  

  <!--- set var to keep url vars alive --->
  <cfparam name="session.keepURLvars" default="#cgi.query_string#">
  
  <!--- Now that user is logged in, send them --->
  <!--- to whatever page makes sense to start --->
  <cflocation url="#CGI.SCRIPT_NAME#?#session.keepURLvars#" addtoken="No">
  
  <!--- if login wrong, keep track of how many failures --->
  <cfelse>
  
  <cfset session.loginfailure = "Sorry, that user name and password are incorrect.">
  		  <cfset session.loginfailnum = session.loginfailnum + 1>
  
  </CFIF>