extends BehaviorAction

class_name BehaviorActionPlayback

var _ost: Variant

static func get_default_progress() -> Dictionary:
	return {
		"level": { "active": false, "name": 0, "type": 0 },
		"rampage": 0, "event": 0
	}

func get_track() -> Variant:
	var track: String = _ost.set[_ost.at]
	var size: int = _ost.set.size()
	if _ost.mix:
		var next: int = randi_range(_ost.at, _ost.at + size - 1)
		_ost.at = (next + 1) % size
	else:
		_ost.at = (_ost.at + 1) % size
	return track
