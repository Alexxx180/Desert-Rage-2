extends BehaviorSequence

class_name BossSoundtrack

const RAMPAGE: int = 3

@onready var theme: BehaviorSelector = $theme

var _caption: String

var level_boss: String:
	set(value):
		_caption = value
		$assert.has_boss = true

func set_ost(music: Node) -> void:
	theme.set_ost(music, _caption)
