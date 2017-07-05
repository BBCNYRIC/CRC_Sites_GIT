<cfinclude template="header.cfm">
<cfinclude template="navtable.cfm"><br>

<table width="100%" border="0" cellspacing="0" cellpadding="10" align="center"><tr><td>
<div align=center class=header>Search Our Website</div>
<table width=100%>

<cfform name="form1" method="post" action="dosearch.cfm">
<tr><td><input type="Text" name="searchcr" range="Please enter a search string" required="Yes" size="40" maxlength="255" onfocus="this.style.backgroundColor='#ceebff';" onblur="this.style.backgroundColor='#ffffff';"> &nbsp;&nbsp;&nbsp;
           <input type="submit" name="Submit" value="  Search   " class="gl_submit"> </td></tr>
         </cfform>
		 
		 
<!--- <cfform action="tfileresults.cfm" method="post">
<INPUT type="hidden" name="StartRow" value="1">
		  
		   <tr>
   			<td>Keywords:</td>
   			<td><cfinput type="Text" name="Criteria" message="Please enter search text" required="Yes" size="30"></td>
		   </tr>
		   <tr>
   			<td>Results per page:</td>
   			<td>
      		 <SELECT name="MaxRows"> 
      		 <OPTION> 10<OPTION> 25<OPTION> 100
      		 </SELECT>
   			</td>
		   </tr>
		   
		  <tr> 
            <td>&nbsp;</td>
   			<td colspan=2><INPUT type="submit" value="   Search   " class="gl_submit"></td>
		   </tr></cfform> --->
		  
		  
        </table>


</td></tr></table>

<cfinclude template="footer.cfm">
</body></html>
