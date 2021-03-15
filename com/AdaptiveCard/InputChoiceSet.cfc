<cfcomponent displayname="InputChoiceSet" extends="Section" accessors="true" hint="Input ChoiceSet template for caller Id cards">

	<cfproperty name="choices" type="array" required="true" hint="The choices in this ChoiceSet">

	<cffunction name="init" access="public" returntype="InputChoiceSet" hint="Initializer for Input ChoiceSet">
		<cfargument name="id" type="string" required="true" hint="The id of the input field">

		<cfset super.init()>
		<cfset SetId(arguments.id)>
		<cfset SetChoices(arrayNew(1))>

		<cfreturn this>
	</cffunction>


	<cffunction name="SetDefaultChoice" access="public" returntype="InputChoiceSet" hint="Sets the default choice of the choice set">
		<cfargument name="value" type="InputChoice" required="true"	hint="The InputChoice object">

		<cfset properties["value"] = arguments.value.GetValue()>

		<cfreturn this>
	</cffunction>


	<cffunction name="AddChoice" access="public" returntype="InputChoiceSet" hint="Adds a choice to this ChoiceSet">
		<cfargument name="choice" type="InputChoice" required="true" hint="The choice to add">

		<cfset arrayAppend(choices, arguments.choice)>

		<cfreturn this>
	</cffunction>

	<cffunction name="AddChoices" access="public" returntype="InputChoiceSet" hint="Add choices to this ChoiceSet">
		<cfargument name="choiceSetChoices" type="array" required="true" hint="An array of choices to add">

		<cfloop array="#arguments.choiceSetChoices#" item="choice">
			<cfset arrayAppend(choices, choice)>
		</cfloop>

		<cfreturn this>
	</cffunction>


	<cffunction name="ConvertToStruct" access="public" returntype="void" hint="Converts this object to Adaptive Card Structure">
		<cfargument name="generator" type="StructGenerator" required="true" hint="A StructGenerator object that does the conversion to adaptive card structure">
		<cfargument name="addTo" type="string" required="false" default="body" hint="The parent's field to which this container is to be added">

		<cfset arguments.generator.ParseInputChoiceSet(this, arguments.addTo)>

		<cfreturn />
	</cffunction>


</cfcomponent>