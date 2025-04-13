extends BehaviorSelector

@onready var level: BehaviorAction = $level
@onready var world: BehaviorAction = $world

func set_playback(music: Node) -> void:
	level.set_playback(music)
	world.set_playback(music)
