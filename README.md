# powershellscripts
Hot and fresh scripts! Free for all to use! These are scripts I've been playing around with my VMWare home lab, and they seem to work there! How about for you? 

OK, so I'm not really a developer, but I am a sysadmin interested in learning more, so while I've been labbing at home, I've been trying to make various scripts work in my VM environment (I'm trying to master and learn to be efficient in all the admin aspects of Active Directory). If they work, then fantastic!

I may also just put other random PowerShell scripts in here that I've gotten to work on my personal PC as well. We will see! 

The ones that I've put in this repository are the ones that I've gotten to work -- feel free to use them however you like, under the MIT license (keep the copyright notice with it and you're good). You'll have to tweak them for your purposes, as they're just templates, but they will work if you plug in the right info in the blanks! 

## What's in here

**Microsoft Graph / 365** -- these need the `Microsoft.Graph` module installed:

| Script | What it does |
| --- | --- |
| `basicprofile.ps1` | Prints a user's basic 365 profile |
| `checkexchangegroups.ps1` | Lists the groups a user belongs to |
| `checklicense.ps1` | Lists a user's assigned licenses |
| `checksyncstatus.ps1` | Says whether a user is AD-synced or cloud-only |
| `CloudResetDates.ps1` | Exports cloud-only users + last password change to Excel (needs `ImportExcel`) |
| `graph_convertaccount.ps1` | Hard matches a cloud-only account to an on-prem AD account |
| `testgraph.ps1` | Quick "is Graph working at all" check |

**Exchange Online** -- these need the `ExchangeOnlineManagement` module:

| Script | What it does |
| --- | --- |
| `addtoemaillist.ps1` | Adds a user to a distribution list |

**Active Directory** -- these need RSAT / the `ActiveDirectory` module:

| Script | What it does |
| --- | --- |
| `get_user_ou.ps1` | Shows which OU a user sits in |
| `lastpwreset.ps1` | Shows when a user last set their password |
| `securitygroups.ps1` | Lists a user's group memberships |
| `unlock.ps1` | Unlocks a locked-out account |
