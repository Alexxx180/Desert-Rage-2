extends Node

@onready var topdown: Node = $topdown
@onready var platformer: Node = $platformer
@onready var current: Node = topdown

func _ready() -> void:
	var input: Node = get_parent()
	topdown.input = input
	platformer.input = input

func select(is_platformer: bool) -> void:
	current = platformer if is_platformer else topdown
	current.on_select()
