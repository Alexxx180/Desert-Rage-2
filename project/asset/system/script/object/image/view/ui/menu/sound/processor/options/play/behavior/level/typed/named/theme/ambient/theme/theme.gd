extends BehaviorSelector

@onready var named: BehaviorAction = $named
@onready var typed: BehaviorAction = $typed

var status: String:
	set(value):
		named.status = value
		typed.status = value

func set_playback(options: Node, path: Array[String]) -> void:
	named.set_playback(options, path)
	typed.set_playback(options, path)
