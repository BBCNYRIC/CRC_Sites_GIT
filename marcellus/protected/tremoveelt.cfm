<cfif NOT isdefined("URL.elttype")>
<cflocation url="http://www.marcellusschools.org" addtoken="No">
<cfabort></cfif>

<cfif URL.elttype IS "link"><cfset urlstring="link_id=#URLEncodedFormat(link_id)#&confirmdelete=yes&elttype=link">
<cfelseif URL.elttype IS "ann"><cfset urlstring="ann_id=#ann_id#&confirmdelete=yes&elttype=ann">
<!--- <cfelseif URL.elttype IS "cal"><cfset urlstring="eventID=#eventID#&confirmdelete=yes&elttype=cal"> --->
<cfelseif URL.elttype IS "file"><cfset urlstring="file_id=#file_id#&confirmdelete=yes&elttype=file">
</cfif>


<cfif isdefined("URL.confirmdelete")>

<cfif URL.elttype IS "link">
<cfquery datasource="#datasource#">
DELETE FROM tpagelinks
WHERE link_id = <cfqueryparam value="#URL.link_id#" cfsqltype="CF_SQL_INTEGER">
	AND tpagelinks.tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery></cfif>

<cfif URL.elttype IS "ann">
<cfquery datasource="#datasource#">
DELETE FROM tpageann
WHERE ann_id = <cfqueryparam value="#URL.ann_id#" cfsqltype="CF_SQL_INTEGER">
	AND tpageann.tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery></cfif>

<!--- <cfif URL.elttype IS "cal">
<cfquery datasource="#datasource#">
DELETE FROM schcal
WHERE eventID = <cfqueryparam value="#URL.eventID#" cfsqltype="CF_SQL_INTEGER">
	AND schcal.tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery></cfif> --->

<!--- remove file from server, keep record in database --->
<cfif URL.elttype IS "file">

<!--- get the file name to delete from server --->
<cfquery datasource="#datasource#" name="getfilename">
SELECT filename
FROM tfiles
WHERE file_id = <cfqueryparam value="#file_id#" cfsqltype="CF_SQL_INTEGER">
	AND tfiles.tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<!--- query to see if this is a password protected page --->
<cfquery name="getpppage" datasource="#datasource#">
SELECT pppage
FROM pageatt 
WHERE tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<cftransaction>
<cfquery datasource="#datasource#">
DELETE FROM tfiles
WHERE file_id = <cfqueryparam value="#file_id#" cfsqltype="CF_SQL_INTEGER">
	AND tfiles.tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>
<!--- check to see if we're dealing with a protected page --->
<cfif #session.URLadd# NEQ "" OR getpppage.pppage EQ 'yes'>
	<cfset variables.folderAppend = "Proc">
<cfelse><cfset variables.folderAppend = "">
</cfif>
<cffile action="DELETE" file="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles#variables.folderAppend#\folder#session.auth.uid#\#getfilename.filename#"> 
</cftransaction>
</cfif>

<!--- selection has been deleted, tell the user --->
<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br><br>

<META http-equiv="refresh" content= "1; url=tmanage<cfoutput>#elttype#</cfoutput>.cfm">

  <table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">Confirm delete operation:</span></td>
          </tr>
          <tr> 
            <td align="center"> <strong>Your selection has been deleted</strong> </td>
          </tr>
        </table>

<br><br><cfinclude template="../footer.cfm"></body>
</html>


<cfabort>
</cfif>

<!--- confirm the delete --->
<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br><br>
 

  <table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">Confirm delete operation:</span></td>
          </tr>
          <tr> 
            <td align="center"> Are you sure you want to delete?  <cfoutput><a href="tremoveelt.cfm?#urlstring#"> </cfoutput> YES</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="tmanage<cfoutput>#elttype#</cfoutput>.cfm">NO</a> </td>
          </tr>
        </table>

<br><br><cfinclude template="../footer.cfm"></body>
</html>
