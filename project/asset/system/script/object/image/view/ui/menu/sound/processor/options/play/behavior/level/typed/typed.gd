extends BehaviorSequence

var _type: int = 0

@export var type: int:
	set(value):
		_type = value
		$assert.type = value

func set_playback(options: Node) -> void:
	var named: Array[Node] = get_children()
	var i: int = named.size()
	var progress: Dictionary = {
		"level": { "active": true, "type": _type, "name": 0 },
		"rampage": 0, "event": 0, "path": ["level", name]
	}
	while i > 1:
		i -= 1
		named[i].set_playback(options, progress.duplicate())
