extends BehaviorSelector

@onready var named: BehaviorAction = $named
@onready var typed: BehaviorAction = $typed

var status: String:
	set(value):
		named.status = value
		typed.status = value

func connect_rampage(check: BehaviorAction) -> void:
	for action in [named, typed]:
		action.progress.connect(check.add_rampage)

func set_ost(music: Node) -> void:
	named.set_ost(music)
	typed.set_ost(music)
