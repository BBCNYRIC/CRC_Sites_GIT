
<cfinclude template="header.cfm">
<cfinclude template="navtable.cfm">
<br><br>
	<table width="90%" border="0" cellspacing="0" cellpadding="6" align="center" bgcolor="#f8f8f8" class="LL BL RL TL" style="padding: 15px;">
		<cfform name="form1" method="post" action="stopBullyingSend.cfm">
			<tr>
				<td colspan="2"><img src="http://www.cnyric.org/tfiles/folder1133/TIpLineBanner.gif" alt="Tip Line.  Report an incident" border="0" align="middle" hspace="5"></td>
			</tr> 
			<tr>
			 	<td colspan="2">At Marcellus Central School District, we take bullying seriously.  To report an incidence of bullying, please use this button which is now called the Tip Line.  <strong>The Tip Line also offers the possibility of reporting concerns in addition to bullying.  You will see the additional concerns named in the dropdowns.</strong><br><br></td>
			</tr>
			<tr>
				<td colspan="2">Please fill out the form below to report incidents.  If you want to remain anonymous, do not enter your name, telephone number, or email address.</td>
			</tr>
			<tr>
				<td colspan="2">If your situation is an emergency, call 911.</td>
			</tr>  
			<tr> 
				<td align="right"> <label for="q1">Your name</label> </td>
				<td> <cfinput type="Text" name="q1" id="q1" required="no" size="50" maxlength="255"> </td>
			</tr>
			
			<tr> 
				<td align="right"> <label for="q2">Telephone number</label> </td>
				<td> <cfinput type="Text" name="q2" id="q2" required="no" size="50" maxlength="255"> </td>
			</tr>

			<tr> 
				<td align="right"> <label for="q3">Email address</label> </td>
				<td> <cfinput type="Text" name="q3" id="q3" required="no" size="50" maxlength="255"> </td>
			</tr>
  
			<tr> 
				<td align="right"> <label for="q4">Category</label> </td>
				<td>
					<select name="q4" id="q4">
						<option value="Bullying">Bullying</option>
						<option value="Alcohol/Drugs">Alcohol/Drugs</option>
						<option value="Fighting">Fighting</option>
						<option value="I do not feel safe">I do not feel safe</option>
						<option value="Other">Other</option>
						<option value="Personal Crisis">Personal Crisis</option>
						<option value="Safety Risk">Safety Risk</option>
						<option value="Threat">Threat</option>
						<option value="Vandalism">Vandalism</option>
						<option value="Weapons">Weapons</option>
					</select>
				</td>
			</tr>
  
			<tr>
				<td align="right"> <label for="q5">Where is this happening?</label> </td>
				<td> 
					<select name="q5" id="q5">
						<option value="High School">High School</option>
						<option value="Middle School">Middle School</option>
						<option value="Elementary School">Elementary School</option>
						<option value="Other Location">Other Location</option>
					</select>
				</td>
			</tr>
  
			<tr> 
				<td align="right"> <label for="q6">Describe what is happening.</label> </td>
				<td> <textarea cols="50" rows="5" name="q6" id="q6"></textarea> </td>
			</tr>

			<tr> 
				<td>&nbsp;</td>
				<td ><INPUT type="submit" class="gl_submit" value="   Submit   "></td>
			</tr>
	  
		</cfform>
	</table>

<br><br><cfinclude template="footer.cfm"></body>
</html>
