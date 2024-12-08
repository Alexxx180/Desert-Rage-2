extends Area2D

signal pressed(tile: Dictionary)
signal release(tile: Dictionary)

@onready var animation: AnimationPlayer = $animation
@onready var _atlas: Dictionary

func _toggle(next: String) -> Dictionary:
	animation.play("buttons/button_" + next)
	return _atlas

func _ready() -> void:
	var logic: TileMapLayer = get_node("../../mark")
	_atlas = Tiling.atlas(logic, position)
	pressed.connect(logic.activators.activate)
	release.connect(logic.activators.activate)

var count: int = 0

func _on_press(_entity: CharacterBody2D) -> void:
	count += 1
	if count == 1: pressed.emit(_toggle("down"))

func _on_release(_entity: CharacterBody2D) -> void:
	count -= 1
	if count == 0: release.emit(_toggle("up"))
