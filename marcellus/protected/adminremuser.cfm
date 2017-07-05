<cfif session.auth.authlevel LT 2>
You dont have access to this page<cfabort></cfif>


<!--- user has confirmed the delete operation --->
<cfif isdefined("URL.confirmdelete")>

<!--- check to make sure they have access to delete --->
<cfquery name="checkaccess" datasource="#datasource#">
SELECT *
FROM contacts
WHERE tid = <cfqueryparam value="#URL.teacher_id#" cfsqltype="CF_SQL_INTEGER">
</cfquery>


<cfif (NOT listFindNoCase(session.auth.accesscode,checkaccess.accessgroup)) AND session.auth.authlevel NEQ 3>

You don't have access to delete this item<cfabort>
</cfif>


<cftransaction>
<cflock timeout="10" throwontimeout="No" type="EXCLUSIVE">


<!--- query to see if this is a password protected page --->
<cfquery name="getpppage" datasource="#datasource#">
SELECT pppage
FROM pageatt 
WHERE tid = <cfqueryparam value="#URL.teacher_id#" cfsqltype="CF_SQL_INTEGER">
</cfquery>


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

<!--- check to see if we're dealing with a protected page --->
<cfif #session.URLadd# NEQ "" OR getpppage.pppage EQ 'yes'>
	<cfset variables.folderAppend = "Proc">
<cfelse><cfset variables.folderAppend = "">
</cfif>

<!--- remove the actual files --->
<cfif directoryExists("F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles#variables.folderAppend#\folder#URL.teacher_id#") IS "Yes">
<cfdirectory action="LIST" directory="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles#variables.folderAppend#\folder#URL.teacher_id#\" name="getlist">
<cfoutput query="getlist">
<cffile action="DELETE" file="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles#variables.folderAppend#\folder#URL.teacher_id#\#name#">
</cfoutput>
<cfdirectory action="DELETE" directory="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles#variables.folderAppend#\folder#URL.teacher_id#">
</cfif>

</cflock></cftransaction>


<!--- selection has been deleted, tell the user --->
<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br>

<META http-equiv="refresh" content= "1; url=adminmain.cfm">

<table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">Confirm delete operation:</span></td>
          </tr>
          <tr> 
            <td align="center"> <strong>The item has been deleted</strong> </td>
          </tr>
        </table>

<br><br><cfinclude template="../footer.cfm"></body>
</html>


<cfabort>
</cfif>

<cfif isdefined("URL.teacher_id")>
<!--- confirm the delete --->
<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br>


  <table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">Confirm delete operation:</span></td>
          </tr>
          <tr> 
            <td align="center"> Are you sure you want to delete this item?  <cfoutput><a href="adminremuser.cfm?confirmdelete=yes&teacher_id=#URL.teacher_id#"> </cfoutput> YES</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="adminmain.cfm">NO</a> </td>
          </tr>
        </table>

<br><br><cfinclude template="../footer.cfm"></body>
</html>
<cfelse><cflocation url="http://www.marcellusschools.org" addtoken="No"><cfabort>
</cfif>