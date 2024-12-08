extends StaticBody2D

signal activate(tile: Dictionary)

@export var activated: bool = false

@onready var animation: AnimationPlayer = $animation
@onready var _atlas: Dictionary

func _toggle_to(next: String) -> void:
	activate.emit(_atlas)
	animation.play("levers/toggle_" + next)

func _ready() -> void:
	var logic: TileMapLayer = get_node("../../mark")
	activate.connect(logic.activators.activate)
	_atlas = Tiling.atlas(logic, position)

	if activated: _toggle_to("on")

func _toggle() -> void:
	activated = !activated
	_toggle_to("on" if activated else "off")
