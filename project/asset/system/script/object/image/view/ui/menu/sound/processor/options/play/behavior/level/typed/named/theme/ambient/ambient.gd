extends BehaviorSequence

@onready var check: BehaviorAction = $assert
@onready var theme: BehaviorSelector = $theme

@export var rampage: int:
	set(value): $assert.rampage = value
var type: int:
	set(value): theme.named.type = value
var caption: int:
	set(value): theme.named.caption = value

func _ready() -> void:
	theme.status = name
