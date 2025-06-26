extends Node

var caption: String = "origin"
var i: int = 0
var music: Array
var _mixed: bool = false

var record: Variant:
	get: return music[i]

func _set_number(tracks: Dictionary) -> void:
	i = tracks.at if tracks.has("at") else 0

func set_track(track: Dictionary) -> void:
	music = track.set
	_set_number(track)

func _has_level(ost: Dictionary) -> bool:
	return ost.name.has(caption) and ost.name[caption].mix
	
func set_tracks(ost: Dictionary) -> void:
	_mixed = ost.type.theme.mix
	
	if _has_level(ost):
		set_track(ost.name[caption])
	else:
		set_track(ost.type.theme)

func next_track() -> void:
	i = (i + 1) % music.size()
