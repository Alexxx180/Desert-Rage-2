extends BehaviorSelector

@onready var named: BehaviorAction = $named
@onready var typed: BehaviorSelector = $typed

func set_playback(music: Node) -> void:
	named.set_ost(music)
	typed.set_ost(music)
