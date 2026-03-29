extends VBoxContainer

@onready var first: Control = $first

func append(next: Label) -> void:
	add_child(next)

func insert(next: Label) -> void:
	next.visible_characters = -1
	first.add_sibling(next)
