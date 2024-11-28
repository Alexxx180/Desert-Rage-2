extends Area2D

signal pressed(activator: Vector2)
signal release(activator: Vector2)

var _activator: Vector2 = Vector2.ZERO # TODO determine method
var count: int = 0

@onready var animation: AnimationPlayer = $animation

func _ready() -> void:
	var logic: TileMapLayer = get_node("../../logic")
	var interactables: Node = logic.get_node("interactables")
	pressed.connect(interactables.activate)
	release.connect(interactables.activate) # logic.local_to_map(position))
	print("USED: ", logic.get_used_cells())
	print("LOCAL: ", logic.local_to_map(position))
	print("LOGIC POSITION :", logic.get_cell_atlas_coords(logic.local_to_map(position)))

func _on_press(_entity: CharacterBody2D) -> void:
	count += 1
	if count == 1:
		animation.play("buttons/button_down")
		pressed.emit(_activator)

func _on_release(_entity: CharacterBody2D) -> void:
	count -= 1
	if count == 0:
		animation.play("buttons/button_up")
		release.emit(_activator)
