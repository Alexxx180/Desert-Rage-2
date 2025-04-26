extends Node

@onready var short: Node = $shortcut

func feedback() -> void: get_tree().quit()
