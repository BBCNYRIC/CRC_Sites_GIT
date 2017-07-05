<cfquery datasource="#datasource#" name="athimages">
SELECT *
FROM tfiles
WHERE (filetype = 'gif' OR 
		filetype = 'jpg' OR 
		filetype = 'jpeg' OR 
		filetype = 'tif' OR 
		filetype = 'png')
	AND tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
ORDER BY file_id
</cfquery>

<cfquery datasource="#datasource#" name="athimages2">
SELECT *
FROM tfiles
WHERE (filetype <> 'gif' AND 
		filetype <> 'jpg' AND 
		filetype <> 'jpeg' AND 
		filetype <> 'tif' AND
		filetype <> 'png')
	AND tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
ORDER BY linkname, filename
</cfquery>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head> 
	<title>Choose an image</title>
</head>

<body>

Right click on an image to copy it, then paste into the body text area.  Or copy and paste a file.
 <br>
<!--- list files --->
<cfloop query="athimages2">
<cfoutput>

<!--- check to see if we're dealing with a protected page --->
<cfif #session.URLadd# NEQ "">
<a href="http://www.marcellusschools.org/protected/servetfile.cfm?teacher=#session.auth.uid#&filename=#URLEncodedFormat(filename)#">
<cfelse>
<a href="http://www.marcellusschools.org/tfiles/folder#session.auth.uid#/#URLEncodedFormat(filename)#">
</cfif><br>



<cfif linkname EQ ''>#filename#</a><cfelse>#linkname#</a></cfif><br>

</cfoutput>
</cfloop>

 <!--- list photos --->
<cfloop query="athimages">
<cfoutput>
<img src="http://www.marcellusschools.org/tfiles/folder#session.auth.uid#/#URLEncodedFormat(filename)#">

<cfif #currentrow# MOD 2 EQ 0><br></cfif>

</cfoutput>
</cfloop>
<br><br></body>
</html>
