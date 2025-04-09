extends BehaviorSelector

@onready var hero: BehaviorAction = $hero
@onready var typed: BehaviorAction = $typed

func set_playback(options: Node, progress: Dictionary) -> void:
	hero.set_playback(options, progress.duplicate())
	typed.set_playback(options, progress.duplicate())
