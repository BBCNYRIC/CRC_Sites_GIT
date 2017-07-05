
<!--- user has confirmed the delete operation --->
<cfif isdefined("URL.confirmdelete")>

<!--- make sure this user is authorized to delete this info --->
<cfquery datasource="#datasource#" name="checkauth">
SELECT tid
FROM teacher
WHERE tid = <cfqueryparam value="#URL.teacher_id#" cfsqltype="CF_SQL_INTEGER">
	AND owner = <cfqueryparam value="#session.auth.loggedInId#" cfsqltype="CF_SQL_INTEGER">
	AND tid <> <cfqueryparam value="#session.auth.loggedInId#" cfsqltype="CF_SQL_INTEGER">
</cfquery>
	<cfif checkauth.recordcount EQ 0>
		<cflocation URL="http://www.marcellusschools.org" addtoken="no"><cfabort>
	</cfif>

<cftransaction>
<cflock timeout="10" throwontimeout="No" type="EXCLUSIVE">

<!--- delete from teacher table --->
<cfquery datasource="#datasource#">
DELETE FROM teacher
WHERE tid = <cfqueryparam value="#URL.teacher_id#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<!--- delete from contacts table --->
<cfquery datasource="#datasource#">
DELETE FROM contacts
WHERE tid = <cfqueryparam value="#URL.teacher_id#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<!--- delete page attributes table --->
<cfquery datasource="#datasource#">
DELETE FROM pageatt
WHERE tid = <cfqueryparam value="#URL.teacher_id#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<!--- delete teacher announcements --->
<cfquery datasource="#datasource#">
DELETE FROM tpageann
WHERE tid = <cfqueryparam value="#URL.teacher_id#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<!--- delete teacher links --->
<cfquery datasource="#datasource#">
DELETE FROM tpagelinks
WHERE tid = <cfqueryparam value="#URL.teacher_id#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<!--- delete teacher files' references --->
<cfquery datasource="#datasource#">
DELETE FROM tfiles
WHERE tid = <cfqueryparam value="#URL.teacher_id#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<!--- remove the actual files --->
<cfif directoryExists("F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#URL.teacher_id#") IS "Yes">
<cfdirectory action="LIST" directory="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#URL.teacher_id#\" name="getlist">
<cfoutput query="getlist">
<cffile action="DELETE" file="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#URL.teacher_id#\#name#">
</cfoutput>
<cfdirectory action="DELETE" directory="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#URL.teacher_id#">
</cfif>

<cfif URL.teacher_id EQ session.auth.uid>
	<cfset session.auth.uid = session.auth.loggedInID>
</cfif>

</cflock></cftransaction>


<!--- selection has been deleted, tell the user --->
<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br><br>

<META http-equiv="refresh" content= "1; url=adminmain.cfm">

<table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">Confirm delete operation:</span></td>
          </tr>
          <tr> 
            <td align="center"> <strong>The page has been deleted</strong> </td>
          </tr>
        </table>

<br><br><cfinclude template="../footer.cfm"></body>
</html>


<cfabort>
</cfif>

<cfif isdefined("URL.teacher_id")>

<!--- dont let them delete their home account --->
<cfif URL.teacher_id EQ session.auth.loggedInId>

<!--- they cant delete this --->
<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br><br>


  <table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">Error</span></td>
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
		  
		  <!--- end navbar ---><br>
		  
		  
          <tr> 
            <td align="center"> You can't delete this page </td>
          </tr>
        </table>

<br><br><cfinclude template="../footer.cfm"></body>
</html><cfabort>
</cfif>



<!--- confirm the delete --->
<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br><br>


  <table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">Confirm delete operation:</span></td>
          </tr>
          <tr> 
            <td align="center"> Are you sure you want to delete this page? This action cannot be undone.  <cfoutput><a href="trempage.cfm?confirmdelete=yes&teacher_id=#URL.teacher_id#"> </cfoutput> YES</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="adminmain.cfm">NO</a> </td>
          </tr>
        </table>

<br><br><cfinclude template="../footer.cfm"></body>
</html>
<cfelse><cflocation url="http://www.marcellusschools.org" addtoken="No"><cfabort>
</cfif>