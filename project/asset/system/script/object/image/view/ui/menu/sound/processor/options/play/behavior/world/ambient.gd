extends BehaviorAction

const RAMPAGE: int = 0

func get_context(board: BehaviorBlackboard) -> Dictionary:
	var context: Array[String] = ["world"]
	board.set_value("context", context)
	return SoundtrackSystem.get_value(context)

func _set_track(mark: Tick) -> void:
	var ost: Dictionary = get_context(mark.blackboard)
	mark.actor.player.load_music(ost.ambient.type.set[0])

func tick(mark: Tick) -> int:
	var value: int = mark.blackboard.get_value("rampage")
	if value == RAMPAGE:
		_set_track(mark)
		mark.blackboard.set_value("rampage", value + 1)
		return OK
	return FAILED
