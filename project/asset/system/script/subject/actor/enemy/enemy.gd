extends CharacterBody2D

enum { SPEED = 200, RANGE = 200 }

@onready var view: Node2D = $view
@onready var hitbox: StaticBody2D = $hitbox
@onready var timer: Timer = $timer

var target: Rect2
var direction: float = -1.0
var transport_index: int = 0

#func init() -> void:
#	target.x = position.y + RANGE
#	target.y = position.y - RANGE

func _physics_process(_delta: float) -> void:
	var motion: Vector2 = Vector2(0, direction * SPEED)
	# print("MOTION: ", motion)
	view.animation.move(motion)
	velocity = motion
	move_and_slide()

func ally_obstacle(_body) -> void:
	timer.start()
	# if timer.seek > 0:
	#	direction *= -1

func avoid_obstale() -> void:
	direction *= -1

func teleport(next: Vector2) -> void:
	velocity = Vector2.ZERO
	position = next
	#target.position = position
	#target.size = next - position
	# view.animation.action_move("jump")

func dash(force: Vector2) -> void: teleport(position + force)

# func move(proportion: float) -> void: position = target.position + target.size * proportion

func reset_velocity(motion: Vector2 = Vector2.ZERO) -> void: velocity = motion

func forget_velocity() -> void:
	reset_velocity()
	view.animation.move(Vector2.ZERO)

func travel(motion: Vector2) -> void:
	motion *= SPEED
	reset_velocity(motion)
