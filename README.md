<p align="center">
    <img src="Assets/Banner.png" alt="Hybrid Identity & Microsoft Entra ID Lab Banner" width="100%">
</p>

![Status](https://img.shields.io/badge/Status-In%20Progress-yellow)
![Progress](https://img.shields.io/badge/Progress-0%2F10%20Completed-lightgrey)
![Windows Server](https://img.shields.io/badge/Windows%20Server-2022-0078D4)
![Microsoft Entra ID](https://img.shields.io/badge/Microsoft-Entra%20ID-0078D4)
![Microsoft 365](https://img.shields.io/badge/Microsoft%20365-Business%20Premium-blue)
![Identity](https://img.shields.io/badge/Identity-Hybrid-success)
![PowerShell](https://img.shields.io/badge/PowerShell-Automation-5391FE)
![GitHub last commit](https://img.shields.io/github/last-commit/Amaggs99/Hybrid-Identity-Entra-ID-Lab)

---

# Hybrid Identity & Microsoft Entra ID Lab


---

# Overview

This repository documents the implementation of a **Hybrid Identity** environment by integrating an on-premises **Active Directory Domain Services (AD DS)** environment with **Microsoft Entra ID** and **Microsoft 365**.

The project simulates the deployment and administration of a real-world hybrid identity infrastructure commonly found in enterprise environments. It demonstrates how identities created and managed on-premises can be synchronized to the cloud using **Microsoft Entra Connect Sync**, enabling users to authenticate with Microsoft 365 services using synchronized credentials.

Each ticket represents a realistic administrative task performed by System Administrators, Microsoft 365 Administrators, Identity Administrators, and IT Support Professionals.

---

# Objectives

* Deploy a hybrid identity environment
* Integrate Active Directory with Microsoft Entra ID
* Configure Microsoft Entra Connect Sync
* Synchronize users and groups to Microsoft 365
* Configure Password Hash Synchronization (PHS)
* Validate hybrid authentication
* Troubleshoot synchronization issues
* Document enterprise administration procedures
* Develop practical Microsoft identity management skills

---

# Lab Environment

## On-Premises Infrastructure

| Component         | Configuration                        |
| ----------------- | ------------------------------------ |
| Hypervisor        | VMware Workstation Pro               |
| Domain Controller | Windows Server 2022                  |
| Active Directory  | AD DS                                |
| DNS               | Active Directory Integrated          |
| Domain            | adlab.local                          |
| Management        | Active Directory Users and Computers |
| Administration    | PowerShell                           |

---

## Cloud Infrastructure

| Component           | Configuration                  |
| ------------------- | ------------------------------ |
| Tenant              | Microsoft 365 Business Premium |
| Identity Provider   | Microsoft Entra ID             |
| Synchronization     | Microsoft Entra Connect Sync   |
| Authentication      | Password Hash Synchronization  |
| Administration      | Microsoft 365 Admin Center     |
| Identity Management | Microsoft Entra Admin Center   |

---

# Hybrid Identity Architecture

```text
                     Microsoft 365
                            │
                            │
                   Microsoft Entra ID
                            ▲
                            │
                 Microsoft Entra Connect
                            ▲
                            │
                 Active Directory Domain
                     Windows Server 2022
                            ▲
                            │
                   Domain Users & Groups
```

*A polished architecture diagram will be added as the project progresses.*

---

# Technologies Used

## Identity & Directory Services

* Active Directory Domain Services (AD DS)
* Microsoft Entra ID
* Microsoft Entra Connect Sync
* Password Hash Synchronization (PHS)

## Microsoft Cloud

* Microsoft 365 Business Premium
* Microsoft 365 Admin Center
* Microsoft Entra Admin Center

## Windows Administration

* Windows Server 2022
* Windows 11
* PowerShell
* DNS
* Organizational Units (OUs)
* Security Groups
* User Management

## Version Control

* Git
* GitHub

---

# Skills Demonstrated

* Hybrid Identity Administration
* Active Directory Administration
* Microsoft Entra ID Administration
* Microsoft 365 Administration
* Identity Synchronization
* Password Hash Synchronization
* User Lifecycle Management
* Organizational Unit Design
* Security Group Administration
* Identity Troubleshooting
* PowerShell Administration
* Enterprise Documentation
* Technical Documentation
* IT Support Best Practices

---

# Project Roadmap

| Ticket  | Status | Description                                  |
| ------- | :----: | -------------------------------------------- |
| HYB-001 |    ⏳   | Assess Active Directory Environment          |
| HYB-002 |    ⏳   | Configure Active Directory UPN Suffix        |
| HYB-003 |    ⏳   | Update User UPNs                             |
| HYB-004 |    ⏳   | Install Microsoft Entra Connect Sync         |
| HYB-005 |    ⏳   | Configure OU Filtering                       |
| HYB-006 |    ⏳   | Perform Initial Directory Synchronization    |
| HYB-007 |    ⏳   | Verify Synchronized Users                    |
| HYB-008 |    ⏳   | Configure Password Hash Synchronization      |
| HYB-009 |    ⏳   | Synchronize Active Directory Groups          |
| HYB-010 |    ⏳   | Troubleshoot Hybrid Identity Synchronization |

---

# Repository Structure

```text
Hybrid-Identity-Entra-ID-Lab
│
├── README.md
├── Ticket-Tracker.md
├── Commands-Used.md
├── LICENSE
│
├── Documentation
│   ├── HYB-001-AD-Environment-Assessment.md
│   ├── HYB-002-UPN-Suffix-Configuration.md
│   ├── HYB-003-User-UPN-Updates.md
│   ├── HYB-004-Entra-Connect-Installation.md
│   ├── HYB-005-OU-Filtering.md
│   ├── HYB-006-Initial-Directory-Synchronization.md
│   ├── HYB-007-Synchronized-User-Verification.md
│   ├── HYB-008-Password-Hash-Synchronization.md
│   ├── HYB-009-Group-Synchronization.md
│   └── HYB-010-Sync-Troubleshooting.md
│
├── Screenshots
│   ├── HYB-001
│   ├── HYB-002
│   ├── HYB-003
│   ├── HYB-004
│   ├── HYB-005
│   ├── HYB-006
│   ├── HYB-007
│   ├── HYB-008
│   ├── HYB-009
│   └── HYB-010
│
└── Diagrams
    └── Hybrid-Identity-Architecture.png
```

---

# Learning Outcomes

By completing this lab, I will gain hands-on experience with:

* Preparing Active Directory for hybrid identity
* Configuring Microsoft Entra Connect Sync
* Managing synchronized identities
* Troubleshooting synchronization issues
* Administering Microsoft Entra ID
* Integrating on-premises infrastructure with Microsoft 365
* Understanding enterprise identity management workflows

---

# Screenshots

Project screenshots will be organized by ticket within the `Screenshots` directory.

---

# Related Projects

* Microsoft 365 Administration Lab
* Active Directory Home Lab
* Windows Server Administration Lab
* CompTIA A+ Study Repository

---

# Future Enhancements

* Seamless Single Sign-On (Seamless SSO)
* Microsoft Entra Cloud Sync
* Microsoft Entra Connect Health
* Password Writeback
* Group Writeback
* Hybrid Azure AD Join
* Microsoft Intune Device Enrollment
* Conditional Access Policy Validation
* Self-Service Password Reset (SSPR)
* Multi-Factor Authentication (MFA)

---

# References

* Microsoft Learn
* Microsoft Entra ID Documentation
* Microsoft Entra Connect Documentation
* Windows Server Documentation
* Microsoft 365 Documentation
* PowerShell Documentation

---

**Project Status:** 🚧 In Progress

This repository is part of a larger enterprise lab portfolio focused on Windows Server, Active Directory, Microsoft Entra ID, Microsoft 365, identity management, and IT infrastructure administration.
