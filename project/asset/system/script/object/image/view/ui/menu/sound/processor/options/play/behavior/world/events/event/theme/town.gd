extends BehaviorActionEvent

func set_ost(music: Node) -> void:
	_ost = music.world.named.ambient.named.town

func set_track(mark: Tick) -> void:
	_determine_track(mark.actor.player)
	super.set_track(mark)
