extends Node

const POWER: int = 250

@onready var cargo: Node = $cargo

func control_cargo() -> void:
	var motion: Vector2 = cargo.platform.see.ledge.move()
	if motion != Vector2.ZERO:
		cargo.move_cargo(motion * POWER)

func _physics_process(_delta: float) -> void:
	if cargo.weight.size() >= 1:
		control_cargo()
