extends BehaviorSelector

@onready var named: BehaviorAction = $named
@onready var typed: BehaviorAction = $typed

func set_playback(options: Node, path: Array[String]) -> void:
	named.set_playback(options, path)
	typed.set_playback(options, path)
