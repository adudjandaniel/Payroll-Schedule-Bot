<cfcomponent displayname="Column" extends="Section" accessors="true" hint="Column template for caller Id cards">

	<cfproperty name="items" type="array" required="true" hint="Items of this Column">

	<cffunction name="init" access="public" returntype="Column" hint="Initializer for Column">
		<cfargument name="properties" type="struct" required="false">

		<cfif structKeyExists(arguments, "properties")>
			<cfset super.init(properties = arguments.properties)>
		<cfelse>
			<cfset super.init()>
		</cfif>

		<cfset SetItems(arrayNew(1))>

		<cfreturn this>
	</cffunction>

	<cffunction name="AddItem" access="public" returntype="Column" hint="Adds an item to this Column">
		<cfargument name="item" type="Section" required="true" hint="The item to add">

		<cfset arrayAppend(items, arguments.item)>
		<cfset arguments.item.SetParentSection(this)>

		<cfreturn this>
	</cffunction>

	<cffunction name="AddItems" access="public" returntype="Column" hint="Add items to this column">
		<cfargument name="columnItems" type="array" required="true" hint="An array of sections to add">

		<cfloop array="#arguments.columnItems#" item="item">
			<cfset arrayAppend(items, item)>
			<cfset item.SetParentSection(this)>
		</cfloop>

		<cfreturn this>
	</cffunction>

	<cffunction name="ConvertToStruct" access="public" returntype="void" hint="Converts this object to Adaptive Card Structure">
		<cfargument name="generator" type="StructGenerator" required="true" hint="A StructGenerator object that does the conversion to adaptive card structure">

		<cfset arguments.generator.ParseColumn(this)>

		<cfreturn />
	</cffunction>

</cfcomponent>