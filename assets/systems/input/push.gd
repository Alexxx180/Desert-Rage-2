extends Area2D

@onready var size: Vector2 = $interaction.shape.size
var rightpos: Vector2 : get = _get_right

func _get_right(): return position + size
