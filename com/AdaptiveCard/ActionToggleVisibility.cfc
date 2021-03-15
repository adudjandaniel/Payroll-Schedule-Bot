<cfcomponent displayname="ActionToggleVisibility" extends="Action" accessors="true" hint="Action.ToggleVisibility template for caller Id cards">

	<cfproperty name="targets" type="array" required="true" hint="An array of sections to toggle">

	<cffunction name="init" access="public" returntype="ActionToggleVisibility" hint="Initializer for Action.ToggleVisibility">
		<cfargument name="title" type="string" required="true">

		<cfset super.init(title = arguments.title)>

		<cfset SetTargets(arrayNew(1))>

		<cfreturn this>
	</cffunction>

	<cffunction name="AddTarget" access="public" returntype="ActionToggleVisibility" hint="Adds a section to list of sections to toggle">
		<cfargument name="section" type="Section" required="true" hint="A section whose display should be toggled">
		<cfargument name="isVisible" type="boolean" required="false" hint="The visibility state to set the section whenever the action is executed">

		<cfset var target = {"section" = arguments.section}>
		<cfif structKeyExists(arguments, "isVisible")>
			<cfset target["isVisible"] = arguments.isVisible>
		</cfif>

		<cfset arrayAppend(targets, target)>
		<cfset arguments.section.SetToggledBy(this)>

		<cfreturn this>
	</cffunction>

	<cffunction name="AddTargets" access="public" returntype="ActionToggleVisibility" hint="Adds sections to list of sections to toggle">
		<cfargument name="sections" type="array" required="true" hint="An array of sections whose display should be toggled">

		<cfloop array="#arguments.sections#" item="item">
			<cfset var target = {"section" = item}>
			<cfset arrayAppend(targets, target)>
			<cfset item.SetToggledBy(this)>
		</cfloop>

		<cfreturn this>
	</cffunction>

	<cffunction name="ConvertToStruct" access="public" returntype="void" hint="Converts this object to Adaptive Card Structure">
		<cfargument name="generator" type="StructGenerator" required="true" hint="A StructGenerator object that does the conversion to adaptive card structure">
		<cfargument name="addTo" type="string" required="false" default="actions" hint="The parent's field to which this action is to be added (selectAction, actions - for ActionSet)">

		<cfset arguments.generator.ParseActionToggleVisibility(this, arguments.addTo)>

		<cfreturn />
	</cffunction>

</cfcomponent>