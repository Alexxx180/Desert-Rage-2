extends CharacterBody2D

@export var speed: int = 40000

func press_power(main, alternate):
	return Input.get_action_strength(main) - Input.get_action_strength(alternate)
	
func move(delta) -> Vector2:
	velocity.x = press_power("ui_right", "ui_left") * delta * speed
	velocity.y = press_power("ui_down", "ui_up") * delta * speed
	return velocity

func _physics_process(delta):
	move(delta)
	move_and_slide()
