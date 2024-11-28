extends StaticBody2D

signal activate(id: int, activator: Vector2)

@export var activated: bool = false

@onready var animation: AnimationPlayer = $animation
@onready var floors: TileMapLayer = get_node("../../floors")

func _get_tile() -> Dictionary:
	var coords: Vector2i = floors.local_to_map(position)
	return {
		'id': floors.get_cell_source_id(coords),
		'cell': floors.get_cell_atlas_coords(coords)
	}

func _toggle_to(next: String) -> void:
	var tile: Dictionary = _get_tile()
	activate.emit(tile['id'], tile['cell'])
	animation.play("levers/toggle_" + next)

func _ready() -> void:
	var activators: Node = floors.get_node("activators")
	activate.connect(activators.activate)

	if activated: _toggle_to("on")

func _toggle() -> void:
	activated = !activated
	_toggle_to("on" if activated else "off")
