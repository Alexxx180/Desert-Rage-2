extends CharacterBody2D

enum { SPEED = 200, RANGE = 600 }

@onready var view: Node2D = $view

var target: Vector2 # Rect2
var direction: float = -1.0

func _ready() -> void:
	target.x = position.y + RANGE
	target.y = position.y - RANGE

func _physics_process(_delta: float) -> void:
	if position.y > target.x:
		direction = -1.0
	elif position.y < target.y:
		direction = 1.0
	var motion: Vector2 = Vector2(0, direction * SPEED)
	view.animation.move(motion)
	velocity = motion
	move_and_slide()

func teleport(_next: Vector2) -> void:
	velocity = Vector2.ZERO
	#target.position = position
	#target.size = next - position
	view.animation.action_move("jump")

func dash(force: Vector2) -> void: teleport(position + force)

# func move(proportion: float) -> void: position = target.position + target.size * proportion

func reset_velocity(motion: Vector2 = Vector2.ZERO) -> void: velocity = motion

func forget_velocity() -> void:
	reset_velocity()
	view.animation.move(Vector2.ZERO)

func travel(motion: Vector2) -> void:
	motion *= SPEED
	reset_velocity(motion)
