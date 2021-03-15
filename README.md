# Payroll Schedule Reminder Bot

**Problem:** Most MSU supervisors tend to forget to approve time entries of their biweekly employees.  The payroll schedule is published 12 months prior on the Controllers website at:
http://www.ctlr.msu.edu/copayroll/payrollschedules.aspx 

**Task:** Create a ColdFusion page that is scheduled to run every morning at 8am and uses a Microsoft Teams message to remind the supervisor if the current date is within 2 days of the “Time Due Date” – from the payroll schedule.


## Walk-through
Here is a simple demo.

After running a script (to be a schedule job), a message is sent to teams.

<img src="./assets/payroll-schedule-bot.gif" alt="Walk-through">

## Setup