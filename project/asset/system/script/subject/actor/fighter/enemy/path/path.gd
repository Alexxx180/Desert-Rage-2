extends Node

var enemy: CharacterBody2D
var target: Rect2
var transport_index: int = 0

func teleport(next: Vector2) -> void:
	enemy.velocity = Vector2.ZERO
	enemy.position = next

func dash(force: Vector2) -> void:
	teleport(enemy.position + force)

func reset_velocity(motion: Vector2) -> void:
	enemy.velocity = motion

func forget_velocity() -> void:
	reset_velocity(Vector2.ZERO)
	enemy.view.animation.move(Vector2.ZERO)

func travel(motion: Vector2) -> void:
	motion *= enemy.logic.processor.target.speed
	reset_velocity(motion)

func _physics_process(_delta: float) -> void:
	var motion: Vector2 = enemy.logic.processor.target.motion 
	enemy.view.animation.move(motion)
	reset_velocity(motion)
	enemy.move_and_slide()
