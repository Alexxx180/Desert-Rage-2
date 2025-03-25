extends InputObserver

@onready var tree: SceneTree = get_tree()

var ui: Control

func suspend() -> void:
	ui.game.hide()
	ui.pause.show()
	ui.pause.options.menu.focused = false
	tree.paused = true
