# HYB-001 — Assess Active Directory Environment

## Objective

Assess the existing on-premises Active Directory environment and confirm that it is healthy and ready for hybrid identity integration with Microsoft Entra ID and Microsoft 365.

This ticket focused on validating the domain controller, DNS, network connectivity, time synchronization, Active Directory health, and the existing user/group structure before introducing Microsoft Entra Connect Sync.

---

# Environment

| Component | Configuration |
| --- | --- |
| Domain | `adlab.local` |
| Domain Controller | `DC01` |
| Operating System | Windows Server 2022 |
| DC01 Internal IP | `192.168.66.10` |
| Internal Network | VMware Host-only / `192.168.66.0/24` |
| Outbound Network | VMware NAT / `192.168.174.0/24` |
| DNS Server | DC01 |
| DNS Client on DC01 | `127.0.0.1` |
| PDC Emulator | `DC01.adlab.local` |

---

# Initial Problem

DC01 was intentionally configured on an isolated VMware Host-only network and did not have Internet access.

This became a problem because the server needed to be updated before being used as part of the hybrid identity lab. Internet connectivity also needed to be available for future interaction with Microsoft cloud services.

The initial network configuration showed:

```text
HOST-ONLY
IPv4: 192.168.66.10
Default Gateway: None
DNS: 127.0.0.1

NAT
Status: Not Present
```

---

# VMware Network Configuration

A second VMware network adapter was configured for NAT access while preserving the existing Host-only adapter for Active Directory traffic.

The intended network roles were:

```text
DC01
├── HOST-ONLY
│   ├── IP: 192.168.66.10
│   ├── AD DS
│   ├── DNS
│   └── Internal lab traffic
│
└── NAT
    ├── DHCP address from VMware
    └── Outbound Internet connectivity
```

The NAT adapter initially appeared as `Not Present` in Windows.

Further investigation showed that the network adapter had been disabled in Device Manager. After enabling it, Windows detected the interface and VMware DHCP assigned an address on the NAT network.

---

# Internet and DNS Connectivity Validation

After enabling the NAT adapter, connectivity was validated in layers.

```powershell
Test-NetConnection 192.168.174.2
Test-NetConnection 8.8.8.8
Resolve-DnsName microsoft.com
```

The tests confirmed:

- VMware NAT gateway connectivity
- Outbound Internet routing
- External DNS resolution

Windows Update was then completed successfully and DC01 was brought fully up to date.

---

# Active Directory Health Validation

The Active Directory domain was validated using:

```powershell
Get-ADDomain
dcdiag
```

`Get-ADDomain` confirmed:

```text
DNSRoot: adlab.local
NetBIOSName: ADLAB
PDCEmulator: DC01.adlab.local
RIDMaster: DC01.adlab.local
```

The major Active Directory diagnostic tests passed, including:

- Connectivity
- Advertising
- DFSR
- SYSVOL
- NetLogons
- Replications
- RID Manager
- Services
- Locator checks

---

# Time Synchronization Remediation

During `dcdiag`, a warning indicated that the PDC Emulator was not configured to use an external time source.

Initial verification showed:

```text
Source: Local CMOS Clock
```

Because DC01 holds the PDC Emulator role, it should act as the authoritative time source for the domain and synchronize with an external NTP source.

The following configuration was applied:

```powershell
w32tm /config /manualpeerlist:"time.windows.com,0x8 time.nist.gov,0x8" /syncfromflags:manual /reliable:yes /update
Restart-Service w32time
w32tm /resync
w32tm /query /source
w32tm /query /status
```

The final validation showed a successful external NTP synchronization.

This is important because Kerberos authentication depends on consistent time across domain members.

---

# DNS Health Check and Troubleshooting

A targeted DNS diagnostic was performed:

```powershell
dcdiag /test:dns
```

The initial result showed a delegation failure caused by a stale DNS reference:

```text
win-9ne9ra9107r.adlab.local
Missing glue A record
```

Investigation identified an obsolete `_msdcs` NS record that still pointed to the server's previous hostname.

The current domain controller was verified with:

```powershell
Get-ADDomainController -Filter * |
Select-Object HostName, IPv4Address, IsGlobalCatalog
```

The stale NS record was inspected and removed using the actual DNS resource record object, then replaced with the correct name server:

```text
_msdcs → dc01.adlab.local.
```

After remediation, the delegation test changed from:

```text
Del = FAIL
```

to:

```text
Del = PASS
```

and `adlab.local` passed the DNS diagnostic.

---

# Multihomed Domain Controller DNS Cleanup

Because DC01 had both a Host-only NIC and a NAT NIC, additional cleanup was required to prevent the NAT address from being used for Active Directory DNS.

The NAT adapter was initially configured to register itself in DNS:

```text
RegisterThisConnectionsAddress : True
```

DNS registration was disabled on the NAT interface:

```powershell
Set-DnsClient -InterfaceAlias "Nat" -RegisterThisConnectionsAddress $false
```

The NAT address had already been registered as an A record for `DC01.adlab.local`, so the unwanted record was removed while preserving the correct internal address.

The desired DNS result was:

```text
DC01.adlab.local → 192.168.66.10
```

The DNS Server service was also found to be listening on both network interfaces.

Using DNS Manager, the server was configured to listen only on:

```text
192.168.66.10
```

The DNS service was restarted and the listening interface was verified.

---

# Organizational Unit, User, and Group Review

The existing Active Directory structure was reviewed before synchronization planning.

Organizational Units were enumerated with:

```powershell
Get-ADOrganizationalUnit -Filter * |
Select-Object Name, DistinguishedName
```

Users were reviewed with:

```powershell
Get-ADUser -Filter * |
Select-Object Name, SamAccountName, UserPrincipalName, Enabled
```

Groups were reviewed with:

```powershell
Get-ADGroup -Filter * |
Select-Object Name, GroupScope, GroupCategory
```

The custom lab structure included:

```text
Company
├── Users
├── Groups
├── Computers
├── Servers
├── Service Accounts
└── Disabled Users
```

Custom security groups included:

- IT_Admins
- HelpDesk
- HR
- Sales

This structure provides a clean foundation for later OU filtering and synchronization scope configuration.

---

# Verification

Final validation confirmed:

- DC01 is healthy and operational
- Active Directory services are functioning
- DNS health checks pass
- The stale `_msdcs` delegation was corrected
- The NAT adapter no longer registers itself in AD DNS
- DNS Server listens only on the internal AD interface
- DC01 has outbound Internet connectivity
- Windows Server is fully updated
- External NTP synchronization is functioning
- Existing users, groups, and OUs are ready for hybrid identity preparation

---

# Problems Encountered

## NAT Adapter Reported as Not Present

**Cause:** The VMware NAT network adapter was disabled inside Windows.

**Resolution:** Enabled the adapter in Device Manager and validated the interface with `Get-NetAdapter`.

---

## Stale DNS Delegation

**Cause:** The `_msdcs` NS record referenced the server's previous hostname.

**Resolution:** Removed the stale NS record and replaced it with `dc01.adlab.local`.

---

## NAT Address Registered in Active Directory DNS

**Cause:** The secondary NAT interface was allowed to register its DHCP address in DNS.

**Resolution:** Disabled DNS registration on the NAT adapter, removed the unwanted NAT A record, and configured DNS Server to listen only on `192.168.66.10`.

---

## PDC Emulator Using Local CMOS Clock

**Cause:** DC01 had no configured external NTP source.

**Resolution:** Configured external NTP peers and verified successful Windows Time synchronization.

---

# What I Learned

This ticket reinforced that hybrid identity preparation begins with a healthy on-premises identity source.

Key lessons included:

- Active Directory depends heavily on DNS and time synchronization.
- A domain controller with multiple network interfaces requires careful DNS configuration.
- Internet access and internal AD traffic should have clearly separated roles.
- DNS diagnostics can reveal stale records that are not obvious during normal administration.
- The PDC Emulator is the authoritative time source for the domain and should synchronize with a reliable external source.
- Infrastructure should be validated before installing identity synchronization software.

---

# Result

**HYB-001 — Assess Active Directory Environment: ✅ Completed**

The existing `adlab.local` environment was validated, remediated, updated, and confirmed ready for the next phase of hybrid identity deployment.
