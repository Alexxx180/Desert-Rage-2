extends BehaviorSelector

@onready var level: BehaviorAction = $level
@onready var world: BehaviorAction = $world

func set_ost(music: Node) -> void:
	level.set_ost(music)
	world.set_ost(music)
