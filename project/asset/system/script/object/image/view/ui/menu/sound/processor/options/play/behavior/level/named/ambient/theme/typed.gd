extends BehaviorAction

func _set_track(mark: Tick) -> void:
	var context: Array[String] = mark.blackboard.get_value("context")
	context[2] = "type"
	var ost: Dictionary = SoundtrackSystem.get_value(context)
	mark.actor.player.load_music(ost.theme.set[0])

func tick(mark: Tick) -> int:
	_set_track(mark)
	return OK
