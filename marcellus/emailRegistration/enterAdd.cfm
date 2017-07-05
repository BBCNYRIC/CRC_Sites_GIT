
<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm">
<br>

<!--- set up a random validation code --->
<cfset variables.alphabet="a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z">
<cfset session.captchacode = ''>
<!--- create a 6 digit random string --->
<cfloop index="i" from="1" to="5" step="1">
	
		<cfset session.captchacode = Insert(ListGetAt(variables.alphabet,RandRange(1,26)),session.captchacode,0)>

</cfloop>

<table width="90%" border="0" cellspacing="0" cellpadding="5" align="center">

<tr><td colspan="2">Your mesage here </td></tr>


<tr><td colspan="2"><img src="../images/EdEmailer.gif" width="230" height="51" alt="" border="0"><br><br>

Please enter your email address to <cfif isdefined("URL.unsubscribe")>unsubscribe<cfelse>sign up</cfif>.  You will be mailed a verification email to activate your account.<br><br></td></tr>


<cfform action="enterinfo.cfm" method="POST">

<cfif isdefined("URL.unsubscribe")>
	<input type="hidden" name="unsubscribe" value="yes">
</cfif>

<tr><td colspan="2">Email address: 
<cfinput type="Text" name="emailadd" message="Please enter your email address" required="Yes" size="40" maxlength="80">
</td></tr>

<cfif NOT isdefined("URL.unsubscribe")>

<tr><td colspan="2">Your name: 
<cfinput type="Text" name="fname" message="Please enter your name" required="Yes" size="20" maxlength="80">
</td></tr>
<!--- <tr><td colspan="2">Last name: 
<cfinput type="Text" name="lname" message="Please enter your last name" required="Yes" size="20" maxlength="80">
</td></tr>
<tr><td colspan="2">Affiliation: 
<select name="affiliation">
<option value="Parent">Parent </option>
<option value="District Employee">District Employee </option>
<option value="Community Member">Community Member </option>			
</select>
</td></tr> --->

<tr><td valign="top" width="10%" nowrap>
Send me messages about:</td>
<td><input type="checkbox" name="catList" value="1"> Middle School News<br>

</td>
</tr>
</cfif>

<tr><td colspan="2">Please enter the text from the image below into the box provided for verification</td></tr>

<tr><td colspan="2">
<cfimage
    action = "captcha"
    height = "37"
    text = "#session.captchacode#"
    width = "170"
	difficulty="low"
	fontsize="25"
	fonts="arial,helvetica,times,geneva,swiss">&nbsp;&nbsp;&nbsp;&nbsp;
	
Enter image text here: <cfinput type="Text" name="captchacode" message="Please enter the letters from the coded image" required="Yes" size="7" maxlength="5">
	</td></tr>


<tr><td colspan="2"><input type="submit" name="submit" value="Submit" class="gl_submit"></td></tr>
</cfform>

<cfif NOT isdefined("URL.unsubscribe")>
<tr><td colspan="2">click here to <a href="enterAdd.cfm?unsubscribe=yes">unsubscribe</a></td></tr>
</cfif>


</table>

<br><br><cfinclude template="../footer.cfm"></body>
</html>
