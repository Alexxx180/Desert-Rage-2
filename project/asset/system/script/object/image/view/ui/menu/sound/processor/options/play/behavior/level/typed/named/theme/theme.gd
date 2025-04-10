extends BehaviorSequence

@onready var rampage: Array[BehaviorSequence] = [$ambient, $heating, $rampage]

var caption: int:
	set(value):
		for status in rampage:
			status.caption = value

func set_playback(options: Node, progress: Dictionary) -> void:
	for status in rampage:
		status.set_playback(options, progress.duplicate())

func get_context(options: Node, progress: Dictionary) -> Dictionary:
	return SoundtrackSystem.get_value(options.ui, progress.path)

func set_actions(options: Node, context: Dictionary) -> void:
	options.set_ambient_theme(context.duplicate())
