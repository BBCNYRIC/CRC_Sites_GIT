<!--- 
  Filename:     Application.cfm
  Created by:   jseitz
  Please Note:  Executes for every page request
--->


<cfif FindNoCase(';', #cgi.query_string#)><cflocation url="http://www.aol.com"><cfabort></cfif>

<!--- Name our app, and enable Session variables --->
<CFAPPLICATION
  NAME="marcellus"
  SESSIONMANAGEMENT="Yes" applicationtimeout="#CreateTimeSpan(1,0,0,1)#">
 
<!--- Any variables set here can be used by all our pages --->
<cfset datasource  = "marcellus">
<cfset masteremail ="jseitz@ocmboces.org">
  
<cferror type="REQUEST" template="errorrequest.cfm" mailto="#masteremail#">
<cferror type="EXCEPTION" template="errorexception.cfm" mailto="#masteremail#">
