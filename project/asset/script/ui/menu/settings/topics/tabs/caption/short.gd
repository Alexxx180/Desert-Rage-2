extends Button

@onready var short: Node = $shortcut

func feedback() -> void: pressed.emit()
