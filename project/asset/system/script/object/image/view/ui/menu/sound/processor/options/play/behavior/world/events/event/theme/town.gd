extends BehaviorActionEvent

@export var scene: String = "town"

func set_track(mark: Tick) -> void:
	_determine_track(mark.actor.player, SoundtrackSystem.user.world.ambient.name[scene])
	super.set_track(mark)
