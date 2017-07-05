<!--- 
  Filename:     LoginCheck.cfm
  Created by:   jseitz
  Purpose:      Validates a user's password entries
  Please Note:  Included by LoginForm.cfm
--->


<!--- Make sure we have Login name and Password --->
<cfparam name="URL.emailadd" TYPE="string">
<cfparam name="URL.verification" TYPE="string">


<!--- Find record with this Username/Password --->
<!--- If no rows returned, password not valid --->

<CFQUERY NAME="GetUser" DATASOURCE="#datasource#">
  SELECT *
  FROM emailadd
  WHERE emailadd = <cfqueryparam value="#URL.emailadd#" cfsqltype="CF_SQL_CHAR">
    AND validation = <cfqueryparam value="#URL.verification#" cfsqltype="CF_SQL_CHAR">
</CFQUERY>

<!--- If the username and password are correct --->
<CFIF GetUser.RecordCount EQ 1>
  <!--- Remember user's logged-in status, plus --->
  <!--- unique id and auth level, in structure --->
  <CFSET session.auth = StructNew()>
  <CFSET session.auth.IsLoggedIn = "Yes">
  <CFSET session.auth.emailadd  = GetUser.emailadd>
  <CFSET session.auth.fname  = GetUser.fname>
  <!--- <CFSET session.auth.lname  = GetUser.lname>
  <CFSET session.auth.affiliation  = GetUser.affiliation> --->
  <CFSET session.auth.active  = GetUser.active>

  

  <!--- Now that user is logged in, send them --->
  <!--- to whatever page makes sense to start --->
  <cflocation url="verifyAccount.cfm" addtoken="No">
  
  <!--- if login wrong, keep track of how many failures --->
  <cfelse>
  Your verification code is invalid<cfabort>
  </CFIF>