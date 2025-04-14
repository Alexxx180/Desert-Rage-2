extends BehaviorSelector

@onready var named: BehaviorAction = $named
@onready var typed: BehaviorSelector = $typed

func set_ost(music: Node, caption: String) -> void:
	named.set_ost(music, caption)
	typed.set_ost(music)
