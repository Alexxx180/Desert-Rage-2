extends StaticBody2D

signal activate(activator: Vector2)

@export var activated: bool = false

@onready var animation: AnimationPlayer = $animation

func _toggle_active() -> void:
	if activated:
		activate.emit(Vector2.ZERO)
		animation.play("levers/toggle_on")
	else:
		activate.emit(Vector2.ZERO)
		animation.play("levers/toggle_off")

func _ready() -> void:
	var interactables: Node = get_node("../../logic/interactables")
	activate.connect(interactables.activate)

	if activated: _toggle_active()

func _toggle() -> void:
	activated = !activated
	_toggle_active()
