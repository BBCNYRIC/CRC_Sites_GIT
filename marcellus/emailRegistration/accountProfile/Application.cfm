<!---  This service is temporarily unavailable<cfabort> --->

<!--- 
  Filename:     Application.cfm
  Created by:   jseitz
  Please Note:  Executes for every page request
--->


<!--- Name our app, and enable Session variables --->
<cfapplication name="MarcellusEDemailer" sessionmanagement="Yes" sessiontimeout="#CreateTimeSpan(0,0,30,0)#">
  
  
<!--- Any variables set here can be used by all our pages --->
<cfset datasource="marcellus">


<!--- If user is not logged in, force them to now --->  
<CFIF NOT IsDefined("session.auth.IsLoggedIn")>
  
    <CFINCLUDE TEMPLATE="LoginCheck.cfm">

</CFIF>  

<cfset masteremail ="jseitz@ocmboces.org">
  
<cferror type="REQUEST" template="../../errorrequest.cfm" mailto="#masteremail#">
<cferror type="EXCEPTION" template="../../errorexception.cfm" mailto="#masteremail#">
