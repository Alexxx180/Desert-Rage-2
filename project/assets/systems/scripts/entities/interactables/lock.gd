extends StaticBody2D

@export var activated: bool = false

@onready var animation: AnimationPlayer = $animation
@onready var floors: TileMapLayer = get_node("../../floors")

func _toggle(next: String) -> void:
	animation.play("locks/" + next)

func activate() -> void:
	activated = !activated
	_toggle("open" if activated else "close")

func _get_tile() -> Dictionary:
	var coords: Vector2i = floors.local_to_map(position)
	return {
		"id": floors.get_cell_source_id(coords),
		"cell": floors.get_cell_atlas_coords(coords)
	}

func _ready() -> void:
	if activated: _toggle("open")

	var activators: Node = floors.get_node("activators")
	var tile: Dictionary = _get_tile()
	activators.add_lock(tile["id"], tile["cell"], self)
