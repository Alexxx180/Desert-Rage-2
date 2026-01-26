extends HBoxContainer

@onready var face: Label = $face

func right() -> void:
	remove_child(face)
	add_child(face)
