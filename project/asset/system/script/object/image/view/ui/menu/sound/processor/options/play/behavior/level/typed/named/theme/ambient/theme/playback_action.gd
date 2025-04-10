extends BehaviorAction

class_name BehaviorActionPlayback

var _context: Variant

func get_context(_options: Node, _progress: Dictionary) -> Dictionary:
	return Defaults.DICT

func set_playback(options: Node, progress: Dictionary) -> void:
	var context: Dictionary = get_context(options, progress)
	_context = context.ost
	_set_options(options, context, progress)

func set_actions(options: Node, context: Dictionary) -> void:
	options.set_leaf_theme(context.duplicate())

func _set_options(options: Node, context: Dictionary, progress: Dictionary) -> void:
	context.progress = progress
	context.i = context.ui.size()
	while context.i > 0:
		context.i -= 1
		set_actions(options, context)
