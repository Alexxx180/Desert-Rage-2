extends Node

@export var direction: Vector2 = Vector2(250, 0)

@onready var timer: Timer = $timer
@onready var cargo: Node = $cargo

const INVERSE: Vector2 = Vector2(-1, -1)
var enabled: bool = false

func control_cargo() -> void:
	if enabled or not cargo.platform.see.ledge.sync_traps():
		cargo.move_cargo(direction) #move_cargo()

func enable_control() -> void:
	enabled = false

func toggle_logic() -> void:
	direction *= INVERSE
	enabled = true
	timer.start()

func _physics_process(_delta: float) -> void:
	#if cargo.weight.size() >= 1:
	control_cargo()
	cargo.platform.move_and_slide()
