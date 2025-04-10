extends BehaviorActionPlayback

func get_context(options: Node, _progress: Dictionary) -> Dictionary:
	return {
		"ost": SoundtrackSystem.user.world.boss.type,
		"ui": options.ui.world.boss.type
	}

func _set_track(mark: Tick) -> void:
	var track: String = _context[0]
	mark.actor.player.load_music(track)

func tick(mark: Tick) -> int:
	_set_track(mark)
	return OK
