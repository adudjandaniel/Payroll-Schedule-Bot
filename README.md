# Payroll Schedule Reminder Bot

**Problem:** Most MSU supervisors tend to forget to approve time entries of their biweekly employees.  The payroll schedule is published 12 months prior on the Controllers website at:
http://www.ctlr.msu.edu/copayroll/payrollschedules.aspx 

**Task:** Create a ColdFusion page that is scheduled to run every morning at 8am and uses a Microsoft Teams message to remind the supervisor if the current date is within 2 days of the “Time Due Date” – from the payroll schedule.


## Walk-through
Here is a simple demo.

After running a script (to be a schedule job), a message is sent to teams.

<img src="./assets/payroll-schedule-bot.gif" alt="Walk-through">

## Setup

You'll need to create Application.cfc with the following in the application scope.

```
APPLICATION.tenantID = "<your-active-directory-tenant-id>";
APPLICATION.clientID = "<app-registration-app-id>";
APPLICATION.clientSecret = "<app-registration-app-secret";
APPLICATION.botId = "28:<app-id>";
APPLICATION.botName = "<name-in-bot-manifest>";
APPLICATION.botToken = "";
APPLICATION.tokenCreatedAt = 0;
APPLICATION.serviceUrl = "https://smba.trafficmanager.net/amer/";
APPLICATION.sitePath = "<file-path-to-root-of-app>";
```

**NB:** Confirm that the *service url*, in request body from teams / botframework is same as the service url below. If they're not equal, update that in the application scope.