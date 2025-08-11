function Get-LazyFramesCount {
	Process {
		if (-not $script:frames) {
			$script:frames = Import-PowershellDataFile "$PSScriptRoot/frames.psd1"
		}
		return $script:frames
	}
}

function Get-ArtFrames([string] $animation) {
	[HashTable] $frames = Get-LazyFramesCount
	[HashTable] $tile = @{ ratio = 16; found = $false; r = @(4, 9, 16) }

	for ($i = 0; ((-not $tile.found) -and ($i -lt $tile.r.count)); $i += 1) {

		$size = $tile.r[$i]
		$keys = $frames[$size]

		for ($j = 0; ((-not $tile.found) -and ($j -lt $keys.count)); $j += 1) {

			$key = $keys[$j]
			$tile.found = $key -in $animation.Contains($key)

			if ($tile.found) {
				$tile.ratio = $size
				Write-Host "($key)" -NoNewLine
			}
		}
	}

	return $tile.ratio
}

function Export-AnimationFrames([HashTable] $file) {
	Begin {
		[int] $size = Get-ArtFrames $file.animation
		[HashTable] $set = @{ tile = 128; path = "$($file.animation)/*.png"; ratio = [Math]::sqrt($size) }
	}

	Process {
		Start-ImageMagick $set.tile $set.ratio -Path $set.path -Name $file.target
		Write-Host "..$($file.animation)|$($set.tile)`X$($set.ratio)" -NoNewLine
	}
}

function Get-ProjectData {
	return @{ word = 'frames'; project = "$(Get-YankLocationString "games.Desert-Rage-2")/project/asset/resource/media/images/actors/player"
		items = @('forward', 'backward', 'left', 'right', 'forward-left', 'forward-right', 'backward-right', 'backward-left') }
}

function Get-FileData([HashTable] $data, $dir) {
	[string] $f = $dir.FullName
	[string] $animation = $f.Substring($f.IndexOf($data.word) + $data.word.length + 1)
	return @{ animation = $animation; target = "$($data.project)/$animation.png" }
}
