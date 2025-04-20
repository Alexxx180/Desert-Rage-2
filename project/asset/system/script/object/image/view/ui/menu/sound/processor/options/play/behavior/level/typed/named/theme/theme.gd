extends BehaviorSelector

@onready var ambient: BehaviorSelector = $ambient
@onready var boss: BehaviorSequence = $boss

var boss_fight: String:
	set(value): boss.level_boss = value

func set_ost(music: Node) -> void:
	ambient.set_ost(music)
	boss.set_ost(music)
