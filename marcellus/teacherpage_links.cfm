
<!--- links include --->
<cfif #links.RecordCount# NEQ 0>
<tr><td bgcolor="006633" height="6"></td></tr>
<tr><td height="16"></td></tr>
<tr><td>
<cfoutput query="common">
<div class="bulletText">
<cfif common.heading2 NEQ ''>
#heading2#
<cfelse>
Links
</cfif>
</div>
</cfoutput>
		
		
		<div class="paddedArea">
  		<cfoutput query="links">
		<a href="#link_url#" class="contentpage_linkText" <cfif newwindow EQ 'yes'>target="_blank"</cfif>>#link_name#</a><br>
		</cfoutput>
		</div>
		<br>
		
</td></tr>
</cfif>