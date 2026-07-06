extends Node

var caption: String = "origin"
var i: int = 0
var music: Array
var _mixed: bool = false
var set_tracks: Callable

var record: Variant:
	get: return music[i]
var ost: SoundtrackSystem
var is_overworld: bool:
	set(value):
		set_tracks = set_world_tracks if value else set_dungeon_tracks

func _set_number(tracks: Dictionary) -> void:
	i = tracks.at if tracks.has("at") else 0

func set_track(track: Dictionary) -> void:
	music = track.set
	_set_number(track)

func _has_level(_ost: Dictionary) -> bool:
	return _ost.name.has(caption) and _ost.name[caption].mix
# func set_tracks(ost: Dictionary) -> void: pass

func set_world_tracks() -> void:
	set_track(ost.user.music.world.ambient.type)
	# _mixed = ost.type.theme.mix

func set_dungeon_tracks() -> void:
	var _ost: Dictionary = ost.user.music.level.caves
	_mixed = _ost.type.theme.mix
	if _has_level(_ost):
		set_track(_ost.name[caption])
	else:
		set_track(_ost.type.theme)

func next_track() -> void:
	i = (i + 1) % music.size()
