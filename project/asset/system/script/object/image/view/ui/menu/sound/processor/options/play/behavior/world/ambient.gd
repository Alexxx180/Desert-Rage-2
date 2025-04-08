extends BehaviorAction

const RAMPAGE: int = 0

var _context: Dictionary

func tick(mark: Tick) -> int:
	var value: int = mark.blackboard.get_value("rampage")
	if value == RAMPAGE:
		mark.actor.player.load_music(_context.set[0])
		mark.blackboard.set_value("rampage", value + 1)
		return OK
	return FAILED

func set_playback(options: Node, progress: Dictionary) -> void:
	progress.rampage = 0
	_context = SoundtrackSystem.user.world.ambient.type
	var ui: Dictionary = options.ui.world.ambient.type
	var i: int = ui.set.size()
	while i > 0:
		i -= 1
		options.connect_ui(ui.set[i], _context.set[i], progress)
