<cfcomponent displayname="Section" accessors="true" hint="Section Template for caller Id cards">

	<cfproperty name="properties" type="struct" required="true" hint="Adaptive card properties for this section">
	<cfproperty name="parentSection" type="Section" required="false" hint="The parent section of this section">
	<cfproperty name="toggledBy" type="ActionToggleVisibility" required="true" hint="The toggle action that toggles visibility of this section">
	<cfproperty name="selectAction" type="Action" required="false" hint="Select Action for this section">

	<cffunction name="init" access="public" returntype="Section" hint="Initializer for section - sets a default unique id">
		<cfargument name="properties" type="struct" required="false">

		<cfset SetProperties((structKeyExists(arguments, "properties"))? arguments.properties : structNew())>

		<cfreturn this>
	</cffunction>

	<cffunction name="AddProperty" access="public" returntype="Section" hint="Adds adaptive card properties to the section">
		<cfargument name="property" type="struct" required="true" hint="A struct of adaptive card properties">

		<cfloop collection="#arguments.property#" item="key">
			<cfset properties[key] = arguments.property[key]>
		</cfloop>

		<cfreturn this>
	</cffunction>

	<cffunction name="AddSelectAction" access="public" returntype="Section" hint="Adds a selectAction to the section">
		<cfargument name="action" required="true" type="Action" hint="An action to add as a selectAction (action.ShowCard not allowed per adaptive card standards">

		<cfset selectAction = arguments.action>

		<cfreturn this>
	</cffunction>

	<cffunction name="ConvertToStruct" access="public" returntype="void" hint="Converts this object to Adaptive Card Structure">
		<cfargument name="generator" type="StructGenerator" required="true" hint="A StructGenerator object that does the conversion to adaptive card structure">


		<cfreturn />
	</cffunction>

	<cffunction name="GetId" access="public" returntype="string" hint="Returns the id of this section">
		<cfreturn properties.id>
	</cffunction>

	<cffunction name="SetId" access="public" returntype="Section" hint="Sets the id of this section">
		<cfargument name="id" type="string" required="true" hint="Id">

		<cfset properties["id"] = arguments.id>

		<cfreturn this>
	</cffunction>

</cfcomponent>