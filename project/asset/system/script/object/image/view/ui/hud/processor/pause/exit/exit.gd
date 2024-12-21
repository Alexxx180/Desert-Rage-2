extends InputObserver

@onready var shortcut: Node = $shortcut

func exit_the_game() -> void:
	get_tree().quit()
