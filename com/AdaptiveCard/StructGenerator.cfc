<cfcomponent displayname="StructGenerator" accessors="true" hint="Handles conversion of card to a coldfusion struct">

	<cfproperty name="cardStruct" type="struct" required="true" hint="Struct to be converted to json">

	<cffunction name="init" access="public" returntype="StructGenerator" hint="Initializer for struct generator">
		<cfargument name="parentStruct" type="struct" required="false" hint="The parent Structure to which the section is to be added. Defaults to the body of the card">
		
		<cfif structKeyExists(arguments, "parentStruct")>
			<cfset SetCardStruct(arguments.parentStruct)>
		<cfelse>
			<cfset SetCardStruct({
				"contentType" = "application/vnd.microsoft.card.adaptive",
				"content" = {
					"$schema"= "http://adaptivecards.io/schemas/adaptive-card.json",
					"type" = "AdaptiveCard",
				    "version" = "1.2",
				    "body" = []
				}
			})>
		</cfif>

		<cfreturn this>
	</cffunction>

	<cffunction name="Restart" access="public" returntype="StructGenerator" hint="Restarts the generator">
		<cfset SetCardStruct({
			"contentType" = "application/vnd.microsoft.card.adaptive",
			"content" = {
				"$schema"= "http://adaptivecards.io/schemas/adaptive-card.json",
				"type" = "AdaptiveCard",
			    "version" = "1.2",
			    "body" = []
			}
		})>

		<cfreturn this>
	</cffunction>

	<cffunction name="GetStruct" access="public" returntype="struct" hint="Gets the struct generated">
		<cfreturn cardStruct>
	</cffunction>

	<cffunction name="ParseContainer" access="public" returntype="void" hint="Converts a section of type container to adaptive card container">
		<cfargument name="containerSection" type="Container" required="true" hint="The container object to parse as adaptive card json data">
		<cfargument name="addTo" type="string" required="true" hint="The parent field to which this container is to be added">

		<cfset var container = {
			"type" = "Container",
        	"items" = []
		}>

		<!--- Add items --->
		<cfset var items = arguments.containerSection.GetItems()>
		<cfset var subGenerator = createObject("component", "com.AdaptiveCard.StructGenerator").init(container)>
		<cfloop array="#items#" item="item">
			<cfset item.ConvertToStruct(subGenerator, "items")>
		</cfloop>

		<!--- Parse select action --->
		<cfif !isNull(arguments.containerSection.GetSelectAction())>
			<cfset ParseSelectAction(arguments.containerSection.GetSelectAction(), container)>
		</cfif>

		<!--- Add properties --->
		<cfset var containerProperties = arguments.containerSection.GetProperties()>
		<cfloop collection="#containerProperties#" item="key">
			<cfset container[key] = containerProperties[key]>
		</cfloop>

		<!--- Add container to adaptive card / parent --->
		<cfif compareNoCase(arguments.addTo, "body") eq 0>
			<cfset arrayAppend(cardStruct.content.body, subGenerator.GetCardStruct())>
		<cfelse>
			<cfset arrayAppend(cardStruct[arguments.addTo], subGenerator.GetCardStruct())>
		</cfif>

		<cfreturn />
	</cffunction>

	<cffunction name="ParseColumnSet" access="public" returntype="void" hint="Converts a section of type ColumnSet to adaptive card ColumnSet">
		<cfargument name="columnsetSection" type="ColumnSet" required="true" hint="The columnset object to parse as adaptive card json data">
		<cfargument name="addTo" type="string" required="true" hint="The parent field to which this container is to be added">

		<cfset var columnset = {
			"type" = "ColumnSet",
        	"columns" = []
		}>

		<!--- Add columns --->
		<cfset var columns = arguments.columnsetSection.GetColumns()>
		<cfset subGenerator = createObject("component", "com.AdaptiveCard.StructGenerator").init(columnset)>
		<cfloop array="#columns#" item="column">
			<cfset column.ConvertToStruct(subGenerator)>
		</cfloop>

		<!--- Parse select action --->
		<cfif !isNull(arguments.columnsetSection.GetSelectAction())>
			<cfset ParseSelectAction(arguments.columnsetSection.GetSelectAction(), columnset)>
		</cfif>

		<!--- Add properties --->
		<cfset var columnsetProperties = arguments.columnsetSection.GetProperties()>
		<cfloop collection="#columnsetProperties#" item="key">
			<cfset columnset[key] = columnsetProperties[key]>
		</cfloop>

		<!--- Add columnset to adaptive card / parent --->
		<cfif compareNoCase(arguments.addTo, "body") eq 0>
			<cfset arrayAppend(cardStruct.content.body, subGenerator.GetCardStruct())>
		<cfelse>
			<cfset arrayAppend(cardStruct[arguments.addTo], subGenerator.GetCardStruct())>
		</cfif>

		<cfreturn />
	</cffunction>

	<cffunction name="ParseColumn" access="public" returntype="void" hint="Converts a section of type Column to adaptive card Column">
		<cfargument name="columnSection" type="Column" required="true" hint="The column object to parse as adaptive card json data">

		<cfset var column = {
			"type" = "Column",
        	"items" = []
		}>

		<!--- Add items --->
		<cfset var items = arguments.columnSection.GetItems()>
		<cfset subGenerator = createObject("component", "com.AdaptiveCard.StructGenerator").init(column)>
		<cfloop array="#items#" item="item">
			<cfset item.ConvertToStruct(subGenerator, "items")>
		</cfloop>

		<!--- Parse select action --->
		<cfif !isNull(arguments.columnSection.GetSelectAction())>
			<cfset ParseSelectAction(arguments.columnSection.GetSelectAction(), column)>
		</cfif>

		<!--- Add properties --->
		<cfset var columnProperties = arguments.columnSection.GetProperties()>
		<cfloop collection="#columnProperties#" item="key">
			<cfset column[key] = columnProperties[key]>
		</cfloop>

		<!--- Add column to adaptive card / parent --->
		<cfset arrayAppend(cardStruct["columns"], subGenerator.GetCardStruct())>

		<cfreturn />
	</cffunction>

	<cffunction name="ParseImage" access="public" returntype="void" hint="Converts a section of type Image to adaptive card Image">
		<cfargument name="imageSection" type="Image" required="true" hint="The Image object to parse as adaptive card json data">
		<cfargument name="addTo" type="string" required="true" hint="The parent field to which this image is to be added">

		<cfset var image = {
			"type" = "Image"
		}>

		<!--- Add properties --->
		<cfset var imageProperties = arguments.imageSection.GetProperties()>
		<cfloop collection="#imageProperties#" item="key">
			<cfset image[key] = imageProperties[key]>
		</cfloop>

		<!--- Parse select action --->
		<cfif !isNull(arguments.imageSection.GetSelectAction())>
			<cfset ParseSelectAction(arguments.imageSection.GetSelectAction(), image)>
		</cfif>

		<!--- Add image to adaptive card / parent --->
		<cfif compareNoCase(arguments.addTo, "body") eq 0>
			<cfset arrayAppend(cardStruct.content.body, image)>
		<cfelse>
			<cfset arrayAppend(cardStruct[arguments.addTo], image)>
		</cfif>

		<cfreturn />
	</cffunction>


	<cffunction name="ParseInputText" access="public" returntype="void" hint="Converts a section of type InputText to adaptive card Input.Text">
		<cfargument name="inputSection" type="InputText" required="true" hint="The InputText object to parse as adaptive card json data">
		<cfargument name="addTo" type="string" required="true" hint="The parent field to which this image is to be added">

		<cfset var input = {
			"type" = "Input.Text"
		}>

		<!--- Add properties --->
		<cfset var inputProperties = arguments.inputSection.GetProperties()>
		<cfloop collection="#inputProperties#" item="key">
			<cfset input[key] = inputProperties[key]>
		</cfloop>

		<!--- Add input to adaptive card / parent --->
		<cfif compareNoCase(arguments.addTo, "body") eq 0>
			<cfset arrayAppend(cardStruct.content.body, input)>
		<cfelse>
			<cfset arrayAppend(cardStruct[arguments.addTo], input)>
		</cfif>

		<cfreturn />
	</cffunction>


	<cffunction name="ParseInputChoiceSet" access="public" returntype="void" hint="Converts a section of type InputChoiceSet to adaptive card Input.ChoiceSet">
		<cfargument name="inputSection" type="InputChoiceSet" required="true" hint="The InputChoiceSet object to parse as adaptive card json data">
		<cfargument name="addTo" type="string" required="true" hint="The parent field to which this container is to be added">

		<cfset var input = {
			"type" = "Input.ChoiceSet",
        	"choices" = []
		}>

		<!--- Add columns --->
		<cfset var choices = arguments.inputSection.GetChoices()>
		<cfset subGenerator = createObject("component", "com.AdaptiveCard.StructGenerator").init(input)>
		<cfloop array="#choices#" item="choice">
			<cfset choice.ConvertToStruct(subGenerator)>
		</cfloop>

		<!--- Add properties --->
		<cfset var inputProperties = arguments.inputSection.GetProperties()>
		<cfloop collection="#inputProperties#" item="key">
			<cfset input["#key#"] = inputProperties[key]>
		</cfloop>

		<!--- Add choiceset to adaptive card / parent --->
		<cfif compareNoCase(arguments.addTo, "body") eq 0>
			<cfset arrayAppend(cardStruct.content.body, subGenerator.GetCardStruct())>
		<cfelse>
			<cfset arrayAppend(cardStruct[arguments.addTo], subGenerator.GetCardStruct())>
		</cfif>

		<cfreturn />
	</cffunction>


	<cffunction name="ParseInputChoice" access="public" returntype="void" hint="Converts an InputChoice to adaptive card Input.Choice">
		<cfargument name="inputSection" type="InputChoice" required="true" hint="The InputChoice object to parse as adaptive card json data">

		<cfset var input = {
			"title" = "#inputSection.GetTitle()#",
			"value" = "#inputSection.GetValue()#"
		}>

		<cfset arrayAppend(cardStruct["choices"], input)>

		<cfreturn />
	</cffunction>


	<cffunction name="ParseTextBlock" access="public" returntype="void" hint="Converts a section of type TextBlock to adaptive card TextBlock">
		<cfargument name="textblockSection" type="TextBlock" required="true" hint="The section object to parse as adaptive card json data">
		<cfargument name="addTo" type="string" required="true" hint="The parent field to which this textblock is to be added">

		<cfset var textblock = {
			"type" = "TextBlock"
		}>

		<!--- Add properties --->
		<cfset var textblockProperties = arguments.textblockSection.GetProperties()>
		<cfloop collection="#textblockProperties#" item="key">
			<cfset textblock[key] = textblockProperties[key]>
		</cfloop>

		<!--- Add column to adaptive card / parent --->
		<cfif compareNoCase(arguments.addTo, "body") eq 0>
			<cfset arrayAppend(cardStruct.content.body, textblock)>
		<cfelse>
			<cfset arrayAppend(cardStruct[arguments.addTo], textblock)>
		</cfif>

		<cfreturn />
	</cffunction>

	<cffunction name="ParseActionSet" access="public" returntype="void" hint="Converts a section of type ActionSet to adaptive card ActionSet">
		<cfargument name="actionsetSection" type="ActionSet" required="true" hint="The section object to parse as adaptive card json data">
		<cfargument name="addTo" type="string" required="true" hint="The parent field to which this actionset is to be added">

		<cfset var actionset = {
			"type" = "ActionSet",
        	"actions" = []
		}>

		<!--- Add properties --->
		<cfset var actionsetProperties = arguments.actionsetSection.GetProperties()>
		<cfloop collection="#actionsetProperties#" item="key">
			<cfset actionset[key] = actionsetProperties[key]>
		</cfloop>

		<!--- Add actions --->
		<cfset var actions = arguments.actionsetSection.GetActions()>
		<cfset subGenerator = createObject("component", "com.AdaptiveCard.StructGenerator").init(actionset)>
		<cfloop array="#actions#" item="action">
			<cfset action.ConvertToStruct(subGenerator, "actions")>
		</cfloop>

		<!--- Add actionset to adaptive card / parent --->
		<cfif compareNoCase(arguments.addTo, "body") eq 0>
			<cfset arrayAppend(cardStruct.content.body, subGenerator.GetCardStruct())>
		<cfelse>
			<cfset arrayAppend(cardStruct[arguments.addTo], subGenerator.GetCardStruct())>
		</cfif>

		<cfreturn />
	</cffunction>

	<cffunction name="ParseSelectAction" access="public" returntype="void" hint="Converts a selectAction to adaptive card SelectAction">
		<cfargument name="action" type="Action" required="true" hint="The action object to parse as adaptive card json data">
		<cfargument name="parentStruct" type="struct" required="true" hint="The parent adaptive card structure for the select action">

		<!--- Add action --->
		<cfset subGenerator = createObject("component", "com.AdaptiveCard.StructGenerator").init(arguments.parentStruct)>
		<cfset arguments.action.ConvertToStruct(subGenerator, "selectAction")>

		<cfreturn />
	</cffunction>

	<cffunction name="ParseActionToggleVisibility" access="public" returntype="void" hint="Converts an ActionToggleVisibility object to adaptive card Action.ToggleVisibility">
		<cfargument name="action" type="ActionToggleVisibility" required="true" hint="The action object to parse as adaptive card json data">
		<cfargument name="addTo" type="string" required="true" hint="The parent's field to which this textblock is to be added">

		<cfset var actionToggle = {
			"type" = "Action.ToggleVisibility",
			"title" = arguments.action.GetTitle(),
			"targetElements" = []
		}>


		<!--- Add properties --->
		<cfset var actionProperties = arguments.action.GetProperties()>
		<cfloop collection="#actionProperties#" item="key">
			<cfset actionToggle[key] = actionProperties[key]>
		</cfloop>

		<!--- Add targetElements --->
		<cfset targets = arguments.action.GetTargets()>
		<cfloop array="#targets#" item="target">
			<cfset targetElement = {}>
			<cfset targetElement["elementId"] = target.section.GetId()>

			<cfif structKeyExists(target, "isVisible")>
				<cfset targetElement["isVisible"] = target.isVisible>
			</cfif>

			<cfset arrayAppend(actionToggle.targetElements, targetElement)>
		</cfloop>

		<!--- Add action to adaptive card --->
		<cfif compareNoCase(arguments.addTo, "selectAction") eq 0>
			<cfset cardStruct["selectAction"] = actionToggle>
		<cfelse>
			<cfset arrayAppend(cardStruct[arguments.addTo], actionToggle)>
		</cfif>

		<cfreturn />
	</cffunction>

	<cffunction name="ParseActionSubmit" access="public" returntype="void" hint="Converts an ActionSubmit object to adaptive card Action.Submit">
		<cfargument name="action" type="ActionSubmit" required="true" hint="The action object to parse as adaptive card json data">
		<cfargument name="addTo" type="string" required="true" hint="The parent's field to which this textblock is to be added">

		<cfset var actionSubmit = {
			"type" = "Action.Submit",
			"title" = arguments.action.GetTitle()
		}>

		<!--- Add properties --->
		<cfset var actionProperties = arguments.action.GetProperties()>
		<cfloop collection="#actionProperties#" item="key">
			<cfset actionSubmit[key] = actionProperties[key]>
		</cfloop>

		<!--- Add Data --->
		<cfset data = arguments.action.GetData()>
		<cfif structCount(data) neq 0>
			<cfset actionSubmit["data"] = {}>
		</cfif>

		<cfloop collection="#data#" item="key">
			<cfset actionSubmit.data["#key#"] = data[key]>
		</cfloop>

		<!--- Add action to adaptive card --->
		<cfif compareNoCase(arguments.addTo, "selectAction") eq 0>
			<cfset cardStruct["selectAction"] = actionSubmit>
		<cfelse>
			<cfset arrayAppend(cardStruct[arguments.addTo], actionSubmit)>
		</cfif>

		<cfreturn />
	</cffunction>

	<cffunction name="ParseActionOpenUrl" access="public" returntype="void" hint="Converts an ActionOpenUrl object to adaptive card Action.OpenUrl">
		<cfargument name="action" type="ActionOpenUrl" required="true" hint="The action object to parse as adaptive card json data">
		<cfargument name="addTo" type="string" required="true" hint="The parent's field to which this textblock is to be added">

		<cfset var actionOpenUrl = {
			"type" = "Action.OpenUrl",
			"title" = arguments.action.GetTitle(),
			"url" = arguments.action.GetUrl()
		}>

		<!--- Add properties --->
		<cfset var actionProperties = arguments.action.GetProperties()>
		<cfloop collection="#actionProperties#" item="key">
			<cfset actionOpenUrl[key] = actionProperties[key]>
		</cfloop>

		<!--- Add action to adaptive card --->
		<cfif compareNoCase(arguments.addTo, "selectAction") eq 0>
			<cfset cardStruct["selectAction"] = actionOpenUrl>
		<cfelse>
			<cfset arrayAppend(cardStruct[arguments.addTo], actionOpenUrl)>
		</cfif>

		<cfreturn />
	</cffunction>

</cfcomponent>