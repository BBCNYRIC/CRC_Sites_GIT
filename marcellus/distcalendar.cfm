<!--- grab calendar events --->
<cfquery datasource="#datasource#" name="getcal">
SELECT *
FROM calendar
WHERE category = '1'
</cfquery>

<cfinclude template="header.cfm">
<cfinclude template="navtable.cfm"><br>


<table width="95%" border="0" cellspacing="0" cellpadding="0" align=center><!--- call the CF_Calendar custom tag --->
<tr><td><CF_CALENDAR HEADER="Athletic Calendar" 
			 headerfontcolor="006633"
			 othermonthbgcolor="6699cc"
			 todaybgcolor="bbbbbb"
			 linkhovercolor="6699cc"
			 linkfontcolor="006633"
			 CurrDateFontColor="006633">

<cfoutput query="getcal">
    <CF_EVENT DATE="#month#/#day#/#year#" 
        TEXT="#Replace(text1, Chr(34), Chr(39), 'all')#" 
        MOUSEOVER="#Replace(text2, Chr(34), Chr(39), 'all')#" 
        POPUPWIDTH="350" 
        POPUPHEIGHT="150"
        POPUPFROMLEFT="200" 
        POPUPFROMTOP="200"
        PRINTCALENDARHEADERINPOPUP="yes">
            <FONT FACE=Verdana>
            #text3#
            </FONT>
    </CF_EVENT>
</cfoutput>
      
</CF_CALENDAR></td></tr></table>

<!--- end page content --->


</body>
</html>
