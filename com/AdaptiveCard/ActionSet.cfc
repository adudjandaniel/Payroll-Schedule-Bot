<cfcomponent displayname="ActionSet" extends="Section" accessors="true" hint="ActionSet Template for caller Id cards">

	<cfproperty name="actions" type="array" required="true" hint="Actions of this ActionSet">

	<cffunction name="init" access="public" returntype="ActionSet" hint="Initializer for ActionSet">
		<cfargument name="properties" type="struct" required="false">

		<cfif structKeyExists(arguments, "properties")>
			<cfset super.init(properties = arguments.properties)>
		<cfelse>
			<cfset super.init()>
		</cfif>

		<cfset SetActions(arrayNew(1))>

		<cfreturn this>
	</cffunction>

	<cffunction name="AddAction" access="public" returntype="ActionSet" hint="Adds an action to this ActionSet">
		<cfargument name="action" type="Action" required="true" hint="The action to add">

		<cfset arrayAppend(actions, arguments.action)>

		<cfreturn this>
	</cffunction>

	<cffunction name="AddActions" access="public" returntype="ActionSet" hint="Adds a actions to this ActionSet">
		<cfargument name="actionSetActions" type="array" required="true" hint="An array of action objects to add">

		<cfloop array="#arguments.actionSetActions#" item="action">
			<cfset arrayAppend(actions, action)>
		</cfloop>

		<cfreturn this>
	</cffunction>

	<cffunction name="ConvertToStruct" access="public" returntype="void" hint="Converts this object to Adaptive Card Structure">
		<cfargument name="generator" type="StructGenerator" required="true" hint="A StructGenerator object that does the conversion to adaptive card structure">
		<cfargument name="addTo" type="string" required="false" default="body" hint="The parent's field to which this container is to be added">

		<cfset arguments.generator.ParseActionSet(this, arguments.addTo)>

		<cfreturn />
	</cffunction>

</cfcomponent>