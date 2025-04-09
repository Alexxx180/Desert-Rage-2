extends BehaviorSelector

@onready var theme: BehaviorSequence = $theme
@onready var boss_fight: BehaviorSequence = $boss

var _name: int = 0

@export_category("Level")
@export var caption: int:
	set(value):
		_name = value
		theme.caption = value
@export var boss: String:
	set(value): boss_fight.level_boss = value

func set_playback(options: Node, progress: Dictionary) -> void:
	progress.path.push_back(name)
	progress.level.name = _name
	theme.set_playback(options, progress.duplicate())
	boss_fight.set_playback(options, progress.duplicate())
