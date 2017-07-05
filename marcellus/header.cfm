
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en">
<html xmlns="http://www.w3.org/1999/xhtml">
<html>
<head>
<META NAME="description" content="Marcellus School District web site.">
<META NAME="keywords" content="Marcellus, education, central new york, upstate new york, new york, learning, school, k12, k-12, district, elementary, highschool, high school">
<META name="robots" content="index, follow">
<title>Marcellus School District</title>
<link href="http://www.marcellusschools.org/main.css" rel="stylesheet" type="text/css">

</head>

<body>


<!--- if they're logged in as someone else, let them know --->
<cfif isDefined("session.auth.AdminLoggedInAsTeacher")>
<cfoutput>
<div id="diffLog">You are currently logged in as #session.auth.fullUserName#. Click here to <a href="/protected/adminLoginTeacher.cfm?logout=y">log back in as yourself</a></div>
</cfoutput>
</cfif>


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
<td valign="top" width="447"><a href="http://www.marcellusschools.org"><img src="/images/mainTopLogo.gif" width="447" height="114" alt="district home" border="0"></a></td>

<td valign="top" width="176">
<ul id="menu">
    <li><a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=437" class="drop"><img src="/images/kchGraphic.gif" width="176" height="62" alt="Heffernan Elementary" border="0"></a>
<div class="dropdown_3columns align_right" style="z-index:999">
           <div class="col_2">
                <h2>K.C. Heffernan Elementary</h2>
            </div>
            <div class="col_1" align="right">
               <img src="/images/mustangGrey.gif" width="39" height="50" alt="" border="0">
            </div>
			<div class="col_3">
                <hr>
            </div>
            <div class="col_3">
			
<table>
<tr>
<td valign="top"><a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=437"><img src="http://www.marcellusschools.org/images/menu_kch.jpg" width="120" height="90" alt="K.C. Heffernan Elementary" border="0" class="img_left imgshadow" /></a></td><td valign="top"><p><a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=437" class="headerLinkText"><span class="headerLinkText">K.C. Heffernan Elementary</span></a><br>2 Learners Landing<br /> Marcellus, NY 13108<br />
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
    <li><a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=447" class="drop"><img src="/images/csdGraphic.gif" width="176" height="62" alt="Driver Middle School" border="0"></a>
<div class="dropdown_3columns align_right" style="z-index:999">
           <div class="col_2">
                <h2>C.S. Driver Middle School</h2>
            </div>
            <div class="col_1" align="right">
               <img src="/images/mustangGrey.gif" width="39" height="50" alt="" border="0">
            </div>
			<div class="col_3">
                <hr>
            </div>
            <div class="col_3">
			
<table>
<tr>
<td valign="top"><a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=447"><img src="http://www.marcellusschools.org/images/menu_dms.jpg" width="120" height="90" alt="Driver Middle School" border="0" class="img_left imgshadow" /></a></td><td valign="top"><p><a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=447" class="headerLinkText"><span class="headerLinkText">C.S. Driver Middle School</span></a><br>2 Reed Parkway<br /> Marcellus, NY 13108
Phone: (315) 673-6200<br />
Fax: (315) 673-6202<br /> 

</p></td></tr>

</table>

            </div>
			
        </div>
        
    </li><!-- End menu -->
</ul></td>

<td valign="top" width="201">
<ul id="menu">
    <li><a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=459" class="drop"><img src="/images/hsGraphic.gif" width="201" height="62" alt="High School" border="0"></a>
<div class="dropdown_3columns align_right" style="z-index:999">
           <div class="col_2">
                <h2>Marcellus Sr. High School</h2>
            </div>
            <div class="col_1" align="right">
               <img src="/images/mustangGrey.gif" width="39" height="50" alt="" border="0">
            </div>
			<div class="col_3">
                <hr>
            </div>
            <div class="col_3">
			
<table>
<tr>
<td valign="top"><a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=459"><img src="http://www.marcellusschools.org/images/menu_mhs.jpg" width="120" height="90" alt="High School" border="0" class="img_left imgshadow" /></a></td><td valign="top"><p><a href="http://www.marcellusschools.org/teacherpage.cfm?teacher=459" class="headerLinkText"><span class="headerLinkText">Marcellus Sr. High School</span></a><br>1 Mustang Hill<br /> Marcellus, NY 13108<br />
Phone: (315) 673-6300<br />
Fax: (315) 673-6327<br /></p></td></tr>

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

</td></tr><!--- end tr for top yellow nav --->





<tr>
<td align="center" valign="top" colspan="2" class="mainfadetable">
<table width="1000" border="0" cellspacing="0" cellpadding="0">
<tr>
<td valign="top" align="left" width="200" class="LL RL TL BL mainBoxShadow" bgcolor="333333">