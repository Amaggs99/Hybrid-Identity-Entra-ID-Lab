# HYB-004 — Install and Configure Microsoft Entra Connect Sync

## Overview

This ticket implements Microsoft Entra Connect Sync to establish hybrid identity synchronization between the existing on-premises Active Directory Domain Services environment and Microsoft Entra ID.

A dedicated Windows Server 2022 member server named `SYNC01` was deployed and joined to the `adlab.local` domain. Microsoft Entra Connect Sync was then installed and configured using Password Hash Synchronization (PHS).

Organizational Unit filtering was configured so that only the required lab users and groups are synchronized from Active Directory to Microsoft Entra ID.

---

## Objectives

- Deploy a dedicated Microsoft Entra Connect Sync server
- Configure SYNC01 networking
- Join SYNC01 to the `adlab.local` domain
- Validate connectivity with DC01
- Install Microsoft Entra Connect Sync
- Connect the `adlab.local` Active Directory forest
- Connect the Microsoft Entra ID tenant
- Configure Password Hash Synchronization
- Configure OU-based synchronization filtering
- Perform the initial synchronization
- Verify synchronized users in Microsoft 365
- Verify synchronized identities in Microsoft Entra ID
- Document troubleshooting encountered during deployment

---

## Environment

| Component | Configuration |
|---|---|
| Domain Controller | DC01 |
| Active Directory Domain | `adlab.local` |
| Domain Controller IP | `192.168.66.10` |
| Synchronization Server | SYNC01 |
| Operating System | Windows Server 2022 |
| SYNC01 AD Network IP | `192.168.66.30` |
| Microsoft Entra Tenant | `Maggs777.onmicrosoft.com` |
| Synchronization Platform | Microsoft Entra Connect Sync |
| Authentication Method | Password Hash Synchronization |
| Virtualization Platform | VMware Workstation |

---

# 1. Deploy SYNC01

A dedicated Windows Server 2022 virtual machine was created to host Microsoft Entra Connect Sync.

Using a separate synchronization server keeps the Microsoft Entra Connect components separate from the domain controller and more closely represents a production hybrid identity architecture.

SYNC01 was configured with two virtual network adapters:

- Internal Active Directory lab network
- NAT network for Internet/Microsoft Entra connectivity

![VMware Dual NIC Configuration](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/01-SYNC01-Server-Deployment/01-VMware-Dual-NIC-Configuration.png)

Windows Server 2022 was installed on the new VM.

![Windows Server 2022 Installation](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/01-SYNC01-Server-Deployment/02-Windows-Server-2022-Installation.png)

The server was renamed:

```text
SYNC01
```

![SYNC01 Computer Name Configuration](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/01-SYNC01-Server-Deployment/03-SYNC01-Computer-Name-Configuration.png)

---

# 2. Configure SYNC01 Networking

The internal network interface was configured to communicate with the existing Active Directory environment.

Key network configuration included:

```text
SYNC01: 192.168.66.30
DC01:   192.168.66.10
DNS:    192.168.66.10
```

DC01 is used as the DNS server because Active Directory depends on DNS for domain controller discovery and access to AD services.

![SYNC01 Network Configuration](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/01-SYNC01-Server-Deployment/04-SYNC01-Network-Configuration.png)

Connectivity with the domain environment was validated before proceeding.

![SYNC01 Domain Connectivity Validation](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/01-SYNC01-Server-Deployment/05-SYNC01-Domain-Connectivity-Validation.png)

---

# 3. Configure Time Zone

The SYNC01 server time zone was configured correctly before domain integration.

Correct system time is particularly important in an Active Directory environment because Kerberos authentication is time-sensitive.

![SYNC01 Time Zone Configuration](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/01-SYNC01-Server-Deployment/06-SYNC01-Time-Zone-Configuration.png)

---

# 4. Join SYNC01 to Active Directory

SYNC01 was joined to the existing:

```text
adlab.local
```

Active Directory domain.

The domain join was validated successfully.

![SYNC01 Domain Join Validation](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/01-SYNC01-Server-Deployment/07-SYNC01-Domain-Join-Validation.png)

A domain administrator account was then used to sign into SYNC01, confirming that domain authentication was functioning correctly.

![SYNC01 Domain Administrator Login](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/01-SYNC01-Server-Deployment/08-SYNC01-Domain-Administrator-Login.png)

---

# 5. Access Microsoft Entra

Before installing Microsoft Entra Connect Sync, access to the Microsoft Entra environment was validated from SYNC01.

![SYNC01 Entra Admin Center Access](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/02-Entra-Connect-Installation/09-SYNC01-Entra-Admin-Center-Access.png)

This confirmed that SYNC01 had Internet connectivity and could reach the Microsoft cloud environment.

---

# 6. Download Microsoft Entra Connect Sync

The Microsoft Entra Connect Sync installer was downloaded to SYNC01.

![Entra Connect Sync Installer Downloaded](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/02-Entra-Connect-Installation/10-Entra-Connect-Sync-Installer-Downloaded.png)

The installer was then launched.

![Microsoft Entra Connect Sync Welcome](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/02-Entra-Connect-Installation/11-Microsoft-Entra-Connect-Sync-Welcome.png)

---

# 7. Select Custom Configuration

Microsoft Entra Connect provides both Express and Custom configuration options.

For this lab, **Custom configuration** was selected.

![Entra Connect Express vs Custom Configuration](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/02-Entra-Connect-Installation/12-Entra-Connect-Express-vs-Custom-Configuration.png)

Custom configuration provides greater administrative control over:

- Authentication method
- Active Directory forest configuration
- OU filtering
- Synchronization scope
- Optional synchronization features

The required Microsoft Entra Connect components were then installed.

![Entra Connect Required Components](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/02-Entra-Connect-Installation/13-Entra-Connect-Required-Components.png)

---

# 8. Configure Password Hash Synchronization

The selected authentication method was:

**Password Hash Synchronization (PHS)**

![Password Hash Synchronization Selection](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/02-Entra-Connect-Installation/14-Password-Hash-Synchronization-Selection.png)

Password Hash Synchronization synchronizes a derived hash of the user's on-premises Active Directory password hash to Microsoft Entra ID.

This allows synchronized users to authenticate against Microsoft Entra ID using credentials associated with their on-premises identity.

The architecture now follows the general identity flow:

```text
On-Premises Active Directory
          │
          ▼
Microsoft Entra Connect Sync
          │
          ├── User / Group Synchronization
          │
          └── Password Hash Synchronization
          │
          ▼
Microsoft Entra ID
          │
          ▼
Microsoft 365
```

---

# 9. Connect Microsoft Entra ID

Microsoft Entra Connect was authenticated against the Microsoft Entra tenant using a cloud administrator account.

![Entra ID Cloud Administrator Connection](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/02-Entra-Connect-Installation/15-Entra-ID-Cloud-Administrator-Connection.png)

The tenant used by the lab is:

```text
Maggs777.onmicrosoft.com
```

---

# 10. Troubleshooting — Enhanced Security Authentication Block

During Microsoft Entra authentication, Windows Server's Internet Explorer Enhanced Security Configuration interfered with the Microsoft authentication workflow.

![Entra Connect IE Enhanced Security Authentication Block](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/02-Entra-Connect-Installation/16-Entra-Connect-IE-Enhanced-Security-Authentication-Block.png)

The authentication request required access to Microsoft's cloud authentication services.

The server security configuration was adjusted so that the Microsoft authentication workflow could complete successfully.

This allowed Microsoft Entra Connect to authenticate to the cloud tenant.

---

# 11. Troubleshooting — Active Directory Discovery Error 1355

Microsoft Entra Connect initially failed to discover the `adlab.local` Active Directory forest.

Testing from SYNC01 produced:

```powershell
nltest /dsgetdc:adlab.local
```

The command returned:

```text
Getting DC name failed: Status = 1355 0x54b ERROR_NO_SUCH_DOMAIN
```

![SYNC01 AD Discovery Error 1355](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/02-Entra-Connect-Installation/17-SYNC01-AD-Discovery-Error-1355.png)

Further troubleshooting included testing DNS resolution and direct connectivity to DC01.

```powershell
Resolve-DnsName DC01.adlab.local -Server 192.168.66.10
```

The DNS request timed out.

Connectivity was then tested using:

```powershell
ping 192.168.66.10
```

The test resulted in 100% packet loss.

SYNC01's DNS configuration was verified and correctly pointed to:

```text
192.168.66.10
```

Further investigation determined that **DC01 was powered off**.

Because DC01 provides both Active Directory Domain Services and DNS for the lab, SYNC01 could not:

- Resolve `adlab.local`
- Locate the domain controller
- Query Active Directory
- Discover the Active Directory forest

DC01 was powered back on, restoring Active Directory and DNS connectivity.

---

# 12. Discover and Connect the Active Directory Forest

After DC01 was restored, Microsoft Entra Connect successfully discovered:

```text
adlab.local
```

![Entra Connect AD Forest Discovery](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/02-Entra-Connect-Installation/18-Entra-Connect-AD-Forest-Discovery.png)

The Active Directory forest was then added successfully to Microsoft Entra Connect.

![Entra Connect AD Forest Connected](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/02-Entra-Connect-Installation/19-Entra-Connect-AD-Forest-Connected.png)

This established the connection:

```text
DC01 / adlab.local
        │
        ▼
      SYNC01
        │
        ▼
Microsoft Entra Connect Sync
```

---

# 13. Configure OU Filtering

Rather than synchronizing the entire Active Directory environment, Microsoft Entra Connect was configured using **OU filtering**.

![Entra Connect OU Filtering](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/02-Entra-Connect-Installation/20-Entra-Connect-OU-Filtering.png)

The synchronization scope was limited primarily to the required lab objects within:

```text
adlab.local
└── Company
    ├── Groups
    └── Users
```

This prevents unnecessary Active Directory objects such as domain controllers, service accounts, infrastructure containers, and unrelated objects from being synchronized to Microsoft Entra ID.

OU filtering also demonstrates an important hybrid identity principle:

> Only synchronize the identities and objects that actually require cloud integration.

---

# 14. Complete Microsoft Entra Connect Configuration

After the synchronization options were reviewed, Microsoft Entra Connect was configured to begin synchronization automatically when configuration completed.

The final configuration included:

- Microsoft Entra tenant connector
- `adlab.local` Active Directory connector
- Password Hash Synchronization
- OU filtering
- Microsoft Entra export deletion threshold
- Automatic initial synchronization

The configuration completed successfully.

![Entra Connect Configuration Complete](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/02-Entra-Connect-Installation/21-Entra-Connect-Configuration-Complete.png)

Microsoft Entra Connect also configured:

```text
mS-DS-ConsistencyGuid
```

as the source anchor attribute.

The source anchor provides a stable identifier used to associate an on-premises Active Directory object with its corresponding Microsoft Entra ID object.

---

# 15. Verify Synchronization in Microsoft 365

After the initial synchronization completed, the Microsoft 365 Admin Center was checked.

The synchronized lab users appeared successfully.

![Synchronized Users Microsoft 365](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/02-Entra-Connect-Installation/22-Synchronized-Users-Microsoft-365.png)

Users visible after synchronization included:

- Emily Davis
- John Smith
- Mike Wilson
- Sarah Brown

This confirmed that the selected on-premises Active Directory users had successfully reached the Microsoft 365 cloud environment.

---

# 16. Verify Synchronization in Microsoft Entra ID

Microsoft Entra ID was then checked directly to verify the source of the synchronized identities.

![Synchronized Users Entra ID Verification](../Screenshots/HYB-004-Install-Microsoft-Entra-Connect-Sync/02-Entra-Connect-Installation/23-Synchronized-Users-Entra-ID-Verification.png)

The **On-premises sync** column showed:

```text
Yes
```

for the synchronized users.

This is the strongest verification that these accounts are being managed through the hybrid identity synchronization process rather than existing only as cloud-created identities.

Cloud-only accounts continued to display:

```text
No
```

under the on-premises synchronization status.

---

# Final Architecture

The completed environment now follows this hybrid identity architecture:

```text
┌───────────────────────────────┐
│ On-Premises Active Directory │
│                               │
│ DC01                          │
│ adlab.local                   │
│ 192.168.66.10                 │
└──────────────┬────────────────┘
               │
               │ AD DS / DNS
               ▼
┌───────────────────────────────┐
│ SYNC01                        │
│ Windows Server 2022           │
│ 192.168.66.30                 │
│                               │
│ Microsoft Entra Connect Sync  │
│ Password Hash Synchronization │
│ OU Filtering                  │
└──────────────┬────────────────┘
               │
               │ HTTPS / Internet
               ▼
┌───────────────────────────────┐
│ Microsoft Entra ID            │
│ Maggs777.onmicrosoft.com      │
└──────────────┬────────────────┘
               │
               ▼
┌───────────────────────────────┐
│ Microsoft 365                 │
│ Cloud Services                │
└───────────────────────────────┘
```

---

# Troubleshooting Summary

| Issue | Cause | Resolution |
|---|---|---|
| Microsoft cloud authentication blocked | Windows Server Enhanced Security Configuration | Adjusted server browser/security configuration to allow Microsoft authentication |
| `ERROR_NO_SUCH_DOMAIN` / Error 1355 | SYNC01 could not locate `adlab.local` | Investigated DNS and domain connectivity |
| DNS queries to `192.168.66.10` timed out | DC01 unavailable | Determined DC01 was powered off |
| Ping to DC01 failed | Domain controller offline | Powered on DC01 |
| AD forest not visible in Entra Connect | AD DS/DNS unavailable | Restored DC01 and refreshed forest discovery |
| `.local` UPN not verified in Entra ID | Internal AD namespace is not a verified cloud domain | Continued lab configuration using the existing Microsoft Entra tenant domain |

---

# Skills Demonstrated

This ticket demonstrates practical experience with:

- Microsoft Entra Connect Sync
- Hybrid identity architecture
- Active Directory Domain Services
- Microsoft Entra ID
- Microsoft 365
- Password Hash Synchronization
- Organizational Unit filtering
- Windows Server 2022
- DNS configuration
- Domain controller discovery
- Multi-NIC server configuration
- Active Directory domain joins
- PowerShell network troubleshooting
- Microsoft Entra synchronization verification
- Identity source verification
- Structured troubleshooting and documentation

---

# Key Takeaway

HYB-004 establishes the primary synchronization bridge between the on-premises Active Directory lab and Microsoft Entra ID.

Before this ticket, the two identity environments operated independently:

```text
Active Directory       Microsoft Entra ID
     │                         │
     X──── No Sync ────────────X
```

After completing HYB-004:

```text
Active Directory
      │
      ▼
Microsoft Entra Connect Sync
      │
      ▼
Microsoft Entra ID
      │
      ▼
Microsoft 365
```

On-premises identities can now be synchronized into Microsoft Entra ID, establishing the foundation for the remaining hybrid identity lab work.