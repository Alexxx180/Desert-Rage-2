extends BehaviorTree

@onready var level: BehaviorSequence = $selector/level
@onready var world: BehaviorSelector = $selector/world

func set_playback(options: Node) -> void:
	level
