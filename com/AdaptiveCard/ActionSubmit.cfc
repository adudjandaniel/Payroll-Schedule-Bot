<cfcomponent displayname="ActionSubmit" extends="Action" accessors="true" hint="Action.Submit template for caller Id cards">

	<cfproperty name="data" type="struct" required="true" hint="Key-value data to submit">

	<cffunction name="init" access="public" returntype="ActionSubmit" hint="Initializer for Action.Submit">
		<cfargument name="title" type="string" required="true">

		<cfset super.init(title = arguments.title)>

		<cfset SetData(structNew())>

		<cfreturn this>
	</cffunction>

	<cffunction name="AddData" access="public" returntype="ActionSubmit" hint="Adds key-value entry to data to be submitted">
		<cfargument name="key" type="string" required="true" hint="Key">
		<cfargument name="value" type="string" required="true" hint="Value">

		<cfset data["#arguments.key#"] = arguments.value>

		<cfreturn this>
	</cffunction>

	<cffunction name="AddMultiData" access="public" returntype="ActionSubmit" hint="Adds key-value entry to data to be submitted">
		<cfargument name="multiData" type="struct" required="true" hint="A struct of key value pairs">

		<cfloop collection="#arguments.multiData#" item="key">
			<cfset data["#key#"] = arguments.multiData["#key#"]>
		</cfloop>

		<cfreturn this>
	</cffunction>

	<cffunction name="ConvertToStruct" access="public" returntype="void" hint="Converts this object to Adaptive Card Structure">
		<cfargument name="generator" type="StructGenerator" required="true" hint="A StructGenerator object that does the conversion to adaptive card structure">
		<cfargument name="addTo" type="string" required="false" default="actions" hint="The parent's field to which this action is to be added (selectAction, actions - for ActionSet)">

		<cfset arguments.generator.ParseActionSubmit(this, arguments.addTo)>

		<cfreturn />
	</cffunction>

</cfcomponent>