
<cfinclude template="header.cfm">
<cfinclude template="navtable.cfm">
<br><br>
  <table width="95%" border="0" cellspacing="0" cellpadding="6" align="center" bgcolor="#f8f8f8" class="LL BL RL TL">
<tr><td colspan="2"><img src="/images/StopBullying.gif" alt="" width="157" height="157" hspace="17" border="0" align="left"><br><br>If you have information regarding an incident of bullying or harassment please fill out this electronic form. </td></tr>
		  <cfform name="form1" method="post" action="stopBullyingSend.cfm">
        
		  
		  <tr> 
            <td align="right">Your name (optional)</td>
            <td> <cfinput type="Text" name="q1" message="Please fill out contact info" required="no" size="50" maxlength="255"> </td>
          </tr>
		  
		  <tr> 
            <td align="right">Your email (optional)</td>
            <td> <cfinput type="Text" name="q2" message="Please" required="no" size="50" maxlength="255"> </td>
          </tr>
		  
		  <tr> 
            <td align="right">Date of incident(s)</td>
            <td> <cfinput type="Text" name="q3" message="Please" required="Yes" size="50" maxlength="255"> </td>
          </tr>
		  
		  <tr> 
            <td align="right">Please provide the name of the person being bullied if known</td>
            <td> <cfinput type="Text" name="q4" message="Please" required="Yes" size="50" maxlength="255"> </td>
          </tr>
		  
		  <tr> 
            <td align="right">Please provide the name of the person doing the bullying if known</td>
            <td> <cfinput type="Text" name="q5" message="Please" required="Yes" size="50" maxlength="255"> </td>
          </tr>
		  
		  <tr> 
            <td align="right">Please provide the names of any witnesses if known </td>
            <td> <cfinput type="Text" name="q8" message="Please" required="Yes" size="50" maxlength="255"> </td>
          </tr>
		  
		  
		  <tr> 
            <td align="right">Describe the incident(s). Please include time of day and the location of the incident(s).</td>
            <td> <textarea cols="50" rows="5" name="q7"></textarea> </td>
          </tr>
		  
		  
		  
		  <tr> 
            <td>&nbsp;</td>
   			<td ><INPUT type="submit" class="gl_submit" value="   Submit   "></td>
		   </tr>
		  
		</cfform>
		  
		  
  
</table>

<br><br><cfinclude template="footer.cfm"></body>
</html>
