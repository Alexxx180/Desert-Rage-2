extends BehaviorActionPlayback

func mod_path(path: Array[String]) -> Array[String]:
	path[2] = "type"
	return path

func get_context(options: Node, progress: Dictionary) -> Dictionary:
	var path: Array[String] = mod_path(progress.path)
	var context: Dictionary = SoundtrackSystem.get_value(options.ui, path)
	return {
		"ost": context.user,
		"ui": context.ui.set,
		"progress": progress
	}

func tick(mark: Tick) -> int:
	var track: String = _context.boss.set[0]
	if track != "":
		mark.actor.player.load_music(track)
		return OK
	return FAILED
