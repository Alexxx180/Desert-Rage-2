extends BehaviorAction

var progress: int = 0

func _set_track(mark: Tick) -> void:
	mark.actor.player.load_music(SoundtrackSystem.user.world.boss.type.set[0])

func tick(mark: Tick) -> int:
	var value: int = mark.blackboard.get_value("progress")
	if value == progress:
		_set_track(mark)
		mark.blackboard.set_value("progress", value + 1)
		return OK
	return FAILED
