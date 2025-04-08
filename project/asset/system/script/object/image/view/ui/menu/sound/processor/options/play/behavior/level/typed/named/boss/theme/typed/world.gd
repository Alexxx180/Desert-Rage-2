extends BehaviorAction

var _context: Dictionary

func _set_track(mark: Tick) -> void:
	var track: String = _context.set[0]
	mark.actor.player.load_music(track)

func tick(mark: Tick) -> int:
	_set_track(mark)
	return OK

func set_playback(options: Node, progress: Dictionary) -> void:
	_context = SoundtrackSystem.user.world.boss.type
	var ui: Dictionary = options.ui.world.boss.type
	var i: int = ui.set.size()
	while i > 0:
		i -= 1
		options.connect_ui(ui.set[i], _context.set[i], progress)
