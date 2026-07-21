# Hybrid Identity Lab Ticket Tracker

## Project Overview

This repository documents the deployment of a Hybrid Identity environment by integrating an on-premises Active Directory Domain Services (AD DS) environment with Microsoft Entra ID and Microsoft 365 using Microsoft Entra Connect Sync.

Each ticket represents a realistic enterprise administration task commonly performed by System Administrators, Microsoft 365 Administrators, Identity Administrators, and IT Support Specialists.

---

# Project Progress

**Overall Progress:** **0 / 10 Tickets Completed**

|  Ticket | Title                                                |   Status  |
| :-----: | ---------------------------------------------------- | :-------: |
| HYB-001 | Assess Active Directory Environment                  | ⏳ Pending |
| HYB-002 | Configure Active Directory UPN Suffix                | ⏳ Pending |
| HYB-003 | Update User UPNs for Hybrid Identity                 | ⏳ Pending |
| HYB-004 | Install Microsoft Entra Connect Sync                 | ⏳ Pending |
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

---

## HYB-002 — Configure Active Directory UPN Suffix

**Objective**

Configure a routable User Principal Name (UPN) suffix that matches the verified Microsoft 365 domain.

**Key Tasks**

* Add alternate UPN suffix
* Verify domain ownership
* Configure Active Directory Domains and Trusts
* Validate UPN availability

---

## HYB-003 — Update User UPNs for Hybrid Identity

**Objective**

Update selected Active Directory user accounts to use the new routable UPN suffix before synchronization.

**Key Tasks**

* Modify user UPNs
* Verify account properties
* Confirm naming consistency
* Prepare identities for synchronization

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

* [ ] HYB-001 — Assess Active Directory Environment
* [ ] HYB-002 — Configure Active Directory UPN Suffix
* [ ] HYB-003 — Update User UPNs for Hybrid Identity
* [ ] HYB-004 — Install Microsoft Entra Connect Sync
* [ ] HYB-005 — Configure Organizational Unit (OU) Filtering
* [ ] HYB-006 — Perform Initial Directory Synchronization
* [ ] HYB-007 — Verify Synchronized Users in Microsoft Entra ID
* [ ] HYB-008 — Configure and Validate Password Hash Synchronization
* [ ] HYB-009 — Synchronize Active Directory Security Groups
* [ ] HYB-010 — Troubleshoot Hybrid Identity Synchronization
