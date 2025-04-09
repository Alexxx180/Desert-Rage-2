extends BehaviorAction

const RAMPAGE: int = 0

var _context: Dictionary

func tick(mark: Tick) -> int:
	var key: String = "rampage"
	if mark.blackboard.compare(key, RAMPAGE):
		mark.actor.player.load_music(_context.set[0])
		mark.blackboard.set_value(key, RAMPAGE + 1)
		return OK
	return FAILED

func set_playback(options: Node, progress: Dictionary) -> void:
	progress.rampage = 0
	_context = SoundtrackSystem.user.world.ambient.type
	var ui: Array[String] = options.ui.world.ambient.type
	var entry: Dictionary = {
		"i": ui.size(), "ui": ui,
		"tracks": _context.set
	}
	while entry.i > 0:
		entry.i -= 1
		options.connect_ui(entry.duplicate(), progress)
