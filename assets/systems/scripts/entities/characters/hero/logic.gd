extends Node2D

@onready var stats: Node = $stats
@onready var detectors: Node2D = $detectors
@onready var processors: Node = $processors

var direction: Vector2i = Vector2i.ZERO
var velocity: int = 0

func set_direction(next: Vector2i) -> void: direction = next
func set_velocity(speed: int) -> void: velocity = speed

func set_control_entity(hero: CharacterBody2D) -> void:
	stats.size.set_control_entity(hero)
	processors.set_control_entity(hero)

func run(delta) -> Vector2:
	return direction * velocity * delta
