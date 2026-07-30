# HYB-005 -- Organizational Unit Filtering

## Overview

This ticket documents the configuration and validation of
**Organizational Unit (OU) filtering in Microsoft Entra Connect Sync**
for the hybrid `adlab.local` environment.

OU filtering was configured so that only selected objects in the
on-premises Active Directory environment are synchronized to Microsoft
Entra ID. The configuration was then validated by moving a test user
outside the synchronization scope, confirming that the corresponding
Entra ID object was soft-deleted, and moving the user back into scope to
confirm automatic restoration.

## Objectives

-   Configure Microsoft Entra Connect Sync to synchronize selected OUs.
-   Limit synchronization to the required `Company` OUs.
-   Include user, group, workstation, and server objects required by the
    lab.
-   Verify password hash synchronization remains enabled.
-   Validate the Entra Connect synchronization scheduler.
-   Test the effect of moving a user outside the synchronization scope.
-   Confirm that an out-of-scope synchronized user is soft-deleted in
    Microsoft Entra ID.
-   Return the user to a synchronized OU and confirm automatic
    restoration.
-   Verify that restored identities remain identified as on-premises
    synchronized objects.

## Environment

  Component                 Configuration
  ------------------------- ------------------------------------
  Active Directory domain   `adlab.local`
  Domain Controller         `DC01`
  Entra Connect server      `SYNC01`
  Client workstation        `CLIENT01`
  Cloud identity platform   Microsoft Entra ID
  Synchronization service   Microsoft Entra Connect Sync
  Synchronization method    Password Hash Synchronization
  Test user                 Emily Carter
  Test user UPN             `ecarter@Maggs777.onmicrosoft.com`

## OU Structure

The lab uses a `Company` OU with separate child OUs for different object
types and lifecycle states.

The synchronization scope used for this ticket included:

``` text
adlab.local
└── Company
    ├── Computers
    ├── Groups
    ├── Servers
    └── Users
```

The following OU was intentionally excluded from synchronization:

``` text
Company
└── Disabled Users
```

`CLIENT01` was placed in the `Company\Computers` OU and `SYNC01` was
placed in the `Company\Servers` OU before the filtering configuration
was finalized.

This design provides a controlled synchronization boundary and
demonstrates how OU placement can affect whether an Active Directory
object is represented in Microsoft Entra ID.

## Configuration Procedure

### 1. Open Microsoft Entra Connect Sync

On `SYNC01`, Microsoft Entra Connect Sync was opened and **Customize
synchronization options** was selected.

The existing Microsoft Entra tenant and `adlab.local` Active Directory
forest were used.

### 2. Verify the Active Directory Connector

The wizard confirmed that the `adlab.local` Active Directory forest was
configured as a connected directory.

This established the on-premises directory from which Entra Connect
imports identity objects.

### 3. Configure Domain and OU Filtering

Under **Domain and OU filtering**, **Sync selected domains and OUs** was
selected instead of synchronizing the entire directory.

The following `Company` OUs were included:

-   `Computers`
-   `Groups`
-   `Servers`
-   `Users`

The `Disabled Users` OU remained excluded.

This configuration ensures that objects placed in selected OUs are
eligible for synchronization while objects moved to excluded OUs fall
outside the configured synchronization scope.

![OU filtering
configuration](../Screenshots/HYB-005/10-OU-Filtering-Selected-OUs.png)

> **Note:** Screenshot filenames/paths should match the final repository
> screenshot names. Update the image reference above if the
> corresponding screenshot uses a different sequence number.

### 4. Verify Optional Features

On the **Optional features** page, **Password hash synchronization**
remained enabled.

Password Hash Synchronization allows password hash data derived from the
on-premises Active Directory password to be synchronized to Microsoft
Entra ID, supporting cloud authentication for synchronized identities.

No unnecessary writeback or Exchange hybrid features were enabled for
this ticket.

### 5. Apply the Configuration

The configuration was applied with:

**Start the synchronization process when configuration completes**

enabled.

Microsoft Entra Connect reported that configuration completed
successfully and initiated the synchronization process.

## Synchronization Validation

### Scheduler Status

The synchronization scheduler was validated on `SYNC01` using:

``` powershell
Get-ADSyncScheduler
```

The final validation showed:

``` text
CurrentlyEffectiveSyncCycleInterval : 00:30:00
NextSyncCyclePolicyType             : Delta
SyncCycleEnabled                    : True
MaintenanceEnabled                  : True
StagingModeEnabled                  : False
SchedulerSuspended                  : False
SyncCycleInProgress                 : False
```

These values confirmed that:

-   Automatic synchronization was enabled.
-   The effective synchronization interval was 30 minutes.
-   Scheduled synchronization was using delta cycles.
-   `SYNC01` was operating as the active synchronization server rather
    than a staging server.
-   The scheduler was not suspended.
-   No synchronization cycle was still running at the time of
    validation.

![Entra Connect scheduler
validation](../Screenshots/HYB-005/19-Entra-Connect-Scheduler-Validation.png)

## OU Filtering Lifecycle Test

To prove that OU filtering was functioning rather than relying only on
the wizard configuration, a synchronized user was deliberately moved in
and out of the configured synchronization scope.

### 1. Establish the Test User

The Active Directory account **Emily Carter** was used for the
validation test.

Her UPN was configured as:

``` text
ecarter@Maggs777.onmicrosoft.com
```

The account was initially placed in:

``` text
Company\Users
```

Because `Company\Users` was included in the Entra Connect OU filtering
scope, Emily Carter synchronized to Microsoft Entra ID.

The Entra admin center showed the account as an on-premises synchronized
identity.

### 2. Move the User Outside Synchronization Scope

Emily Carter was moved from:

``` text
Company\Users
```

to:

``` text
Company\Disabled Users
```

The `Disabled Users` OU was intentionally excluded from the Entra
Connect synchronization scope.

A delta synchronization was then initiated from `SYNC01`:

``` powershell
Start-ADSyncSyncCycle -PolicyType Delta
```

The command returned:

``` text
Result
------
Success
```

### 3. Verify Soft Deletion in Microsoft Entra ID

After synchronization completed, Emily Carter was no longer present
under **All users** in the Microsoft Entra admin center.

The **Deleted users** view showed Emily Carter as a deleted cloud
object.

![Out-of-scope user
soft-deleted](../Screenshots/HYB-005/16-Out-Of-Scope-User-Soft-Deleted.png)

This demonstrated that moving an on-premises identity outside the
configured Entra Connect synchronization scope caused the synchronized
cloud representation to be removed from the active directory and placed
into the Microsoft Entra soft-deleted state.

No manual deletion was performed in Microsoft Entra ID.

## Restoration Test

The lifecycle test was then reversed to confirm that returning the same
Active Directory object to synchronization scope restored its cloud
identity.

### 1. Return Emily Carter to the Synchronized OU

On `DC01`, Emily Carter was moved from:

``` text
Company\Disabled Users
```

back to:

``` text
Company\Users
```

No manual restoration was performed from the Microsoft Entra **Deleted
users** interface.

### 2. Trigger Delta Synchronization

On `SYNC01`, the following command was executed:

``` powershell
Start-ADSyncSyncCycle -PolicyType Delta
```

The synchronization request completed successfully.

![Restore user delta
synchronization](../Screenshots/HYB-005/17-Restore-User-Delta-Sync.png)

### 3. Verify Automatic Restoration

After the delta synchronization completed, Microsoft Entra ID was
refreshed.

Emily Carter reappeared under **All users**.

The account showed:

``` text
On-premises sync: Yes
```

![Restored synchronized
user](../Screenshots/HYB-005/18-Restored-Synced-User-Entra-ID.png)

This confirmed that Entra Connect recognized the original on-premises
Active Directory object when it returned to synchronization scope and
restored its corresponding Microsoft Entra identity.

## Validation Results

  ------------------------------------------------------------------------------
  Test                    Expected Result                Result
  ----------------------- ------------------------------ -----------------------
  Selected OU filtering   Only intended OUs are          PASS
  configured              synchronized                   

  `Company\Users`         User objects are eligible for  PASS
  included                synchronization                

  `Company\Groups`        Group objects are eligible for PASS
  included                synchronization                

  `Company\Computers`     `CLIENT01` is within           PASS
  included                synchronization scope          

  `Company\Servers`       `SYNC01` is within             PASS
  included                synchronization scope          

  `Disabled Users`        Objects moved there leave      PASS
  excluded                synchronization scope          

  Password Hash           Password hash synchronization  PASS
  Synchronization enabled remains active                 

  Delta sync initiated    Command returns `Success`      PASS
  manually                                               

  User moved out of scope Entra identity becomes         PASS
                          soft-deleted                   

  User returned to scope  Entra identity is              PASS
                          automatically restored         

  Restored user           `On-premises sync` displays    PASS
  synchronization state   `Yes`                          

  Scheduler enabled       `SyncCycleEnabled : True`      PASS

  Scheduler operational   `SchedulerSuspended : False`   PASS
  ------------------------------------------------------------------------------

## PowerShell Commands Used

Check the Microsoft Entra Connect synchronization scheduler:

``` powershell
Get-ADSyncScheduler
```

Trigger a delta synchronization:

``` powershell
Start-ADSyncSyncCycle -PolicyType Delta
```

A **delta** synchronization was appropriate for the lifecycle test
because only changes made since the previous synchronization needed to
be processed.

## Troubleshooting and Observations

### UPN Configuration

The on-premises `adlab.local` suffix is not the Microsoft Entra tenant
sign-in suffix used by the lab.

The test user's UPN was therefore configured with the available
Microsoft Entra tenant suffix:

``` text
ecarter@Maggs777.onmicrosoft.com
```

This provided a cloud-compatible sign-in name while the underlying
Active Directory domain remained `adlab.local`.

### OU Scope Behavior

A key observation from this ticket is that Entra Connect evaluates
whether an object is within the configured synchronization scope.

Moving Emily Carter into the excluded `Disabled Users` OU did not simply
disable synchronization of future attribute changes. From the
synchronization system's perspective, the previously synchronized object
was no longer present within scope, causing its cloud representation to
enter the deleted-user lifecycle.

Returning the same object to an included OU allowed synchronization to
restore the cloud identity.

### Synchronization Timing

The scheduler was configured for a 30-minute effective synchronization
interval. Manual delta synchronization was used during testing so that
changes could be validated immediately rather than waiting for the next
scheduled cycle.

## Security and Administrative Considerations

OU filtering should be treated as part of the identity synchronization
design rather than as a substitute for account-management controls.

In a production environment, administrators should carefully evaluate
the consequences of changing synchronization scope. Removing an OU that
contains currently synchronized objects can cause those objects to be
removed from the active Microsoft Entra directory.

For this lab, the behavior was intentionally tested using a controlled
test identity.

## Outcome

HYB-005 successfully demonstrated selective synchronization between
on-premises Active Directory and Microsoft Entra ID.

The completed configuration proved that:

1.  Entra Connect can restrict synchronization to selected Active
    Directory OUs.
2.  Users, groups, workstations, and servers can be organized into
    explicit synchronization boundaries.
3.  Moving an identity outside the synchronization scope causes the
    corresponding Microsoft Entra identity to be soft-deleted.
4.  Returning the same identity to synchronization scope allows Entra
    Connect to restore it automatically.
5.  Delta synchronization can be manually initiated for immediate
    processing of directory changes.
6.  The Entra Connect scheduler remains enabled and operational for
    automatic synchronization.

This ticket validates both the configuration and the operational
behavior of OU filtering in the hybrid identity environment.
