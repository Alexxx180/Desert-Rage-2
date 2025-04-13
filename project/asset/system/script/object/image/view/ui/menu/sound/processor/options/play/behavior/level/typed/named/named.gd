extends BehaviorSelector

@onready var theme: BehaviorSequence = $theme
@onready var boss: BehaviorSequence = $boss

@export_category("Level")
@export var caption: int:
	set(value): theme.caption = value
@export var boss_fight: String:
	set(value): $boss.level_boss = value

var type: int:
	set(value): theme.type = value

func set_ost(music: Node) -> void:
	theme.set_ost(music)
	boss.set_ost(music)
