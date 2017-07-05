

<!--- if this form has been submited, update the record --->
<cfif isdefined("FORM.updated")>

<cfparam name="FORM.catlist" default="">

<!--- unsubscribe operations --->
<cfif isdefined("FORM.unsub")>

<!--- delete their account --->
<cfquery datasource="marcellus">
DELETE FROM emailadd
WHERE emailadd = <cfqueryparam value="#session.auth.emailadd#" cfsqltype="CF_SQL_CHAR">
</cfquery>

<cfinclude template="../../header.cfm">
<br>
<img src="../../images/EdEmailer.gif" width="230" height="51" alt="" border="0"><br><br>
Your email address - <cfoutput><strong>#session.auth.emailadd#</strong></cfoutput> - has been removed.<br>
<a href="http://www.marcellusschools.org">Marcellus Home</a>
<br><br><cfinclude template="../../footer.cfm"></body>
</html>
<cfabort>
</cfif>


<cfquery datasource="#datasource#">
UPDATE emailadd
SET active = 1,
	catlist = <cfqueryparam value=",#FORM.catlist#," cfsqltype="CF_SQL_CHAR">
WHERE emailadd = <cfqueryparam value="#session.auth.emailadd#" cfsqltype="CF_SQL_CHAR">
</cfquery>

<cfset session.auth.active = 1>

</cfif>

<!--- get user info --->
<cfquery name="getuserinfo" datasource="#datasource#">
SELECT *
FROM emailadd
WHERE emailadd = <cfqueryparam value="#session.auth.emailadd#" cfsqltype="CF_SQL_CHAR">
</cfquery>

<cfparam name="getuserinfo.catlist" default="">

<cfinclude template="../../header.cfm">


<table width="90%" border="0" cellspacing="0" cellpadding="5" align="center">

<tr><td colspan="2"><img src="../../images/EdEmailer.gif" width="230" height="51" alt="" border="0"><br><br>
<cfif isdefined("FORM.updated")>
Your settings have been verified, you are now registered for the following options.
</cfif>
<cfif session.auth.active NEQ 1>
<strong><font color="ff0000">You have not yet verified your account.</font>  Please click the "Update Preferences" button below to verify your enrollment.</strong>
</cfif>
</td></tr>


<cfform action="verifyAccount.cfm" method="POST" enablecab="Yes">
<input type="hidden" name="updated" value="yes">

<cfoutput>
<tr><td colspan="2">Email address: <strong>#session.auth.emailadd#</strong></td></tr>
<tr><td colspan="2">Your name: <strong>#getuserinfo.fname#</strong></td></tr>
<!--- <tr><td colspan="2">Last name: <strong>#getuserinfo.lname#</strong></td></tr>
<tr><td colspan="2">Affiliation: <strong>#getuserinfo.affiliation#</strong></td></tr> --->
</cfoutput>

<tr><td valign="top" width="10%" nowrap>
Send me messages about:</td>
<td><input type="checkbox" name="catList" value="1" <cfif listFind(getuserinfo.catlist,1)>checked</cfif>> Middle School News<br>

</td>
</tr>

<tr><td colspan="2"><hr></td></tr>

<tr><td valign="top" width="10%" nowrap>
Unsubscribe Completely:</td>
<td><input type="checkbox" name="unsub" value="1"> </td>
</tr>

<tr><td colspan="2"><input type="submit" name="submit" value="Update Preferences" class="gl_submit"></td></tr>
</cfform>

</table>


<br><br><cfinclude template="../../footer.cfm"></body>
</html>



