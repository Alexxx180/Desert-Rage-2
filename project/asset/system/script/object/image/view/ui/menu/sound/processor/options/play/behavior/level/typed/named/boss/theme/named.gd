extends BehaviorAction

var caption: String
var _context: Dictionary

func tick(mark: Tick) -> int:
	var track: String = _context[caption]
	if track != "":
		mark.actor.player.load_music(track)
		return OK
	return FAILED

func set_playback(options: Node, progress: Dictionary) -> void:
	_context = SoundtrackSystem.user.world.boss.name
	var ui: Dictionary = options.ui.world.boss.name
	var i: int = ui.set.size()
	while i > 0:
		i -= 1
		options.connect_ui(ui[i], _context[i], progress)
