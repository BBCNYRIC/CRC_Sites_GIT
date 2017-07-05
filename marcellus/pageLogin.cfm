<!--- 
  Filename:     LoginCheck.cfm
  Created by:   jseitz
  Purpose:      Validates a user's password entries
  Please Note:  Included by LoginForm.cfm
--->


<!--- Make sure we have Login name and Password --->
<cfif isdefined("FORM.UserPassword")>

<!--- Find record with this Username/Password --->
<!--- If no rows returned, password not valid --->

<CFQUERY NAME="GetUser" DATASOURCE="#datasource#">
  SELECT pagePassword
  FROM pageatt
  WHERE tid = <cfqueryparam value="#FORM.pageid#" cfsqltype="CF_SQL_INTEGER">
  	AND pagePassword = <cfqueryparam value="#FORM.UserPassword#" cfsqltype="CF_SQL_CHAR">
</CFQUERY>

<!--- If the username and password are correct --->
<CFIF GetUser.RecordCount EQ 1>
  <!--- Remember user's logged-in status, plus --->
  <!--- unique id and auth level, in structure --->
  
  <cfif NOT isdefined("session.pppageAuth")>
  	<CFSET session.pppageAuth = StructNew()>
</cfif>
	
  <cfset "session.pppageAuth.pageLoggedIn#FORM.pageid#" = "yes">

  <!--- Now that user is logged in, send them --->
  <!--- to whatever page makes sense to start --->
  <cflocation url="teacherpage.cfm?teacher=#FORM.pageid#" addtoken="No"><cfabort>
  
  </cfif>
  
  
  
  </cfif>
  
  
  
  
  <!--- 
  Filename:     LoginForm.cfm
  Created by:   jseitz
  Purpose:      Presented whenever a user has not logged in yet
  Please Note:  Included by Application.cfm
--->

<!--- If the user is now submitting "Login" form, --->
<!--- Include "Login Check" code to validate user --->


<cfinclude template="header.cfm">
<cfinclude template="navtable.cfm">

<cfif isdefined("FORM.pageID")>
	<cfset URL.pageID = FORM.pageID>
</cfif>


<table width="100%" border="0" cellspacing="0" cellpadding="10" align="center"><tr><td>



<!--- Start our Login Form --->
<CFFORM ACTION="#CGI.SCRIPT_NAME#" NAME="LoginForm" METHOD="POST">
  <!--- Make the UserLogin and UserPassword fields required --->
  <input type="hidden" name="pageid" value="<cfoutput>#URL.pageid#</cfoutput>">

  
<table width="400" border="0" cellspacing="0" cellpadding="1" align="center">
  <tr>
  <td><img src="http://www.cnyric.org/images/padlock.gif" width="215" height="56" alt="" border="0"> <br />&nbsp;</td>
  </tr>
    <tr> 
      <td> <table width="400" border="0" cellspacing="0" cellpadding="10" bgcolor="#dddddd" class="LL BL RL TL">
          <tr> 
            <td colspan="3" class="BL" class="headercolor"><span class="tempeditHeader">Please enter a password for this page</span></td>
          </tr>
         
		  <tr> 
            <td align="right" bgcolor="#FFFFFF"> Password: </td>
            <td bgcolor="#FFFFFF" align="left"> <!--- Text field for Password --->  
      <CFINPUT 
        TYPE="Password" class="gl_textbox"
        NAME="UserPassword"
        SIZE="20"
        VALUE=""
        MAXLENGTH="25"
        REQUIRED="Yes"
        MESSAGE="Please enter a password."> </td>
          </tr>
		  
          <tr> 
            <td bgcolor="#FFFFFF">&nbsp;</td>
            <td bgcolor="#FFFFFF"> <div align="right">
              <input type="submit" class="gl_submit" name="Submit" value="Submit"> 
             
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
<cfinclude template="footer.cfm">
</body>
</HTML>
