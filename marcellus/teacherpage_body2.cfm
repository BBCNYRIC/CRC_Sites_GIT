
<!--- announcements include --->
<cfif common.body2 NEQ '' AND common.body2 NEQ '&nbsp;'>
<!--- if bumping right table down, dont put bar across --->
<cfif common.righttable NEQ 'yes'>
<tr><td bgcolor="006633" height="6"></td></tr></cfif>
<tr><td height="16"></td></tr>
<tr><td>
<table width="100%" cellpadding="8"><tr><td><cfoutput>#common.body2#</cfoutput></td></tr></table>
</td></tr>

<!--- if bumping right table down, dont put bar across --->
<cfif common.righttable EQ 'yes'>
<tr><td bgcolor="006633" height="6"></td></tr></cfif>


</cfif>