
<!--- if form is being submitted, do the resizing --->
<cfif isdefined("FORM.piclist")>
 
	<cfloop index="i" list="#FORM.piclist#">
	<!--- check if this pic was chosen for a resize and make sure the numbers arent too high or low --->
		<cfif (isdefined("FORM.pic#i#")) AND (#Evaluate("FORM.pic#i#")# NEQ '') AND (#Evaluate("FORM.pic#i#")# GT 0) AND (#Evaluate("FORM.pic#i#")# LT 1001)>
			
		<!--- we need to query so we can have the filename --->
		<cfquery datasource="#datasource#" name="getfilename">
		SELECT filename
		FROM tfiles
		WHERE file_id = <cfqueryparam value="#i#" cfsqltype="CF_SQL_INTEGER">
			AND tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>
			
		<!--- calculate new height based on width passed from form --->
		<cfimage action="info" structname="tempimage" source="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#\#getfilename.filename#" />
			
			<cfset variables.newheight = Round(((#Evaluate("FORM.pic#i#")#) * #tempimage.height#) / #tempimage.width#)>

			
		<cfimage action="resize" 
				 source="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#\#getfilename.filename#" 
				 destination="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#\#getfilename.filename#"
				 width="#Evaluate('FORM.pic#i#')#" 
				 height="#variables.newheight#" 
				 overwrite="true" />
			
		</cfif>
	
	</cfloop>

<!--- if coming from the manage files page, send them back there --->
	<cfif isdefined("FORM.backtofiles")>
	<cflocation url="tmanagefile.cfm" addtoken="No"><cfabort></cfif>
	
	
</cfif>




<cfquery datasource="#datasource#" name="getimages">
SELECT *
FROM tfiles
WHERE tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
	AND (filetype = 'gif' OR 
		filetype = 'jpg' OR 
		filetype = 'jpeg' OR 
		filetype = 'tif' OR 
		filetype = 'png')
</cfquery>
	


<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br>

<script type="text/javascript">
	<!--
		function toggleTable()
		{
			document.getElementById("submittable").style.display="none";
			document.getElementById("waittable").style.display="block";
		}
		-->
</script>


<table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">Select images to resize</span></td>
          </tr>
		  
		  <!--- navbar --->
		  <tr><td bgcolor="#ffffff" class="BL noPadCell" colspan="3">
		  
		 <table border="0" cellspacing="0" cellpadding="0"><tr>
		 <td><img src="http://www.cnyric.org/images/tempedit_navbar_jumpto.gif" alt="" border="0"></td>
		 <td><a href="teditpage.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_tempedit.gif" alt="" border="0"></a></td>
		 <td><a href="tmanagefile.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_images.gif" alt="" border="0"></a></td>
		 <td><a href="adminmain.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_admin.gif" alt="" border="0"></a></td>
		 <td><a href="../logout.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_logout.gif" alt="" border="0"></a></td>
		 </tr></table>
		 </td></tr>
		 <!--- spacer row --->
		  <tr><td height="20"></td></tr>
		  
		  <!--- end navbar --->
		  
		  
		  
		  <cfform action="#CGI.SCRIPT_NAME#" method="POST">
		  <cfoutput><input type="hidden" name="piclist" value="#valuelist(getimages.file_id)#"></cfoutput>
		  
		 
		   <cfoutput query="getimages">
		   
		   <!--- check to make sure this image actually exists --->
		   <cfif fileExists("F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#\#filename#")>
		   
		   <cfimage action="info" structname="imagetemp" source="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#\#filename#" />
		   
		   <tr>
		   <td>New width : <cfinput type="Text" name="pic#file_id#" message="Please enter an integer for picture size" validate="integer" required="No" size="5" maxlength="5"><br>
<font size="-2">(height will be calculated automatically)</font></td>

		   <td><img src="../tfiles/folder#session.auth.uid#/#filename#" width="100" height="100"></td>
<td> #linkname# (#filename#)<br> Current size: width: #imagetemp.width# X height: #imagetemp.height#</td>
		   </tr>
		   
		   </cfif>
		   </cfoutput>
		   
		   <tr><td>
		   
		   <table id="submittable"><tr><td><input type="submit" id="submit" name="submit" value="Resize" onclick="toggleTable();" class="gl_submit"/></td></tr></table>
<table id="waittable" style="display:none;"><tr><td>One moment please, your files are being processed...</td></tr></table>

</td></tr>

		  </cfform>
         
          
		  </table>
		 

<br><br><cfinclude template="../footer.cfm">