<cfcomponent displayname="Container" extends="Section" accessors="true" hint="Container Template for caller Id cards">

	<cfproperty name="items" type="array" required="true" hint="Items of this container">

	<cffunction name="init" access="public" returntype="Container" hint="Initializer for container">
		<cfargument name="properties" type="struct" required="false">

		<cfif structKeyExists(arguments, "properties")>
			<cfset super.init(properties = arguments.properties)>
		<cfelse>
			<cfset super.init()>
		</cfif>

		<cfset SetItems(arrayNew(1))>

		<cfreturn this>
	</cffunction>

	<cffunction name="AddItem" access="public" returntype="Container" hint="Adds an item to this container">
		<cfargument name="item" type="Section" required="true" hint="The item to add">

		<cfset arrayAppend(items, arguments.item)>
		<cfset arguments.item.SetParentSection(this)>

		<cfreturn this>
	</cffunction>

	<cffunction name="AddItems" access="public" returntype="Container" hint="Add items to this container">
		<cfargument name="containerItems" type="array" required="true" hint="An array of sections to add">

		<cfloop array="#arguments.containerItems#" item="item">
			<cfset arrayAppend(items, item)>
			<cfset item.SetParentSection(this)>
		</cfloop>

		<cfreturn this>
	</cffunction>

	<cffunction name="ConvertToStruct" access="public" returntype="void" hint="Converts this object to Adaptive Card Structure">
		<cfargument name="generator" type="StructGenerator" required="true" hint="A StructGenerator object that does the conversion to adaptive card structure">
		<cfargument name="addTo" type="string" required="false" default="body" hint="The parent field to which this container is to be added">

		<cfset arguments.generator.ParseContainer(this, arguments.addTo)>

		<cfreturn />
	</cffunction>

</cfcomponent>