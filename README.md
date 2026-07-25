### autolab-monorepo

The app purpose is to provide a centralized digital vehicle service history and reminder system for both customers and service centres.
🧩 PRODUCT PURPOSE

## AUTOLAB is used by:

# Customers

Track vehicle service history

See due & upcoming services

Maintain oil change details, parts replaced, etc.

Receive reminders

Add four-wheeler and two-wheeler

# Service Centres

Search vehicle by number

Update service details

Mark parts replaced

Enter oil & service details

Set next service date

Notify customer

This is a vehicle service record management system.

---

# Use full commands

kill backend command is below

lsof -ti:3002 | xargs kill -9 2>/dev/null;

# Start working

#First start backend
cd apps/backend
npm run start or npm run dev

#Flutter app start app
cd apps/flutter-app
./run.sh

#Flutter customer start app
cd apps/customer_app
./run.sh

```bash

```

# Today changes files check

git diff --name-only HEAD | xargs -I{} stat -c "%y {}" {} | grep "^$(date +%Y-%m-%d)" | awk '{print $NF}'

# Next
push all remaing changes on git main branch
make clone on local mac system
create apk for both apps
apk update on website so anyone can download 
-----

# Note
*Note: do not change anything other then this requirement and do it will minimum code change