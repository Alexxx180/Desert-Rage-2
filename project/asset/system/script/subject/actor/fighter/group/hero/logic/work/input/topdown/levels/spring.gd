extends Node

enum { ID = 4, HEIGHT = 5, CELL = 64 } # 0 , TRY = 75000

@onready var ground: Node = $ground
@onready var control: Node = $control

var spring: ShapeCast2D

func perform_jump(_force: float) -> void:
	ground.activate_spring(control.slide.hero.position)
	control.jump(true)

func return_input() -> void:
#	ground.deactivate_spring()
	control.jump(false)

func gravity(delta: float) -> void:
	if spring.is_colliding() and Input.is_action_just_released("run"):
		perform_jump(1.0)
		ground.save(control.slide.hero.position.y)
	control.gravity(delta)
