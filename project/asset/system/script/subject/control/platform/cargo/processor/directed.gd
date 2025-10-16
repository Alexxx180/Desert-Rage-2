extends Node

@export var direction: Vector2 = Vector2(250, 0)

@onready var timer: Timer = $timer
@onready var cargo: Node = $cargo

const INVERSE: Vector2 = Vector2(-1, -1)

func move_cargo() -> void:
	cargo.move_cargo(direction)

func control_cargo() -> void:
	if not cargo.platform.see.ledge.sync_traps():
		move_cargo()

func enable_control() -> void:
	cargo.movement = control_cargo

func toggle_logic() -> void:
	direction *= INVERSE
	#cargo.movement = move_cargo
	timer.start()
