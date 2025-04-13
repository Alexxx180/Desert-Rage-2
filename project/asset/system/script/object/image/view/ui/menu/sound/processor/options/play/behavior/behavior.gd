extends BehaviorTree

@onready var level: BehaviorSequence = $location/level
@onready var world: BehaviorSelector = $location/world

func set_playback(options: Node) -> void:
	var progress: Dictionary = BehaviorActionPlayback.get_default_progress()
	level.set_playback(options, progress.duplicate())
	world.set_playback(options, progress.duplicate())
