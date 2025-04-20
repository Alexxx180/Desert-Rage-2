extends BehaviorActionPlayback

const RAMPAGE: int = 0

func set_ost(music: Node) -> void:
	_ost = music.world.typed.ost.ambient

func tick(mark: Tick) -> int:
	var key: String = "rampage"
	if mark.blackboard.compare(key, RAMPAGE):
		mark.actor.as_theme(_ost, get_track())
		# mark.actor.player.load_music(get_track())
		mark.blackboard.set_value(key, RAMPAGE + 1)
		return OK
	return FAILED
