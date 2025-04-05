extends AudioStreamPlayer

var extensions: Dictionary = {
	"mp3": AudioStreamMP3.new(),
	"ogg": AudioStreamOggVorbis.new()
}

func _load_data(path: String) -> PackedByteArray:
	var file = FileAccess.open(path, FileAccess.READ)
	return file.get_buffer(file.get_length())

func load_music(track: String) -> void:
	stop()
	var i: int = track.rfind(".")
	var type: String = track.substr(i).to_lower()
	if extensions.has(type):
		extensions[type].data = _load_data(track)
		stream = extensions[type]
	play()
