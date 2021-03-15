<cfcomponent displayname="Image" extends="Section" accessors="true" hint="Image template for caller Id cards">

	<cffunction name="init" access="public" returntype="Image" hint="Initializer for Image">
		<cfargument name="properties" type="struct" required="false">

		<cfif structKeyExists(arguments, "properties")>
			<cfset super.init(properties = arguments.properties)>
		<cfelse>
			<cfset super.init()>
		</cfif>

		<cfreturn this>
	</cffunction>

	<cffunction name="ConvertToStruct" access="public" returntype="void" hint="Converts this object to Adaptive Card Structure">
		<cfargument name="generator" type="StructGenerator" required="true" hint="A StructGenerator object that does the conversion to adaptive card structure">
		<cfargument name="addTo" type="string" required="false" default="body" hint="The parent's field to which this container is to be added">

		<cfset arguments.generator.ParseImage(this, arguments.addTo)>

		<cfreturn />
	</cffunction>

</cfcomponent>