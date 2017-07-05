
<cfquery name="info" datasource="#datasource#">
SELECT *
FROM tpageann tp
WHERE tp.tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
ORDER BY rankorder</cfquery>


<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br>


<script type="text/javascript" src="/ocm_ckeditor/ckeditor.js"></script>


  <table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">Manage Announcements</span></td>
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
            <td align="left"> <span class="tempeditHeader">Add an announcement:</span> </td>
          </tr>
		  
		  <CFFORM ACTION="taddelt.cfm" NAME="addform" METHOD="POST">
		  <input type="hidden" name="elt" value="ann">
		  <tr><td colspan="3">
		  <table width="100%" border="0" cellspacing="0" cellpadding="5">
		  <tr> 
            <td align="right"> Announcement title: </td>
            <td align="left"> 
      <cfinput type="Text" name="ann_header" required="No" size="50" maxlength="75" class="gl_textbox"> </td>
          </tr>
		  
          <tr> 
            <td align="right"> Announcement text: </td>
            <td align="left"> 			
			<textarea cols="80" id="addtext" name="addtext" rows="1">
			
			</textarea>
			
			<script data-sample="2">
				CKEDITOR.replace( 'addtext', {
					allowedContent:
							'a[!href];' +
							'p[!style];',
							// p exception says allow p tag only if a "style" is defined (i chose style randomly).  this is because ckeditor replaces disallowed tags with the <p> tag for some reason, this workaround supresses that
							
					removeButtons: 'Source,Templates,Preview,Cut,Copy,Paste,PasteFromWord,PasteText,Undo,Redo,Find,Replace,SelectAll,Indent,Scayt,Maximize,Indent,Outdent,ShowBlocks,Styles,Format,SpecialChar,RemoveFormat,About',
					height: 50,
					width: 500,
					removePlugins: 'elementspath',
					enterMode: CKEDITOR.ENTER_BR
				} );
			</script>
       

			</td>
          </tr>
		  
		 
		  <tr> 
            <td align="right"> Order on page: </td>
            <td align="left"> 
      <cfinput type="Text" name="rankorder" value="99" validate="integer" required="No" size="3" maxlength="2" class="gl_textbox"> </td>
          </tr>
		  
		   <tr> 
            <td>&nbsp;</td>
            <td align="left"> <input type="submit" class="gl_submit" name="Submit" value="Add this announcement"></td>
          </tr>
		  
		  </table>
		  
		  </td></tr>
		  </CFFORM>
		  
		  <tr><td align="left" colspan="3" class="BL"></td></tr>
		  
		  <tr> 
            <td align="left"> <span class="tempeditHeader">Your current announcements:</span> </td>
          </tr>
		  
		  <cfoutput query="info">
		  <cfform name="form#ann_id#" method="post" action="tupdateelt.cfm">
		  
		  <tr> 
            <td align="right" valign="middle" colspan="2"> Announcement #currentrow# title: </td>
            <td align="left"> 
<cfinput type="Text" name="ann_header" value="#ann_header#" required="No" size="50" maxlength="75" class="gl_textbox"></td>
          </tr>
          <tr> 
            <td align="right" valign="top" colspan="2"> Announcement #currentrow# text: </td>
            <td align="left"> 
<!--- <cfinput type="Text" name="ann_text" value="#ann_text#" required="No" size="50" maxlength="255"> --->
<textarea cols="80" id="ann_text#ann_id#" name="ann_text#ann_id#" rows="1">#ann_text#</textarea>

			<script data-sample="2">
				CKEDITOR.replace( 'ann_text#ann_id#', {
					allowedContent:
							'a[!href];' +
							'p[!style];',
							// p exception says allow p tag only if a "style" is defined (i chose style randomly).  this is because ckeditor replaces disallowed tags with the <p> tag for some reason, this workaround supresses that
							
					removeButtons: 'Source,Templates,Preview,Cut,Copy,Paste,PasteFromWord,PasteText,Undo,Redo,Find,Replace,SelectAll,Indent,Scayt,Maximize,Indent,Outdent,ShowBlocks,Styles,Format,SpecialChar,RemoveFormat,About',
					height: 50,
					width: 500,
					removePlugins: 'elementspath',
					enterMode: CKEDITOR.ENTER_BR
				} );
			</script>

<br>
Rank: <cfinput type="Text" name="rankorder" value="#rankorder#" validate="integer" required="No" size="3" maxlength="2" class="gl_textbox">

			<input type="hidden" name="ann_id" value="#ann_id#">
			<input type="hidden" name="elttype" value="ann">
			<input type="submit" class="gl_submit" value="Save Changes"> 
			<font size="-1"><a href="tremoveelt.cfm?ann_id=#ann_id#&elttype=ann">remove</a></font></td>
          </tr>
		  </cfform>
		  <tr><td align="left" colspan="3" class="BL"></td></tr>
		  
		  </cfoutput>
		  
		  
        </table>

<br><br><cfinclude template="../footer.cfm"></body>
</html>