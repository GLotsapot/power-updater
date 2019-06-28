 param (
    [Parameter(Mandatory=$True)]
    [string]$fileLocal = "",
	[Parameter(Mandatory=$True)]
    [string]$fileRemote = ""
 )


function Check4Update([string]$localFile, [string]$remoteFile) {
    <#
    .Synopsis
    Compares a remote and local file date

    .DESCRIPTION
    Checks to see if the remote and local file both exist, and returns $true if the local file is newer
    #>
    Write-Host "Checking File: $remoteFile" -BackgroundColor DarkGray -ForegroundColor Yellow
    if (Test-Path $localFile) {
        if (Test-Path $remoteFile) {
            if ((Get-Item $localFile).LastWriteTime -gt (Get-Item $remoteFile).LastWriteTime) {
                Write-Host "- Local File is newer than Remote File"
                return $true
            }
            else {
                Write-Host "- Remote File is newer than local File, or the same"
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
    Replaces the remote file with the local one, and optionally backs up the original
    #>
    Write-Host "Updating File: $remoteFile" -BackgroundColor DarkGray -ForegroundColor Yellow
    if($backup) {
        $backupFile = "$remoteFile.backup"
        if (Test-Path $backupFile) {
            Write-Host "- Removing existing backup file: $backupFile"
            Remove-Item $backupFile
            }
        Write-Host "- Backup up existing file as: $backupFile"
        Rename-Item $remoteFile $backupFile
    }
    else {
        Write-Host "- Removing original file: $remoteFile"
        Remove-Item $remoteFile
    }
    
    Write-Host "- Copying file $localFile to $remoteFile"
    Copy-Item $localFile $remoteFile
}

##################### Main Code Goes down here #####################
if (Check4Update $fileLocal $fileRemote) {
    UpdateFile $fileLocal $fileRemote
}