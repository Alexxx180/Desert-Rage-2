extends BehaviorTree

@onready var level: BehaviorSequence = $selector/level
@onready var world: BehaviorSelector = $selector/world

func set_playback(options: Node) -> void:
	var progress: Dictionary = {
		"level": { "active": false, "type": 0, "name": 0 },
		"rampage": 0, "event": 0, "path": []
	}
	level.set_playback(options, progress.duplicate())
	world.set_playback(options, progress.duplicate())
