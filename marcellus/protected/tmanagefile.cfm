
<!--- query to see if this is a password protected page --->
<cfquery name="getpppage" datasource="#datasource#">
SELECT pppage
FROM pageatt 
WHERE tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>


<!--- if this form was submitted --->
<cfif isdefined("FORM.doneupload")>

<!--- if not coming from this page --->
<cfif cgi.http_referer does not contain "marcellusschools.org"><cflocation url="http://www.marcellusschools.org" addtoken="No"><cfabort></cfif>

<cftransaction>
	<!--- cffile operations --->
	<cflock timeout="30" throwontimeout="No" type="EXCLUSIVE">
	
	<!--- check to see if we're dealing with a protected page --->
<cfif #session.URLadd# NEQ "" OR getpppage.pppage EQ 'yes'>
	<cfset variables.folderAppend = "Proc">
<cfelse><cfset variables.folderAppend = "">
</cfif>


<!--- include allowed mime types, this lists the file extensions and their associated mime types --->
<cfinclude template="../../cfGlobalCode/allowedMimeTypes.cfm">




	<!--- do the upload, catch errors --->
	<cftry>
	<cffile action="upload"
			filefield="FORM.filename"
			destination="F:\Inetpub\wwwroot\crc_sites\zTempUploads"
			nameconflict="makeunique"
			result="request.uploadResult"
			strict="false"
			accept="#variables.allowedExtensions#">

<cfcatch>
<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br>
    <cfoutput>
        #CFCATCH.message#
        <br>#CFCATCH.detail#<cfabort>
        <br>
    </cfoutput>
	<cfinclude template="../footer.cfm">
</cfcatch>
</cftry>


<!--- get actual mime type of uploaded file--->
<cfset variables.actualMimeType = FileGetMimeType(request.uploadResult.ServerDirectory & '/' & request.uploadResult.ServerFile, true) />


<!--- if the extension is one of our allowed extensions --->
<cfif StructKeyExists(variables.allowedMimeTypes,request.uploadResult.ServerFileExt)>

<!--- compare file extension to mime type.  an extension could have multiple acceptable mime types due to adobe and MS glitches --->
<cfif #listFindNoCase(StructFind(variables.allowedMimeTypes, request.uploadResult.ServerFileExt),variables.actualMimeType,',')# NEQ 0>



<!--- file size check can be done here, for now were using the max post size limit in cf admin, set to 65MB --->
<!--- good to go, move the file to appropriate place --->
<!--- check if user already has a directory on the server --->
<cfif directoryExists("F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles#variables.folderAppend#\folder#session.auth.uid#") IS "No">
	<!--- if not, create the directory --->
	<cfdirectory action="create" directory="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles#variables.folderAppend#\folder#session.auth.uid#">
</cfif>

<cffile action="move"
        source="#request.uploadResult.ServerDirectory#\#request.uploadResult.ServerFile#" 
        destination="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles#variables.folderAppend#\folder#session.auth.uid#" />

<!--- if the makeunique had to rename the file, name it back to the users' specs --->
<cfif #request.uploadResult.ServerFile# NEQ #request.uploadResult.ClientFile#>
<cffile action="RENAME" source="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles#variables.folderAppend#\folder#session.auth.uid#\#request.uploadResult.ServerFile#" destination="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles#variables.folderAppend#\folder#session.auth.uid#\#request.uploadResult.ClientFile#">
</cfif>


<!--- file type and mime type dont match, error --->
<cfelse>
<!--- delete the file --->
<cffile action="delete" file="#request.uploadResult.ServerDirectory#\#request.uploadResult.ServerFile#">


<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br>
Error: invalid file type - <a href="tmanagefile.cfm">back to files page</a>
<cfinclude template="../footer.cfm">

<cfabort>
</cfif>
</cfif>


			
<!--- begin error trapping code (replaced by accept attribute of cffile) --->
<!--- user is NOT allowed to upload a cfm file! check file size, too --->
<!--- <cfif ((cffile.clientfileext EQ "cfm") OR (cffile.clientfileext EQ "cfml") OR (cffile.clientfileext EQ "exe") OR (cffile.clientfileext EQ "sys") OR (cffile.clientfileext EQ "bat") OR (cffile.clientfileext EQ "ini") OR (cffile.clientfileext EQ "asp") OR (cffile.clientfileext EQ "php") OR (cffile.clientfileext EQ "jsp"))>
<cffile action="DELETE" file="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles#variables.folderAppend#\folder#session.auth.uid#\#cffile.serverfile#"> 
<cflocation url="uploaderror.cfm" addtoken="No"><cfabort>
</cfif> --->
<!--- end error trapping code --->



<!--- check if this file is already refered to in the database.  if it is, update the table information instead of inserting it.  this way, if a teacher uploads a file that they already have uploaded, it will simply overwrite both the file on the server and the info in the db --->
<cfquery datasource="#datasource#" name="isfileindb">
SELECT file_id
FROM tfiles
WHERE filename = <cfqueryparam value="#request.uploadResult.ClientFile#" cfsqltype="CF_SQL_CHAR">
	AND tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<cfparam name="FORM.showLink" default="No">

<!--- if we already have that file in the db, update instead of insert --->
<cfif isfileindb.recordcount EQ 1>
	<cfquery datasource="#datasource#">
	UPDATE tfiles
	SET linkname=<cfqueryparam value="#FORM.linkname#" cfsqltype="CF_SQL_CHAR">,
		filetype=<cfqueryparam value="#request.uploadResult.clientfileext#" cfsqltype="CF_SQL_CHAR">,
		filesize=<cfqueryparam value="#request.uploadResult.filesize#" cfsqltype="CF_SQL_INTEGER">,
		showLink=<cfqueryparam value="#FORM.showLink#" cfsqltype="CF_SQL_CHAR">
	WHERE file_id = <cfqueryparam value="#isfileindb.file_id#" cfsqltype="CF_SQL_INTEGER">
	</cfquery>

<cfelse>
	<!--- insert filename and link name into tfile table where tid is auth.uid --->
	<cfquery datasource="#datasource#">
	INSERT INTO tfiles(tid, filename, linkname, filetype, filesize, showLink)
	VALUES (<cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">, 
		   <cfqueryparam value="#request.uploadResult.ClientFile#" cfsqltype="CF_SQL_CHAR">, 
		   <cfqueryparam value="#FORM.linkname#" cfsqltype="CF_SQL_CHAR">, 
		   <cfqueryparam value="#request.uploadResult.clientfileext#" cfsqltype="CF_SQL_CHAR">, 
		   <cfqueryparam value="#request.uploadResult.filesize#" cfsqltype="CF_SQL_INTEGER">, 
		   <cfqueryparam value="#FORM.showLink#" cfsqltype="CF_SQL_CHAR">)
	</cfquery>
</cfif>


</cflock></cftransaction>
</cfif> <!--- end of cffile operation --->


<cfif isdefined("FORM.thumbnail")>
	<cflocation url="selectThumbnail.cfm" addtoken="No"><cfabort>
</cfif>


<cfquery name="info" datasource="#datasource#">
SELECT *
FROM tfiles fz
WHERE fz.tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
ORDER BY rankorder
</cfquery>


<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br>



<script type="text/javascript">
<!--
	function showhide(id, id2){ 

		document.getElementById(id).style.display="none";
		document.getElementById(id2).style.display="";  
        
    }
-->
</script>


<CFFORM ACTION="#CGI.SCRIPT_NAME#" NAME="uploadform" METHOD="POST" enctype="multipart/form-data">
<input type="hidden" name="doneupload" value="true">
<cfif isdefined("URL.thumbnail")>
	<input type="hidden" name="thumbnail" value="true">
</cfif>

  <table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL"><img src="http://www.cnyric.org/images/tempedit_images.gif" width="237" height="56" alt="" border="0"></td>
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
            <td align="left" width="150" nowrap> <strong>Upload a New File</strong> </td>
			<td align="right" width="150" nowrap> Choose a file: </td>
            <td align="left"> 
      <input type="file" name="filename" size="40" class="gl_textbox" style="HEIGHT: 20px;"> </td>
          </tr>
		  
		  
		  <tr> <td></td>
            <td align="right"> Description of file: </td>
            <td align="left"> 
      <cfinput type="text" class="gl_textbox" name="linkname" required="No" size="40"> </td>
          </tr>
		  
		  <tr><td colspan="2"></td>
		  <td align="left">Automatically display link on page <input type="checkbox" name="showLink" value="yes">
		  </td></tr>

          <tr> 
            <td colspan="2">&nbsp;</td>
            <td align="left"> 
<table id="submittable"><tr><td>
<input type="submit" class="gl_submit" name="Submit" value=" Upload File " onclick="showhide('submittable','submittable2');">
<!--- <input type="reset" class="gl_submit" name="reset" value="Reset form"> --->
</td></tr></table>
<table id="submittable2" style="display:none;"><tr><td>One moment please, your files are being processed...</td></tr></table>
			
			     </td>
          </tr>
		  
		 
		 
        </table>
	
	

</CFFORM>

  <table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          
		  <tr> 
            <td align="left"> <strong>Your current files:</strong> </td>
			<td align="right"><a href="resizeImages.cfm" class="tempEDsmallLink">resize all images</a></td>
          </tr>
		  
		  <cfoutput query="info">
		  
		  <cfset variables.imageError = 'false'>
		  
		  <cfform name="form#file_id#" method="post" action="tupdateelt.cfm">
		<input type="hidden" name="file_id" value="#file_id#">
		<input type="hidden" name="elttype" value="file">
          <tr <cfif currentrow MOD 2 EQ 1>bgcolor="f2f2f2"</cfif>> 
            <td align="left" valign="top" class="TL"> <strong>File&nbsp;&nbsp;#currentrow#:</strong> </td>
            <td class="TL" align="left">
			<table>
			
<tr><td>File name: <a href="../tfiles/folder#session.auth.uid#/#filename#" target="_blank" class="tempEDsmallLink">#filename#</a></td></tr>
			
<tr><td>Description: <cfinput type="Text" name="linkname" value="#linkname#" required="No" size="50" maxlength="255" class="gl_textbox"></td></tr>
<tr><td>Rank: <cfinput type="Text" name="rankorder" value="#rankorder#" validate="integer" required="No" size="3" maxlength="3"></td></tr>

<tr><td>Display link on page <input type="checkbox" name="showLink" value="yes" <cfif #showLink# EQ 'yes'>checked</cfif>></td></tr>


 <cfif filetype EQ 'gif' OR filetype EQ 'jpg' OR filetype EQ 'jpeg' OR filetype EQ 'tif' OR filetype EQ 'png'>
		  
		  <!--- check to make sure this image actually exists --->
		   <cfif fileExists("F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#\#filename#")>
		   
		   <!--- some images are prone to error, trap it here --->
		   <cftry>
		   
		   <cfimage action="info" structname="imagetemp" source="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#\#filename#" />

			<cfcatch type="Any"><!--- #cfcatch.Detail# --->
		   		<cfset variables.imageError = 'true'>
			</cfcatch>
			
			</cftry>

		<cfif variables.imageError NEQ "true">
		

		  <tr>
		  
		  <td class="TL">
		  <table><tr>
		  <td><img src="/tfiles/folder#session.auth.uid#/#filename#" width="75" height="75"></td>
		  <td>Current size: width: #imagetemp.width# X height: #imagetemp.height#<br>
		  
		  <input type="hidden" name="backtofiles" value="true">
		  <input type="hidden" name="piclist" value="#file_id#">
		  
		  New width : <cfinput type="Text" name="pic#file_id#" message="Please enter an integer for picture size" validate="integer" required="No" size="5" maxlength="5"> <font size="-2">(height will be calculated automatically)</font><br>


</td>
		  
		  </tr></table>
		  
		  </td>
		  </tr></cfif><!--- end image error trapping --->
		  </cfif></cfif>
		  
		  

			
			
<tr><td>
<table id="resizetable#file_id#"><tr><td><div class="tempedsearchBar-submit"><input id="searchBtn" type="submit" value="Save Changes" onclick="showhide('resizetable#file_id#','resizetable2#file_id#');"></div></td></tr></table>
<table id="resizetable2#file_id#" style="display:none;"><tr><td>One moment please, your files are being processed...</td></tr></table>
</td>
<td><a href="tremoveelt.cfm?file_id=#file_id#&elttype=file"><img src="http://www.cnyric.org/images/tempeditDelete.gif" width="36" height="44" alt="" border="0"></a></td>
</tr>


			
			
			</table>
			</td>
          </tr>
		  </cfform>
		  
		 
		  
		  
		  </cfoutput>
		  
		  
          
        </table>

<br><br><cfinclude template="../footer.cfm">