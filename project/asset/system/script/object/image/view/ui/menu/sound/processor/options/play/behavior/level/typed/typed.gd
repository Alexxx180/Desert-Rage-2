extends BehaviorSequence

@onready var check: BehaviorAction = $assert

@export var type: int:
	set(value):
		check.type = value
		set_levels(func(l): l.type = value)

func set_levels(feedback: Callable) -> void:
	var levels: Array[Node] = get_children()
	var i: int = levels.size()
	while i > 1:
		i -= 1
		feedback.call(levels[i])

func set_playback(music: Node) -> void:
	set_levels(func(l): l.set_ost(music))
