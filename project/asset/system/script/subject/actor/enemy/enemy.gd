extends CharacterBody2D

@onready var view: Node2D = $view
@onready var logic: Node2D = $logic

var target: Rect2
var transport_index: int = 0

func _physics_process(_delta: float) -> void:
	# print("MOTION: ", logic.path.target.motion)
	view.animation.move(logic.path.target.motion)
	velocity = logic.path.target.motion
	move_and_slide()

func _ready() -> void:
	view.animation.dead.health = logic.fight.hitbox.health
	view.animation.dead.path = logic.path.target
	logic.fight.hitbox.health.dead.connect(view.animation.dead_animation)

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
	motion *= logic.path.target.speed
	reset_velocity(motion)
