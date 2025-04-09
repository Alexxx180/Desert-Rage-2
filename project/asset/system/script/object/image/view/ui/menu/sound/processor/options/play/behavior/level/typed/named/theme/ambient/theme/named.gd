extends BehaviorAction

var caption: int = 0
var _context: Dictionary

func mod_path(path: Array[String]) -> Array[String]:
	path.insert(2, "name")
	return path

func tick(mark: Tick) -> int:
	var key: String = "level_name"
	if mark.blackboard.compare(key, caption):
		mark.actor.player.load_music(_context.set[0])
		mark.blackboard.set_value(key, caption + 1)
		return OK
	return FAILED

func set_playback(options: Node, progress: Dictionary) -> void:
	var path: Array[String] = mod_path(progress.path)
	var context: Dictionary = SoundtrackSystem.get_value(options.ui, path)
	
	var ui: Dictionary = context.ui
	_context = context.user
	var entry: Dictionary = {
		"i": context.ui.set.size(),
		"ui": context.ui.set,
		"tracks": _context.set
	}
	while entry.i > 0:
		entry.i -= 1
		var leaf: HBoxContainer = entry.ui[entry.i]
		leaf.set_actions(options, entry.duplicate, progress)
