extends BehaviorSelector

@onready var named: BehaviorAction = $named
@onready var typed: BehaviorAction = $typed

func set_ost(music: Node, event: int, caption: String) -> void:
	named.caption = caption
	named.set_ost(music, event)
	typed.set_ost(music)

func connect_rampage(check) -> void:
	for action in [named, typed]:
		action.progress.connect(check.add_rampage)
