<cfif NOT FindNoCase("10", #session.auth.accesscode#)>
You dont have access to this page<cfabort></cfif>

<cfif NOT isdefined("FORM.tid")>
	<cflocation url="adminmain.cfm" addtoken="No">
	<cfabort>
</cfif>

<!--- if this form has been submited, update the record --->
<cfif isdefined("FORM.updated")>

<cfparam name="FORM.hidepage" type="string" default="no">
<cfparam name="FORM.newscat" type="string" default="null,">
<cfparam name="FORM.featuredNews" type="string" default="no">

<cfquery datasource="#datasource#">
UPDATE contacts
SET newscat = <cfqueryparam value=",#FORM.newscat#," cfsqltype="CF_SQL_CHAR">,
	description = <cfqueryparam value="#Trim(preserveSingleQuotes(FORM.description))#" cfsqltype="CF_SQL_CHAR">,
	<!--- rankorder = <cfqueryparam value="#Trim(FORM.rankorder)#" cfsqltype="CF_SQL_INTEGER">, --->
	hidepage = <cfqueryparam value="#FORM.hidepage#" cfsqltype="CF_SQL_CHAR">,
	featuredNews = <cfqueryparam value="#FORM.featuredNews#" cfsqltype="CF_SQL_CHAR">
WHERE tid = <cfqueryparam value="#FORM.tid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<cfquery datasource="#datasource#">
UPDATE teacher
SET homepage = <cfqueryparam value="#Trim(preserveSingleQuotes(FORM.homepage))#" cfsqltype="CF_SQL_CHAR">,
	description = <cfqueryparam value="#Trim(preserveSingleQuotes(FORM.description))#" cfsqltype="CF_SQL_CHAR">
WHERE tid = <cfqueryparam value="#FORM.tid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<cfquery datasource="#datasource#">
UPDATE pageatt
SET <cfif FORM.showDateFrom EQ ''>showDateFrom=NULL,
	<cfelse>
	showDateFrom=<cfqueryparam value="#DateFormat(FORM.showDateFrom, 'M/D/YYYY')#" cfsqltype="CF_SQL_DATE">,</cfif>
	<cfif FORM.showDateTo EQ ''>showDateTo=NULL
	<cfelse>
	showDateTo=<cfqueryparam value="#DateFormat(FORM.showDateTo, 'M/D/YYYY')#" cfsqltype="CF_SQL_DATE"></cfif>
WHERE tid = <cfqueryparam value="#FORM.tid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

</cfif>


<!--- if wants to modify a record, list all the users' info.  this should be coming from the select box in adminmain --->
<cfquery name="getuserinfo" datasource="#datasource#">
SELECT *
FROM contacts, teacher, pageatt
WHERE contacts.tid = <cfqueryparam value="#FORM.tid#" cfsqltype="CF_SQL_INTEGER">
	AND teacher.tid = <cfqueryparam value="#FORM.tid#" cfsqltype="CF_SQL_INTEGER">
	AND pageatt.tid = <cfqueryparam value="#FORM.tid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>



<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br>


<cfinclude template="../../cfGlobalCode/globalScriptsDatePicker.cfm">
<cfinclude template="../../cfGlobalCode/globalScripts.cfm">



<cfform name="form1" method="post" action="#CGI.SCRIPT_NAME#">

<input type="hidden" name="updated" value="yes">
<cfoutput><input type="hidden" name="tid" value=#getuserinfo.tid#></cfoutput>
<table width="90%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">Update News</span></td>
          </tr>
		  
		  <!--- navbar --->
		  <tr><td bgcolor="#ffffff" class="BL noPadCell" colspan="3">
		  
		 <table border="0" cellspacing="0" cellpadding="0"><tr>
		 <td><img src="http://www.cnyric.org/images/tempedit_navbar_jumpto.gif" alt="" border="0"></td>
		 <td><a href="adminmain.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_admin.gif" alt="" border="0"></a></td>
		 <td><a href="teditpage.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_tempedit.gif" alt="" border="0"></a></td>
		 <td><a href="adminAddPage.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_addpage.gif" alt="" border="0"></a></td>
		 <td><a href="../logout.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_logout.gif" alt="" border="0"></a></td>
		 </tr></table>
		 </td></tr>
		 <!--- spacer row --->
		  <tr><td height="20"></td></tr>
		  
		  <!--- end navbar --->
		  
		  
		  <tr> 
            <td align="right"> Unique id: </td>
            <td align="left"> <cfoutput>#getuserinfo.tid#</cfoutput> </td>
          </tr>
		  
          <tr> 
            <td align="right"> Story Headline: </td>
            <td align="left"> <cfinput type="text" class="gl_textbox" name="description" value="#getuserinfo.description#" message="Please enter a headline" required="Yes" size="50" maxlength="255"> </td>
          </tr>
		  
		  <tr> 
            <td align="right" valign="top">
			<table id="showtext"><tr><td><a href="##" onclick="hideTable('showtext');showTable('hidetext2');showTable('hidetext');">Link to an outside page [+]</a></td></tr></table> 
			<table id="hidetext2" style="display:none;"><tr><td><a href="##" onclick="showTable('showtext');hideTable('hidetext2');hideTable('hidetext');">Link to an outside page [-]</a></td></tr></table> </td>
            <td align="left"> 
			<table id="hidetext" style="display:none;"><tr><td><cfinput type="Text" name="homepage" value="#getuserinfo.homepage#" required="No" size="50" class="gl_textbox"> <br><font size="-2">*Leave as default if using a page created with tempEDIT OR paste in URL</font>
		</td></tr></table>
</td>
          </tr>
		  
		   <!--- <tr> 
            <td align="right"> Rank: </td>
            <td align="left"> <cfinput type="Text" name="rankorder" message="Please enter a number" validate="integer" required="No" size="5" class="gl_textbox" value="#getuserinfo.rankorder#"><font size="-2"> Order to list on page</font> </td>
          </tr> --->
		  
		  <tr> 
            <td align="right"> Hide this page: </td>
            <td align="left"> <input type="checkbox" name="hidepage" value="yes" <cfif getuserinfo.hidepage EQ 'yes'>checked</cfif>> </td>
          </tr>
		  
		  <tr> 
            <td align="right" valign="top">
			 <div id="dateRangeWindow" <cfif getuserinfo.showDateFrom NEQ '' OR getuserinfo.showDateTo NEQ ''>style="display:none;"</cfif>><a href="##" onclick="hideTable('dateRangeWindow');showTable('dateRangeWindow2');showTable('dateRangeWindow3');">Choose date range for this page [+]</a></div>
			 <div id="dateRangeWindow3" <cfif getuserinfo.showDateFrom EQ '' AND getuserinfo.showDateTo EQ ''>style="display:none;"</cfif>><a href="##" onclick="hideTable('dateRangeWindow2');hideTable('dateRangeWindow3');showTable('dateRangeWindow');">Hide Date range [-]</a></div>
			</td>
            <td align="left"> 
			<div id="dateRangeWindow2" <cfif getuserinfo.showDateFrom EQ '' AND getuserinfo.showDateTo EQ ''>style="display:none;"</cfif>>
			<table border="0" cellpadding="2">
<tr><td>Choose date(s) to start and stop showing this page.  Page will be unavailable outside of date range.<br><br></td></tr>
<tr><td>

Begin showing: <cfinput type="Text" name="showDateFrom" value="#DateFormat(getuserinfo.showDateFrom,'M/D/YYYY')#" validate="date" required="No" size="16" id="showDateFrom" placeholder="Click to choose date">

&nbsp;&nbsp;&nbsp;&nbsp;

Stop showing after: <cfinput type="Text" name="showDateTo" value="#DateFormat(getuserinfo.showDateTo,'M/D/YYYY')#" validate="date" required="No" size="16" id="showDateTo" placeholder="Click to choose date">

</td></tr></table>
			</div>
			</td>
          </tr>
		  
		 <tr> 
            <td align="right" valign="top"> News Categories:</td>
            <td align="left"> 
				 <cfif ListFind(session.auth.accesscode,2)>
				 <input type="checkbox" name="newscat" value="2" <cfif ListFind(getuserinfo.newscat,2)> checked</cfif>> District News <br></cfif>
				<cfif ListFind(session.auth.accesscode,44)>
				<input type="checkbox" name="newscat" value="44"<cfif ListFind(getuserinfo.newscat,44)> checked</cfif>> Spotlight <br></cfif>
				
				 </td>
          </tr>
		  
		  <!--- they can only add featured item if they have access to main cat --->
		  <cfif ListFind(session.auth.accesscode,2)>
		  <tr> 
            <td align="right"> Featured Item: </td>
            <td align="left"> <input type="checkbox" name="featuredNews" value="yes" <cfif getuserinfo.featuredNews EQ 'yes'>checked</cfif>> </td>
          </tr></cfif>
		  
		   
		  <tr> 
            <td align="right"> <a href="adminremuser.cfm?teacher_id=<cfoutput>#getuserinfo.tid#</cfoutput>">Delete this page</a> </td>
          </tr>
		  
          <tr> 
            <td>&nbsp;</td>
            <td> <input type="submit" class="gl_submit" name="Submit" value="Save Changes"> 
			     <input type="reset" class="gl_submit" name="reset" value="Reset All Fields"></td>
          </tr>
        </table>
</cfform>
<br><br><cfinclude template="../footer.cfm"></body>
</html>