<cfparam name="URL.img_id" default="1">
<cfquery datasource="#datasource#" name="athimages">
SELECT *
FROM tfiles
WHERE file_id = <cfqueryparam value="#URL.img_id#" cfsqltype="CF_SQL_INTEGER">
</cfquery>


<cfinclude template="header.cfm">
<cfinclude template="navtable.cfm">


	
	<table width="100%" border="0" cellspacing="0" cellpadding="10" align="center"><tr><td valign="top" width="100%">

<p align="center">
	<cfoutput query="athimages"><img src="http://www.marcellusschools.org/tfiles/folder#URL.teacher#/#URLEncodedFormat(filename)#" border=1 alt=""><br>
   
	</cfoutput>
	
	</p></td><td width="25%">

</td></tr></table>
	
	

<cfinclude template="footer.cfm"></body>
</html>
