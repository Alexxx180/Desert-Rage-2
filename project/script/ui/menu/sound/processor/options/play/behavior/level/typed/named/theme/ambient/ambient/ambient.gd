extends BehaviorSequence

@onready var check: BehaviorAction = $assert
@onready var theme: BehaviorSelector = $theme

@export var rampage: int = 0

var type: int:
	set(value): theme.named.type = value
var caption: int:
	set(value): theme.named.caption = value

func _ready() -> void:
	theme.status = name
	check.rampage = rampage
	theme.connect_rampage(check)

func set_ost(music: Node) -> void:
	theme.set_ost(music)
