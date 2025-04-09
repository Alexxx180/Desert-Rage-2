extends BehaviorAction

var _context: Dictionary

func mod_path(path: Array[String]) -> Array[String]:
	path[2] = "type"
	path.push_back("theme")
	return path

func tick(mark: Tick) -> int:
	mark.actor.player.load_music(_context.set[0])
	return OK

func set_playback(options: Node, progress: Dictionary) -> void:
	var path: Array[String] = mod_path(progress.path)
	var context: Dictionary = SoundtrackSystem.get_value(options.ui, path)
	
	var ui: Dictionary = context.ui
	_context = context.user
	var i: int = ui.set.size()
	while i > 0:
		i -= 1
		options.connect_ui(ui.set[i], _context.set[i], progress)
