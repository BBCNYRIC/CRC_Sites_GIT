<cfinclude template="teacherpage.cfm"><cfabort>

<!--- if a teacher id number is not defined in the url, redirect to listall page --->
<cfif NOT isdefined("URL.teacher")><cflocation url="listall.cfm" addtoken="No"><cfabort></cfif>

<!--- query for page attributes --->
<cfquery name="common" datasource="#datasource#">
SELECT *
FROM pageatt pa
WHERE pa.tid = <cfqueryparam value="#URL.teacher#" cfsqltype="CF_SQL_INTEGER"></cfquery>


<!--- if no records have been found, teacher does not have a page --->
<cfif common.recordcount eq 0>
<cfinclude template="header.cfm">
<cfinclude template="navtable.cfm">


  <table width="90%" border="0" cellspacing="0" cellpadding="1" bgcolor="#000000" align="center">
    <tr> 
      <td> <table width="100%" border="0" cellspacing="0" cellpadding="4" bgcolor="#cccccc">
          <tr class="headercolor"> 
            <td colspan="3"><font color="#ffffff"><b>An error has occured:
              </b></font></td>
          </tr>
          <tr> 
            <td align="center"> We cannot find the page you are looking for.  Please check to make sure the path is correct, or <a href="listall.cfm">go to a listing of teachers</a>.
          </tr>
        </table></td>
    </tr>
  </table>
<cfabort>
</cfif>


<!--- update hit counter --->
<cfquery datasource="#datasource#">
UPDATE pageatt
SET hitcount = #IncrementValue(common.hitcount)#
WHERE tid = <cfqueryparam value="#URL.teacher#" cfsqltype="CF_SQL_INTEGER"></cfquery>

<!--- query for links --->
<cfquery name="links" datasource="#datasource#">
SELECT *
FROM tpagelinks ln
WHERE ln.tid = <cfqueryparam value="#URL.teacher#" cfsqltype="CF_SQL_INTEGER"></cfquery>

<!--- query for announcements --->
<cfquery name="ann" datasource="#datasource#">
SELECT *
FROM tpageann an
WHERE an.tid = <cfqueryparam value="#URL.teacher#" cfsqltype="CF_SQL_INTEGER">
ORDER BY rankorder</cfquery>

<!--- query for links to files the teacher has uploaded --->
<cfquery name="filez" datasource="#datasource#">
SELECT *
FROM tfiles tf
WHERE tf.tid = <cfqueryparam value="#URL.teacher#" cfsqltype="CF_SQL_INTEGER"></cfquery>

<!--- for the left side listing --->
<cfquery datasource="#datasource#" name="getaccgp">
SELECT accessgroup
FROM contacts
WHERE tid = <cfqueryparam value="#URL.teacher#" cfsqltype="CF_SQL_INTEGER"></cfquery>

<cfinclude template="header.cfm">
<cfinclude template="navtable.cfm">

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr>

<td valign=top>

<cfif #common.title# NEQ "">
<table width="95%" border="0" align="center" cellpadding="4" cellspacing="2">
  <tr> 
    <td align="center"><cfoutput query="common"><font face="#titlefont#" color="###titlefontcolor#"><h#titlefontsize#>#title#</h#titlefontsize#></font></cfoutput></td>
  </tr>
  </table></cfif>
  
  
  <table width="95%" border="0" align="center" cellpadding="4" cellspacing="2">
  <tr> 

    <cfoutput><cfif #common.mainimage# NEQ ""><td valign="top" width="10%">
	<cfif FindNoCase("http://", "#common.mainimage#")>
	<img src="#common.mainimage#"><cfelse>
	<img src="timages/#common.mainimage#"></cfif></td></cfif></cfoutput>
    
 
  	<cfif #common.body# NEQ ""><td valign="top" rowspan=2>
<p><cfoutput query="common"><font face="#bodyfont#" color="###bodycolor#" size="#bodysize#px"><cfif htmlinbody EQ 'yes'>#body#<cfelse>#ReplaceNoCase(body, Chr(13), '<br>', 'ALL')#</cfif></font></cfoutput></p>
</td></cfif>
	</tr>
	</table>
	
	 <cfif (filez.RecordCount NEQ 0) OR (links.recordcount NEQ 0) OR (ann.recordcount NEQ 0) OR (common.mainimage NEQ "") OR (common.heading1 NEQ "") OR (common.heading2 NEQ "") OR (common.filesheading NEQ "")>
	<table width="95%" border="0" align="center" cellpadding="4" cellspacing="2">
	<tr>
  	<td align="left" valign="top">
	<p><cfoutput query="common"><font face="#annfont#" color="###anncolor#"><h#annsize#>#heading1#</h#annsize#></font></cfoutput></p>
	<ul><cfoutput query="ann">
  		<li><div class=anntext>#ann_text#</div></li><br>
		    </cfoutput>
		</ul><br><br>
		
		<p><cfoutput query="common"><font face="#linkfont#" color="###linkcolor#"><h#linksize#>#heading2#</h#linksize#></font></cfoutput></p>
		<blockquote>
  		<cfoutput query="links">
		<a href="redirect.cfm?catchout=http://#link_url#">#link_name#</a><br>
		</cfoutput></blockquote>
		<br>
		
		<p><cfoutput query="common"><font face="#filesfont#" color="###filesfontcolor#"><h#filesfontsize#>#filesheading#</h#filesfontsize#></font></cfoutput></p>
<blockquote>
  		<cfoutput query="filez">
		<cfif #filez.linkname# NEQ "">
		<a href="http://www.marcellusschools.org/tfiles/folder#URL.teacher#/#URLEncodedFormat(filename)#">#linkname#</a><br>
		</cfif>
		</cfoutput></blockquote>
		<br>
		
  	</td> 
  </tr>  </table></cfif>

  <cfif common.putemail EQ "yes">  <br><br>
	<cfquery datasource="#datasource#" name="getemail">
	SELECT email
	FROM teacher
	WHERE tid = <cfqueryparam value="#URL.teacher#" cfsqltype="CF_SQL_INTEGER">
	</cfquery>
	
<table width="100%" border="0" cellspacing="1" cellpadding="1" align="center">
<tr><td align="center"><cfoutput><a href="mailto:#getemail.email#">Email Contact</a></cfoutput></td></tr>
</table>
</cfif>

<cfif #common.hitcounton# EQ "yes">
<table width="100%" border="0" cellspacing="1" cellpadding="1" align="center">
<tr><td align="center"><cfoutput>This page has #common.hitcount# hits</cfoutput></td></tr>
</table></cfif>

<table width="100%" border="0" cellspacing="1" cellpadding="1" align="center">
<tr><td align="center"><cfoutput>Last updated on #common.lastupdate#</cfoutput></td></tr>
</table>

<br><br><cfinclude template="footer.cfm"></body>
</html>
