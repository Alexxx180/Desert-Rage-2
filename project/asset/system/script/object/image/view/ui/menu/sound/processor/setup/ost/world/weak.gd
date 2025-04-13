extends OSTLeaf

func set_ost(options: Node) -> void:
	ost = { 
		"ui": options.ui.world.weak,
		"theme": SoundtrackSystem.user.music.world.weak,
		"play": func(_b): pass
	}
	set_leaf(options, ost)
