extends BehaviorSequence

class_name BossSoundtrack

const RAMPAGE: int = 3

@onready var check: BehaviorAction = $assert
@onready var theme: BehaviorSelector = $theme

var _caption: String

var level_boss: String:
	set(value):
		_caption = value
		$assert.has_boss = value != ""
		$assert.rampage = RAMPAGE

func set_ost(music: Node) -> void:
	theme.set_ost(music, _caption)

func _ready() -> void:
	theme.connect_rampage(check)
