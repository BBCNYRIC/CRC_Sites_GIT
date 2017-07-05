

<!--- files include --->
<cfif #filez.RecordCount# NEQ 0>

<tr><td height="16"></td></tr>
<tr><td>
<cfoutput query="common">
<div class="bulletTextSmall">
<cfif common.filesheading NEQ ''>
#filesheading#
<cfelse>
Downloads
</cfif>
</div>
</cfoutput>


<br>
  	<cfoutput query="filez">
		<cfif #filez.showLink# EQ 'yes'>
			<cfif common.pppage EQ 'yes'>
			<a href="servetfile.cfm?teacher=#URL.teacher#&filename=#URLEncodedFormat(filename)#" class="contentpage_linkText">
			<cfelse>
			<a href="tfiles/folder#URL.teacher#/#URLEncodedFormat(filename)#" class="contentpage_linkText">
			</cfif>
			<cfif linkname EQ ''>#URLEncodedFormat(filename)#
			<cfelse>#linkname#</cfif></a><br>
		</cfif>
	</cfoutput>


</td></tr>
</cfif>