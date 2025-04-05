extends BehaviorAction

var caption: int = 0

func _set_track(mark: Tick) -> void:
	var context: Array[String] = mark.blackboard.get_value("context")
	context.insert(2, "name")
	var ost: Dictionary = SoundtrackSystem.get_value(context)
	mark.actor.player.load_music(ost.set[0])

func tick(mark: Tick) -> int:
	var value: int = mark.blackboard.get_value("level_name")
	if value == caption:
		_set_track(mark)
		mark.blackboard.set_value("level_name", value + 1)
		return OK
	return FAILED
