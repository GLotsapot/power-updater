<#
.Synopsis
Automate updating remote files to local machine
    
.AUTHORS
Nick Munday - GCGC SysAdmin
    
.DESCRIPTION
This script will check the remote share and move the Access Database files locally if the remote version is newer.

.FIXES
Version 1.1

- Removed Archive functionality as was not needed

#>

# Sets Local and Remote Folder Location
$LocalFolder = "C:\CAS"
$RemoteShare = "\\blackjack.gcgaming.com\departments\GCC\TSG\Staff\5.0 Common\OGELP\CAS2018\TIC"

# Log File
$LogFile = "$LocalFolder\Update_Database_From_Remote.log"

# Sets Local and Remote Files
$Local_MDE = "$LocalFolder\Casino Acct.mde"
$Local_ACCDE = "$LocalFolder\Casino Acct.accde"
$Remote_MDE = "$RemoteShare\Casino Acct.mde"
$Remote_ACCDE = "$RemoteShare\Casino Acct.accde"

# Creates an array for the paths
$Paths = @(
$Local_MDE
$Local_ACCDE
$Remote_MDE
$Remote_ACCDE
)

# Puts date in the log file
Get-Date | Out-File $LogFile -Append
"Starting Script." | Out-File $LogFile -Append

# Checks if the paths exist, if not exits
ForEach ($Path in $Paths) {
    IF (-not(Test-Path $Path)) {
        Write-Warning "Can't find $Path - Exiting Script."
        "Can't find $Path - Exiting Script." | Out-File $LogFile -Append
        Exit
    }
}

# Checking if Remote file is newer than Local file
IF ((Get-Item $Remote_MDE).LastWriteTime -gt (Get-Item $Local_MDE).LastWriteTime ) {
    $New_MDE = "Yes"
    Write-Host "Remote locatation has newer file for $Local_MDE, will continue with copy."
    "Remote locatation has newer file for $Local_MDE, will continue with copy." | Out-File $LogFile -Append
} ELSE {
    $New_MDE = "No"
    Write-Host "Remote locatation does not have a newer file for $Local_MDE, no action required."
    "Remote locatation does not have a newer file for $Local_MDE, no action required." | Out-File $LogFile -Append
}
IF ((Get-Item $Remote_ACCDE).LastWriteTime -gt (Get-Item $Local_ACCDE).LastWriteTime ) {
    $New_ACCDE = "Yes"
    Write-Host "Remote locatation has newer file for $Local_ACCDE, will continue with copy."
    "Remote locatation has newer file for $Local_ACCDE, will continue with copy." | Out-File $LogFile -Append
} ELSE {
    $New_ACCDE = "No"
    Write-Host "Remote locatation does not have a newer file for $Local_ACCDE, no action required."
    "Remote locatation does not have a newer file for $Local_ACCDE, no action required." | Out-File $LogFile -Append
}

# If both files do not need updating, exit script.
IF (($New_MDE -eq "Yes") -or ($New_ACCDE -eq "Yes") ) {
    Write-Host "Remote location has one or newer files, will continue with copy"
} ELSE {
    Write-Host "No action required. Remote and local files match for both files. Script completed."
    "No action required. Remote and local files match for both files." | Out-File $LogFile -Append
    "Script completed." | Out-File $LogFile -Append
    Exit
}

# If the remote MDE file is newer, remove the current local and copy the remote file
IF ($New_MDE -eq "Yes") {

    Remove-Item $Local_MDE
    Copy-Item $Remote_MDE $LocalFolder

    IF (-not(Test-Path $Local_MDE)) {
        Write-Warning "Local .MDE file no longer exists - Investigate."
        "WARNING: Local $Local_MDE file no longer exists - Investigate." | Out-File $LogFile -Append
    }
    
    IF ((Get-Item $Remote_MDE).LastWriteTime -match (Get-Item $Local_MDE).LastWriteTime ) {
        Write-Host "Success: Local and remote files match for $Local_MDE."
        "Success: Local and remote files match for $Local_MDE."  | Out-File $LogFile -Append
    } ELSE {
        Write-Warning "Local and remote files do not match for $Local_MDE - Investigate."
        "Local and remote files do not match for $Local_MDE - Investigate." | Out-File $LogFile -Append
    }
}

# If the remote ACCDE file is newer, then create a backup, remove the current local and copy the remote file

IF ($New_ACCDE -eq "Yes") {

    Remove-Item $Local_ACCDE
    Copy-Item $Remote_ACCDE $LocalFolder

    IF (-not(Test-Path $Local_ACCDE)) {
        Write-Warning "Local .MDE file no longer exists - Investigate."
        "WARNING: Local $Local_ACCDE file no longer exists - Investigate." | Out-File $LogFile -Append
    }
    
    IF ((Get-Item $Remote_ACCDE).LastWriteTime -match (Get-Item $Local_ACCDE).LastWriteTime ) {
        Write-Host "Success: Local and remote files match for $Local_ACCDE."
        "Success: Local and remote files match for $Local_ACCDE."  | Out-File $LogFile -Append
    } ELSE {
        Write-Warning "Local and remote files do not match for $Local_ACCDE - Investigate."
        "WARNING: Local and remote files do not match for $Local_ACCDE - Investigate." | Out-File $LogFile -Append
    }
}

Write-Host "Script Completed."
"Script Completed." | Out-File $LogFile -Append