<!--- 
  Filename:     LoginForm.cfm
  Created by:   jseitz
  Purpose:      Presented whenever a user has not logged in yet
  Please Note:  Included by Application.cfm
--->

<!--- If the user is now submitting "Login" form, --->
<!--- Include "Login Check" code to validate user --->
<cfif IsDefined("Form.UserLogin")> 
  <cfinclude template="LoginCheck.cfm">
</cfif>


<!--- URL variables are lost during the login process, so do a check to keep them --->
<cfset session.keepURLvars = #cgi.query_string#>


<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm">
<table width="100%" border="0" cellspacing="0" cellpadding="10" align="center"><tr><td>

<!--- if login is wrong, display the message, redirect if more than 3 times --->

<cfoutput><div align="center"><font size="+1">#session.loginfailure#</font></div></cfoutput>
<cfif #session.loginfailnum# GTE 6>
<cflocation url="http://www.marcellusschools.org/" addtoken="No"> <cfabort></cfif>

<!--- Start our Login Form --->
<CFFORM ACTION="#CGI.SCRIPT_NAME#" NAME="LoginForm" METHOD="POST">
  <!--- Make the UserLogin and UserPassword fields required --->
  <INPUT TYPE="Hidden" NAME="UserLogin_required">
  <INPUT TYPE="Hidden" NAME="UserPassword_required">
  
<table width="400" border="0" cellspacing="0" cellpadding="1" align="center">
  <tr>
  <td><img src="http://www.cnyric.org/images/padlock.gif" width="215" height="56" alt="" border="0"> <br />&nbsp;</td>
  </tr>
    <tr> 
      <td> <table width="400" border="0" cellspacing="0" cellpadding="10" bgcolor="#dddddd" class="LL BL RL TL">
          <tr> 
            <td colspan="3" class="BL" class="headercolor"><span class="tempeditHeader">Enter Username &amp; Password:</span></td>
          </tr>
          <tr> 
            <td align="right" bgcolor="#FFFFFF"> User name: </td>
            <td bgcolor="#FFFFFF" align="left"> <!--- Text field for "User Name" --->  
      <CFINPUT 
        type="text" class="gl_textbox"
        NAME="UserLogin"
        SIZE="20"
        VALUE=""
        MAXLENGTH="100"
        REQUIRED="Yes"
        MESSAGE="Please enter a username."> </td>
          </tr>
		  <tr> 
            <td align="right" bgcolor="#FFFFFF"> Password: </td>
            <td bgcolor="#FFFFFF" align="left"> <!--- Text field for Password --->  
      <CFINPUT 
        TYPE="Password" class="gl_textbox"
        NAME="UserPassword"
        SIZE="20"
        VALUE=""
        MAXLENGTH="100"
        REQUIRED="Yes"
        MESSAGE="Please enter a password."> </td>
          </tr>
		  
          <tr> 
            <td bgcolor="#FFFFFF">&nbsp;</td>
            <td bgcolor="#FFFFFF"> <div align="right">
              <input type="submit" class="gl_submit" name="Submit" value="Log In"> 
              <input type="reset" class="gl_submit" name="reset" value="Clear">
            </div></td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF">&nbsp;</td>
            <td bgcolor="#FFFFFF">&nbsp;</td>
          </tr>
          
        </table></td>
    </tr>
  </table>
</CFFORM>

</td></tr></table>
<cfinclude template="../footer.cfm">
</body>
</HTML>
