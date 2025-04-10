extends BehaviorActionPlayback

const MAX: int = 100

func probable(mix: int) -> bool:
	return mix != 0 and (mix == MAX or randi_range(_context.mix, MAX) == MAX)

func _set_track(mark: Tick) -> void:
	mark.actor.player.load_music(_context.set.ray)

func get_context(options: Node, _progress: Dictionary) -> Dictionary:
	return {
		"ui": options.ui.world.rampage.name,
		"ost": SoundtrackSystem.user.world.rampage.name
	}

func tick(mark: Tick) -> int:
	if probable(_context.mix):
		_set_track(mark)
		return OK
	return FAILED
