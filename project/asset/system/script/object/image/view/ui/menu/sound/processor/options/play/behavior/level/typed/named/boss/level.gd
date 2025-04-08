extends BehaviorAction

var _context: Dictionary

func mod_path(path: Array[String]) -> Array[String]:
	path[2] = "type"
	return path

func tick(mark: Tick) -> int:
	var track: String = _context.boss.set[0]
	if track != "":
		mark.actor.player.load_music(track)
		return OK
	return FAILED

func set_playback(options: Node, progress: Dictionary) -> void:
	var path: Array[String] = mod_path(progress.path)
	var context: Dictionary = SoundtrackSystem.get_value(options.ui, path)
	
	var ui: Dictionary = context.ui
	_context = context.user
	var i: int = ui.set.size()
	while i > 0:
		i -= 1
		options.connect_ui(ui.set[i], _context.set[i], progress)
