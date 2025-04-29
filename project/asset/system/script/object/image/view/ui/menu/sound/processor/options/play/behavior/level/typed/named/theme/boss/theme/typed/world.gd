extends BehaviorActionPlayback

signal progress(mark: Tick)

func set_ost(music: Node) -> void:
	_ost = music.world.typed.ost.boss

func tick(mark: Tick) -> int:
	super.tick(mark)
	progress.emit(mark)
	return OK
