<cfcomponent displayname="InputChoice" accessors="true" hint="Input choice template for caller Id cards">

	<cfproperty name="title" type="string" required="true" hint="The title of the input choice (displayed on card)">
	<cfproperty name="value" type="string" required="true" hint="The value of the input choice (sent on submit)">

	<cffunction name="init" access="public" returntype="InputChoice" hint="Initializer for Input choice">
		<cfargument name="title" type="string" required="true" hint="The title of the input choice (displayed on card)">
		<cfargument name="value" type="string" required="true" hint="The value of the input choice (sent on submit)">

		<cfset SetTitle(arguments.title)>
		<cfset SetValue(arguments.value)>

		<cfreturn this>
	</cffunction>



	<cffunction name="ConvertToStruct" access="public" returntype="void" hint="Converts this object to Adaptive Card Structure">
		<cfargument name="generator" type="StructGenerator" required="true" hint="A StructGenerator object that does the conversion to adaptive card structure">

		<cfset arguments.generator.ParseInputChoice(this)>

		<cfreturn />
	</cffunction>

</cfcomponent>