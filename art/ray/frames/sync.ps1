Param([bool] $force)

function Get-ArtFrameCount($frames, $animation) {
	foreach($size in @(4, 9, 16)) {
		foreach($entry in $frames[$size]) { if ($entry -in $animation) { return $size } }
	}
	return 4
}

function Restore-FrameSheets([string] $sheet) {
	[string] $temp = "spritesheet*"
	if (Test-Path $sheet) { Remove-Item $sheet }
	if (Get-ChildItem $temp) { Remove-Item $temp }
}

[int] $export = 256
[string] $project = Get-YankLocationString "Desert-Rage-2"
$project += "/project/asset/resource/media/images/actors/player"
$word = 'frames'
[HashTable] $frames = Import-PowershellDataFile "$PSScriptRoot/frames.psd1"

Get-ChildItem 'forward', 'backward', 'left', 'right' -Directory -Recurse | ForEach-Object {
	[string] $f = $PSItem.FullName
	$animation = $f.Substring($f.IndexOf($word) + $word.length + 1)

	[string] $sheet = "$($PSItem.Name).png"
	[string] $target = "$project/$animation.png"
	[bool] $exists = Test-Path $target

	if ($force -or (-not $exists)) {
		[int] $size = Get-ArtFrameCount $frames $animation
		[int] $tile = [Math]::sqrt($size)

		Write-Host "..$animation" -NoNewLine
		Push-Location $animation

		Restore-FrameSheets $sheet
		magick.ps1 png $export $tile
		Move-Item "spritesheet.png" $sheet

		if (-not $exists) { New-Item $target -Force > $null }
		Copy-Item $sheet $target -Force
		Restore-FrameSheets $sheet

		Pop-Location
	}
}
