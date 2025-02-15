Param([Parameter(Mandatory=$true)][string] $animation)

[int] $export = 256

[string] $project = Get-YankLocationString "Desert-Rage-2"
[string] $hero = (Get-Item .).Name
$project = "$project/project/asset/resource/media/images/actors/player/$hero/$animation"

[bool] $exists = Test-Path $animation
if (-not $exists) { return }

[int] $frames = Get-Content "$animation/frames.txt"
[int] $tile = [Math]::sqrt($frames)

Get-ChildItem $animation -Directory | ForEach-Object {
	[string] $sheet = $PSItem.Name
	[string] $progress = "$animation/$sheet"

	Write-Host "..$progress" -NoNewLine

	Push-Location $progress
	$sheet += ".png"
	[string] $default = "spritesheet.png"
	if (Test-Path $default) { Remove-Item $default }
	if (Test-Path $sheet) { Remove-Item $sheet }
	magick.ps1 png $export $tile
	Move-Item $default $sheet
	Copy-Item $sheet "$project/$sheet" -Force
	Pop-Location
}
