<!--- stop spammers --->
<cfif findnocase('http',FORM.q6) OR findnocase('1',FORM.q1)>
	<cflocation url="http://www.aol.com" addtoken="No"><cfabort>
</cfif>

<cfset variables.emailTo="dmunn@marcellusschools.org">

<!--- send the email --->
<cfmail to="#variables.emailTo#" from="Marcellus Bullying Report <bullying@sametime.cnyric.org>" subject="Bullying Report from marcellusschools.org Website" bcc="jseitz@ocmboces.org" type="HTML">
	<strong>Submitter's name</strong><br>
	&nbsp;&nbsp;&nbsp;&nbsp;#FORM.q1#<br><br>
	
	<strong>Telephone number</strong><br>
	&nbsp;&nbsp;&nbsp;&nbsp;#FORM.q2#<br><br>
	
	<strong>Email address</strong><br>
	&nbsp;&nbsp;&nbsp;&nbsp;#FORM.q3#<br><br>
	
	<strong>Tip category</strong><br>
	&nbsp;&nbsp;&nbsp;&nbsp;#FORM.q4#<br><br>
	
	<strong>Where is this happening?</strong><br>
	&nbsp;&nbsp;&nbsp;&nbsp;#FORM.q5#
	<br><br>
	
	<strong>Describe what is happening</strong><br>
	&nbsp;&nbsp;&nbsp;&nbsp;#FORM.q6#<br><br>
	
	<strong>User's IP address</strong><br>
	
	<cfoutput>
		<cfif StructKeyExists(GetHttpRequestData().headers, "X-Forwarded-For") >
			#Trim(ListFirst(GetHttpRequestData().headers["X-Forwarded-For"]))# 
		<cfelse>
			#CGI.REMOTE_ADDR#
		</cfif>
	</cfoutput>
</cfmail>


<cfinclude template="header.cfm">
<cfinclude template="navtable.cfm">
<br><br><br>
	<table width="90%" border="0" cellspacing="0" cellpadding="6" bgcolor="#f8f8f8" class="LL BL RL TL" align="center">
		<tr class="headercolor">
			<td colspan="3" class="BL" align="left"><span class="tempeditHeader">Report Taken</span></td>
		</tr>
		<tr>
			<td align="left">Thank you, your report has been received </td>
		</tr>
	</table>
<br><br><cfinclude template="footer.cfm"></body>
</html>