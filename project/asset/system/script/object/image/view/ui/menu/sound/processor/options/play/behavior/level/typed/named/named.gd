extends BehaviorSelector

@onready var rampage: Array[BehaviorSequence] = [$ambient, $heating, $rampage]
@onready var boss_fight: BehaviorSequence = $boss

@export_category("Level")
@export var caption: int:
	set(value):
		for status in rampage:
			status.caption = value
@export var boss: String:
	set(value): boss_fight.level_boss = value

func set_playback(options: Node, path: Array[String]) -> void:
	path.push_back(name)
	for status in rampage:
		status.set_playback(options, path.duplicate())
	boss_fight.set_playback(options, path.duplicate())
