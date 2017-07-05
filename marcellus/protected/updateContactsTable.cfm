

<cfset variables.datasource = "marcellus">

<cfquery datasource="#variables.datasource#">
UPDATE contacts
SET accesscode = <cfqueryparam value="0" cfsqltype="CF_SQL_CHAR">
WHERE accesscode = 'null'
	OR accesscode IS NULL
</cfquery>

<cfquery datasource="#variables.datasource#">
UPDATE contacts
SET accessgroup = <cfqueryparam value="0" cfsqltype="CF_SQL_INTEGER">
WHERE accessgroup IS NULL
</cfquery>