extends CharacterBody2D

@export var push: int = 2
@export var speed: int = 10000
@export var control: bool = false

@onready var size: Vector2 = $collision.shape.size

var rightpos: Vector2 : get = _get_rightpos

func _get_rightpos() -> Vector2: return position + size

func press(primary: String, secondary: String) -> float:
	var power: float = Input.get_action_strength(primary) - Input.get_action_strength(secondary)
	return power * speed

func additional_force() -> int:
	return 4 if Input.is_action_pressed("run") else 1
	
func move(delta):
	var run = additional_force()
	velocity.x = press("right", "ui_left") * delta * run
	velocity.y = press("backward", "forward") * delta * run
	move_and_slide()

func _physics_process(delta):
	if (control):
		move(delta)
