# Hybrid Identity Lab Ticket Tracker

## Project Overview

This repository documents the deployment of a Hybrid Identity environment by integrating an on-premises Active Directory Domain Services (AD DS) environment with Microsoft Entra ID and Microsoft 365 using Microsoft Entra Connect Sync.

Each ticket represents a realistic enterprise administration task commonly performed by System Administrators, Microsoft 365 Administrators, Identity Administrators, and IT Support Specialists.

---

# Project Progress

**Overall Progress:** **6 / 10 Tickets Completed**

|  Ticket | Title                                                |   Status  |
| :-----: | ---------------------------------------------------- | :-------: |
| HYB-001 | Assess Active Directory Environment                  | ✅ Completed |
| HYB-002 | Configure Active Directory UPN Suffix                | ✅ Completed |
| HYB-003 | Update User UPNs for Hybrid Identity                 | ✅ Completed |
| HYB-004 | Install Microsoft Entra Connect Sync                 | ✅ Completed |
| HYB-005 | Configure Organizational Unit (OU) Filtering         | ✅ Completed |
| HYB-006 | Perform Initial Directory Synchronization            | ✅ Completed |
| HYB-007 | Verify Synchronized Users in Microsoft Entra ID      | ⏳ Pending |
| HYB-008 | Configure and Validate Password Hash Synchronization | ⏳ Pending |
| HYB-009 | Synchronize Active Directory Security Groups         | ⏳ Pending |
| HYB-010 | Troubleshoot Hybrid Identity Synchronization         | ⏳ Pending |

---

# Ticket Status Legend

| Status         | Meaning                                |
| -------------- | -------------------------------------- |
| ⏳ Pending      | Work has not yet started               |
| 🚧 In Progress | Ticket is currently being completed    |
| ✅ Completed    | Ticket has been successfully completed |
| 🔄 Revised     | Ticket was updated after completion    |

---

# Ticket Objectives

## HYB-001 — Assess Active Directory Environment

**Objective**

Verify that the existing Active Directory environment is healthy and ready for hybrid identity deployment.

**Key Tasks**

* Verify Active Directory health
* Verify DNS configuration
* Verify domain functionality
* Review Organizational Units
* Review users and security groups
* Confirm Microsoft Entra Connect prerequisites

**Status:** ✅ Completed

**Completed Work**

* Validated Active Directory and DNS health
* Restored and verified DC01 Internet connectivity through the VMware NAT interface
* Corrected multihomed DNS behavior so the DNS Server service listens only on `192.168.66.10`
* Corrected stale DNS records and validated the `adlab.local` DNS zone
* Configured and validated domain controller time synchronization
* Reviewed Organizational Units, users, and security groups
* Confirmed the environment is ready for hybrid identity preparation

---

## HYB-002 — Configure Active Directory UPN Suffix

**Objective**

Configure a routable User Principal Name (UPN) suffix that matches the verified Microsoft 365 domain.

**Key Tasks**

* Add alternate UPN suffix
* Verify domain ownership
* Configure Active Directory Domains and Trusts
* Validate UPN availability

**Status:** ✅ Completed

**Completed Work**

* Confirmed the Microsoft 365 tenant domain `Maggs777.onmicrosoft.com`
* Added `Maggs777.onmicrosoft.com` as an alternative UPN suffix in Active Directory Domains and Trusts
* Validated that the new suffix is available for Active Directory user accounts

---

## HYB-003 — Update User UPNs for Hybrid Identity

**Objective**

Update selected Active Directory user accounts to use the new routable UPN suffix before synchronization.

**Key Tasks**

* Modify user UPNs
* Verify account properties
* Confirm naming consistency
* Prepare identities for synchronization

**Status:** ✅ Completed

**Completed Work**

* Updated John Smith as the initial test account
* Verified the test user's UPN through PowerShell
* Updated the remaining enabled lab users to `@Maggs777.onmicrosoft.com`
* Verified the enabled user accounts and on-premises security groups before synchronization

---

## HYB-004 — Install Microsoft Entra Connect Sync

**Objective**

Deploy Microsoft Entra Connect and establish synchronization between the on-premises Active Directory environment and Microsoft Entra ID.

**Key Tasks**

* Install Microsoft Entra Connect
* Connect Active Directory
* Connect Microsoft 365 tenant
* Configure Password Hash Synchronization
* Validate installation

**Status:** ✅ Completed

**Completed Work**

* Deployed a dedicated Windows Server 2022 synchronization server named `SYNC01`
* Configured dual VMware network adapters for internal AD connectivity and outbound Internet access
* Configured the internal SYNC01 interface as `192.168.66.30/24`
* Configured internal DNS to use DC01 at `192.168.66.10`
* Corrected the SYNC01 time zone to Eastern Time
* Joined SYNC01 to the `adlab.local` domain and verified domain authentication
* Installed Microsoft Entra Connect Sync on SYNC01 using Custom configuration
* Connected the `adlab.local` Active Directory forest
* Connected the `Maggs777.onmicrosoft.com` Microsoft Entra tenant
* Selected Password Hash Synchronization as the authentication method
* Configured OU filtering to synchronize the required `Company` users and groups
* Completed the Microsoft Entra Connect configuration and initiated the initial synchronization
* Verified synchronized users in the Microsoft 365 admin center
* Verified synchronized identities in Microsoft Entra ID using the on-premises synchronization status
* Troubleshot Active Directory forest discovery error 1355 and restored connectivity after identifying that DC01 was powered off

**Next Step**

Proceed to HYB-005 to specifically validate and document Organizational Unit filtering and synchronization scope.

---

## HYB-005 — Configure Organizational Unit (OU) Filtering

**Objective**

Limit Microsoft Entra Connect synchronization to selected Organizational Units and validate synchronization-scope behavior.

**Key Tasks**

* Configure synchronization scope
* Exclude unnecessary objects
* Validate OU filtering
* Validate user lifecycle behavior when objects move in and out of synchronization scope
* Verify synchronization scheduler status

**Status:** ✅ Completed

**Completed Work**

* Configured Microsoft Entra Connect to use selected domain and OU synchronization
* Included the `Company\Users`, `Company\Groups`, `Company\Computers`, and `Company\Servers` OUs in synchronization scope
* Excluded the `Company\Disabled Users` OU from synchronization scope
* Confirmed CLIENT01 is located in the synchronized `Company\Computers` OU
* Confirmed SYNC01 is located in the synchronized `Company\Servers` OU
* Retained Password Hash Synchronization as an enabled synchronization feature
* Verified Emily Carter synchronized to Microsoft Entra ID from the included `Company\Users` OU
* Moved Emily Carter to the excluded `Company\Disabled Users` OU and initiated a delta synchronization
* Confirmed the out-of-scope Emily Carter identity was soft-deleted in Microsoft Entra ID
* Returned Emily Carter to the synchronized `Company\Users` OU and initiated another delta synchronization
* Confirmed Microsoft Entra Connect automatically restored Emily Carter without a manual cloud restore
* Verified the restored identity reports `On-premises sync: Yes`
* Validated the Microsoft Entra Connect scheduler with `Get-ADSyncScheduler`
* Confirmed a 30-minute effective synchronization interval, delta policy, enabled scheduler, disabled staging mode, and non-suspended scheduler

**Next Step**

Proceed to HYB-006 to document and validate directory synchronization execution and synchronization results.

---

## HYB-006 — Perform Initial Directory Synchronization

**Objective**

Validate Microsoft Entra Connect synchronization by confirming scheduler health, manually initiating a Delta synchronization, and verifying that synchronized Active Directory users are successfully represented in Microsoft Entra ID.

**Key Tasks**

* Verify Microsoft Entra Connect scheduler
* Validate synchronization scheduler configuration
* Initiate manual Delta synchronization
* Verify synchronization completion
* Validate synchronized users in Microsoft Entra ID

**Status:** ✅ Completed

**Completed Work**

* Verified the Microsoft Entra Connect scheduler using `Get-ADSyncScheduler`
* Confirmed automatic synchronization is enabled with a 30-minute synchronization interval
* Verified Delta synchronization is configured as the active synchronization policy
* Confirmed SYNC01 is operating as the active synchronization server with Staging Mode disabled
* Initiated a manual Delta synchronization using `Start-ADSyncSyncCycle -PolicyType Delta`
* Verified the synchronization cycle completed successfully
* Confirmed synchronized Active Directory users appear within Microsoft Entra ID
* Verified synchronized users display **On-premises sync: Yes**, confirming Active Directory as the source of authority
* Confirmed cloud-only administrative accounts remain independent from synchronized identities
* Validated the hybrid identity environment is functioning correctly and ready for additional synchronization testing

**Next Step**

Proceed to HYB-007 to validate synchronized user attributes and compare on-premises Active Directory objects with their Microsoft Entra ID counterparts.

---

## HYB-007 — Verify Synchronized Users in Microsoft Entra ID

**Objective**

Validate that synchronized users appear correctly in Microsoft Entra ID.

**Key Tasks**

* Verify synchronized identities
* Compare on-premises and cloud attributes
* Validate synchronization status
* Confirm source of authority

---

## HYB-008 — Configure and Validate Password Hash Synchronization

**Objective**

Validate Password Hash Synchronization by testing password changes and cloud authentication.

**Key Tasks**

* Change password on-premises
* Synchronize password hash
* Test Microsoft 365 sign-in
* Validate hybrid authentication

---

## HYB-009 — Synchronize Active Directory Security Groups

**Objective**

Synchronize Active Directory security groups to Microsoft Entra ID.

**Key Tasks**

* Create or modify security groups
* Synchronize group membership
* Validate synchronized groups
* Confirm membership changes

---

## HYB-010 — Troubleshoot Hybrid Identity Synchronization

**Objective**

Investigate and resolve common synchronization issues.

**Key Tasks**

* Review synchronization logs
* Identify synchronization errors
* Resolve configuration issues
* Validate successful synchronization
* Document findings

---

# Completion Checklist

* [x] HYB-001 — Assess Active Directory Environment
* [x] HYB-002 — Configure Active Directory UPN Suffix
* [x] HYB-003 — Update User UPNs for Hybrid Identity
* [x] HYB-004 — Install Microsoft Entra Connect Sync
* [x] HYB-005 — Configure Organizational Unit (OU) Filtering
* [x] HYB-006 — Perform Initial Directory Synchronization
* [ ] HYB-007 — Verify Synchronized Users in Microsoft Entra ID
* [ ] HYB-008 — Configure and Validate Password Hash Synchronization
* [ ] HYB-009 — Synchronize Active Directory Security Groups
* [ ] HYB-010 — Troubleshoot Hybrid Identity Synchronization
