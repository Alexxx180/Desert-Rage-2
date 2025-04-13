extends BehaviorActionPlayback

func set_ost(music: Node) -> void:
	_ost = music.world.typed.ost.rampage.theme

func set_track(mark: Tick) -> void:
	mark.actor.player.load_music(get_track())

func set_fight(board: BehaviorBlackboard) -> void:
	var value: int = HeroBattleTheme.RAMPAGE + 1
	board.set_value("rampage", value)

func tick(mark: Tick) -> int:
	set_track(mark)
	set_fight(mark.blackboard)
	return OK
