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
# Review Organizational Units
Get-ADOrganizationalUnit -Filter * |
Select-Object Name, DistinguishedName

# Review Active Directory users
Get-ADUser -Filter * |
Select-Object Name, SamAccountName, UserPrincipalName, Enabled

# Review Active Directory groups
Get-ADGroup -Filter * |
Select-Object Name, GroupScope, GroupCategory

# Review DNS Server listening interfaces
Get-DnsServerSetting -All |
Select-Object -ExpandProperty ListeningIpAddress

# Restart DNS after interface configuration
Restart-Service DNS

# Validate Active Directory DNS health
dcdiag /test:dns /v
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

No PowerShell command was required for the UPN suffix change. The alternative UPN suffix was configured through **Active Directory Domains and Trusts**.

Configured suffix:

```text
Maggs777.onmicrosoft.com
```

## Administrative Tools

* Active Directory Domains and Trusts
* Active Directory Users and Computers

---

# HYB-003 — Update User UPNs for Hybrid Identity

## PowerShell

```powershell
# Verify the initial test user's UPN
Get-ADUser jsmith -Properties UserPrincipalName |
Select-Object Name, SamAccountName, UserPrincipalName

# Update the remaining enabled lab users
$Users = "sbrown","edavis","mwilson"

foreach ($User in $Users) {
    Set-ADUser $User -UserPrincipalName "$User@Maggs777.onmicrosoft.com"
}

# Verify all enabled users in the Company\Users OU
Get-ADUser -Filter 'Enabled -eq $true' -SearchBase "OU=Users,OU=Company,DC=adlab,DC=local" |
Select-Object Name, SamAccountName, UserPrincipalName

# Review users selected for synchronization
Get-ADUser -Filter * -SearchBase "OU=Users,OU=Company,DC=adlab,DC=local" |
Select-Object Name, Enabled, UserPrincipalName

# Review security groups selected for synchronization
Get-ADGroup -Filter * -SearchBase "OU=Groups,OU=Company,DC=adlab,DC=local" |
Select-Object Name, GroupScope, GroupCategory
```

## Administrative Tools

* Active Directory Users and Computers
* Windows PowerShell

---

# HYB-004 — Install Microsoft Entra Connect Sync

## PowerShell

Commands used while deploying, validating, and troubleshooting the dedicated `SYNC01` synchronization server:

```powershell
# Identify the Host-only and NAT interfaces
Get-NetIPConfiguration |
Select-Object InterfaceAlias,
    @{Name="IPv4Address";Expression={$_.IPv4Address.IPAddress}},
    @{Name="Gateway";Expression={$_.IPv4DefaultGateway.NextHop}},
    @{Name="DNSServer";Expression={$_.DNSServer.ServerAddresses -join ", "}}

# Disable DHCP on the internal Host-only interface
Set-NetIPInterface -InterfaceAlias "Ethernet0" -Dhcp Disabled

# Configure the static internal address
New-NetIPAddress `
-InterfaceAlias "Ethernet0" `
-IPAddress 192.168.66.30 `
-PrefixLength 24

# Configure DC01 as the DNS server for the internal interface
Set-DnsClientServerAddress `
-InterfaceAlias "Ethernet0" `
-ServerAddresses 192.168.66.10

# Test connectivity to DC01
ping 192.168.66.10

# Resolve the domain controller through AD DNS
Resolve-DnsName DC01.adlab.local

# Discover a domain controller for adlab.local
nltest /dsgetdc:adlab.local

# Review the local date and time zone
Get-Date
Get-TimeZone

# Correct the server time zone
Set-TimeZone -Id "Eastern Standard Time"

# Join SYNC01 to the Active Directory domain
Add-Computer -DomainName "adlab.local" -Credential "ADLAB\Administrator" -Restart

# Verify domain membership
(Get-CimInstance Win32_ComputerSystem) |
Select-Object Name, Domain, PartOfDomain

# Identify the currently authenticated account
whoami

# Verify the secure channel to Active Directory
nltest /sc_verify:adlab.local

# Review DNS servers assigned to each IPv4 interface during
# Active Directory forest discovery troubleshooting
Get-DnsClientServerAddress -AddressFamily IPv4 |
Select-Object InterfaceAlias, ServerAddresses

# Query DC01 directly after forest discovery failed
Resolve-DnsName DC01.adlab.local -Server 192.168.66.10

# Test direct IP connectivity after the DNS query timed out
ping 192.168.66.10

# Review SYNC01 IPv4 addresses and default gateways
Get-NetIPConfiguration |
Select-Object InterfaceAlias,
    @{N="IPv4";E={$_.IPv4Address.IPAddress}},
    @{N="Gateway";E={$_.IPv4DefaultGateway.NextHop}}
```

## Microsoft Entra Connect Configuration

Microsoft Entra Connect Sync was configured through the graphical configuration wizard. No additional PowerShell commands were required to complete the initial connector configuration.

Configuration performed included:

* Selected **Custom** configuration
* Selected **Password Hash Synchronization**
* Connected the `Maggs777.onmicrosoft.com` Microsoft Entra tenant
* Connected the `adlab.local` Active Directory forest
* Configured synchronization scope using OU filtering
* Selected the required `Company\Users` and `Company\Groups` OUs
* Allowed Microsoft Entra Connect to manage the source anchor
* Used `mS-DS-ConsistencyGuid` as the source anchor attribute
* Started the initial synchronization when configuration completed
* Verified synchronized users in Microsoft 365
* Verified `On-premises sync = Yes` for synchronized users in Microsoft Entra ID

## Troubleshooting Performed

During Active Directory forest discovery, the following command returned Error 1355:

```powershell
nltest /dsgetdc:adlab.local
```

The error reported:

```text
ERROR_NO_SUCH_DOMAIN
```

A direct DNS query to DC01 then timed out:

```powershell
Resolve-DnsName DC01.adlab.local -Server 192.168.66.10
```

Direct IP connectivity also failed:

```powershell
ping 192.168.66.10
```

Reviewing the SYNC01 network configuration confirmed that the internal interface and DNS configuration were correct. Investigation then determined that `DC01` was powered off.

After DC01 was powered on, Active Directory DNS and domain controller discovery resumed and Microsoft Entra Connect successfully discovered and connected the `adlab.local` forest.

## Administrative Tools

* VMware Workstation Pro
* Server Manager
* Windows PowerShell
* Microsoft Entra Connect Sync
* Microsoft Entra Admin Center
* Microsoft 365 Admin Center
* Active Directory Users and Computers

> **Status:** HYB-004 completed. Microsoft Entra Connect Sync is installed and configured on SYNC01, the on-premises forest and Microsoft Entra tenant are connected, Password Hash Synchronization is enabled, and the initial synchronized identities have been verified.

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
