<cfcomponent displayname="TeamsRequestHandler" accessors="true" 
    hint="Responds to http requests to the app. Serves as entry point to the app">

	<cfproperty name="requestBody" required="false" type="struct" hint="The request body">


    <cffunction name="init" access="public" returntype="TeamsRequestHandler" hint="Initialization">
		<cfargument name="requestBody" required="true" type="string" hint="The request body">

		<cfset SetRequestBody(deserializeJson(arguments.requestBody["content"]))>

		<!--- Ignore if the type of teams request is not 'ConversationUpdate' --->
		<cfif compareNoCase(requestBody.type, "ConversationUpdate") eq 0>
			<cfset AddUser(requestBody.from.id, requestBody.conversation.id)>
		</cfif>

        <cfreturn this>
    </cffunction>



    <cffunction name="AddUser" access="public" returntype="void" 
		hint="Adds the user who installed the bot in their Teams app">
		<cfargument name="userId" required="true" type="string">
		<cfargument name="conversationId" required="true" type="string">

		<!--- To do: Add user to application scope / file --->

		<cfreturn />
	</cffunction>

</cfcomponent>