extends InputObserver

@onready var tree: SceneTree = get_tree()

var ui: Control

func resume() -> void:
	ui.pause.hide()
	ui.game.show()
	tree.paused = false
