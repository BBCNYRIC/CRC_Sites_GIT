<cfif NOT #session.auth.loggedInId# EQ 39>
You dont have access to this page<cfabort></cfif>

<!--- if this form has been submited, update the record --->
<cfif isdefined("FORM.updated")>

<!--- query for max id, ours will be next available number --->
<cfquery name="getmaxid" datasource="#datasource#">
SELECT MAX(code_id) as maxid
FROM accessgroup
</cfquery>


<!--- insert account information in contacts --->
<cfquery datasource="#datasource#">
INSERT INTO accessgroup(groupname, groupid, iscat)
VALUES (<cfqueryparam value="#FORM.groupname#" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="#incrementvalue(getmaxid.maxid)#" cfsqltype="CF_SQL_INTEGER">,
		<cfqueryparam value="yes" cfsqltype="CF_SQL_CHAR">
		)
</cfquery>



</cfif>



<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br>


<cfform name="form1" method="post" action="#CGI.SCRIPT_NAME#">

<input type="hidden" name="updated" value="yes">
<table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">Add a category (Josh Only)</span></td>
          </tr>
		 
		  
		  <tr> 
            <td align="right"> Group Name: </td>
            <td> <cfinput type="Text" name="groupname" message="Please enter a page name" required="Yes" size="50" maxlength="255" class="gl_textbox"> </td>
          </tr>
		
		
		  
		  
		  
		  <tr> 
            <td align="right"> <a href="adminmain.cfm">Back to main</a> </td>
          </tr>
		  
          <tr> 
            <td>&nbsp;</td>
            <td> <input type="submit" class="gl_submit" name="Submit" value="Add this group"> 
			     <input type="reset" class="gl_submit" name="reset" value="Reset All Fields"></td>
          </tr>
        </table>
</cfform>
<br><br><cfinclude template="../footer.cfm"></body>
</html>