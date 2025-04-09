extends BehaviorAction

class_name BehaviorActionPlayback

var _context: Dictionary

func get_context(options: Node, progress: Dictionary) -> Dictionary:
	# SoundtrackSystem.get_value(ui, mod_path(progress.path))
	return {
		"ost": SoundtrackSystem.user.world.boss.type,
		"ui": options.ui.world.boss.type,
		"progress": progress
	}

# func get_ost_context(_ui: Dictionary, _progress: Dictionary) -> Dictionary:
#	return

#SoundtrackSystem.user.world.boss.type

# func get_ui_context(options: Node) -> Dictionary:
# 	return

#options.ui.world.boss.type

func set_playback(options: Node, progress: Dictionary) -> void:
	var context: Dictionary = get_context(options, progress)
	_context = context.ost # get_ost_context(options.ui, progress)
	_set_options(options, progress)

func _set_options(options: Node, context: Dictionary) -> void:
	var entry: Dictionary = _get_entry(context.ui)
	while entry.i > 0:
		entry.i -= 1
		options.connect_ui(entry.duplicate(), context.progress)

func _get_entry(ui: Dictionary) -> Dictionary:
	return {
		"i": ui.size(), "ui": ui,
		"ost": _context.set
	}
