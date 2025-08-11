Param([switch] $force)

Import-Module "$PSScriptRoot/frames.psm1"

$data = Get-ProjectData

Get-ChildItem $data.items -Directory -Recurse | ForEach-Object {
	[HashTable] $file = Get-FileData $data $PSItem
	[bool] $missing = -not (Test-Path $file.target)

	if ($force -or $missing) {
		if ($missing) { New-Item $file.target -Force > $null }

		Export-AnimationFrames $file
	}
}
