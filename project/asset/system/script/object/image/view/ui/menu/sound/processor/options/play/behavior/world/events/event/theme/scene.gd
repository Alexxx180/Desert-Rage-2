extends BehaviorSequence

@onready var check: BehaviorAction = $assert
@onready var theme: BehaviorSelector = $theme

@export var event: int = 0

func set_ost(music: Node, event: int) -> void:
	theme.set_ost(music, event, name)

func _ready() -> void:
	check.event = event
	theme.connect_rampage(check)
