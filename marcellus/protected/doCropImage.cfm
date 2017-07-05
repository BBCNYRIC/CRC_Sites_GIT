
<cfif isdefined("FORM.x")>

<!--- <cfdump var="#FORM#"> --->

<!--- first make an appropriately sized image for the body of the news story --->

<!--- we need to check this page for a photo, if they already have one in their body, dont' auto insert one for them --->
<cfquery datasource="#datasource#" name="checkForImage">
SELECT body
FROM pageatt
WHERE tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<cfif NOT findNoCase("<img",checkForImage.body)>

<!--- get info --->
<cfimage action="info" structname="tempimage" source="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#/newsthumbnail.jpg" />

<!--- if image too big, make it smaller --->
<cfif tempimage.width GT 350>

	<!--- set new height --->
	<cfset variables.newheight = Round(((350) * #tempimage.height#) / #tempimage.width#)>
	<cfset variables.newwidth = 350>
	
<!--- image smaller or equal to 350, leave its size alone --->
<cfelse>
	<cfset variables.newheight = #tempimage.height#>
	<cfset variables.newwidth = #tempimage.width#>

</cfif>

	<!--- give image a new name and resize --->
	<cfimage action="resize" 
		source="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#/newsthumbnail.jpg" 
		destination="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#/mainNewsImage.jpg"
		width="#variables.newwidth#" 
		height="#variables.newheight#" 
		overwrite="true" />
		
	<!--- add database entry --->
<!--- see if this page already has a thumbnail, if so don't add a db entry, it should already be there --->
<cfquery datasource="#datasource#" name="checkForThumb">
SELECT filename
FROM tfiles
WHERE filename = <cfqueryparam value="mainNewsImage.jpg" cfsqltype="CF_SQL_CHAR">
	AND tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>
		
<cfif checkForThumb.recordcount EQ 0>
<!--- add entry to database so this thumbnail will show up in the manage files section --->
<cfquery datasource="#datasource#">
INSERT INTO tfiles(tid, filename, linkname, filetype, filesize, showLink)
VALUES (#session.auth.uid#, 
		'mainNewsImage.jpg', 
		<cfqueryparam value="main news image" cfsqltype="CF_SQL_CHAR">, 
		'jpg', 
		'100', 
		<cfqueryparam value="no" cfsqltype="CF_SQL_CHAR">)
</cfquery>
</cfif>



<!--- now add html code for photo to body of page --->
<cfquery datasource="#datasource#">
UPDATE pageatt
SET body = '<img src="/tfiles/folder#session.auth.uid#/mainNewsImage.jpg" style="float: left; border-width: 1px; border-style: solid; margin: 5px;">' + body	
WHERE tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

</cfif>


<!--- done with main image, now crop for thumbnail --->
		
<cfimage source="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#/newsthumbnail.jpg" name="myImage">
<!--- Crop myImage to appropriate size, Fix() is cf version of Floor() --->
<cfset ImageCrop(myImage,#Fix(FORM.x)#,#Fix(FORM.y)#,#Fix(FORM.w)#,#Fix(FORM.h)#)>
<!--- Write the result to a file. --->
<cfimage source="#myImage#" 
		action="write" 
		destination="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#/newsthumbnail.jpg" 
		overwrite="yes">


<!--- now resize to appropriate size --->
	
<cfimage action="resize" 
		source="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#/newsthumbnail.jpg" 
		destination="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#/newsthumbnail.jpg"
		width="110" 
		height="110" 
		overwrite="true" />



</cfif>


<cflocation url="teditpage.cfm" addtoken="No"><cfabort>