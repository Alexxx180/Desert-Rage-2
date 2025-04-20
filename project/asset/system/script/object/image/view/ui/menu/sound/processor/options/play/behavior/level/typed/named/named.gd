extends BehaviorSequence

@onready var theme: BehaviorSelector = $theme

@export_category("Level")
@export var caption: int = 0
@export var boss_fight: String = ""

var type: int:
	set(value): theme.ambient.type = value

func _ready() -> void:
	$assert.caption = caption
	theme.ambient.caption = caption
	theme.boss.level_boss = boss_fight

func set_ost(music: Node) -> void:
	theme.set_ost(music)
