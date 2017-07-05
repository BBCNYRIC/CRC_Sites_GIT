
<cfif isdefined("FORM.emailadd")>

	<!--- check their captcha authentication --->
	<cfif NOT (#FORM.captchacode# EQ #session.captchacode#)>
<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm">
<br>
<img src="../images/EdEmailer.gif" width="230" height="51" alt="" border="0"><br><br>
Your registration has NOT been completed.  You have entered an incorrect verification code.  Please <a href="enterAdd.cfm">try again</a><br><br>

<cfinclude template="../footer.cfm"></body>
</html>
<cfabort></cfif>



<!--- check to make sure this address is not already in the database --->
<cfquery datasource="marcellus" name="checkdups">
SELECT * FROM emailadd WHERE emailadd = <cfqueryparam value="#FORM.emailadd#" cfsqltype="CF_SQL_CHAR">
</cfquery>

<cfif (checkdups.recordcount GT 0) OR (isdefined("FORM.unsubscribe") AND checkdups.recordcount GT 0)>

<!--- address already in database, send generic email so they can log in and change settings --->
<cfmail to="#FORM.emailadd#" from="emailSignup@marcellusschools.org" subject="Marcellus Schools Email Updates Signup Verification" type="HTML" replyto="donotreply@marcellusschools.org">
You have signed up to receive regular updates from the Marcellus School District.  Click here to verify your enrollment - <a href="http://www.marcellusschools.org/emailRegistration/accountProfile/verifyAccount.cfm?verification=#checkdups.validation#&emailadd=#URLEncodedFormat(checkdups.emailadd)#">Verify my enrollment</a><br><br>
Please keep this email for your records, you can use the above link any time to change your account preferences
</cfmail>

<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm">
	<br>
<img src="../images/EdEmailer.gif" width="230" height="51" alt="" border="0"><br><br>
That email address is already signed up.  An email has been sent to you with a link to verify your account preferences.<br><br>

<br><br><cfinclude template="../footer.cfm"></body>
</html>
<cfabort>

<!--- if theyre trying to unsubscribe, but arent in the db --->
<cfelseif isdefined("FORM.unsubscribe") AND checkdups.recordcount EQ 0>

<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm">
	<br>
<img src="../images/EdEmailer.gif" width="230" height="51" alt="" border="0"><br><br>
That email address is not in our database.  You may not unsubscribe that address.  Click here if you would like to <a href="enteradd.cfm">sign up</a><br><br>

<br><br><cfinclude template="../footer.cfm"></body>
</html>
<cfabort>

</cfif><!--- end of duplicate address check --->




<!--- set up a random validation code --->
<cfset variables.alphabet="a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z">
<cfset variables.validationcode = ''>
<!--- create a 64 digit random string --->
<cfloop index="i" from="1" to="64" step="1">
	<!--- randomly choose either a number or a letter --->
	<cfif RandRange(1,2) EQ 1>
		<cfset variables.validationcode = Insert(RandRange(1,9),variables.validationcode,0)>
	<cfelse>
		<cfset variables.validationcode = Insert(ListGetAt(variables.alphabet,RandRange(1,26)),variables.validationcode,0)>
	</cfif>

</cfloop>


<!--- now, insert info to the database --->
<cfparam name="FORM.catlist" type="string" default="1">

<cfquery datasource="marcellus">
INSERT INTO emailadd(emailadd, validation, active, fname, catlist)
VALUES (<cfqueryparam value="#FORM.emailadd#" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="#variables.validationcode#" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value="0" cfsqltype="CF_SQL_INTEGER">,
		<cfqueryparam value="#FORM.fname#" cfsqltype="CF_SQL_CHAR">,
		<cfqueryparam value=",#FORM.catlist#," cfsqltype="CF_SQL_CHAR">)
</cfquery>


<!--- now send verification email --->
<cfmail to="#FORM.emailadd#" from="emailSignup@marcellusschools.org" subject="Marcellus Schools Email Updates Signup Verification" type="HTML" replyto="donotreply@marcellusschools.org">
You have signed up to receive regular updates from the Marcellus School District.  Click here to verify your enrollment - <a href="http://www.marcellusschools.org/emailRegistration/accountProfile/verifyAccount.cfm?verification=#variables.validationcode#&emailadd=#URLEncodedFormat(FORM.emailadd)#">Verify my enrollment</a><br><br>
Please keep this email for your records, you can use the above link any time to change your account preferences
</cfmail>



<cflocation url="thankyou.cfm" addtoken="No"><cfabort>


<cfelse><cflocation url="http://www.marcellusschools.org" addtoken="No"><cfabort>
</cfif>
