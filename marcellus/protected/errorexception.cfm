<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br>





  <table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">An error has occured:</span></td>
          </tr>
          <tr> 
            <td align="center"> An error has occurred on this page.  Please <a href="mailto:<cfoutput>#ERROR.mailto#</cfoutput>">email the webmaster</a> for assistance.</td>
          </tr>
        </table>
  
  <cfif ERROR.mailto NEQ "">
  <!--- email an error report to the webmaster --->
  <cfmail
  	TO = "#ERROR.mailto#"
	FROM = "marcellusErrorsender@ocmboces.org"
	SUBJECT = "Error on page #ERROR.template#">
	Error Date/time: #ERROR.datetime#
	User's Browser: #ERROR.browser#
	URL Parameters: #ERROR.querystring#
	Previous Page: #ERROR.HTTPreferer#
	Users IP: #CGI.REMOTE_ADDR#
	Users id number: #session.auth.loggedInId#
	--------------------------------------------
	Error message: #ERROR.diagnostics#
	</cfmail>
</cfif>
  
  
<!--- end main content ---> 


<br><br><cfinclude template="../footer.cfm"></body>
</html>