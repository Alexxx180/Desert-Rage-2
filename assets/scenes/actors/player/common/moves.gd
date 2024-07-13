extends CharacterBody2D

@export var speed: int = 10000
@export var control: bool = false

@onready var size: Vector2 = $collision.shape.size

var right: Vector2 : get = _calculate_right

func _calculate_right() -> Vector2:
	return position + size

func press(primary: String, secondary: String) -> float:
	var power: float = Input.get_action_strength(primary) - Input.get_action_strength(secondary)
	return power * speed
	
func move(delta):
	var run = 4 if Input.is_action_pressed("run") else 1
	velocity.x = press("right", "ui_left") * delta * run
	velocity.y = press("backward", "forward") * delta * run
	move_and_slide()

func _physics_process(delta):
	if (control):
		move(delta)
