extends BehaviorAction

class_name HeroBattleTheme

var _context: Dictionary

enum { MIN = 0, MAX = 100, RAMPAGE = 1 }

func probable(mix: int) -> bool:
	return randi_range(mix, MAX) == MAX

func use_track(mix: int) -> bool:
	return mix != MIN and (mix == MAX or probable(mix))

func tick(mark: Tick) -> int:
	if use_track(_context.mix):
		mark.actor.player.load_music(_context.set.ray)
		mark.blackboard.set_value("rampage", RAMPAGE + 1)
		return OK
	return FAILED

func set_playback(options: Node, progress: Dictionary) -> void:
	progress.rampage = HeroBattleTheme.RAMPAGE
	_context = SoundtrackSystem.user.world.rampage.name
	var ui: Dictionary = options.ui.world.rampage.name
	for hero in _context:
		options.connect_ui(options.ui.set[hero], _context[hero], progress)
