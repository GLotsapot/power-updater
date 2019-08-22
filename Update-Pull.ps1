
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
                Write-Host "- Local File is newer or the same as the Remote File"
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

