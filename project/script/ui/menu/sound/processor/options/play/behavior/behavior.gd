@tool
extends BehaviorTree

@onready var level: BehaviorSequence = $location/level
@onready var world: BehaviorSelector = $location/world

func set_ost(music: Node) -> void:
	level.set_ost(music)
	world.set_ost(music)
