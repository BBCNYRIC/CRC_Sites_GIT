

<!--- if not logged in, dont show file --->

<cfif NOT isdefined("session.pppageAuth.pageLoggedIn#URL.teacher#")>
	<cfabort>
</cfif>



<cfparam name="URL.teacher" type="numeric" default="0">
<cfparam name="URL.filename" type="string" default="">

<!--- get mime type of file --->
<cfset variables.actualMimeType = FileGetMimeType("F:\Inetpub\wwwroot\crc_sites\marcellus\tfilesProc\folder#URL.teacher#\#URL.filename#", true)>


<!--- Serve up the document using the cfcontent tag --->
<cfheader name="Content-Disposition" value="inline; filename=#URL.filename#">

<cfcontent type="#variables.actualMimeType#" file="F:\Inetpub\wwwroot\crc_sites\marcellus\tfilesProc\folder#URL.teacher#\#URL.filename#" deletefile="No">