<cfcomponent displayname="InputText" extends="Section" accessors="true" hint="Input Text field template for caller Id cards">

	<cffunction name="init" access="public" returntype="InputText" hint="Initializer for Input Text">
		<cfargument name="id" type="string" required="true" hint="The id of the input field">

		<cfset super.init()>
		<cfset SetId(arguments.id)>

		<cfreturn this>
	</cffunction>



	<cffunction name="ConvertToStruct" access="public" returntype="void" hint="Converts this object to Adaptive Card Structure">
		<cfargument name="generator" type="StructGenerator" required="true" hint="A StructGenerator object that does the conversion to adaptive card structure">
		<cfargument name="addTo" type="string" required="false" default="body" hint="The parent's field to which this container is to be added">

		<cfset arguments.generator.ParseInputText(this, arguments.addTo)>

		<cfreturn />
	</cffunction>

</cfcomponent>