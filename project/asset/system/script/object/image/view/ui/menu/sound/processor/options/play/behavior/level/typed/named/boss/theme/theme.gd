extends BehaviorSelector

@onready var named: BehaviorAction = $named
@onready var typed: BehaviorSelector = $typed

func set_playback(options: Node, progress: Dictionary) -> void:
	named.set_playback(options, progress)
	typed.set_playback(options, progress)
