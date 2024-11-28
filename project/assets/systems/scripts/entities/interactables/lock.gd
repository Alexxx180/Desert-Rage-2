extends StaticBody2D

@export var activated: bool = false

@onready var animation: AnimationPlayer = $animation

func _unlock() -> void:
	if activated:
		animation.play("locks/open")
	else:
		animation.play("locks/close")

func activate() -> void:
	activated = !activated
	_unlock()

func _ready() -> void:
	if activated: _unlock()

	var activator: Vector2 = Vector2.ZERO # TODO determine method

	var interactables: Node = get_node("../logic/interactables")
	interactables.add_lock(activator, self)
