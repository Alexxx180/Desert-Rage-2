extends OSTLeaf

func set_leaf(options: Node, context: Dictionary) -> void:
	var ui: Dictionary = context.ui
	# ui.set.event.name = "weak"
	ui.set.set_options(options, context)

func set_ost(options: Node) -> void:
	ost = { 
		"ui": options.ui.world.weak,
		"theme": SoundtrackSystem.user.music.world.weak,
		"play": func(_b): pass
	}
	set_leaf(options, ost)
