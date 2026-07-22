# HYB-003 — Update User UPNs for Hybrid Identity

## Objective

Update selected on-premises Active Directory users from the internal `@adlab.local` UPN suffix to the cloud-compatible `@Maggs777.onmicrosoft.com` suffix configured in HYB-002.

The goal was to prepare the enabled lab identities for synchronization with Microsoft Entra ID while preserving their existing Active Directory accounts, passwords, group memberships, and legacy logon names.

---

# Why This Matters

Before the change, users had UPNs such as:

```text
jsmith@adlab.local
```

For this hybrid identity lab, the intended sign-in identity is:

```text
jsmith@Maggs777.onmicrosoft.com
```

Using a consistent UPN between on-premises Active Directory and Microsoft Entra ID creates a clearer hybrid identity model and prepares the accounts for Microsoft Entra Connect Sync.

The change affects the **User Principal Name** only. It does not rename the `adlab.local` domain.

---

# Initial Test User

Rather than changing every account immediately, one user was updated first to validate the configuration.

Test account:

```text
Name: John Smith
sAMAccountName: jsmith
Original UPN: jsmith@adlab.local
New UPN: jsmith@Maggs777.onmicrosoft.com
```

Using **Active Directory Users and Computers**, the Account tab for John Smith was opened and the newly configured suffix was selected.

The legacy logon name remained:

```text
ADLAB\jsmith
```

This demonstrated that changing the UPN does not change the user's `sAMAccountName`.

---

# Test User Verification

After updating John Smith, the change was verified with PowerShell:

```powershell
Get-ADUser jsmith -Properties UserPrincipalName |
Select-Object Name, SamAccountName, UserPrincipalName
```

The result confirmed:

```text
John Smith
jsmith
jsmith@Maggs777.onmicrosoft.com
```

This validated the UPN configuration before applying the change to the remaining enabled lab users.

---

# Bulk UPN Update

The remaining enabled lab users were updated with PowerShell:

```powershell
$Users = "sbrown","edavis","mwilson"

foreach ($User in $Users) {
    Set-ADUser $User -UserPrincipalName "$User@Maggs777.onmicrosoft.com"
}
```

The enabled lab identities prepared for synchronization were:

| User | sAMAccountName | Updated UPN |
| --- | --- | --- |
| John Smith | `jsmith` | `jsmith@Maggs777.onmicrosoft.com` |
| Sarah Brown | `sbrown` | `sbrown@Maggs777.onmicrosoft.com` |
| Emily Davis | `edavis` | `edavis@Maggs777.onmicrosoft.com` |
| Mike Wilson | `mwilson` | `mwilson@Maggs777.onmicrosoft.com` |

---

# User Verification

All enabled users in the `Company\Users` OU were then verified:

```powershell
Get-ADUser -Filter 'Enabled -eq $true' `
-SearchBase "OU=Users,OU=Company,DC=adlab,DC=local" |
Select-Object Name, SamAccountName, UserPrincipalName
```

The output confirmed that all four enabled users were using the new cloud-compatible suffix.

---

# Pre-Synchronization Object Review

Before moving to Microsoft Entra Connect, the users and groups intended for synchronization were reviewed.

Users:

```powershell
Get-ADUser -Filter * `
-SearchBase "OU=Users,OU=Company,DC=adlab,DC=local" |
Select-Object Name, Enabled, UserPrincipalName
```

Groups:

```powershell
Get-ADGroup -Filter * `
-SearchBase "OU=Groups,OU=Company,DC=adlab,DC=local" |
Select-Object Name, GroupScope, GroupCategory
```

The custom security groups identified included:

```text
IT_Admins
HelpDesk
HR
Sales
```

This established a clear **pre-sync state** that can later be compared with the objects synchronized into Microsoft Entra ID.

---

# Synchronization Scope Planning

The Active Directory structure was reviewed with the intention of using scoped synchronization rather than synchronizing the entire directory.

The relevant structure was:

```text
adlab.local
└── Company
    ├── Users
    ├── Groups
    ├── Computers
    ├── Servers
    ├── Service Accounts
    └── Disabled Users
```

The lab plan is to synchronize the required user and group OUs while excluding unnecessary infrastructure and disabled-account OUs when OU filtering is configured later in the project.

---

# Screenshot Evidence

Screenshots for this ticket are stored in:

```text
Screenshots/
└── HYB-003-Update-User-UPNs-for-Hybrid-Identity/
    ├── 01-Test-User-UPN-Updated.png
    ├── 02-Test-User-UPN-Verification.png
    ├── 03-All-User-UPNs-Updated.png
    └── 04-OnPrem-Users-Groups-PreSync.png
```

These screenshots document the initial test change, PowerShell verification, completed UPN updates, and the on-premises objects before synchronization.

---

# Verification

The following conditions were confirmed:

- The alternative UPN suffix was available in Active Directory.
- John Smith was successfully updated and verified as the initial test user.
- Sarah Brown, Emily Davis, and Mike Wilson were successfully updated through PowerShell.
- All four enabled users now use `@Maggs777.onmicrosoft.com`.
- Existing `sAMAccountName` values were preserved.
- The users remained members of the `adlab.local` domain.
- The on-premises users and security groups were documented before synchronization.

---

# Problems Encountered

No errors occurred while updating the user UPNs.

The change was deliberately performed on one test account first to reduce risk before applying the configuration to the remaining enabled users.

---

# What I Learned

This ticket demonstrated the difference between an Active Directory account's UPN and its legacy logon name.

Key lessons included:

- A UPN is commonly used as the modern user sign-in identity.
- The UPN suffix can be changed without renaming the Active Directory domain.
- `sAMAccountName` and UPN are separate account attributes.
- Testing an identity change on one account before applying it broadly is a safer administrative practice.
- PowerShell provides an efficient and repeatable method for updating multiple identities.
- Establishing a pre-synchronization inventory makes later Microsoft Entra ID validation easier.
- OU design is important because Microsoft Entra Connect can use OU filtering to control synchronization scope.

---

# Result

**HYB-003 — Update User UPNs for Hybrid Identity: ✅ Completed**

Four enabled Active Directory users were successfully updated to use the `Maggs777.onmicrosoft.com` UPN suffix and verified in preparation for Microsoft Entra Connect synchronization.

The next phase is HYB-004, where the dedicated `SYNC01` server is prepared and Microsoft Entra Connect Sync is installed and configured.
