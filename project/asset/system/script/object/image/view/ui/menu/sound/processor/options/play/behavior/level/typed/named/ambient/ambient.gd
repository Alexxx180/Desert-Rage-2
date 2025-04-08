extends BehaviorSequence

@onready var check: BehaviorAction = $assert
@onready var theme: BehaviorSelector = $theme

@export var rampage: int:
	set(value): check.rampage = value
var caption: int:
	set(value): theme.named.caption = value

func _ready() -> void: check.caption = name

func set_playback(options: Node, path: Array[String]) -> void:
	path.push_back(name)
	theme.set_playback(options, path)
