extends BehaviorSequence

@onready var rampage: Array[BehaviorSequence] = [$ambient, $heating, $rampage]

var caption: int:
	set(value):
		for status in rampage:
			status.caption = value

func set_playback(options: Node, progress: Dictionary) -> void:
	for status in rampage:
		status.set_playback(options, progress.duplicate())
