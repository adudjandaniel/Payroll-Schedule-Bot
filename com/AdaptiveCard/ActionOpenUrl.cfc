<cfcomponent displayname="ActionOpenUrl" extends="Action" accessors="true" hint="Action.OpenUrl template for caller Id cards">

	<cfproperty name="url" type="string" required="true" hint="Url">

	<cffunction name="init" access="public" returntype="ActionOpenUrl" hint="Initializer for ActionOpenUrl">
		<cfargument name="title" type="string" required="true">
		<cfargument name="url" type="string" required="false" default="">

		<cfset super.init(title = arguments.title)>

		<cfset SetUrl(arguments.url)>

		<cfreturn this>
	</cffunction>

	<cffunction name="ConvertToStruct" access="public" returntype="void" hint="Converts this object to Adaptive Card Structure">
		<cfargument name="generator" type="StructGenerator" required="true" hint="A StructGenerator object that does the conversion to adaptive card structure">
		<cfargument name="addTo" type="string" required="false" default="actions" hint="The parent's field to which this action is to be added (selectAction, actions - for ActionSet)">

		<cfset arguments.generator.ParseActionOpenUrl(this, arguments.addTo)>

		<cfreturn />
	</cffunction>

</cfcomponent>