extends BehaviorAction

func set_track(mark: Tick) -> void:
	var track: String = SoundtrackSystem.user.world.rampage.type.set[0]
	mark.actor.player.load_music(track)

func set_rampage(board: BehaviorBlackboard) -> void:
	var value: int = board.get_value("rampage")
	board.set_value("rampage", value + 1)

func tick(mark: Tick) -> int:
	set_track(mark)
	set_rampage(mark.blackboard)
	return OK
