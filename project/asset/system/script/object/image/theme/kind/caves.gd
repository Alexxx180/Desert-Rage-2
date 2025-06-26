extends OSTPlayer

@export var caption: String = "origin"

var i: int = 0
var _set: Array
var _mixed: bool = false

@onready var tension: Node = $tension

func _ready() -> void:
	SoundtrackSystem.update.connect(set_tracks)
	tension.change_danger.connect(set_playback)

func _has_level(ost: Dictionary) -> bool:
	return ost.name.has(caption) and ost.name[caption].mix

func _set_number(tracks: Dictionary) -> void:
	i = tracks.at if tracks.has("at") else 0

func set_track(track: Dictionary) -> void:
	_set = track.set
	_set_number(track)

func set_tracks() -> void:
	var ost: Dictionary = SoundtrackSystem.user.music.level.caves
	_mixed = ost.type.theme.mix
	if _has_level(ost):
		set_track(ost.name[caption])
	else:
		set_track(ost.type.theme)
	next_playback() # TODO - enable

func stop_timing() -> void: pass
func start_timing() -> void:
	var paused: bool = stream_paused
	stop()
	_load_music()
	if paused: stream_paused = true

func next_playback() -> void:
	i = (i + 1) % _set.size()
	set_playback()

func set_playback() -> void:
	var previous = _set[i][tension.previous_state]
	if not previous is Dictionary:
		_set[i][tension.previous_state] = {
			"track": previous,
			"position": get_playback_position()
		}
	else:
		previous.position = get_playback_position()
	var actual: Variant = _set[i][tension.state]
	if actual is Dictionary:
		load_music(actual.track)
		# if get_playback_position()
		#if actual.position >= stream.get_length():
		#	actual.position = 0.0
		#else:
		seek(actual.position)
		# stream.get_length()
		print("LENGTH: ", stream.get_length())
		print("SEEK: ", actual.position)
	else:
		load_music(actual)

func _finished() -> void:
	if _set[i][tension.state] is Dictionary:
		_set[i][tension.state].position = 0.0
	next_playback()
