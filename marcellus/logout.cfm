<cfset StructDelete(session, "auth")>
<cfset StructDelete(session, "loginfailure")>
<cfset StructDelete(session, "loginfailnum")>


<cflocation url="http://www.marcellusschools.org" addtoken="No">