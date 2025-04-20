extends AudioStreamPlayer

var _mp3: AudioStreamMP3 = AudioStreamMP3.new()

func _load_data(path: String) -> PackedByteArray:
	var file = FileAccess.open(path, FileAccess.READ)
	return file.get_buffer(file.get_length())

func _load_mp3(track: String) -> int:
	if not FileAccess.file_exists(track): return FAILED

	_mp3.data = _load_data(track)
	stream = _mp3
	return OK

func _load_ogg(track: String) -> int:
	if not FileAccess.file_exists(track): return FAILED

	stream = AudioStreamOggVorbis.load_from_file(track)
	return OK

func _get_extension(track: String) -> String:
	var period: int = track.rfind(".")
	return track.substr(period + 1)

func load_music(track: String) -> int:
	stop()
	var result: int
	match _get_extension(track).to_lower():
		"mp3": result = _load_mp3(track)
		"ogg": result = _load_ogg(track)
		_: result = ERR_BUSY
	if result == OK: play()
	return result
