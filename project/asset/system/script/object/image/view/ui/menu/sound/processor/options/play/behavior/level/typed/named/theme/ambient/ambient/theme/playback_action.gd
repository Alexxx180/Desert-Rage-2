extends BehaviorAction

class_name BehaviorActionPlayback

var _ost: Variant

static func get_default_progress() -> Dictionary:
	return {
		"level": { "active": false, "name": 0, "type": 0 },
		"rampage": 0, "event": 0
	}

func get_track() -> Control:
	var at: int = 0
	if _ost.theme.has("at"):
		at = _ost.theme.at
	var size: int = _ost.theme.set.size()
	if _ost.theme.mix:
		var next: int = randi_range(at, at + size - 1)
		at = (next + 1) % size
	else:
		at = (at + 1) % size
	_ost.theme.at = at
	return _ost.ui.set[at]

func _set_track(mark: Tick) -> void:
	mark.actor.as_theme(_ost, get_track())
	# mark.actor.player.load_music(get_track())

func tick(mark: Tick) -> int:
	_set_track(mark)
	return OK
