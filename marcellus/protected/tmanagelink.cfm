

<cfquery name="info" datasource="#datasource#">
SELECT *
FROM tpagelinks tp
WHERE tp.tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>


<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br>


  <table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">Manage Links</span></td>
          </tr>
		  
		  <!--- navbar --->
		  <tr><td bgcolor="#ffffff" class="BL noPadCell" colspan="3">
		  
		 <table border="0" cellspacing="0" cellpadding="0"><tr>
		 <td><img src="http://www.cnyric.org/images/tempedit_navbar_jumpto.gif" alt="" border="0"></td>
		 <td><a href="teditpage.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_tempedit.gif" alt="" border="0"></a></td>
		  <td><a href="adminmain.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_admin.gif" alt="" border="0"></a></td><td><a href="adminAddPage.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_addpage.gif" alt="" border="0"></a></td>
		 <td><a href="../logout.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_logout.gif" alt="" border="0"></a></td>
		 </tr></table>
		 </td></tr>
		 <!--- spacer row --->
		  <tr><td height="20"></td></tr>
		  
		  <!--- end navbar --->
		  
		  
		  <tr> 
            <td align="left"> <span class="tempeditHeader">Add a link:</span> </td>
          </tr>
		  
		  <CFFORM ACTION="taddelt.cfm" NAME="addform" METHOD="POST">
		  <input type="hidden" name="elt" value="link">
		  <tr><td colspan="3">
		  <table width="100%" border="0" cellspacing="0" cellpadding="5">
		  <tr> 
            <td align="right"> Link title: </td>
            <td align="left"> 
      <cfinput type="Text" name="addtext" required="No" size="50" maxlength="255" class="gl_textbox"> </td>
          </tr>
		  
          <tr> 
            <td align="right"> Link URL: </td>
            <td align="left"> <cfinput type="Text" name="link_url" message="Please enter a URL" required="Yes" size="50" maxlength="255" class="gl_textbox">
</td>
          </tr>
		  
		 
		  <tr> 
            <td align="right"> Order on page: </td>
            <td align="left"> 
      <cfinput type="Text" name="rankorder" value="99" validate="integer" required="No" size="3" maxlength="2" class="gl_textbox"> </td>
          </tr>
		  
		   <tr> 
            <td>&nbsp;</td>
            <td align="left"> <input type="submit" class="gl_submit" name="Submit" value="Add this link"></td>
          </tr>
		  
		  </table>
		  
		  </td></tr>
		  </CFFORM>
		  
		  <tr><td align="left" colspan="3" class="BL"></td></tr>
		  
		  <tr> 
            <td align="left"> <span class="tempeditHeader">Your current links:</span> </td>
          </tr>
		  
		  <cfoutput query="info">
		  <cfform name="form1" method="post" action="tupdateelt.cfm">
		  
		  <tr> 
            <td align="right" valign="middle" colspan="2"> Link #currentrow# title: </td>
            <td align="left"> 
<cfinput type="Text" name="link_name" value="#link_name#" message="Please enter a name for this link" required="Yes" size="50" maxlength="255" class="gl_textbox"></td>
          </tr>
          <tr> 
            <td align="right" valign="top" colspan="2"> Link #currentrow# URL: </td>
            <td align="left"> 
<cfinput type="Text" name="link_url" value="#link_url#" message="Please enter a URL for this link" required="Yes" size="50" maxlength="255" class="gl_textbox"><br>
Rank: <cfinput type="Text" name="rankorder" value="#rankorder#" validate="integer" required="No" size="3" maxlength="2">
			<input type="hidden" name="link_id" value="#link_id#">
			<input type="hidden" name="elttype" value="link">
			<input type="submit" class="gl_submit" value="Save Changes"> 
			<font size="-1"><a href="tremoveelt.cfm?link_id=#link_id#&elttype=link">remove</a></font></td>
          </tr>
		  </cfform>
		  <tr><td align="left" colspan="3" class="BL"></td></tr>
		  
		  </cfoutput>
		  
		  
        </table>

<br><br><cfinclude template="../footer.cfm"></body>
</html>