extends BehaviorActionPlayback

const MAX: int = 100

func probable(mix: int) -> bool:
	return mix != 0 and (mix == MAX or randi_range(_ost.mix, MAX) == MAX)

func _set_track(mark: Tick) -> void:
	mark.actor.player.load_music(_ost.set.ray)

func get_ost(options: Node, _progress: Dictionary) -> Dictionary:
	return {
		"ui": options.ui.world.rampage.name,
		"ost": SoundtrackSystem.user.world.rampage.name
	}

func tick(mark: Tick) -> int:
	if probable(_ost.mix):
		_set_track(mark)
		return OK
	return FAILED
