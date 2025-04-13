extends BehaviorSequence

class_name BossSoundtrack

const RAMPAGE: int = 3

@onready var theme: BehaviorSelector = $theme

var level_boss: String:
	set(value):
		$theme/named.caption = value
		$assert.has_boss = true

func set_ost(music: Node) -> void:
	theme.set_ost(music)
