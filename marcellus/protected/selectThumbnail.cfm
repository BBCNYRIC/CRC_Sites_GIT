

 
<!--- if they're using a stock image, copy the image from stock image folder to our current folder --->
<cfif isdefined("URL.img")>
		
<cfif URL.stock EQ 'yes'>
		
		
		<!--- check if user already has a directory on the server --->
	<cfif directoryExists("F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#") IS "No">
		<!--- if not, create the directory --->
		<cfdirectory action="create" directory="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#">
	</cfif>
	
		
			<!--- calculate new height based on thumbnail width --->
		<cfimage action="info" structname="tempimage" source="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder1144\#URL.img#" />
			
		<cfset variables.newheight = Round(((110) * #tempimage.height#) / #tempimage.width#)>

			
		<cfimage action="resize" 
				 source="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder1144\#URL.img#" 
				 destination="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#\newsthumbnail.jpg"
				 width="110" 
				 height="#variables.newheight#" 
				 overwrite="true" />
		
		
		<!--- see if this page already has a thumbnail, if so don't add a db entry, it should already be there --->
		<cfquery datasource="#datasource#" name="checkForThumb">
		SELECT filename
		FROM tfiles
		WHERE filename = <cfqueryparam value="newsthumbnail.jpg" cfsqltype="CF_SQL_CHAR">
			AND tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>
		
		<cfif checkForThumb.recordcount EQ 0>
		<!--- add entry to database so this thumbnail will show up in the manage files section --->
		<cfquery datasource="#datasource#">
		INSERT INTO tfiles(tid, filename, linkname, filetype, filesize, showLink)
		VALUES (#session.auth.uid#, 
				'newsthumbnail.jpg', 
				<cfqueryparam value="news thumbnail" cfsqltype="CF_SQL_CHAR">, 
				'jpg', 
				'100', 
				<cfqueryparam value="no" cfsqltype="CF_SQL_CHAR">)
		</cfquery>
		</cfif>
		
		
		<!--- done with stock image operations, send user back to tempEDIT --->
		<cflocation url="teditpage.cfm" addtoken="No"><cfabort>
		</cfif>
		</cfif>
		




<!--- get this users images --->
<cfquery datasource="#datasource#" name="getimages">
SELECT *
FROM tfiles
WHERE tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
	AND filename <> 'newsthumbnail.jpg'
	AND filename <> 'mainNewsImage.jpg'
	AND (filetype = 'gif' OR 
		filetype = 'jpg' OR 
		filetype = 'jpeg' OR 
		filetype = 'tif' OR 
		filetype = 'png')
</cfquery>

<!--- get stock images --->
<cfquery datasource="#datasource#" name="getimages2">
SELECT *
FROM tfiles
WHERE tid = 1144
	AND (filetype = 'gif' OR 
		filetype = 'jpg' OR 
		filetype = 'jpeg' OR 
		filetype = 'tif' OR 
		filetype = 'png')
</cfquery>


<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br>

<!--- <script type="text/javascript">
	<!--
		function toggleTable()
		{
			document.getElementById("submittable").style.display="none";
			document.getElementById("waittable").style.display="block";
		}
		-->
</script> --->


<table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">Select an image to use as a thumbnail</span></td>
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
		 <!---  <tr><td height="20"></td></tr> --->
		  
		  <!--- end navbar --->
		  
		  
		 
		  <tr>
		  
		  <!--- check to make sure this image actually exists --->
		   <cfif fileExists("F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#\newsthumbnail.jpg")>
		   <td align="center" valign="middle"><img src="http://www.cnyric.org/images/tempedit_thumbnailOK.png" alt="" border="0" align="middle"> &mdash;&mdash;&mdash;&mdash;&gt;
		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  
		  <cfoutput><img src="../tfiles/folder#session.auth.uid#/newsthumbnail.jpg" alt="" border="0" align="middle"></cfoutput>
		  
		  <cfelse>
		  <td align="center"><img src="http://www.cnyric.org/images/tempedit_thumbnailNOTOK.png" alt="" border="0" align="middle">
		  </cfif>
		  </td>
		  </tr>
		  <tr><td colspan="2" align="center" class="BL TL">Click an image below to use it as the thumbnail for this article <strong>OR</strong> <a href="tmanagefile.cfm?thumbnail=true">Click here to upload a new image</a></td></tr>
		 

		   
		   <!--- display their images --->
		   <cfoutput query="getimages">
		   
		   <!--- check to make sure this image actually exists --->
		   <cfif fileExists("F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#\#filename#")>
		   
		   <!--- some images are prone to error, trap it here --->
		   <cftry>
		   
		   <cfimage action="info" structname="imagetemp" source="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#\#filename#" />
		   
		   <cfcatch type="Any">
		   		<cfset variables.imageError = 'true'>
			</cfcatch>
			
			</cftry>

		<cfif NOT isdefined("variables.imageError")>
		
		   <tr>
		   <!--- <td align="center"><input type="radio" name="imagethumb" value="#file_id#"></td> --->

		   <!--- display image as it will appear in news story, ie 110 x the new height --->
		   <cfset variables.newheight = Round(((110) * #imagetemp.height#) / #imagetemp.width#)>
		   
		   <cfset variables.randnum = RandRange(1, 566)>
		   <td align="center" class="BL"><a href="cropImage.cfm?img=#encodeForURL(filename)#&stock=#variables.randnum#no&fileid=#file_id#"><img src="../tfiles/folder#session.auth.uid#/#filename#" width="110" height="#variables.newheight#"><br>#linkname# (#filename#)</a></td>

		   </tr></cfif><!--- end image error trapping --->
		   
		   </cfif>
		   </cfoutput>

		   
		   <!--- display stock images --->
		   <cfoutput query="getimages2">
		   
		   <!--- check to make sure this image actually exists --->
		   <cfif fileExists("F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder1144\#filename#")>
		   
		   <cfimage action="info" structname="imagetemp" source="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder1144\#filename#" />
		   
		   <tr>
		   <!--- <td align="center"><input type="radio" name="imagethumb" value="stockimage_#file_id#"></td> --->

		   <!--- display image as it will appear in news story, ie 110 x the new height --->
		   <cfset variables.newheight = Round(((110) * #imagetemp.height#) / #imagetemp.width#)>
		   
		   
		   <td align="center" class="BL"><a href="selectThumbnail.cfm?img=#encodeForURL(filename)#&stock=yes&fileid=#file_id#"><img src="../tfiles/folder1144/#filename#" width="110" height="#variables.newheight#"><br>#linkname# (#filename#)</a></td>

		   </tr>
		   
		   </cfif>
		   </cfoutput>

        </table>

<br><br><cfinclude template="../footer.cfm"></body>
</html>