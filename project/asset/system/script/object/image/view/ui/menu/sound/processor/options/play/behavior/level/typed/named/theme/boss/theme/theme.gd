extends BehaviorSelector

@onready var named: BehaviorAction = $named
@onready var typed: BehaviorSelector = $typed

func set_ost(music: Node, caption: String) -> void:
	named.set_ost(music, caption)
	typed.set_ost(music)

func connect_rampage(check: Node) -> void:
	for action in [named, typed.level, typed.world]:
		action.progress.connect(check.add_rampage)
