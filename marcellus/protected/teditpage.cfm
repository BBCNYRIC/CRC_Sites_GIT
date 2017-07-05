
<!--- <cfparam name="FORM.hitcount" default="no"> --->
<cfparam name="FORM.righttable" default="no">
<cfparam name="FORM.bumprighttable" default="no">
<!--- <cfparam name="FORM.bodyPadding" default="yes"> --->
<cfparam name="FORM.title" default="">
<cfparam name="FORM.pagebody" default="">
<cfparam name="FORM.pagebody2" default="">
<cfparam name="FORM.heading1" default="">
<cfparam name="FORM.heading2" default="">
<cfparam name="FORM.filesheading" default="">
<cfparam name="FORM.newsFeedList" default="">

<cfinclude template="../../cfGlobalCode/compareLists.cfm">


<cfif isdefined("FORM.updated")>

<!--- check to see if they've used the back button and clobbered the page content --->
<cfif #session.auth.uid# NEQ #FORM.sessid#>
	<cfinclude template="../header.cfm">
	<cfinclude template="../navtable.cfm"><br>
	<strong>WARNING!!!  You may be unintentionally overwriting data.  Use the following link to return to your page.  Please do not use your browser's back button at any time when editing your pages.</strong><br><br>

<a href="<cfoutput>#CGI.SCRIPT_NAME#</cfoutput>">Click here to return to your page</a>
	<cfinclude template="../footer.cfm"><cfabort>
	
</cfif>


<!--- make sure this isnt a locked page --->
<cfquery datasource="#datasource#" name="checkLock">
SELECT lockHeader
FROM contacts
WHERE tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<!--- only do body operations if page isn't locked --->
<cfif checkLock.lockHeader NEQ 'yes' OR session.auth.authlevel EQ 3>

<!--- create a backup of their content in case they made a mistake --->
<cfquery datasource="#datasource#" name="backupQ">
SELECT body
FROM pageatt
WHERE tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<!--- only back up if it's not a blank page --->
<cfif backupQ.body NEQ '' AND backupQ.body NEQ '&nbsp;' AND backupQ.body NEQ '<br>'>
<cfquery datasource="#datasource#">
UPDATE pageatt
SET bodyBackup=<cfqueryparam value="#backupQ.body#" cfsqltype="CF_SQL_LONGVARCHAR">
WHERE tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>
</cfif>
<!--- end backup code --->

</cfif>

<cfquery datasource="#datasource#">
UPDATE pageatt
SET title=<cfqueryparam value="#FORM.title#" cfsqltype="CF_SQL_CHAR">,
<cfif checkLock.lockHeader NEQ 'yes' OR session.auth.authlevel EQ 3>
	body=<cfqueryparam value="#FORM.pagebody#" cfsqltype="CF_SQL_LONGVARCHAR">,</cfif>
	body2=<cfqueryparam value="#FORM.pagebody2#" cfsqltype="CF_SQL_LONGVARCHAR">,
	heading1=<cfqueryparam value="#FORM.heading1#" cfsqltype="CF_SQL_CHAR">,
	heading2=<cfqueryparam value="#FORM.heading2#" cfsqltype="CF_SQL_CHAR">,
	filesheading=<cfqueryparam value="#FORM.filesheading#" cfsqltype="CF_SQL_CHAR">,
	<!--- hitcounton=<cfqueryparam value="#FORM.hitcount#" cfsqltype="CF_SQL_CHAR">, --->
	righttable=<cfqueryparam value="#FORM.righttable#" cfsqltype="CF_SQL_CHAR">,
	bumprighttable=<cfqueryparam value="#FORM.bumprighttable#" cfsqltype="CF_SQL_CHAR">,
	<!--- bodyPadding=<cfqueryparam value="#FORM.bodyPadding#" cfsqltype="CF_SQL_INTEGER">, --->
	lastupdate=<cfqueryparam value="#DateFormat(Now(), 'M/D/YYYY')#" cfsqltype="CF_SQL_CHAR">,
	lastupdateBy=<cfqueryparam value="#session.auth.fullUserName#" cfsqltype="CF_SQL_CHAR">,
	<cfif FORM.showDateFrom EQ ''>showDateFrom=NULL,
	<cfelse>
	showDateFrom=<cfqueryparam value="#DateFormat(FORM.showDateFrom, 'M/D/YYYY')#" cfsqltype="CF_SQL_DATE">,</cfif>
	<cfif FORM.showDateTo EQ ''>showDateTo=NULL,
	<cfelse>
	showDateTo=<cfqueryparam value="#DateFormat(FORM.showDateTo, 'M/D/YYYY')#" cfsqltype="CF_SQL_DATE">,</cfif>
	annRank=<cfqueryparam value="#FORM.annRank#" cfsqltype="CF_SQL_INTEGER">,
	filesRank=<cfqueryparam value="#FORM.filesRank#" cfsqltype="CF_SQL_INTEGER">,
	linksRank=<cfqueryparam value="#FORM.linksRank#" cfsqltype="CF_SQL_INTEGER">,
	textArea2Rank=<cfqueryparam value="#FORM.textArea2Rank#" cfsqltype="CF_SQL_INTEGER">,
	newsfeedRank=<cfqueryparam value="#FORM.newsfeedRank#" cfsqltype="CF_SQL_INTEGER">,
	newsFeedList=<cfqueryparam value=",#FORM.newsFeedList#," cfsqltype="CF_SQL_CHAR">
WHERE tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>



</cfif>


<!--- get page info --->
<cfquery datasource="#datasource#" name="pageatt">
SELECT *
FROM pageatt, contacts
WHERE pageatt.tid = contacts.tid
	AND contacts.tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>


<!--- see if user has access to any more pages --->
<cfquery name="changeid" datasource="#datasource#">
SELECT contacts.tid, contacts.description, accessgroup.groupname, contacts.hidepage, contacts.accessgroup, contacts.newscat
FROM contacts, teacher, accessgroup
WHERE accessgroup IN(#session.auth.accesscode#)
	AND contacts.tid = teacher.tid
	AND teacher.homepage = 'default'
	AND accessgroup.groupid = contacts.accessgroup
	AND #session.auth.authlevel# > 1
ORDER BY accessgroup.groupname, contacts.newscat, contacts.description
</cfquery>


<!--- get other teacher pages and their home account page --->
<cfquery datasource="#datasource#" name="getTeacherPages">
SELECT contacts.description, contacts.tid, hidepage
FROM teacher, contacts
WHERE teacher.tid = contacts.tid
	AND (
	(owner = <cfqueryparam value="#session.auth.loggedInId#" cfsqltype="CF_SQL_INTEGER">
	AND fname = 'TVOID')
	OR contacts.tid = <cfqueryparam value="#session.auth.loggedInId#" cfsqltype="CF_SQL_INTEGER">
	)
ORDER BY contacts.description
</cfquery>

<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br>


<script type="text/javascript" src="/ocm_ckeditor/ckeditor.js"></script>


<cfinclude template="../../cfGlobalCode/globalScriptsDatePicker.cfm">

<cfinclude template="../../cfGlobalCode/globalScripts.cfm">


<table width="100%" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor">
            <td colspan="3" class="BL" align="left"><img src="http://www.cnyric.org/images/tempedit_temped.gif" width="171" height="56" alt="" border="0"></td>
          </tr>
		  
		  <!--- navbar --->
		  <tr><td bgcolor="#ffffff" class="BL noPadCell" colspan="3">
		  
		 <table border="0" cellspacing="0" cellpadding="0"><tr>
		 <td><img src="http://www.cnyric.org/images/tempedit_navbar_jumpto.gif" alt="" border="0"></td>
		 <td><a href="tmanagefile.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_images.gif" alt="" border="0"></a></td>
		 <td><a href="adminmain.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_admin.gif" alt="" border="0"></a></td>
		 <td><a href="adminAddPage.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_addpage.gif" alt="" border="0"></a></td>
		 <td><a href="../logout.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_logout.gif" alt="" border="0"></a></td>
		 </tr></table>
		 </td></tr>
		 <!--- spacer row --->
		  <tr><td height="20"></td></tr>
		  
		  <!--- end navbar --->
		  
		  
		  <!--- only display if user has multiple accounts --->
		  <cfif (changeid.recordcount NEQ 0) OR (getTeacherPages.recordcount NEQ 1)>
		  <tr><cfform action="#CGI.SCRIPT_NAME#" method="POST" name="userchange">
            <td align="left" valign="top"> &nbsp;Modify: 
            
			
			<select name="changeuser" onchange="document.userchange.submit();">
			<!--- <cfoutput><option value="#session.auth.loggedInId#" <cfif session.auth.loggedInId EQ session.auth.uid>selected</cfif>>My Pages - My Home Page</option></cfoutput> --->
			<cfoutput query="getTeacherPages">
				<option value="#tid#" <cfif session.auth.uid EQ tid>selected</cfif>>My Pages - #description#</option></cfoutput>
			<cfoutput query="changeid">
			<!--- for news stories, only show stories they have access to --->
			<cfif accessgroup EQ 10>
			<!--- compare newscat list with session.accesscode to see if they have access to this category.  compareLists() function included above --->
				<cfif compareLists(session.auth.accesscode,newscat) NEQ 0 OR findNoCase('null',newscat)>

					<option value="#tid#" <cfif session.auth.uid EQ tid>selected</cfif>>#groupname#: 
						<cfif listFindNoCase(newscat,'2')>District News: 
						<cfelseif listFindNoCase(newscat,'44')>Spotlight: 
						<cfelse>NO CATEGORY SPECIFIED: 
						</cfif>
					#description#: <cfif hidepage EQ 'yes'>(hidden)</cfif> id:#tid#</option>
					
				</cfif>
				<!--- otherwise, if not news category --->
				<cfelse>
				<option value="#tid#" <cfif session.auth.uid EQ tid>selected</cfif>>#groupname# - #description# <cfif hidepage EQ 'yes'>(hidden)</cfif>(id #tid#)</option>
			</cfif>
			</cfoutput>
			</select>
			
			</td></cfform>
          </tr></cfif>
		  
<tr><td align="left">
<cfform name="teditform" id="teditform" method="post" action=#CGI.SCRIPT_NAME#>
<input type="hidden" name="updated" value="true">
<input type="hidden" name="sessid" value="<cfoutput>#session.auth.uid#</cfoutput>">

		<table align="left">
		
		<tr><td colspan="2"><input type="submit" class="gl_submit" name="Submit" value="Save Changes"></td></tr>
		  
		<tr><td colspan="2">  



<table border="0" width="1000" bgcolor="dddddd">

		   <tr>
            <td width="20%" nowrap> 
			<cfif session.auth.accessgroup EQ 10>
			Story Headline
			<cfelse>
			Page title:</cfif>
			<cfinput size="40" name="title" value="#pageatt.title#" class="gl_textbox">
			
			<cfif session.auth.accessgroup EQ 10><br><br><a href="selectThumbnail.cfm">
			
			<!--- check for existance of thumbnail --->
			<cfif fileExists("F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#/newsthumbnail.jpg")>
			<img src="http://www.cnyric.org/images/tempedit_thumbnailOK.png" alt="" border="0" align="middle">
			
			<cfelse>
			<img src="http://www.cnyric.org/images/tempedit_thumbnailNOTOK.png" alt="" border="0" align="middle">
			
			</cfif>
			</a> </cfif>
			</td>
			
			<cfif pageatt.lockHeader NEQ 'yes' OR session.auth.authlevel EQ 3>
			<td align="right">

<table id="showtext"><tr><td><a href="##" onclick="hideTable('showtext');showTable('hidetext');showTable('hidetext2');">Advanced options</a> [+]</td></tr></table>
<table id="hidetext2" style="display:none;"><tr><td><a href="##" onclick="showTable('showtext');hideTable('hidetext');hideTable('hidetext2');">Hide advanced options</a> [-]</td></tr></table>


			</td></cfif>
          </tr>
		  
		  <cfif pageatt.lockHeader EQ 'yes' AND session.auth.authlevel NEQ 3>
		  <tr><td colspan="2" bgcolor="ffffff"><strong>Your system administrator has limited access to this page.</strong></td></tr>
		  
		  </cfif>
		  <tr><td colspan="2">

		<table id="hidetext" <cfif pageatt.lockHeader NEQ 'yes' OR session.auth.authlevel EQ 3>style="display:none;"</cfif> bgcolor="f1f1f1" width="1000">
		
   		  <tr>
            <td align="right"> Announcements section heading: </td>
            <td> <cfinput class="gl_textbox" size="40" name="heading1" value="#pageatt.heading1#" maxlength="21"> </td>
          </tr>
		  <tr>
            <td align="right"> Announcements section rank: </td>
            <td><select name="annRank">
				<option value="1" <cfif pageatt.annRank EQ 1>selected</cfif>>1</option>
				<option value="2" <cfif pageatt.annRank EQ 2>selected</cfif>>2</option>
				<option value="3" <cfif pageatt.annRank EQ 3>selected</cfif>>3</option>
				<option value="4" <cfif pageatt.annRank EQ 4>selected</cfif>>4</option>
				<option value="5" <cfif pageatt.annRank EQ 5>selected</cfif>>5</option>
				<option value="0" <cfif pageatt.annRank EQ 0>selected</cfif>>Hide this section</option>
				</select> </td>
          </tr>
	
		  <tr>
            <td align="right"> <a href="tmanageann.cfm">Manage Announcements</a> </td>
          </tr>
		  
		  <tr><td colspan="2">&nbsp;<hr></td></tr>
		  
		  <tr>
            <td align="right"> Links section heading: </td>
            <td> <cfinput class="gl_textbox" size="40" name="heading2" value="#pageatt.heading2#" maxlength="21"> </td>
          </tr>
		  <tr>
            <td align="right"> Links section rank: </td>
            <td><select name="linksRank">
				<option value="1" <cfif pageatt.linksRank EQ 1>selected</cfif>>1</option>
				<option value="2" <cfif pageatt.linksRank EQ 2>selected</cfif>>2</option>
				<option value="3" <cfif pageatt.linksRank EQ 3>selected</cfif>>3</option>
				<option value="4" <cfif pageatt.linksRank EQ 4>selected</cfif>>4</option>
				<option value="5" <cfif pageatt.linksRank EQ 5>selected</cfif>>5</option>
				<option value="0" <cfif pageatt.linksRank EQ 0>selected</cfif>>Hide this section</option>
				</select> </td>
          </tr>
		  
		  <tr>
            <td align="right"> <a href="tmanagelink.cfm">Manage Links</a> </td>
          </tr>
		  
		  <tr><td colspan="2">&nbsp;<hr></td></tr>
		  
		  <tr>
            <td align="right"> Files section heading: </td>
            <td> <cfinput class="gl_textbox" size="40" name="filesheading" value="#pageatt.filesheading#" maxlength="21"> </td>
          </tr>
		   <tr>
            <td align="right"> Files section rank: </td>
            <td><select name="filesRank">
				<option value="1" <cfif pageatt.filesRank EQ 1>selected</cfif>>1</option>
				<option value="2" <cfif pageatt.filesRank EQ 2>selected</cfif>>2</option>
				<option value="3" <cfif pageatt.filesRank EQ 3>selected</cfif>>3</option>
				<option value="4" <cfif pageatt.filesRank EQ 4>selected</cfif>>4</option>
				<option value="5" <cfif pageatt.filesRank EQ 5>selected</cfif>>5</option>
				<option value="0" <cfif pageatt.filesRank EQ 0>selected</cfif>>Hide this section</option>
				</select> </td>
          </tr>

		  <tr>
            <td align="right"> <a href="tmanagefile.cfm">Manage files</a> </td>
          </tr>
		  
		  <tr><td colspan="2">&nbsp;<hr></td></tr>
		  
		  <tr> 
            <td colspan="2"> 
			
			<div id="extraTempeditWindow" <cfif pageatt.body2 NEQ '' AND pageatt.body2 NEQ '&nbsp;' AND pageatt.body2 NEQ '<br>'>style="display:none;"</cfif>><a href="##" onclick="hideTable('extraTempeditWindow');showTable('extraTempeditWindow3');showTable('extraTempeditWindow2');">Show an additional text area [+]</a></div>
<div id="extraTempeditWindow2" <cfif pageatt.body2 EQ '' OR pageatt.body2 EQ '&nbsp;' OR pageatt.body2 EQ '<br>'>style="display:none;"</cfif>><a href="##" onclick="showTable('extraTempeditWindow');hideTable('extraTempeditWindow2');hideTable('extraTempeditWindow3');">Hide additional text area [ -]</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
The additional text area box is now displayed below your main text area
</div><br><br>

<div id="newsFeedWindow"><a href="##" onclick="hideTable('newsFeedWindow');showTable('newsFeedWindow2');">Add a news feed [+]</a></div>
<div id="newsFeedWindow2" style="display:none;">
<table border="0" cellpadding="2"><tr><td valign="top" width="200">
<a href="##" onclick="showTable('newsFeedWindow');hideTable('newsFeedWindow2');">Hide news feed [ -]</a>
</td><td>
Add any of the following feeds to your page<br>
<input type="checkbox" name="newsFeedList" value="2" <cfif listFind(pageatt.newsFeedList,2)>checked</cfif>>District News<br>
<input type="checkbox" name="newsFeedList" value="44" <cfif listFind(pageatt.newsFeedList,44)>checked</cfif>>District Spotlight<br>


News section rank: 
<select name="newsfeedRank">
<option value="1" <cfif pageatt.newsfeedRank EQ 1>selected</cfif>>1</option>
<option value="2" <cfif pageatt.newsfeedRank EQ 2>selected</cfif>>2</option>
<option value="3" <cfif pageatt.newsfeedRank EQ 3>selected</cfif>>3</option>
<option value="4" <cfif pageatt.newsfeedRank EQ 4>selected</cfif>>4</option>
<option value="5" <cfif pageatt.newsfeedRank EQ 5>selected</cfif>>5</option>
<option value="0" <cfif pageatt.newsfeedRank EQ 0>selected</cfif>>Hide this section</option>
</select>
</td></tr></table>

</div><br><br>

<div id="dateRangeWindow" <cfif pageatt.showDateFrom NEQ '' OR pageatt.showDateTo NEQ ''>style="display:none;"</cfif>><a href="##" onclick="hideTable('dateRangeWindow');showTable('dateRangeWindow2');">Choose date range for this page [+]</a></div>
<div id="dateRangeWindow2" <cfif pageatt.showDateFrom EQ '' AND pageatt.showDateTo EQ ''>style="display:none;"</cfif>>
<table border="0" cellpadding="2">
<tr><td><a href="##" onclick="showTable('dateRangeWindow');hideTable('dateRangeWindow2');">Hide Date range [-]</a><br>
Choose date(s) to start and stop showing this page.  Page will be unavailable outside of date range.<br><br></td></tr>
<tr><td>

Begin showing: <cfinput type="Text" name="showDateFrom" value="#DateFormat(pageatt.showDateFrom,'M/D/YYYY')#" validate="date" required="No" size="16" id="showDateFrom" placeholder="Click to choose date">

&nbsp;&nbsp;&nbsp;&nbsp;

Stop showing after: <cfinput type="Text" name="showDateTo" value="#DateFormat(pageatt.showDateTo,'M/D/YYYY')#" validate="date" required="No" size="16" id="showDateTo" placeholder="Click to choose date">

</td></tr></table>

</div>
			
			</td>
          </tr>
		  
		  <tr><td colspan="2">&nbsp;<hr></td></tr>
		  
		  <tr>
            <td align="right"> Put Files, Announcements, and Links in a right justified column </td>
			<td><input type="checkbox" name="righttable" value="yes" <cfif #pageatt.righttable# EQ 'yes'> checked</cfif>>
			&nbsp;&nbsp;&nbsp;&nbsp;
			Put right column under header <input type="checkbox" name="bumprighttable" value="yes" <cfif #pageatt.bumprighttable# EQ 'yes'> checked</cfif>>
			</td>
          </tr>
		  
		  </table>
		  
</td></tr>

		  <cfif pageatt.lockHeader NEQ 'yes' OR session.auth.authlevel EQ 3>
		  <tr>
            <td colspan="2"> <div><br>Main text area</div>
			<textarea class="gl_textarea" rows="8" cols="50" name="pagebody"><cfoutput>#HTMLEditFormat(pageatt.body)#</cfoutput></textarea> </td>
          </tr></cfif>
		  
		  <tr>
            <td colspan="2">
			
			<div width="1000" id="extraTempeditWindow3" <cfif pageatt.body2 EQ '' OR pageatt.body2 EQ '&nbsp;' OR pageatt.body2 EQ '<br>'>style="display:none;"</cfif>>
			<div><br>Additional text area</div>
			
			 Additional text area rank:&nbsp;&nbsp;&nbsp;
            <select name="textArea2Rank">
				<option value="1" <cfif pageatt.textArea2Rank EQ 1>selected</cfif>>1</option>
				<option value="2" <cfif pageatt.textArea2Rank EQ 2>selected</cfif>>2</option>
				<option value="3" <cfif pageatt.textArea2Rank EQ 3>selected</cfif>>3</option>
				<option value="4" <cfif pageatt.textArea2Rank EQ 4>selected</cfif>>4</option>
				<option value="5" <cfif pageatt.textArea2Rank EQ 5>selected</cfif>>5</option>
				<option value="0" <cfif pageatt.textArea2Rank EQ 0>selected</cfif>>Hide this section</option>
				</select> 
			
			 <textarea class="gl_textarea" rows="8" cols="50" name="pagebody2"><cfoutput>#HTMLEditFormat(pageatt.body2)#</cfoutput></textarea> 
</div>

</td>
          </tr>
		  
		  
		  <script type="text/javascript">
		<!--- CKEDITOR.instances.pagebody.updateElement(); --->
		<cfif pageatt.lockHeader NEQ 'yes' OR session.auth.authlevel EQ 3>
		CKEDITOR.replace( 'pagebody',
    {
        customConfig : '/ocm_ckeditor/template_nysdlc_config.js'
    });</cfif>
	
	CKEDITOR.replace( 'pagebody2',
    {
        customConfig : '/ocm_ckeditor/template_nysdlc_config.js'
    });
	</script>
	
		  <tr>
            <td colspan="2"> <a href="#" onClick="MyWindow=window.open('viewpics.cfm','MyWindow','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=475,height=500'); return false;">Drag &amp; Drop pics/files</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

<a href="pageBackup.cfm">Get a backup of this page</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

</td>
</tr>

		  
		  <tr> 
            <td colspan="2"><a href="../<cfoutput>#session.URLadd#teacherpage.cfm?teacher=#session.auth.uid#</cfoutput>">View my page</a> 
			<font size="-2">&nbsp;&nbsp;&nbsp;(be sure to save changes first)</font>
			</td>
          </tr>
		  
          <tr> 
            <td> <input type="submit" class="gl_submit" name="Submit" value="Save Changes"></td>
			
			<td align="right"><cfoutput>Last updated on #DateFormat(pageatt.lastUpdate,'M/D/YY')# by #pageatt.lastupdateBy#</cfoutput>&nbsp;&nbsp;</td>
          </tr></table>
		  </cfform></td><tr>
        </table>
		
		
</td><tr></table>
<br><br><cfinclude template="../footer.cfm">