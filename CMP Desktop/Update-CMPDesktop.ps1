Write-Host "Script running at $(Get-Date)"
$wsList = Get-Content -Path:"CMP-Workstations.txt"

foreach($ws in $wsList) {
	Write-Host "Updating workstation: $ws" -BackgroundColor DarkGreen -ForegroundColor Yellow

    $remoteLocation = "\\$ws\c`$\Program Files (x86)\Bally Technologies\CMPDesktop\"
	
	../Update-Push.ps1 "Build.version" (Join-Path -Path $remoteLocation -ChildPath "Build.version")
    ../Update-Push.ps1 "ReportFillTypes.xml" (Join-Path -Path $remoteLocation -ChildPath "XML\ReportFillTypes.xml")
}
