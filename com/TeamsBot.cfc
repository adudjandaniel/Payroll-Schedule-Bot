<!--- Documentation: https://docs.microsoft.com/en-us/azure/bot-service/rest-api/bot-framework-rest-connector-api-reference?view=azure-bot-service-4.0
--->
<cfcomponent displayname="TeamsBot" accessors="true" hint="Class for creating bot object">

	<cfproperty  name="serviceUrl" required="true" type="string">
	<cfproperty  name="tokenEndpoint" required="true" type="string">
	<cfproperty  name="tenantId" required="true" type="string">
	<cfproperty  name="clientId" required="true" type="string">
	<cfproperty  name="clientSecret" required="true" type="string">
	<cfproperty  name="accessToken" required="false" type="string">
	<cfproperty  name="scope" required="true" type="string">
	<cfproperty  name="grantType" required="true" type="string">
	<cfproperty  name="conversationType" required="true" type="string">
	<cfproperty  name="conversationId" required="true" type="string">
	<cfproperty  name="botName" required="true" type="string">
	<cfproperty  name="userId" required="true" type="string">
	<cfproperty  name="botId" required="true" type="string">




	<cffunction name="init" access="public" returntype="TeamsBot" hint="Initializes the bot. NB: default grant type: client_credentials">
		<cfargument  name="tenantId" type="string" required="false" default="" hint="ID of Azure AD tenant.">
		<cfargument  name="clientId" type="string" required="false" default="" hint="ID of application created in the Azure AD tenant.">
		<cfargument  name="clientSecret" type="string" required="false" default="" hint="Secret of application created in the Azure AD tenant.">
		<cfargument  name="botId" type="string" required="false" default="" hint="Id of bot linked to the application.">
		<cfargument  name="botName" type="string" required="false" default="" hint="Name of bot linked to the application.">
		<cfargument  name="scope" type="string" required="false" default="https://api.botframework.com/.default">
		<cfargument name="conversationType" type="string" required="false" default="personal" hint="Types of conversation: 'teams', 'personal', 'groupChat'">
		<cfargument name="serviceUrl" type="string" required="false" default="https://smba.trafficmanager.net/amer/" hint="Service url - added to every response from teams. Initialy got through bot installation. For more details - https://stackoverflow.com/questions/60764564/service-url-for-notification-only-teams-bot">

		<cfset SetTenantId(arguments.tenantID)>
		<cfset SetClientId(arguments.clientID)>
		<cfset SetClientSecret(arguments.clientSecret)>
		<cfset SetBotId(arguments.botId)>
		<cfset SetBotName(arguments.botName)>
		<cfset SetConversationType(arguments.conversationType)>
		<cfset SetServiceUrl(arguments.serviceUrl)>
		<cfset SetScope(arguments.scope)>

		<cfset SetTokenEndpoint("https://login.microsoftonline.com/botframework.com/oauth2/v2.0/token")>
		<cfset SetGrantType("client_credentials")>

		<cfreturn this>
	</cffunction>




	<cffunction name="GetHttpErrorResponse" returntype="struct" access="package" hint="Returns error from http request">
        <cfargument name="httpResponse" type="struct" required="true">
		<cfargument name="request" type="string" required="false" default="Unknown">

        <cfset response = {success = false, statusCode = arguments.httpResponse.responseheader.status_code}>
		<cftry>
        	<cfset response.content = deserializeJSON(httpResponse.fileContent)>
		<cfcatch>
			<cfset response.content = httpResponse.fileContent>
		</cfcatch>
		</cftry>

        <cfreturn response>
    </cffunction>



	<cffunction name="SetUser" access="public" returntype="void" hint="Sets the user id and conversation Id of the bot instance">
		<cfargument name="userId" required="true" type="string">
		<cfargument name="conversationId" required="false" type="string" default="">

		<cfset SetUserId(arguments.userId)>
		<cfset SetConversationId(arguments.conversationId)>

		<cfreturn />
	</cffunction>



	<!--- https://docs.microsoft.com/en-us/azure/bot-service/rest-api/bot-framework-rest-connector-authentication?view=azure-bot-service-4.0#bot-to-connector --->
	<cffunction name="RequestToken" access="public" returntype="struct" hint="Request token from token endpoint. Updates access token property if successful.">

		<cfset var result = structNew()>

		<cfset result["success"] = false>

		<cfhttp url="#tokenEndpoint#" method="POST" throwonerror="false" result="httpResponse">
			<cfhttpparam type="formfield" name="client_id" value="#clientId#">
			<cfhttpparam type="formfield" name="grant_type" value="#grantType#">
			<cfhttpparam type="formfield" name="client_secret" value="#clientSecret#">
			<cfhttpparam type="formfield" name="scope" value="#scope#">
		</cfhttp>

		<cfif Left(httpResponse.responseheader.status_code, 2) neq 20>
            <cfreturn GetHttpErrorResponse(httpResponse, "Request Token")>
        </cfif>

		<cfset var httpResponse = deserializeJson(httpResponse.fileContent)>

		<!--- Update access token property --->
		<cfset SetAccessToken(httpResponse.access_token)>
		
		<cfset result["content"] = httpResponse>
		<cfset result["success"] = true>

		<cfreturn result>
	</cffunction>




	<cffunction name="SetupConversation" access="public" returntype="struct" hint="Sets up a conversation and updates the bot's conversation id">

		<cfset var result = structNew()>
		<cfset result["success"] = false>

		<cfset var body = {
			"bot" = {
				"id" = botId,
				"name" = botName
			},
			"members" = [
				{
					"id" = userId
				}
			],
			"channelData" = {
				"tenant" = {
					"id" = tenantId
				}
			}
		}>

		<cfhttp url="#serviceUrl#v3/conversations" method="POST" throwonerror="false" result="httpResponse">
			<cfhttpparam type="header" name="Authorization" value="Bearer #accessToken#">
			<cfhttpparam type="header" name="Content-Type" value="application/json">
			<cfhttpparam type="body" value="#serializeJSON(body)#">
		</cfhttp>

		<cfif Left(httpResponse.responseheader.status_code, 2) neq 20>
			<cfreturn GetHttpErrorResponse(httpResponse, "Setup Conversation")>
		</cfif>

		<cfset var responseContent = deserializeJson(httpResponse.fileContent)>

		<cfset SetConversationId(responseContent.id)>
		<cfset result["content"] = responseContent>

		<cfset result["success"] = true>

		<cfreturn result>

	</cffunction>




	<cffunction name="SendMessage" access="public" returntype="struct" hint="sends a message to a user through a conversation created.">
		<cfargument name="message" type="string" required="false" default="" hint="message in markdown format">
		<cfargument name="conversationId" type="string" required="false" default="">
		<cfargument name="card" type="struct" required="false" default="#structNew()#">

		
		<cfif arguments.conversationId neq "">
			<cfset SetConversationId(arguments.conversationId)>
		</cfif>


		<cfset var result = structNew()>
		<cfset result["success"] = false>

		<cfset var body = {
			"type" = "message",
			"from" = {
				"id" = botId,
				"name" = botName
			},
			"conversation" = {
				"id" = GetConversationId()
			},
			"recipient" = {
				"id" = userId
			}
		}>

		<cfif arguments.message neq "">
			<cfset body["text"] = arguments.message>
		<cfelseif !structIsEmpty(arguments.card)>
			<cfset body["attachments"] = [arguments.card]>
		</cfif>

		<cfhttp url="#serviceUrl#v3/conversations/#GetConversationId()#/activities" method="POST" throwonerror="false" result="httpResponse">
			<cfhttpparam type="header" name="Authorization" value="Bearer #accessToken#">
			<cfhttpparam type="header" name="Content-Type" value="application/json">
			<cfhttpparam type="body" value="#serializeJSON(body)#">
		</cfhttp>

		<cfif Left(httpResponse.responseheader.status_code, 2) neq 20>
			<cfreturn GetHttpErrorResponse(httpResponse, "Send Message")>
		</cfif>

		<cfset var responseContent = deserializeJson(httpResponse.fileContent)>
		<cfset result["content"] = responseContent>

		<cfset result["success"] = true>

		<cfreturn result>

	</cffunction>



	<cffunction name="ProfileInfo" access="public" returntype="struct" hint="returns some profile info for members of a conversation">
		<cfargument name="conversationId" type="string" required="false" default="">

		<cfset var result = structNew()>

		<!--- Allow getting profile info of different conversation --->
		<cfset local.conversationId = GetConversationId()>
		<cfif arguments.conversationId neq "">
			<cfset local.conversationId = arguments.conversationId>
		</cfif>

		<cfset result["success"] = false>

		<cfhttp url="#serviceUrl#v3/conversations/#local.conversationId#/members" method="GET" throwonerror="false" result="httpResponse">
			<cfhttpparam type="header" name="Authorization" value="Bearer #accessToken#">
			<cfhttpparam type="header" name="Content-Type" value="application/json">
		</cfhttp>

		<cfif Left(httpResponse.responseheader.status_code, 2) neq 20>
			<cfreturn GetHttpErrorResponse(httpResponse, "Profile Info")>
		</cfif>

		<cfset var responseContent = deserializeJson(httpResponse.fileContent)>

		<cfset result["content"] = responseContent>

		<cfset result["success"] = true>

		<cfreturn result>
	</cffunction>



	<cffunction name="GetTeamMembers" access="public" returntype="struct" hint="returns some profile info for members of a conversation">
		<cfargument name="channelId" type="string" required="true">

		<cfset var result = structNew()>

		<cfset result["success"] = false>

		<cfhttp url="#serviceUrl#v3/conversations/#arguments.channelId#/members" method="GET" throwonerror="false" result="httpResponse">
			<cfhttpparam type="header" name="Authorization" value="Bearer #accessToken#">
			<cfhttpparam type="header" name="Content-Type" value="application/json">
		</cfhttp>

		<cfif Left(httpResponse.responseheader.status_code, 2) neq 20>
			<cfreturn GetHttpErrorResponse(httpResponse, "Get Team Members")>
		</cfif>

		<cfset var responseContent = deserializeJson(httpResponse.fileContent)>

		<cfset result["content"] = responseContent>

		<cfset result["success"] = true>

		<cfreturn result>
	</cffunction>



	<cffunction name="UpdateMessage" access="public" returntype="struct" hint="updates a message">
		<cfargument name="activityId" type="string" required="true">
		<cfargument name="conversationId" type="string" required="false" default="">
		<cfargument name="message" type="string" required="false" default="" hint="message in markdown format">
		<cfargument name="card" type="struct" required="false" default="#structNew()#">


		<cfif arguments.conversationId neq "">
			<cfset SetConversationId(arguments.conversationId)>
		</cfif>


		<cfset var result = structNew()>

		<cfset result["success"] = false>

		<cfset var body = {
			"type" = "message",
			"from" = {
				"id" = botId,
				"name" = botName
			},
			"conversation" = {
				"id" = GetConversationId()
			},
			"recipient" = {
				"id" = userId
			}
		}>

		<cfif arguments.message neq "">
			<cfset body["text"] = arguments.message>
		<cfelseif !structIsEmpty(arguments.card)>
			<cfset body["attachments"] = [arguments.card]>
		</cfif>

		<cfhttp url="#serviceUrl#v3/conversations/#GetConversationId()#/activities/#arguments.activityId#" method="PUT" throwonerror="false" result="httpResponse">
			<cfhttpparam type="header" name="Authorization" value="Bearer #accessToken#">
			<cfhttpparam type="header" name="Content-Type" value="application/json">
			<cfhttpparam type="body" value="#serializeJSON(body)#">
		</cfhttp>

		<cfif Left(httpResponse.responseheader.status_code, 2) neq 20>
			<cfreturn GetHttpErrorResponse(httpResponse, "Update Message")>
		</cfif>

		<cfset var responseContent = httpResponse.fileContent>

		<cfset result["content"] = responseContent>

		<cfset result["success"] = true>

		<cfreturn result>

	</cffunction>



	<cffunction name="DeleteMessage" access="public" returntype="struct" hint="deletes a message">
		<cfargument name="conversationId" type="string" required="true">
		<cfargument name="activityId" type="string" required="true">


		<cfif structKeyExists(arguments, "conversationId")>
			<cfset SetConversationId(arguments.conversationId)>
		</cfif>


		<cfset var result = {"success" = false}>


		<cfhttp url="#serviceUrl#v3/conversations/#conversationId#/activities/#arguments.activityId#" method="DELETE" throwonerror="false" result="httpResponse">
			<cfhttpparam type="header" name="Authorization" value="Bearer #accessToken#">
			<cfhttpparam type="header" name="Content-Type" value="application/json">
		</cfhttp>

		<cfif Left(httpResponse.responseheader.status_code, 2) neq 20>
			<cfreturn GetHttpErrorResponse(httpResponse, "Delete Message")>
		</cfif>

		<cfset var responseContent = httpResponse.fileContent>

		<cfset result["content"] = responseContent>

		<cfset result["success"] = true>

		<cfreturn result>

	</cffunction>



</cfcomponent>