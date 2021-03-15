<cfset requestBody = getHTTPRequestData()>


<!--- Check if request from Teams/ Bot framework --->
<cfif compareNoCase(cgi.REQUEST_METHOD, "post") eq 0>
    <!--- handle teams request --->
    <cfset createObject("component", "com.TeamsRequestHandler")
        .init(requestBody)>

    <cfabort>
</cfif>


<!--- Check for runSchedule url parameter --->
<cfif !structKeyExists(url, "runSchedule")>
    <cfabort>
</cfif>


<!--- Run Schedule --->
<cfset payroll = createObject("component", "com.Payroll").init()>
<cfset timeDueDate = payroll.getUpcomingTimeDueDate()>

<cfset bot = createObject("component", "com.PayrollBot").init()>
<cfset message = "**#dateDiff("d", now(), timeDueDate)# days remaining**">




<!--- Send out message --->
<cfloop collection="#APPLICATION.users#" item="user">
    <cfdump var="#APPLICATION.users[user]#" label="#user#">
    <cfset bot.SetUser(
        userId = APPLICATION.users[user].user_id, 
        conversationId = APPLICATION.users[user].conversation_id
    )>

    <!--- Send Raw Text --->
    <cfset bot.sendMessage(message = message)>
</cfloop>




<!--- 
    Using Adaptive Card 
--->

<!--- Create Adaptive Card --->
<!--- <cfset card = createObject("component", "com.AdaptiveCard.Card").init()>
<cfset mainContainer = createObject("component", "com.AdaptiveCard.Container").init()>
<cfset daysRemainingTextBlock = createObject("component", "com.AdaptiveCard.TextBlock")
    .init({"text" = "**#dateDiff("d", now(), timeDueDate)#** days remaining", wrap = "true"})>
<cfset mainContainer.AddItem(daysRemainingTextBlock)>
<cfset card.AddSection(mainContainer)>

<!--- <cfdump var="#card.ConvertToAdaptiveCard()#"> --->
<cfset bot.sendMessage(card = card.ConvertToAdaptiveCard())> --->