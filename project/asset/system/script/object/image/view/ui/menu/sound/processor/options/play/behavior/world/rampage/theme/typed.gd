extends BehaviorActionPlayback

func get_context(options: Node, progress: Dictionary) -> Dictionary:
	progress.rampage = HeroBattleTheme.RAMPAGE
	return {
		"ost": SoundtrackSystem.user.world.rampage.type.set,
		"ui": options.ui.world.rampage.type.set,
		"progress": progress
	}

func set_track(mark: Tick) -> void:
	var track: String = _context[0]
	mark.actor.player.load_music(track)

func set_fight(board: BehaviorBlackboard) -> void:
	var value: int = HeroBattleTheme.RAMPAGE + 1
	board.set_value("rampage", value)

func tick(mark: Tick) -> int:
	set_track(mark)
	set_fight(mark.blackboard)
	return OK
