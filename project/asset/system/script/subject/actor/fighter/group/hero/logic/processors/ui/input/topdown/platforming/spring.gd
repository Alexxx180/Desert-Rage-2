extends Node

enum { ID = 4, HEIGHT = 5, CELL = 64, TRY = 75000 } # 0

@onready var deactivation: Timer = $deactivation
@onready var ground: Node = $ground
@onready var control: Node = $control

var spring: ShapeCast2D

func perform_jump(_force: float) -> void:
	ground.activate_spring(control.hero.position)
	control.jump(true)

func return_input() -> void:
	control.jump(false)

func _input(_event: InputEvent) -> void:
	if spring.is_colliding() and Input.is_action_just_released("run"):
		perform_jump(1.0)
		ground.save(control.hero.position.y)
