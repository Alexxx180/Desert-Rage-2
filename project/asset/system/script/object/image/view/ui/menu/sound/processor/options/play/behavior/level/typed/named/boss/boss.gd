extends BehaviorSequence

class_name BossSoundtrack

const RAMPAGE: int = 4

@onready var theme: BehaviorSelector = $theme

var level_boss: String:
	set(value):
		$theme/named.caption = value
		$assert.has_boss = true

func set_playback(options: Node, progress: Dictionary) -> void:
	progress.path.push_back(name)
	progress.rampage = RAMPAGE
	theme.set_playback(options, progress)
