extends BehaviorActionPlayback

var caption: String

func get_context(options: Node, progress: Dictionary) -> Dictionary:
	return {
		"ost": SoundtrackSystem.user.world.boss.name,
		"ui": options.ui.world.boss.name,
		"progress": progress
	}

func tick(mark: Tick) -> int:
	var track: String = _context[caption]
	if track != "":
		mark.actor.player.load_music(track)
		return OK
	return FAILED
