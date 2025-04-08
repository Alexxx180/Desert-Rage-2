extends BehaviorAction

var caption: int = 0
var _context: Dictionary

func mod_path(path: Array[String]) -> Array[String]:
	path.insert(2, "name")
	return path

func tick(mark: Tick) -> int:
	var value: int = mark.blackboard.get_value("level_name")
	if value == caption:
		mark.actor.player.load_music(_context.set[0])
		mark.blackboard.set_value("level_name", value + 1)
		return OK
	return FAILED

func set_playback(options: Node, path: Array[String]) -> void:
	var context: Dictionary = SoundtrackSystem.get_value(options.ui, mod_path(path))
	
	var ui: Dictionary = context.ui
	_context = context.user
	var i: int = ui.set.size()
	while i > 0:
		i -= 1
		options.connect_ui(ui.set[i], _context.set[i])
