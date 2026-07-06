extends OSTPlayer

func stop_timing() -> void: pass
func start_timing() -> void:
	var paused: bool = stream_paused
	stop()
	_load_music()
	if paused: stream_paused = true

func set_record_playback(record: Variant) -> void:
	if record is Dictionary:
		load_music(record.track)
		seek(record.position)
	else:
		load_music(record)
