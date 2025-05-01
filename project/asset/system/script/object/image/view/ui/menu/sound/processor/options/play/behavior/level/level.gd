extends BehaviorSequence

@onready var dungeon: BehaviorSelector = $dungeon

func set_ost(music: Node) -> void:
	dungeon.set_ost(music)
