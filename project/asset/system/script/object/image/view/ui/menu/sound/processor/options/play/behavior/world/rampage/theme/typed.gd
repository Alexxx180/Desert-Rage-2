extends BehaviorAction

var _context: Dictionary

func set_track(mark: Tick) -> void:
	var track: String = SoundtrackSystem.user.world.rampage.type.set[0]
	mark.actor.player.load_music(track)

func set_fight(board: BehaviorBlackboard) -> void:
	var value: int = HeroBattleTheme.RAMPAGE + 1
	board.set_value("rampage", value)

func tick(mark: Tick) -> int:
	set_track(mark)
	set_fight(mark.blackboard)
	return OK

func set_playback(options: Node, progress: Dictionary) -> void:
	progress.rampage = HeroBattleTheme.RAMPAGE
	_context = SoundtrackSystem.user.world.rampage.type
	var ui: Dictionary = options.ui.world.rampage.type
	var entry: Dictionary = {
		"i": ui.size(), "ui": ui,
		"tracks": _context.set
	}
	while entry.i > 0:
		entry.i -= 1
		options.connect_ui(entry.duplicate(), progress)
