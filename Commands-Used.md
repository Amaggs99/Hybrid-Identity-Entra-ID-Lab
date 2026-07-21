# Commands Used

This document serves as a centralized reference for all PowerShell commands, Windows administrative tools, and Microsoft Entra Connect commands used throughout the Hybrid Identity & Microsoft Entra ID Lab.

Commands are organized by lab ticket to provide a clear record of the administrative actions performed during the project.

---

# Table of Contents

* HYB-001 — Assess Active Directory Environment
* HYB-002 — Configure Active Directory UPN Suffix
* HYB-003 — Update User UPNs for Hybrid Identity
* HYB-004 — Install Microsoft Entra Connect Sync
* HYB-005 — Configure Organizational Unit (OU) Filtering
* HYB-006 — Perform Initial Directory Synchronization
* HYB-007 — Verify Synchronized Users in Microsoft Entra ID
* HYB-008 — Configure and Validate Password Hash Synchronization
* HYB-009 — Synchronize Active Directory Security Groups
* HYB-010 — Troubleshoot Hybrid Identity Synchronization

---

# HYB-001 — Assess Active Directory Environment

## PowerShell

```powershell
# Commands will be documented during this ticket.
```

## Administrative Tools

* Active Directory Users and Computers
* Active Directory Domains and Trusts
* Active Directory Sites and Services
* DNS Manager
* Group Policy Management
* Server Manager
* Windows PowerShell

---

# HYB-002 — Configure Active Directory UPN Suffix

## PowerShell

```powershell
# Commands will be documented during this ticket.
```

## Administrative Tools

* Active Directory Domains and Trusts
* Active Directory Users and Computers

---

# HYB-003 — Update User UPNs for Hybrid Identity

## PowerShell

```powershell
# Commands will be documented during this ticket.
```

## Administrative Tools

* Active Directory Users and Computers
* Windows PowerShell

---

# HYB-004 — Install Microsoft Entra Connect Sync

## PowerShell

```powershell
# Commands will be documented during this ticket.
```

## Administrative Tools

* Microsoft Entra Connect
* Microsoft Entra Admin Center
* Microsoft 365 Admin Center

---

# HYB-005 — Configure Organizational Unit (OU) Filtering

## PowerShell

```powershell
# Commands will be documented during this ticket.
```

## Administrative Tools

* Microsoft Entra Connect
* Active Directory Users and Computers

---

# HYB-006 — Perform Initial Directory Synchronization

## PowerShell

```powershell
# Commands will be documented during this ticket.
```

## Administrative Tools

* Microsoft Entra Connect
* Synchronization Service Manager
* Windows PowerShell

---

# HYB-007 — Verify Synchronized Users in Microsoft Entra ID

## PowerShell

```powershell
# Commands will be documented during this ticket.
```

## Administrative Tools

* Microsoft Entra Admin Center
* Microsoft 365 Admin Center

---

# HYB-008 — Configure and Validate Password Hash Synchronization

## PowerShell

```powershell
# Commands will be documented during this ticket.
```

## Administrative Tools

* Active Directory Users and Computers
* Microsoft Entra Admin Center
* Microsoft 365 Admin Center

---

# HYB-009 — Synchronize Active Directory Security Groups

## PowerShell

```powershell
# Commands will be documented during this ticket.
```

## Administrative Tools

* Active Directory Users and Computers
* Microsoft Entra Admin Center

---

# HYB-010 — Troubleshoot Hybrid Identity Synchronization

## PowerShell

```powershell
# Commands will be documented during this ticket.
```

## Administrative Tools

* Microsoft Entra Connect
* Synchronization Service Manager
* Event Viewer
* Windows PowerShell

---

# Command Reference

## Common PowerShell Cmdlets

The following cmdlets are expected to be used throughout the project and will be expanded as the lab progresses.

### Active Directory Module

```powershell
Get-ADUser
Set-ADUser
New-ADUser
Get-ADGroup
New-ADGroup
Add-ADGroupMember
Get-ADOrganizationalUnit
Get-ADDomain
Get-ADForest
Get-ADDomainController
```

### Networking

```powershell
ipconfig /all
ping
nslookup
Test-NetConnection
Resolve-DnsName
```

### Microsoft Entra Connect

```powershell
Start-ADSyncSyncCycle
Get-ADSyncScheduler
```

---

# Notes

* Every command used during the project will be recorded under its corresponding ticket.
* Commands will remain in the order they were executed to accurately reflect the implementation process.
* Screenshots captured throughout each ticket will reference the commands documented here where applicable.
