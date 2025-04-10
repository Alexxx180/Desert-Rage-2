extends BehaviorActionPlayback

const RAMPAGE: int = 0

func get_context(options: Node, progress: Dictionary) -> Dictionary:
	progress.rampage = RAMPAGE
	return {
		"ost": SoundtrackSystem.user.world.ambient.type,
		"ui": options.ui.world.ambient.type,
		"progress": progress
	}

func tick(mark: Tick) -> int:
	var key: String = "rampage"
	if mark.blackboard.compare(key, RAMPAGE):
		mark.actor.player.load_music(_context[0])
		mark.blackboard.set_value(key, RAMPAGE + 1)
		return OK
	return FAILED
