extends StaticBody2D

@export var activated: bool = false

@onready var animation: AnimationPlayer = $animation
@onready var stand: Area2D = $stand

func _toggle(next: String) -> void:
	animation.play("locks/" + next)

func activate() -> void:
	activated = !activated
	_toggle("open" if activated else "close")

func _ready() -> void:
	if activated: _toggle("open")

	var logic: TileMapLayer = get_node("../../mark")
	var activators: Node = logic.get_node("activators")
	var tile: Dictionary = Tiling.atlas(logic, position)

	stand.box = self
	stand.seat = $seat

	#print("lock tile: ", tile)
	activators.add_lock(tile, self)
