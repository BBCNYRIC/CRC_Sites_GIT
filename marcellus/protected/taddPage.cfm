
<!--- if this form has been submited, update the record --->
<cfif isdefined("FORM.updated")>

<cfparam name="FORM.hidepage" type="string" default="no">
<cfparam name="FORM.pppage" type="string" default="no">


<!--- if they password protected it but didn't enter a password --->
<cfif FORM.pppage EQ 'yes' AND FORM.pagePassword EQ ''>

<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br>

  <table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">Invalid selection:</span></td>
          </tr>
          <tr> 
            <td align="center"> You have chosen to password protect this page but you did not choose a password.  Use your browsers back button to go back and enter a password.</td>
          </tr>
        </table>

<br><br><cfinclude template="../footer.cfm">
<cfabort>
</cfif>


<cftransaction>
<cflock timeout="10" throwontimeout="No" type="EXCLUSIVE"> 

<!--- insert account information in contacts --->
<cfquery datasource="#datasource#">
INSERT INTO contacts(userlogin, userpassword, authlevel, accessgroup, description, rankorder, hidepage)
VALUES (<cfqueryparam value="TVOID" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="TVOID" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">,
		<cfqueryparam value="0" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="#Trim(preserveSingleQuotes(FORM.description))#" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="#FORM.rankorder#" cfsqltype="CF_SQL_INTEGER">,
		<cfqueryparam value="#FORM.hidepage#" cfsqltype="CF_SQL_CHAR">)
</cfquery>

<cfquery datasource="#datasource#" name="gettid">
SELECT Max(tid) AS maxtid
FROM contacts
</cfquery>

 <!--- insert personal info into teachers --->
<cfquery datasource="#datasource#">
INSERT INTO teacher(tid, fname, lname, homepage, description, owner)
VALUES (<cfoutput query="gettid"><cfqueryparam value="#maxtid#" cfsqltype="CF_SQL_INTEGER"></cfoutput>,
		<cfqueryparam value="TVOID" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="TVOID" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="default" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="#Trim(preserveSingleQuotes(FORM.description))#" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="#session.auth.loggedInId#" cfsqltype="CF_SQL_INTEGER">)
</cfquery>

<!--- add an entry for their web page table --->
<cfquery datasource="#datasource#">
INSERT INTO pageatt(tid, pppage, pagePassword, showDateFrom, showDateTo)
VALUES (<cfoutput query="gettid"><cfqueryparam value="#maxtid#" cfsqltype="CF_SQL_INTEGER"></cfoutput>,
		<cfqueryparam value="#FORM.hidepage#" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="#FORM.pagePassword#" cfsqltype="CF_SQL_CHAR">,
		<cfif FORM.showDateFrom EQ ''>NULL,
		<cfelse><cfqueryparam value="#DateFormat(FORM.showDateFrom, 'M/D/YYYY')#" cfsqltype="CF_SQL_DATE">,</cfif>
		<cfif FORM.showDateTo EQ ''>NULL
		<cfelse><cfqueryparam value="#DateFormat(FORM.showDateTo, 'M/D/YYYY')#" cfsqltype="CF_SQL_DATE"></cfif>)
</cfquery>


</cflock>
</cftransaction>
</cfif>



<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br>


<cfinclude template="../../cfGlobalCode/globalScriptsDatePicker.cfm">
<cfinclude template="../../cfGlobalCode/globalScripts.cfm">


<cfform name="form1" method="post" action="#CGI.SCRIPT_NAME#">

<input type="hidden" name="updated" value="yes">
<table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><img src="http://www.cnyric.org/images/tempedit_addpage.gif" alt="" border="0"></td>
          </tr>
		  
		  <!--- navbar --->
		  <tr><td bgcolor="#ffffff" class="BL noPadCell" colspan="3">
		  
		 <table border="0" cellspacing="0" cellpadding="0"><tr>
		 <td><img src="http://www.cnyric.org/images/tempedit_navbar_jumpto.gif" alt="" border="0"></td>
		 <td><a href="adminmain.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_admin.gif" alt="" border="0"></a></td>
		 <td><a href="teditpage.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_tempedit.gif" alt="" border="0"></a></td>
		 <td><a href="../logout.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_logout.gif" alt="" border="0"></a></td>
		 </tr></table>
		 </td></tr>
		 <!--- spacer row --->
		  <tr><td height="20"></td></tr>
		  
		  <!--- end navbar --->
		 
		  
		   <tr> 
            <td align="right" valign="top"> Page Name: </td>
            <td align="left"> <cfinput type="Text" name="description" message="Please enter a page name" required="Yes" size="50" maxlength="50" class="gl_textbox"> </td>
          </tr>
		
		<tr> 
            <td align="right" valign="top">
			<table id="showtext"><tr><td><a href="##" onclick="hideTable('showtext');showTable('hidetext2');showTable('hidetext');">Link to an outside page [+]</a></td></tr></table> 
			<table id="hidetext2" style="display:none;"><tr><td><a href="##" onclick="showTable('showtext');hideTable('hidetext2');hideTable('hidetext');">Link to an outside page [-]</a></td></tr></table> </td>
            <td align="left"> 
			<table id="hidetext" style="display:none;"><tr><td><cfinput type="Text" name="homepage" value="default" required="No" size="50" class="gl_textbox"> <br><font size="-2">*Leave as default if using a page created with tempEDIT OR paste in URL</font>
		</td></tr></table>
</td>
          </tr>
		  
		  <tr> 
            <td align="right"> Rank: </td>
            <td align="left"> <cfinput type="Text" name="rankorder" message="Please enter a number for page rank order" validate="integer" required="yes" size="5" class="gl_textbox" value="99"><font size="-2"> Order to list on nav bar</font> </td>
          </tr>
		  
		  <tr> 
            <td align="right"> Hide this page: </td>
            <td align="left"> <input type="checkbox" name="hidepage" value="yes"> </td>
          </tr>
		  
		  <tr> 
            <td align="right"> Password protect this page: </td>
            <td align="left"> <input type="checkbox" name="pppage" value="yes"> &nbsp;&nbsp;&nbsp;
			Password:&nbsp;&nbsp;
			<cfinput type="Text" name="pagePassword" size="15" class="gl_textbox">
			</td>
          </tr>
		  
		  <tr> 
            <td align="right" valign="top">
			 <div id="dateRangeWindow"><a href="##" onclick="hideTable('dateRangeWindow');showTable('dateRangeWindow2');showTable('dateRangeWindow3');">Choose date range for this page [+]</a></div>
			 <div id="dateRangeWindow3" style="display:none;"><a href="##" onclick="hideTable('dateRangeWindow2');hideTable('dateRangeWindow3');showTable('dateRangeWindow');">Hide Date range [-]</a></div>
			</td>
            <td align="left"> 
			<div id="dateRangeWindow2" style="display:none;">
			<table border="0" cellpadding="2">
<tr><td>Choose date(s) to start and stop showing this page.  Page will be unavailable outside of date range.<br><br></td></tr>
<tr><td>

Begin showing: <cfinput type="Text" name="showDateFrom" value="" validate="date" required="No" size="16" id="showDateFrom" placeholder="Click to choose date">

&nbsp;&nbsp;&nbsp;&nbsp;

Stop showing after: <cfinput type="Text" name="showDateTo" value="" validate="date" required="No" size="16" id="showDateTo" placeholder="Click to choose date">

</td></tr></table>
			</div>
			</td>
          </tr>
		  
          <tr> 
            <td>&nbsp;</td>
            <td> <input type="submit" class="gl_submit" name="Submit" value="Add this Page"></td>
          </tr>
        </table>
</cfform>
<br><br><cfinclude template="../footer.cfm"></body>
</html>