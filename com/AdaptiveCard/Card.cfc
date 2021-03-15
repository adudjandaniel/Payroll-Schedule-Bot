<cfcomponent displayname="Card" accessors="true" hint="Card Template for caller Id cards">

	<cfproperty name="sections" type="array" required="true" hint="Main Sections of the card">

	<cffunction name="init" access="public" returntype="Card" hint="Initializer for card">

		<cfset setSections(arrayNew(1))>

		<cfreturn this>
	</cffunction>

	<cffunction name="AddSection" access="public" returntype="Card" hint="Adds a section to the card">
		<cfargument name="section" type="Section" required="true" default="The section to add">

		<cfset arrayAppend(sections, arguments.section)>

		<cfreturn this>
	</cffunction>

	<cffunction name="ConvertToAdaptiveCard" access="public" returntype="struct" hint="Returns Adaptive card version of this card instance">

		<cfset var generator = createObject("component", "StructGenerator").init()>

		<cfloop array="#sections#" item="section">
			<cfset section.ConvertToStruct(generator)>
		</cfloop>

		<cfreturn generator.GetCardStruct()>
	</cffunction>

</cfcomponent>