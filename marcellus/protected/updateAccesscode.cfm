

<cfset variables.datasource = "marcellus">


<cfquery name="getacc" datasource="#variables.datasource#">
SELECT accesscode, tid
FROM contacts
</cfquery>

<cfoutput query="getacc">

<!--- if theres a trailing comma, remove it in the folowing query --->
<cfif #right(accesscode,1)# EQ ','>

<cfquery datasource="#variables.datasource#">
UPDATE contacts
SET accesscode = '#left(accesscode,len(accesscode)-1)#'
WHERE tid = #tid#
</cfquery>


#tid#<br><br>
</cfif>

</cfoutput>