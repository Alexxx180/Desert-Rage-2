extends Node

const POWER: int = 250

@onready var cargo: Node = $cargo

func control_cargo() -> void:
	var motion: Vector2 = cargo.platform.see.ledge.move()
	if motion != Vector2.ZERO:
		cargo.move_cargo(motion * POWER)
