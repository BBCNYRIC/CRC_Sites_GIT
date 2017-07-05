
<!--- 12 rows max, otherwise the graphic gets pushed down --->
<cfquery name="getcats" datasource="#datasource#" maxrows=12>
SELECT contacts.description, teacher.template, contacts.tid, teacher.homepage
FROM contacts, teacher, pageatt
WHERE teacher.tid = contacts.tid
	AND pageatt.tid = contacts.tid
	AND teacher.fname <> 'TVOID'
	AND contacts.hidepage = 'no'
	AND contacts.accessgroup = 2
	AND ISNULL(pageatt.showDateFrom, '1/1/1900') <= <cfqueryparam value="#DateFormat(Now())#" cfsqltype="CF_SQL_DATE">
	AND ISNULL(pageatt.showDateTo, '1/1/2025') >= <cfqueryparam value="#DateFormat(Now())#" cfsqltype="CF_SQL_DATE">
ORDER BY contacts.rankorder, contacts.description
</cfquery>


<!--- query for news items --->
<cfquery name="newslinks" datasource="#datasource#" maxrows=6>
SELECT contacts.description, contacts.tid, teacher.homepage, pageatt.title, pageatt.body, contacts.newscat
FROM contacts, teacher, pageatt
WHERE teacher.tid = contacts.tid
	AND pageatt.tid = contacts.tid
	AND teacher.fname <> 'TVOID'
	AND contacts.accessgroup = 10
	AND contacts.featuredNews = 'yes'
	AND newscat LIKE <cfqueryparam value="%,2,%" cfsqltype="CF_SQL_CHAR">
	AND ISNULL(pageatt.showDateFrom, '1/1/1900') <= <cfqueryparam value="#DateFormat(Now())#" cfsqltype="CF_SQL_DATE">
	AND ISNULL(pageatt.showDateTo, '1/1/2025') >= <cfqueryparam value="#DateFormat(Now())#" cfsqltype="CF_SQL_DATE">
ORDER BY contacts.tid DESC, contacts.rankorder, contacts.description
</cfquery>

<!--- query for news items --->
<cfquery name="newslinks2" datasource="#datasource#">
SELECT contacts.description, contacts.tid, teacher.homepage, pageatt.title, pageatt.body, contacts.newscat
FROM contacts, teacher, pageatt
WHERE teacher.tid = contacts.tid
	AND pageatt.tid = contacts.tid
	AND teacher.fname <> 'TVOID'
	AND contacts.accessgroup = 10
	AND newscat LIKE <cfqueryparam value="%,44,%" cfsqltype="CF_SQL_CHAR">
	AND ISNULL(pageatt.showDateFrom, '1/1/1900') <= <cfqueryparam value="#DateFormat(Now())#" cfsqltype="CF_SQL_DATE">
	AND ISNULL(pageatt.showDateTo, '1/1/2025') >= <cfqueryparam value="#DateFormat(Now())#" cfsqltype="CF_SQL_DATE">
	<!--- AND contacts.featuredNews = 'yes' --->
ORDER BY contacts.tid DESC, contacts.rankorder, contacts.description
</cfquery>

<!--- query for message board --->
<!--- <cfquery name="messageboard" datasource="#datasource#">
SELECT body, title
FROM pageatt pa
WHERE pa.tid = <cfqueryparam value="667" cfsqltype="CF_SQL_INTEGER">
</cfquery> --->



<!--- random photo --->

<cfquery name="getimg" datasource="#datasource#" cachedwithin="#CreateTimeSpan(0, 0, 30, 0)#">
SELECT filename
FROM tfiles
WHERE tid = <cfqueryparam value="1241" cfsqltype="CF_SQL_INTEGER">
	AND (filetype = <cfqueryparam value="jpg" cfsqltype="CF_SQL_CHAR">
	OR filetype = <cfqueryparam value="jpeg" cfsqltype="CF_SQL_CHAR">)
</cfquery>



<!--- set var for rotating spotlight item --->
<cfset variables.randnumSpotlight = RandRange(1, newslinks2.recordcount)>
	<cfif variables.randnumSpotlight EQ 0><cfset variables.randnumSpotlight = 1></cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--- <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"> --->
<html>
<head>
<META NAME="description" content="Marcellus School District web site.">
<META NAME="keywords" content="Marcellus, education, central new york, upstate new york, new york, learning, school, k12, k-12, district, elementary, highschool, high school">
<META name="robots" content="index, follow">
<title>Marcellus School District</title>
<link href="main.css" rel="stylesheet" type="text/css">

</head>

<body>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr><!--- tr for top navigation --->
<td align="center" bgcolor="#000000">

<table width="1000" border="0" cellspacing="0" cellpadding="0"><tr><td valign="top">

<!--- include for right top images and flyouts --->
<cfinclude template="flyoutmenu.cfm">

</td></tr></table>

</td></tr><!--- end tr for top nav --->

<tr><!--- tr for top title bar --->
<td align="center" bgcolor="#006633">

<table width="1000" border="0" cellspacing="0" cellpadding="0"><tr>
<td valign="top" width="447"><a href="http://www.marcellusschools.org"><img src="images/mainTopLogo.gif" width="447" height="114" alt="district home" border="0"></a></td>

<td valign="top" width="176">
<ul id="menu">
    <li><a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=437" class="drop"><img src="images/kchGraphic.gif" width="176" height="62" alt="Heffernan Elementary" border="0"></a>
<div class="dropdown_3columns align_right" style="z-index:999">
           <div class="col_2">
                <h2>K.C. Heffernan Elementary</h2>
            </div>
            <div class="col_1" align="right">
               <img src="images/mustangGrey.gif" width="39" height="50" alt="" border="0">
            </div>
			<div class="col_3">
                <hr>
            </div>
            <div class="col_3">
			
<table>
<tr>
<td valign="top"><a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=437"><img src="http://www.marcellusschools.org/images/menu_kch.jpg" width="120" height="90" alt="Heffernan Elementary" border="0" class="img_left imgshadow" /></a></td><td valign="top"><p><a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=437" class="headerLinkText"><span class="headerLinkText">K.C. Heffernan Elementary</span></a><br>2 Learners Landing<br /> Marcellus, NY 13108<br />
Phone: (315) 673-6100<br />
Fax: (315) 673-0227<br>
</p></td></tr>

</table>

            </div>
			
        </div>
        
    </li><!-- End contact us menu -->
</ul></td>

<td valign="top" width="176">
<ul id="menu">
    <li><a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=447" class="drop"><img src="images/csdGraphic.gif" width="176" height="62" alt="Driver Middle School" border="0"></a>
<div class="dropdown_3columns align_right" style="z-index:999">
           <div class="col_2">
                <h2>C.S. Driver Middle School</h2>
            </div>
            <div class="col_1" align="right">
               <img src="images/mustangGrey.gif" width="39" height="50" alt="" border="0">
            </div>
			<div class="col_3">
                <hr>
            </div>
            <div class="col_3">
			
<table>
<tr>
<td valign="top"><a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=447"><img src="http://www.marcellusschools.org/images/menu_dms.jpg" width="120" height="90" alt="Driver Middle School" border="0" class="img_left imgshadow" /></a></td><td valign="top"><p><a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=447" class="headerLinkText"><span class="headerLinkText">C.S. Driver Middle School</span></a><br>2 Reed Parkway<br /> Marcellus, NY 13108
Phone: (315) 673-6200<br />
Fax: (315) 673-6327<br /> 

</p></td></tr>

</table>

            </div>
			
        </div>
        
    </li><!-- End menu -->
</ul></td>

<td valign="top" width="201">
<ul id="menu">
    <li><a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=459" class="drop"><img src="images/hsGraphic.gif" width="201" height="62" alt="High School" border="0"></a>
<div class="dropdown_3columns align_right" style="z-index:999">
           <div class="col_2">
                <h2>Marcellus Sr. High School</h2>
            </div>
            <div class="col_1" align="right">
               <img src="images/mustangGrey.gif" width="39" height="50" alt="" border="0">
            </div>
			<div class="col_3">
                <hr>
            </div>
            <div class="col_3">
			
<table>
<tr>
<td valign="top"><a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=459"><img src="http://www.marcellusschools.org/images/menu_mhs.jpg" width="120" height="90" alt="High School" border="0" class="img_left imgshadow" /></a></td><td valign="top"><p><a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=459" class="headerLinkText"><span class="headerLinkText">Marcellus Sr. High School</span></a><br>1 Mustang Hill<br /> Marcellus, NY 13108<br />
Phone: (315) 673-6300<br />
Fax: (315) 673-6326<br /></p></td></tr>

</table>

            </div>
			
        </div>
        
    </li><!-- End menu -->
</ul></td>


</tr></table>

</td></tr><!--- end tr for top title bar --->


<tr><!--- tr for top yellow bar navigation --->
<td align="center" bgcolor="#ffecaa">

<table width="1000" border="0" cellspacing="0" cellpadding="0"><tr><td valign="top">

<!--- include for right top images and flyouts --->
<cfinclude template="flyoutmenu2.cfm">

</td></tr></table>

</td></tr><!--- end tr for top red nav --->

<tr><td bgcolor="#99cc00" height="2" colspan="2"></td></tr><!--- thin black line --->


<tr><td bgcolor="#ffffff" height="10" colspan="2"></td></tr><!--- thin black line --->

<tr><!---  --->
<td align="center" bgcolor="#ffffff">

<table width="1000" border="0" cellspacing="0" cellpadding="0"><tr><td valign="top">
<a href="/teacherpage.cfm?teacher=1209"><img src="/tfiles/folder1017/HomePageAd.png" width="1000" height="100" alt="" border="0"></a>


</td></tr></table>

</td></tr><!--- end tr for top red nav ---><br>





<!--- left side nav links --->
<tr>
<td align="center" class="mainfadetable">

<table width="1000" border="0" cellspacing="12" cellpadding="0"><tr>

<!--- <tr><td height="10"></td></tr><!--- spacer ---> --->

<!--- nav links --->
<td valign="top" width="190">

<table width="190" height="302" border="0" cellspacing="0" cellpadding="0" align="left" class="LL RL TL BL mainBoxShadow greenfadetable">
<tr><td valign="top"><img src="images/distLinks.gif" width="196" height="37" alt="quick links" border="0"></td></tr>

<cfoutput query="getcats">

<cfif homepage IS "default">
		<tr><td align="right" nowrap><a href="teacherpage.cfm?teacher=#tid#" class="mainpagenav">#description# ::</a></td></tr>
<cfelse><tr><td align="right" nowrap><a href="#homepage#" class="mainpagenav">#description# ::</a></td></tr></cfif>
</cfoutput>

<tr><td height="5"></td></tr>
</table>


</td><!--- end nav links --->


<td valign="top" width="414">
<table width="245" border="0" cellspacing="0" cellpadding="0" align="left"><tr>

<td valign="top" align="left">
<!--- <img src="tfiles/folder1241/mainPhoto10.jpg" width="410" height="302" alt="" border="0" class="mainBoxShadow"> --->
<cfoutput query="getimg" startrow=#RandRange(1, getimg.recordcount)# maxrows=1>
<img src="tfiles/folder1241/#filename#" width="410" height="302" alt="" border="0" class="mainBoxShadow">
</cfoutput>


</td></tr></table>
</td>


<td valign="top">


<table width="324" border="0" cellspacing="0" cellpadding="0" class="LL RL TL BL mainBoxShadow" bgcolor="ffffff">
<tr><td><img src="images/calHeader.gif" width="324" height="36" alt="calendar" border="0"></td></tr>

<tr><td><table cellpadding="4" border="0"><tr><td><iframe src="https://www.google.com/calendar/embed?showTitle=0&amp;showPrint=0&amp;showTabs=0&amp;showTz=0&amp;mode=AGENDA&amp;height=253&amp;wkst=1&amp;bgcolor=%23FFFFFF&amp;src=marcellusschools.org_nnrg5jepo2o0ftcr65pkoj5lus%40group.calendar.google.com&amp;color=%23125A12&amp;src=marcellusschools.org_rbuji89nhgbcgd5mllhvlmaiqc%40group.calendar.google.com&amp;color=%235229A3&amp;src=marcellusschools.org_e46mgqrt5buu6kg7n8me9tqrco%40group.calendar.google.com&amp;color=%23875509&amp;src=marcellusschools.org_sgq9k25ugjvjkp46kaauuv9iq0%40group.calendar.google.com&amp;color=%236B3304&amp;ctz=America%2FNew_York" style=" border-width:0 " width="100%" height="253" frameborder="0" scrolling="no"></iframe>

</td></tr></table></td></tr>
</table>


</td>
</tr><!--- end first row --->

<!--- <tr><td height="10"></td></tr><!--- spacer ---> --->

<!--- news stories and buttons --->
<tr>
<!--- news --->
<td valign="top" width="600" colspan="2">

<table width="600" border="0" cellspacing="0" cellpadding="0" align="left" bgcolor="ffffff" class="mainBoxShadow">
<tr><td colspan="2" nowrap>
<table width="622" border="0" cellspacing="0" cellpadding="0"><tr><td><img src="images/newsHeader.gif" width="472" height="37" alt="news" border="0"></td><td><a href="districtnews.cfm"><img src="images/newsHeaderMore.gif" width="150" height="37" alt="more news" border="0"></a></td></tr></table>
</td></tr>
<tr><td height="7"></td></tr>

<cfif newslinks.recordcount EQ 0>
<tr><td width="100%" align="left"><br>No news stories at this time</td></tr>

<cfelse>
<tr><td align="left" valign="top" width="130">
<div class="scrollableArea">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<cfoutput query="newslinks">
<tr><td align="left" valign="top" width="130">

<!--- query for thumbnail image --->
<cfquery datasource="#datasource#" name="getimage">
SELECT *
FROM tfiles
WHERE filename = 'newsthumbnail.jpg'
	AND tid = <cfqueryparam value="#tid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>


<cfif getimage.recordcount EQ 1>
<img border="1" alt="#description#" hspace="10" vspace="2" width="110" height="110" align="left" src="tfiles/folder#tid#/newsthumbnail.jpg" class="mainBoxShadow" />
<cfelse>
<img src="tfiles/folder1144/mustangGreySq.gif" alt="#description#" width="110" height="110" hspace="10" vspace="2" border="1" align="left" class="mainBoxShadow">
</cfif>
</td>
<td valign="top">
<a href="teacherpage.cfm?teacher=#tid#" class="newsHead">#description#:</a><br>

<!--- this strips out html coding --->
<cfset variables.cleantext = #REReplace(body,"</?\w+(\s*[\w:]+\s*=\s*(""[^""]*""|'[^']*'))*\s*/?>"," ","all")# />

<!--- now get the first space after 300 chars --->
<cfset variables.charNum = Find(" ",variables.cleantext,350)>


<!--- make sure our cleaned text is actually long enough to get 300 + chars out of --->
<cfif variables.charnum NEQ 0>
	<span class="newsfont">#Left(variables.cleantext,variables.charNum)# ... </span> 
	<a href="teacherpage.cfm?teacher=#tid#" class="whitetablefont">more &gt;&gt;</a>
<cfelse><span class="newsfont">#variables.cleantext#</span></cfif>

</td>
</tr>
<cfif currentrow NEQ recordcount>
<tr><td colspan="2"><hr width="90%" size="1" color="##808080" noshade></td></tr>
<cfelse><tr><td height="10"></td></tr></cfif>

</cfoutput>
</table></div>

</td></tr>
</cfif>


</table>

</td><!--- end news --->


<td valign="top" width="324"><!--- td for buttons --->

<table width="324" border="0" cellspacing="0" cellpadding="0" align="left" bgcolor="ffffff" class="mainBoxShadow">
<tr><td><img src="images/quickLinks.gif" width="324" height="36" alt="quicklinks" border="0"></td></tr>

<tr><td height="7"></td></tr>

<tr><td>

<table width="324" border="0" cellspacing="0" cellpadding="5">

<tr>
<td width="100"><a href="https://snn.neric.org/marcellus/" target="_blank"><img src="images/butSNN.gif" width="89" height="80" alt="school news notifier" border="0"></a></td>
<td width="100"><a href="http://www.parenttoday.org/" target="_blank"><img src="images/butPT.gif" width="89" height="80" alt="parent today" border="0"></a></td>
<td><a href="https://marcellus.schooltool.cnyric.org/SchoolToolWeb/" target="_blank"><img src="images/butSchooltool.gif" width="89" height="80" alt="schooltool" border="0"></a></td>
</tr>

<tr>
<td><a href="http://www.facebook.com/MarcellusCSD" target="_blank"><img src="images/butfacebook.gif" width="89" height="80" alt="facebook" border="0"></a></td>
<td><a href="https://www.myschoolbucks.com/login/getmain.do?action=home" target="_blank"><img src="images/butBucks.gif" width="89" height="80" alt="myschoolbucks" border="0"></a></td>
<td><a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=1143"><img src="images/butMenus.gif" width="89" height="80" alt="lunch menus" border="0"></a></td>
</tr>

<tr>
<td><a href="http://www.marcellusschools.org/stopbullying.cfm"><img src="images/butBullying.gif" width="89" height="80" alt="stop bullying" border="0"></a></td>
<td><a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=903"><img src="images/butNewsletter.gif" width="89" height="80" alt="Newsletter" border="0"></a></td>
<td width="100"><a href="https://twitter.com/MarcellusCSD" target="_blank"><img src="images/butTwitter.gif" width="89" height="80" alt="twitter" border="0"></a></td>
</tr>

</table>

</td></tr>
</table>



</td><!--- end td for buttons --->

</tr>



</table>

</td></tr><!--- end left side nav links --->


<tr><td bgcolor="#99cc00" height="5" colspan="2"></td></tr><!--- thin black line --->





<tr><!--- tr for spotlight and dist info --->
<td align="center" bgcolor="#006633">

<table width="975" border="0" cellspacing="0" cellpadding="5">
<tr><td height="4"></td></tr><!--- spacer --->
<tr>

<!--- td for spotlight story --->
<td valign="top" width="700" class="mainfadetable roundedTable">

<table width="600" border="0" cellspacing="0" cellpadding="0" align="left">


<cfif newslinks.recordcount EQ 0>
<tr><td width="100%" align="left"><br>No news stories at this time</td></tr></cfif>

<cfoutput query="newslinks2" startrow=#variables.randnumSpotlight# maxrows=1>
<tr><td align="left" valign="top" width="130">

<!--- query for thumbnail image --->
<cfquery datasource="#datasource#" name="getimage">
SELECT *
FROM tfiles
WHERE filename = 'newsthumbnail.jpg'
	AND tid = <cfqueryparam value="#tid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>


<cfif getimage.recordcount EQ 1>
<img border="1" alt="#description#" hspace="10" vspace="2" align="left" src="http://www.marcellusschools.org/tfiles/folder#tid#/newsthumbnail.jpg" class="mainBoxShadow" />
<cfelse>
<img src="http://www.marcellusschools.org/tfiles/folder1144/mustangGreySq.gif" alt="#description#" width="110" hspace="10" vspace="2" border="1" align="left" class="darkermainBoxShadow">
</cfif>
</td>
<td valign="top" align="left"><span class="spotlightText">Did You Know?</span><br>
<a href="teacherpage.cfm?teacher=#tid#" class="newsHead">#description#:</a>

<!--- this strips out html coding --->
<cfset variables.cleantext = #REReplace(body,"</?\w+(\s*[\w:]+\s*=\s*(""[^""]*""|'[^']*'))*\s*/?>"," ","all")# />

<!--- now get the first space after 300 chars --->
<cfset variables.charNum = Find(" ",variables.cleantext,350)>


<!--- make sure our cleaned text is actually long enough to get 300 + chars out of --->
<cfif variables.charnum NEQ 0>
	<span class="newsfont">#Left(variables.cleantext,variables.charNum)# ... </span> 
	<a href="teacherpage.cfm?teacher=#tid#" class="whitetablefont">more &gt;&gt;</a>
<cfelse><span class="newsfont">#variables.cleantext#</span></cfif>

</td>
</tr></cfoutput>


</table>


</td><!--- end td for spotlight story --->
<td valign="top" align="right">
<span class="yellowfont">Marcellus School District</span><br>
<span class="whitefontFooter">
Michelle Brantner, Superintendent<br>

2 Reed Parkway<br>
Marcellus, NY 13108<br>

Phone: (315) 673-6000<br>

<a href="http://www.marcellusschools.org" class="whitelinkFooter">www.marcellusschools.org</a>

</span>
</td>
</tr>
<tr><td height="10"></td></tr>
</table>

</td></tr><!--- end tr for spotlight and dist info --->



<tr><!--- tr for footer --->
<td align="center" bgcolor="#ffffff">

<table width="1000" border="0" cellspacing="0" cellpadding="0"><tr><td valign="top">

<!--- include for right top images and flyouts --->
<cfinclude template="footer.cfm">

</td></tr></table>

</td></tr><!--- end tr for footer --->


</body>
</html>