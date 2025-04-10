extends BehaviorAction

class_name BehaviorActionPlayback

var _context: Variant

func get_context(_options: Node, progress: Dictionary) -> Dictionary:
	return { "progress": progress }

func set_playback(options: Node, progress: Dictionary) -> void:
	var context: Dictionary = get_context(options, progress)
	_context = context.ost
	_set_options(options, context)

func _set_options(options: Node, context: Dictionary) -> void:
	context.i = context.ui.size()
	while context.i > 0:
		context.i -= 1
		options.connect_ui(context.duplicate())
