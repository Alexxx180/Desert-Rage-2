extends BehaviorAction

var progress: int = 0

func _set_track(mark: Tick) -> void:
	var context: Array[String] = mark.blackboard.get_value("context")
	context[2] = "type"
	var ost: Dictionary = SoundtrackSystem.get_value(context)
	mark.actor.player.load_music(ost.boss.set[0])

func tick(mark: Tick) -> int:
	var value: int = mark.blackboard.get_value("progress")
	if value == progress:
		_set_track(mark)
		mark.blackboard.set_value("progress", value + 1)
		return OK
	return FAILED
