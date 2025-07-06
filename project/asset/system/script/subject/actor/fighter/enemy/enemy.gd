extends CharacterBody2D

@onready var view: Node2D = $view
@onready var logic: Node2D = $logic

var target: Rect2
var transport_index: int = 0

func _physics_process(_delta: float) -> void:
	view.animation.move(logic.processor.target.motion)
	velocity = logic.processor.target.motion
	move_and_slide()

func _ready() -> void: logic.relation.controls(self)

func teleport(next: Vector2) -> void:
	velocity = Vector2.ZERO
	position = next

func dash(force: Vector2) -> void: teleport(position + force)

func reset_velocity(motion: Vector2 = Vector2.ZERO) -> void: velocity = motion

func forget_velocity() -> void:
	reset_velocity()
	view.animation.move(Vector2.ZERO)

func travel(motion: Vector2) -> void:
	motion *= logic.processor.target.speed
	reset_velocity(motion)
