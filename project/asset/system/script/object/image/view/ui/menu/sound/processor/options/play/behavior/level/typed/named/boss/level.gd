extends BehaviorAction

func get_context(mark: Tick) -> Dictionary:
	var context: Array[String] = mark.blackboard.get_value("context")
	context[2] = "type"
	return SoundtrackSystem.get_value(context)

func tick(mark: Tick) -> int:
	var track: String = get_context(mark).boss.set[0]
	if track != "":
		mark.actor.player.load_music(track)
		return OK
	return FAILED
