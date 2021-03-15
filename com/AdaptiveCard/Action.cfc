<cfcomponent displayname="Action" accessors="true" hint="Action Template for caller Id cards">

	<cfproperty name="title" type="string" required="true" hint="Title of the action">
	<cfproperty name="properties" type="struct" required="true" hint="Adaptive card properties for this section">

	<cffunction name="init" access="public" returntype="Action" hint="Initializer for Action">
		<cfargument name="title" type="string" required="true">

		<cfset SetTitle(arguments.title)>
		<cfset SetProperties(structNew())>

		<cfreturn this>
	</cffunction>

	<cffunction name="AddProperty" access="public" returntype="Action" hint="Adds properties to the action">
		<cfargument name="property" type="struct" required="true" hint="A struct of adaptive card action properties">

		<cfloop collection="#arguments.property#" item="key">
			<cfset properties[key] = arguments.property[key]>
		</cfloop>

		<cfreturn this>
	</cffunction>

	<cffunction name="ConvertToStruct" access="public" returntype="void" hint="Converts this object to Adaptive Card Structure">
		<cfargument name="generator" type="StructGenerator" required="true" hint="A StructGenerator object that does the conversion to adaptive card structure">
		<cfargument name="addTo" type="string" required="false" default="actions" hint="The parent's field to which this action is to be added (selectAction, actions - for ActionSet)">


		<cfreturn />
	</cffunction>

</cfcomponent>