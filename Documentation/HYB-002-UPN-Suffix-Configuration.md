# HYB-002 — Configure Active Directory UPN Suffix

## Objective

Configure an alternative User Principal Name (UPN) suffix in the on-premises `adlab.local` Active Directory domain so user sign-in names can align with the Microsoft 365 / Microsoft Entra ID tenant.

The Microsoft 365 tenant domain used for this lab is:

```text
Maggs777.onmicrosoft.com
```

---

# Why This Matters

The existing Active Directory domain uses the internal namespace:

```text
adlab.local
```

Existing users therefore originally had UPNs such as:

```text
jsmith@adlab.local
```

For the hybrid identity lab, the users need a cloud-compatible sign-in suffix that corresponds with the Microsoft Entra tenant.

The Active Directory domain itself does **not** need to be renamed. Instead, an alternative UPN suffix can be added and assigned to selected users.

The intended identity format is:

```text
On-Premises Active Directory
jsmith@Maggs777.onmicrosoft.com
             │
             │ Microsoft Entra Connect Sync
             ▼
Microsoft Entra ID
jsmith@Maggs777.onmicrosoft.com
```

---

# Microsoft Entra Tenant Validation

Before modifying Active Directory, the Microsoft Entra admin center was reviewed to confirm the tenant domain.

The available tenant domain was:

```text
Maggs777.onmicrosoft.com
```

This suffix was selected for the hybrid lab so the on-premises UPNs could align with the cloud tenant.

---

# Alternative UPN Suffix Configuration

On `DC01`, **Active Directory Domains and Trusts** was opened.

The following path was used:

```text
Active Directory Domains and Trusts
    → Properties
    → Alternative UPN suffixes
```

The following suffix was added:

```text
Maggs777.onmicrosoft.com
```

The configuration was then applied.

This made the new suffix available in Active Directory Users and Computers when editing the **User logon name** for domain users.

---

# Screenshot Evidence

The configuration is documented in:

```text
Screenshots/
└── HYB-002-Configure-Active-Directory-UPN-Suffix/
    └── 01-Alternative-UPN-Suffix-Configured.png
```

The screenshot demonstrates that `Maggs777.onmicrosoft.com` was successfully added as an alternative UPN suffix.

---

# Verification

The configuration was verified by opening an Active Directory user's **Account** properties.

The new suffix appeared as an available option for the user's UPN.

This confirmed that Active Directory could now assign sign-in names in the following format:

```text
username@Maggs777.onmicrosoft.com
```

while the underlying Active Directory domain remained:

```text
adlab.local
```

---

# Important Concept

A **UPN suffix** and an **Active Directory domain name** are not the same thing.

The domain remains:

```text
adlab.local
```

A user's UPN can still be:

```text
jsmith@Maggs777.onmicrosoft.com
```

The legacy logon format also remains available:

```text
ADLAB\jsmith
```

This allows the organization to use a cloud-compatible sign-in identity without renaming the existing Active Directory domain.

---

# Problems Encountered

No configuration errors were encountered while adding the alternative UPN suffix.

The main consideration was confirming the correct Microsoft Entra tenant domain before changing any on-premises user identities.

---

# What I Learned

This ticket demonstrated how on-premises Active Directory identities can be prepared for synchronization with Microsoft Entra ID without changing the underlying AD domain.

Key lessons included:

- The Active Directory DNS domain and user UPN suffix can be different.
- Alternative UPN suffixes provide a way to align on-premises sign-in names with cloud identities.
- UPN planning should be completed before directory synchronization.
- Changing a user's UPN does not change the user's `sAMAccountName`, password, OU placement, or domain membership.
- Identity naming consistency simplifies the hybrid sign-in experience.

---

# Result

**HYB-002 — Configure Active Directory UPN Suffix: ✅ Completed**

`Maggs777.onmicrosoft.com` was successfully added as an alternative UPN suffix to the `adlab.local` Active Directory environment.

The environment is now ready for selected user accounts to be updated with cloud-compatible UPNs in HYB-003.
