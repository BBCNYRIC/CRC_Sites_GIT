<cfif session.auth.authlevel EQ 3 OR isDefined("session.auth.AdminLoggedInAsTeacher")>



<cfif isDefined("URL.logout")>
<!--- log back in as themself --->

<cfquery name="getTeacherInfo" datasource="#datasource#">
  SELECT contacts.tid, authlevel, accesscode, accessgroup, building, userlogin
  FROM contacts, teacher
  WHERE contacts.tid = <cfqueryparam value="#session.auth.AdminLoggedInAsTeacher#" cfsqltype="CF_SQL_INTEGER">
	AND contacts.tid = teacher.tid
	AND userlogin <> 'TVOID'
	AND userlogin <> 'VOID'
</cfquery>


<cfif getTeacherInfo.RecordCount EQ 1>

  <cfset StructDelete(session.auth,"AdminLoggedInAsTeacher")>
  
  <cfset session.auth.uid  = getTeacherInfo.tid>
  <cfset session.auth.fullUserName  = getTeacherInfo.userlogin>
  <cfset session.auth.loggedInId  = getTeacherInfo.tid>
  <cfset session.auth.authlevel  = getTeacherInfo.authlevel>
  <cfset session.auth.accesscode = getTeacherInfo.accesscode>
  <cfset session.auth.accessgroup = getTeacherInfo.accessgroup>
  <cfset session.auth.school = getTeacherInfo.building>
  

<cflocation url="adminMain.cfm" addtoken="No"><cfabort>

</cfif>

</cfif>


<!--- query for teacher info --->
<cfquery name="getTeacherInfo" datasource="#datasource#">
  SELECT contacts.tid, authlevel, accesscode, accessgroup, building, userlogin
  FROM contacts, teacher
  WHERE contacts.tid = <cfqueryparam value="#URL.tid#" cfsqltype="CF_SQL_INTEGER">
	AND contacts.tid = teacher.tid
	AND userlogin <> 'TVOID'
	AND userlogin <> 'VOID'
</cfquery>



<cfif getTeacherInfo.RecordCount EQ 1>
  
  <!--- set var to remember who they actually are --->
  <cfset session.auth.AdminLoggedInAsTeacher = session.auth.loggedInId>
  
  <cfset session.auth.uid  = getTeacherInfo.tid>
  <cfset session.auth.fullUserName  = getTeacherInfo.userlogin>
  <cfset session.auth.loggedInId  = getTeacherInfo.tid>
  <cfset session.auth.authlevel  = getTeacherInfo.authlevel>
  <cfset session.auth.accesscode = getTeacherInfo.accesscode>
  <cfset session.auth.accessgroup = getTeacherInfo.accessgroup>
  <cfset session.auth.school = getTeacherInfo.building>
  
<cflocation url="adminMain.cfm" addtoken="No">

</cfif>



<cfelse><cfabort>
</cfif>