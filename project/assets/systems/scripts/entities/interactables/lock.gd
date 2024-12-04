extends StaticBody2D

@export var activated: bool = false

@onready var animation: AnimationPlayer = $animation
@onready var logic: TileMapLayer = get_node("../../logic")

func _toggle(next: String) -> void:
	animation.play("locks/" + next)

func activate() -> void:
	activated = !activated
	_toggle("open" if activated else "close")

func _ready() -> void:
	if activated: _toggle("open")

	var activators: Node = logic.get_node("activators")
	var tile: Dictionary = Tiling.atlas(logic, position)
	print("lock tile: ", tile)
	activators.add_lock(tile, self)
