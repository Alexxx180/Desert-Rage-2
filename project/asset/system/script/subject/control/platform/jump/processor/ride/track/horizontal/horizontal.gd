extends Node

signal forwarding(velocity: Vector2)
signal directing(direction: Vector2)

@onready var platform: CharacterBody2D
@onready var engine: Node = $engine

var seat: Node

func _physics_process(_delta: float) -> void:
	engine.process()
	platform.move_and_slide()
	seat.transport(platform.logic.see.stand.get_ledge_position())

func hero_entered(_hero: CharacterBody2D) -> void: pass

func apply_velocity(next: Vector2) -> void:
	forwarding.emit(next)
	directing.emit(next.normalized())
