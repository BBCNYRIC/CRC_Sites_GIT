
<!--- links include --->
<cfif #links.RecordCount# NEQ 0>

<tr><td height="16"></td></tr>
<tr><td>
<cfoutput query="common">
<div class="bulletTextSmall">
<cfif common.heading2 NEQ ''>
#heading2#
<cfelse>
Links
</cfif>
</div>
</cfoutput>
		
		
		<br>
  		<cfoutput query="links">
		<a href="#link_url#" class="contentpage_linkText" <cfif newwindow EQ 'yes'>target="_blank"</cfif>>#link_name#</a><br>
		</cfoutput>
		
		<br>
		
</td></tr>
</cfif>