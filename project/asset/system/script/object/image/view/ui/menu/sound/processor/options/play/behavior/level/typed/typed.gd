extends BehaviorSequence

@export var type: int:
	set(value): $assert.type = value

func set_playback(options: Node) -> void:
	var named: Array[Node] = get_children()
	var i: int = named.size()
	while i > 1:
		i -= 1
		named[i].set_playback(options, ["level", name])
