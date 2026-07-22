$Screenshots = ".\Screenshots"

$Renames = @{
    "HYB-001-AD-Health-and-Network-Validation" = "HYB-001-Assess-Active-Directory-Environment"
    "HYB-002-Entra-Tenant-Preparation" = "HYB-002-Configure-Active-Directory-UPN-Suffix"
    "HYB-003-UPN-Suffix-Configuration" = "HYB-003-Update-User-UPNs-for-Hybrid-Identity"
    "HYB-004-Install-Microsoft-Entra-Connect-Sync" = "HYB-004-Install-Microsoft-Entra-Connect-Sync"
    "HYB-005-SYNC01-Server-Deployment" = "HYB-005-Configure-OU-Filtering"
    "HYB-006-Entra-Connect-Installation" = "HYB-006-Initial-Directory-Synchronization"
    "HYB-007-Directory-Synchronization" = "HYB-007-Verify-Synchronized-Entra-ID-Users"
    "HYB-008-Sync-Validation-and-Troubleshooting" = "HYB-008-Password-Hash-Synchronization"
    "HYB-009-Hybrid-Identity-Testing" = "HYB-009-Synchronize-AD-Security-Groups"
    "HYB-010-Final-Validation-and-Documentation" = "HYB-010-Troubleshoot-Hybrid-Identity-Synchronization"
}

foreach ($OldName in $Renames.Keys) {
    $NewName = $Renames[$OldName]

    $OldPath = Join-Path $Screenshots $OldName
    $NewPath = Join-Path $Screenshots $NewName

    if ($OldName -eq $NewName) {
        Write-Host "Already correct: $OldName"
        continue
    }

    if (Test-Path $OldPath) {
        if (Test-Path $NewPath) {
            Write-Warning "Skipped: '$NewName' already exists."
        }
        else {
            Rename-Item -Path $OldPath -NewName $NewName
            Write-Host "Renamed: $OldName -> $NewName"
        }
    }
    else {
        Write-Warning "Not found: $OldName"
    }
}

Write-Host "`nFinal screenshot folders:"
Get-ChildItem $Screenshots -Directory |
    Sort-Object Name |
    Select-Object -ExpandProperty Name