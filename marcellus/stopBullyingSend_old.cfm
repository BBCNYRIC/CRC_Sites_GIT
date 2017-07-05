
<!--- stop spammers --->
<cfif findnocase('http',FORM.q7) OR findnocase('1',FORM.q1)>
	<cflocation url="http://www.aol.com" addtoken="No"><cfabort></cfif>



	<cfset variables.emailTo="dmunn@marcellusschools.org">



<!--- send the email --->
<cfmail to="#variables.emailTo#" from="Marcellus Bullying Report <bullying@sametime.cnyric.org>" subject="Bullying Report from marcellusschools.org Website" bcc="jseitz@ocmboces.org" type="HTML">

<strong>Your name (optional)</strong><br>
&nbsp;&nbsp;&nbsp;&nbsp;#FORM.q1#<br><br>

<strong>Your email (optional)</strong><br>
&nbsp;&nbsp;&nbsp;&nbsp;#FORM.q2#<br><br>

<strong>Date of incident(s)</strong><br>
&nbsp;&nbsp;&nbsp;&nbsp;#FORM.q3#<br><br>

<strong>Please provide the name of the person being bullied if known</strong><br>
&nbsp;&nbsp;&nbsp;&nbsp;#FORM.q4#<br><br>

<strong>Please provide the name of the person doing the bullying if known</strong><br>
&nbsp;&nbsp;&nbsp;&nbsp;#FORM.q5#<br><br>

<strong>Please provide the names of any witnesses if known</strong><br>
&nbsp;&nbsp;&nbsp;&nbsp;#FORM.q8#<br><br>



<strong>Describe the incident(s). Please include time of day and the location of the incident(s). </strong><br><br>
&nbsp;&nbsp;&nbsp;&nbsp;#FORM.q7#<br><br>

<strong>User's IP address</strong><br>
#CGI.REMOTE_ADDR#</cfmail>


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
