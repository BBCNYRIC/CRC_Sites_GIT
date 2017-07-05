<!--- Listing 21.28	Day.cfm --->
<!--- DATE: 04/28/01
AUTHOR: Emily B. Kim (emily@gtalliance.com)

ACKNOWLEDGEMENTS: Thanks to Sierra Bufe of the Radiance Group, Ben Forta 
and Robert Crooks of Macromedia, and Ken Fricklas of the 
Mallfinder Network for their various contributions to the 
creation of this Calendar custom tag.

PARENT CUSTOM TAG: CF_Calendar
CHILD CUSTOM TAG: CF_Event
OTHER FILES: day.cfm

RESTRICTIONS: designed for Microsoft Internet Explorer 4.x and higher.

DESCRIPTION: CF_CALENDAR is a ColdFusion custom tag to create an HTML/JavaScript 
calendar display. CF_EVENT is a child tag used to populate the calendar with events. 
Day.cfm is used to generate the popup window for each event.
--->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
    <title>Calendar Event Popup</title>
</HEAD>
<!--- always popup calendar event information in the same window --->
<BODY  onLoad="window.focus()">

<!--- print out the popup window message --->
<CFOUTPUT>
#URL.PopupMessage#
</CFOUTPUT>

</BODY>
</HTML>

