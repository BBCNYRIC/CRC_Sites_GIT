

<cfif isdefined("URL.restore")>


<cfquery datasource="#datasource#" name="backupQ">
SELECT bodyBackup
FROM pageatt
WHERE tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>


<cfquery datasource="#datasource#">
UPDATE pageatt
SET body = <cfqueryparam value="#backupQ.bodyBackup#" cfsqltype="CF_SQL_LONGVARCHAR">
WHERE tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<cflocation url="teditpage.cfm" addtoken="No"><cfabort>

</cfif>


<!--- get content in backup --->
<cfquery datasource="#datasource#" name="pageatt2">
SELECT bodyBackup
FROM pageatt
WHERE tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>


<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br>

<table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">Page Backup</span></td>
          </tr>
		  
		  <tr> 
		  		<td align="left">
				Below is the content of your page that we have in backup (scroll down to view the content).  <br><br>
				Click here to restore your page to this version -> <a href="pageBackup.cfm?restore=yes">Restore this page</a><br><br>
				If you do not want to restore this page click here -> <a href="teditpage.cfm">Do Not Restore this page</a>
				</td>
          </tr>
		 <tr> 
		  		<td align="left" class="LL RL TL BL">
				<cfoutput>#pageatt2.bodyBackup#</cfoutput>
				</td>
          </tr>
		  
		  
		  <tr> 
            <td align="right"> <a href="adminmain.cfm">Back to main</a> </td>
          </tr>
		  
		  
        </table>

<br><br><cfinclude template="../footer.cfm"></body>
</html>