<cfcomponent displayname="PayrollBot" extends="Teamsbot" accessors="true" hint="Class for creating bot object">



	<cffunction name="init" access="public" returntype="PayrollBot" hint="Initializes the bot">
		<cfargument name="userId" type="string" required="false" default="">
		<cfargument name="conversationType" type="string" required="false" default="personal">
		<cfargument name="conversationId" type="string" required="false" default="">
		<cfargument name="serviceUrl" type="string" required="false" default="">
		<cfargument name="botId" type="string" required="false" default="">
		<cfargument  name="scope" type="string" required="false" default="https://api.botframework.com/.default">
		<cfargument  name="botName" type="string" required="false" default="">

		<cfset Super.init(tenantId = APPLICATION.tenantID, clientId = APPLICATION.clientID, clientSecret = APPLICATION.clientSecret, botId = arguments.botId eq "" ? APPLICATION.botId : arguments.botId, botName = arguments.botName eq "" ? APPLICATION.botName : "", scope = arguments.scope)>

		<cfset SetAccessToken(APPLICATION.botToken)>
		<cfset SetUserId(arguments.userId)>
		<cfset SetConversationId(arguments.conversationId)>

		<!--- request token if token has expired --->
		<cfif APPLICATION.tokenCreatedAt eq 0 || APPLICATION.tokenCreatedAt + 3500 lt round(getTickCount() / 1000)>
			<cfset var tokenRequestResult = RequestToken()>
			<cfset APPLICATION.tokenCreatedAt = round(getTickCount() / 1000)>
			<cfset APPLICATION.botToken = tokenRequestResult.content.access_token>
		</cfif>

		<cfreturn this>
	</cffunction>



	<cffunction name="GetHttpErrorResponse" returntype="struct" access="private" hint="Returns error from http request">
        <cfargument name="httpResponse" type="struct" required="true">
		<cfargument name="request" type="string" required="false" default="Unknown">

        <cfreturn super.GetHttpErrorResponse(arguments.httpResponse, arguments.request)>
    </cffunction>


	<cffunction  name="GetUserName" access="public" returntype="string" hint="Gets user name from api">
		<cfargument name="conversationId" type="string" required="false" default="">

		<cfset var userProfileResult = ProfileInfo(arguments.conversationId)>

		<cfif userProfileResult.success>
			<cfreturn userProfileResult.Content[1].name>
		</cfif>

		<cfreturn "">
	</cffunction>



</cfcomponent>