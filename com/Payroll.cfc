<cfcomponent displayName="Payroll" accessors="true" hint="For interraction with payroll data">

    <cfproperty name="payrollSchedule" type="struct" required="true">


    <cffunction name="init" access="public" returntype="Payroll">
        
        <!--- To be changed --->
        <cfset var filePath = "#APPLICATION.sitePath#biweekly2021.json">
        <cfset SetPayrollSchedule(loadPayrollSchedule(filePath))>

        <cfreturn this>
    </cffunction>


    <cffunction name="loadPayrollSchedule" returntype="struct" access="private">
        <cfargument name="filePath" type="string" required="true">

        <cfreturn deserializeJson(fileRead(arguments.filePath))>
    </cffunction>


    <cffunction name="getUpcomingTimeDueDate" returntype="string" access="public">

        <cfset var currentDate = now()>

        <cfloop collection="#payrollSchedule#" item="key">
            <cfset var yearSchedule = payrollSchedule[key]>

            <cfloop array="#yearSchedule#" item="schedule">
                <!--- 
                    Continue to next schedule if time due date string cannot be converted 
                    into a date 
                --->
                <cfif !isDate(schedule.timeDueDate)>
                    <cfcontinue>
                </cfif>

                <!--- 
                    convert time due date string to datetime object
                --->
                <cfset var timeDueDate = parseDateTime(schedule.timeDueDate)>

                <!--- 
                    Continue if date difference of current date and time due date
                    is greater that 14 (two weeks)
                    or if date difference is less than 0
                --->
                <cfset var dateDifference = dateDiff('d', currentDate, timeDueDate)>
                <cfif dateDifference gt 14 || dateDifference lt 0>
                    <cfcontinue>
                </cfif>

                <cfreturn schedule.timeDueDate>
            </cfloop>
        </cfloop>

        <cfreturn "">
    </cffunction>

</cfcomponent>