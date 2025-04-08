extends BehaviorSelector

@onready var level: BehaviorAction = $level
@onready var world: BehaviorAction = $world

func set_playback(options: Node, progress: Dictionary) -> void:
	level.set_playback(options, progress)
	world.set_playback(options, progress)
