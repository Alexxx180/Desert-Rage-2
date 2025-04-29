extends OSTPlayer

@export var caption: String = "origin"

var i: int = 0
var _set: Array[Dictionary]
var _mixed: bool = false

func _ready() -> void:
	SoundtrackSystem.update.connect(set_tracks)

func _has_level(ost: Dictionary) -> bool:
	return ost.name.has(caption) and ost.name[caption].mix

func set_tracks() -> void:
	var ost: Dictionary = SoundtrackSystem.context.level.caves
	_mixed = ost.caves.type.theme.mix
	if _has_level(ost):
		_set = ost.name[caption]
	else:
		_set = ost.type.theme
	set_playback()

func stop_timing() -> void: pass
func start_timing() -> void:
	stop()
	_load_music()

func set_playback() -> void:
	i = i + 1 % _set.size()
	load_music(_set[i].ambient)

func _finished() -> void:
	set_playback()
