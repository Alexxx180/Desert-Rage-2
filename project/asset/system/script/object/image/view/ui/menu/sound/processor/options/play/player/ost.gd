extends AudioStreamPlayer

class_name OSTPlayer

var _track: String = ""
var _method: Callable

func _load_data(path: String) -> PackedByteArray:
	var file = FileAccess.open(path, FileAccess.READ)
	return file.get_buffer(file.get_length())

func _load_mp3() -> void:
	var sound: AudioStreamMP3 = AudioStreamMP3.new()
	sound.data = _load_data(_track)
	stream = sound

func _load_ogg() -> void:
	stream = AudioStreamOggVorbis.load_from_file(_track)

func _load_music() -> void:
	print("LOAD MUSIC")
	_method.call()
	play()

func _get_extension(track: String) -> String:
	var period: int = track.rfind(".")
	return track.substr(period + 1)

func stop_timing() -> void: stop()
func start_timing() -> void: pass

func load_music(track: String) -> int:
	_track = track
	stop_timing()
	match _get_extension(track).to_lower():
		"mp3": _method = _load_mp3
		"ogg": _method = _load_ogg
		_: return ERR_BUSY
	if not FileAccess.file_exists(track):
		return FAILED
	start_timing()
	return OK
