extends BehaviorSequence

@onready var check: BehaviorAction = $assert

@export var type: int:
	set(value): check.type = value

func set_playback(options: Node, progress: Dictionary) -> void:
	progress.type = check.type
	progress.path.push_back(name)
	var named: Array[Node] = get_children()
	var i: int = named.size()

	while i > 1:
		i -= 1
		named[i].set_playback(options, progress.duplicate())
