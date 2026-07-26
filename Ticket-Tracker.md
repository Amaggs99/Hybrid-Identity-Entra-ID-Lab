# Hybrid Identity Lab Ticket Tracker

## Project Overview

This repository documents the deployment of a Hybrid Identity environment by integrating an on-premises Active Directory Domain Services (AD DS) environment with Microsoft Entra ID and Microsoft 365 using Microsoft Entra Connect Sync.

Each ticket represents a realistic enterprise administration task commonly performed by System Administrators, Microsoft 365 Administrators, Identity Administrators, and IT Support Specialists.

---

# Project Progress

**Overall Progress:** **4 / 10 Tickets Completed**

|  Ticket | Title                                                |   Status  |
| :-----: | ---------------------------------------------------- | :-------: |
| HYB-001 | Assess Active Directory Environment                  | ✅ Completed |
| HYB-002 | Configure Active Directory UPN Suffix                | ✅ Completed |
| HYB-003 | Update User UPNs for Hybrid Identity                 | ✅ Completed |
| HYB-004 | Install Microsoft Entra Connect Sync                 | ✅ Completed |
| HYB-005 | Configure Organizational Unit (OU) Filtering         | ⏳ Pending |
| HYB-006 | Perform Initial Directory Synchronization            | ⏳ Pending |
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

Limit synchronization to selected Organizational Units.

**Key Tasks**

* Configure synchronization scope
* Exclude unnecessary objects
* Validate OU filtering
* Run synchronization preview

---

## HYB-006 — Perform Initial Directory Synchronization

**Objective**

Run the first synchronization cycle and verify successful synchronization.

**Key Tasks**

* Start synchronization
* Monitor synchronization progress
* Verify successful completion
* Review synchronization statistics

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
* [ ] HYB-005 — Configure Organizational Unit (OU) Filtering
* [ ] HYB-006 — Perform Initial Directory Synchronization
* [ ] HYB-007 — Verify Synchronized Users in Microsoft Entra ID
* [ ] HYB-008 — Configure and Validate Password Hash Synchronization
* [ ] HYB-009 — Synchronize Active Directory Security Groups
* [ ] HYB-010 — Troubleshoot Hybrid Identity Synchronization
