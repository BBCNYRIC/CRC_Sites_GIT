<!---  This service is temporarily unavailable<cfabort> --->

<!--- 
  Filename:     Application.cfm
  Created by:   jseitz
  Please Note:  Executes for every page request
--->


<!--- <cfif cgi.http_referer does not contain "marcellusschools.org">
<cflocation url="http://www.marcellusschools.org"><cfabort></cfif> --->

<!--- Name our app, and enable Session variables --->
<cfapplication name="marcellus" sessionmanagement="Yes" sessiontimeout="#CreateTimeSpan(0,1,0,0)#">
  
  
<!--- Any variables set here can be used by all our pages --->
<cfset datasource="marcellus">

<cfparam name="session.URLadd" default="">
<cfif isdefined("URL.pageid")><cfset session.fakeURLvar = #URL.pageid#></cfif>


<cfparam name="session.loginfailnum" default=0>
<cfparam name="session.loginfailure" default=" ">

<!--- set var to turn off google analytics tracking in header.cfm, it breaks the ckeditor on macs and it shouldnt be tracking here anyway --->
<cfset variables.noTracking = "true">


<!--- If user is not logged in, force them to now --->  
<CFIF NOT IsDefined("session.auth.IsLoggedIn")>
  <!--- If the user is now submitting "Login" form, --->
  <!--- Include "Login Check" code to validate user --->
  <CFIF IsDefined("Form.UserLogin")> 
    <CFINCLUDE TEMPLATE="LoginCheck.cfm">
  </CFIF>

  <CFINCLUDE TEMPLATE="LoginForm.cfm">
  <CFABORT>
</CFIF>  

<cfset masteremail ="jseitz@ocmboces.org">
  
<cferror type="REQUEST" template="errorrequest.cfm" mailto="#masteremail#">
<cferror type="EXCEPTION" template="errorexception.cfm" mailto="#masteremail#">


<!--- allow session id to be changed from URL, from Edit this page link --->
<cfif isdefined("URL.numid")>
	<cfset FORM.changeuser = #URL.numid#>
</cfif>

<!--- change session id ---> 
<cfif isdefined("FORM.changeuser")>
	<!--- <cfif (NOT FindNoCase('http://www.marcellusschools.org/protected', Left(cgi.http_referer, 32))) AND 
			(NOT FindNoCase('http://syracusecityschools.org/protected', Left(cgi.http_referer, 28)))>
	Unauthorized<cfabort></cfif> --->

	<!--- query for accessgroup of the passed page to be edited --->
	<cfquery name="getauthcode" datasource="marcellus">
	SELECT accessgroup
	FROM contacts
	WHERE tid = <cfqueryparam value="#FORM.changeuser#" cfsqltype="CF_SQL_INTEGER">
	</cfquery>
	
	<!--- if the accessgroup is 35, it's a protected page, we need to add the protected folder to our URL for view my page link in teditpage.cfm.  We will also check this variable throughout the application to see if we're dealing with a protected page --->
	<cfif getauthcode.accessgroup EQ 9999>
		<cfset session.URLadd = "protected/">
	<cfelse>
		<cfset session.URLadd = "">
	</cfif>
	
	<!--- if the accessgroup is 0, its a additional teacher page, or the users homepage --->
	<cfif getauthcode.accessgroup EQ 0>
		<cfquery name="getzeroauthcode" datasource="marcellus">
		SELECT teacher.tid
		FROM contacts, teacher
		WHERE teacher.tid = contacts.tid
			AND teacher.owner = #session.auth.loggedinid#
			AND contacts.tid = <cfqueryparam value="#FORM.changeuser#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>
		<!--- if we found a record above OR if user is switching back to their main account --->
		<cfif (getzeroauthcode.recordcount NEQ 0) OR (FORM.changeuser EQ session.auth.loggedInID)>
		<cfset session.auth.uid = #FORM.changeuser#>
		<!--- set accessgroup to 0 for adding additional pages --->
		<cfset session.auth.accessgroup = #getauthcode.accessgroup#>
		<!--- we're done, set a variable to skip the next section --->
		<cfset variables.skip="yes">
	<cfelse>Unauthorized<cfabort>
		</cfif>
	</cfif>
	
	<!--- skip var not set, auth code wasn't 0 --->
	<cfif NOT isdefined("variables.skip")>
	<cfquery name="confirmauth" datasource="marcellus">
	SELECT tid
	FROM contacts
	WHERE tid = #session.auth.loggedinid#
		AND #getauthcode.accessgroup# IN(#session.auth.accesscode#)
	</cfquery>
	
	<cfif confirmauth.recordcount NEQ 0>
		<cfset session.auth.uid = #FORM.changeuser#>
		<cfset session.auth.accessgroup = #getauthcode.accessgroup#>
	<cfelse>Unauthorized<cfabort>
	</cfif>
	</cfif>
	
</cfif>