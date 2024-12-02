extends Area2D

signal pressed(activator: Vector2)
signal release(activator: Vector2)

var count: int = 0

@onready var animation: AnimationPlayer = $animation
@onready var floors: TileMapLayer = get_node("../../floors")

func _get_tile() -> Dictionary:
	var coords: Vector2i = floors.local_to_map(position)
	return {
		'id': floors.get_cell_source_id(coords),
		'cell': floors.get_cell_atlas_coords(coords)
	}

func _toggle(next: String) -> Dictionary:
	animation.play("buttons/button_" + next)
	return _get_tile()

func _ready() -> void:
	var activators: Node = floors.get_node("activators")
	pressed.connect(activators.activate)
	release.connect(activators.activate) # logic.local_to_map(position))
	#print("POS: ", position)
	#print("USED: ", logic.get_used_cells())
	#print("LOCAL: ", logic.local_to_map(position))

func _on_press(_entity: CharacterBody2D) -> void:
	count += 1
	if count == 1:
		var tile: Dictionary = _toggle("down")
		pressed.emit(tile['id'], tile['cell'])

func _on_release(_entity: CharacterBody2D) -> void:
	count -= 1
	if count == 0:
		var tile: Dictionary = _toggle("up")
		release.emit(tile['id'], tile['cell'])
