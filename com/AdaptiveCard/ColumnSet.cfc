<cfcomponent displayname="ColumnSet" extends="Section" accessors="true" hint="ColumnSet Template for caller Id cards">

	<cfproperty name="columns" type="array" required="true" hint="Columns of this ColumnSet">

	<cffunction name="init" access="public" returntype="ColumnSet" hint="Initializer for ColumnSet">
		<cfargument name="properties" type="struct" required="false">

		<cfif structKeyExists(arguments, "properties")>
			<cfset super.init(properties = arguments.properties)>
		<cfelse>
			<cfset super.init()>
		</cfif>

		<cfset SetColumns(arrayNew(1))>

		<cfreturn this>
	</cffunction>

	<cffunction name="AddColumn" access="public" returntype="ColumnSet" hint="Adds a column to this ColumnSet">
		<cfargument name="column" type="Column" required="true" hint="The column to add">

		<cfset arrayAppend(columns, arguments.column)>
		<cfset arguments.column.SetParentSection(this)>

		<cfreturn this>
	</cffunction>

	<cffunction name="AddColumns" access="public" returntype="ColumnSet" hint="Add columns to this ColumnSet">
		<cfargument name="columnSetColumns" type="array" required="true" hint="An array of columns to add">

		<cfloop array="#arguments.columnSetColumns#" item="column">
			<cfset arrayAppend(columns, column)>
			<cfset column.SetParentSection(this)>
		</cfloop>

		<cfreturn this>
	</cffunction>

	<cffunction name="ConvertToStruct" access="public" returntype="void" hint="Converts this object to Adaptive Card Structure">
		<cfargument name="generator" type="StructGenerator" required="true" hint="A StructGenerator object that does the conversion to adaptive card structure">
		<cfargument name="addTo" type="string" required="false" default="body" hint="The parent's field to which this container is to be added">

		<cfset arguments.generator.ParseColumnSet(this, arguments.addTo)>

		<cfreturn />
	</cffunction>

</cfcomponent>