<#
.Synopsis
Automate updating remote files to local machine

.AUTHORS
Nick Munday - GCGC SysAdmin
Sawyer Peacock - OGELP SysAdmin

.DESCRIPTION
This script will check the remote share and move the Access Database files locally if the remote version is newer.

.FIXES
Version 1.1
- Removed Archive functionality as was not needed

Version 1.2
- Nick's spelling is horrible
- Re-wrote redundant code into functions

#>
##################### Configurable Variables #####################
# Sets Local and Remote Folder Location
$LocalFolder = "C:\CAS"
$RemoteShare = "\\blackjack.gcgaming.com\departments\GCC\TSG\Staff\5.0 Common\OGELP\CAS2018\TIC"

# Sets Local and Remote Files
$Local_MDE = "$LocalFolder\Casino Acct.mde"
$Local_ACCDE = "$LocalFolder\Casino Acct.accde"
$Remote_MDE = "$RemoteShare\Casino Acct.mde"
$Remote_ACCDE = "$RemoteShare\Casino Acct.accde"

##################### Utility Functions #####################
function Check4Update([string]$localFile, [string]$remoteFile) {
    <#
    .Synopsis
    Compares a remote and local file date

    .DESCRIPTION
    Checks to see if the remote and local file both exist, and returns $true if the remote file is newer
    #>
    Write-Host "Checking File: $localFile" -BackgroundColor DarkGray -ForegroundColor Yellow
    if (Test-Path $localFile) {
        if (Test-Path $remoteFile) {
            if ((Get-Item $remoteFile).LastWriteTime -gt (Get-Item $localFile).LastWriteTime) {
                Write-Host "- Remote File is newer than Local File"
                return $true
            }
            else {
                Write-Host "- Local File is newer than Remote File"
            }
        }
        else {
            Write-Warning "- Remote file $remoteFile does not exist - skipping update"
        }
    }
    else {
        Write-Warning "- Local file $localFile does not exist - skipping update"
    }
    return $false
}

function UpdateFile([string]$localFile, [string]$remoteFile, [bool]$backup = $true) {
    <#
    .Synopsis
    Replace a file with different one

    .DESCRIPTION
    Replaces the local file with the remote one, and optionally backs up the original
    #>
    Write-Host "Updating File: $localFile" -BackgroundColor DarkGray -ForegroundColor Yellow
    if($backup) {
        $backupFile = "$localFile.backup"
        if (Test-Path $backupFile) {
            Write-Host "- Removing existing backup file: $backupFile"
            Remove-Item $backupFile
            }
        Write-Host "- Backup up existing file as: $backupFile"
        Rename-Item $localFile $backupFile
    }
    else {
        Write-Host "- Removing original file: $localFile"
        Remove-Item $localFile
    }
    
    Write-Host "- Copying file $remoteFile to $localFile"
    Copy-Item $remoteFile $localFile
}

##################### Main Code Goes down here #####################
Write-Host "Script running at $(Get-Date)"

if (Check4Update $Local_MDE $Remote_MDE) {
    UpdateFile $Local_MDE $Remote_MDE
}

if (Check4Update $Local_ACCDE $Remote_ACCDE) {
    UpdateFile $Local_ACCDE $Remote_ACCDE $false
}