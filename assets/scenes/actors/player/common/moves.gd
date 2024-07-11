extends CharacterBody2D

@export var speed: int = 40000

func press(primary: String, secondary: String) -> float:
	var power: float = Input.get_action_strength(primary) - Input.get_action_strength(secondary)
	return power * speed
	
func move(delta):
	velocity.x = press("right", "ui_left") * delta
	velocity.y = press("backward", "forward") * delta
	move_and_slide()

func _physics_process(delta):
	move(delta)
