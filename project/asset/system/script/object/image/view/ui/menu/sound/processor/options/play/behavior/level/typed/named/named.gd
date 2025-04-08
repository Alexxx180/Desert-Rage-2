extends BehaviorSelector

@onready var rampage: Array[BehaviorSequence] = [$ambient, $heating, $rampage]
@onready var boss_fight: BehaviorSequence = $boss

var _name: int = 0

@export_category("Level")
@export var caption: int:
	set(value):
		_name = value
		for status in rampage:
			status.caption = value
@export var boss: String:
	set(value): boss_fight.level_boss = value

func set_playback(options: Node, progress: Dictionary) -> void:
	progress.path.push_back(name)
	progress.level.name = _name
	for status in rampage:
		status.set_playback(options, progress.duplicate())
	boss_fight.set_playback(options, progress.duplicate())
