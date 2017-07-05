<cfinclude template="header.cfm">


<table width="90%" border="0" cellspacing="0" cellpadding="6" bgcolor="#f8f8f8" class="LL BL RL TL" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">An Error Has Occured</span></td>
          </tr>
          <tr> 
            <td align="center"> An error has occurred on this page.  Please <a href="mailto:<cfoutput>#ERROR.mailto#</cfoutput>">email the webmaster</a> for assistance.</td>
          </tr>
        </table>
  
  <cfif ERROR.mailto NEQ "">
  <!--- email an error report to the webmaster --->
  <cfmail
  	TO = "#ERROR.mailto#,bbak@cnyric.org"
	FROM = "MarcellusErrorsender@ocmboces.org"
	SUBJECT = "Error on page #ERROR.template#">
	Error Date/time: #ERROR.datetime#
	User's Browser: #ERROR.browser#
	URL Parameters: #ERROR.querystring#
	Previous Page: #ERROR.HTTPreferer#
	Users IP: #CGI.REMOTE_ADDR#
	--------------------------------------------
	Error message: #ERROR.diagnostics#
	</cfmail>
</cfif>
  
  
<cfinclude template="footer.cfm">
