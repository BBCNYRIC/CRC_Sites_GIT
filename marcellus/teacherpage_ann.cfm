
<!--- announcements include --->
<cfif #ann.RecordCount# NEQ 0>
<tr><td bgcolor="006633" height="6"></td></tr>
<tr><td height="16"></td></tr>
<tr><td>
<cfoutput query="common">
<div class="bulletText">
<cfif common.heading1 NEQ ''>
#heading1#
<cfelse>
Announcements
</cfif>
</div>
</cfoutput>
	
	
	<div class="paddedArea">
	<cfoutput query="ann">
	<div class="contentpage_ann_header">#ann_header#</div>
  	<div class="contentpage_ann_text">#ann_text#</div>
	<cfif currentrow NEQ recordcount><br><hr><br></cfif>
	</cfoutput>
	</div>
	<br>
</td></tr>
</cfif>