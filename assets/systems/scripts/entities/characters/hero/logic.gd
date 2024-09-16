extends Node2D

@onready var stats: Node = $stats
@onready var detectors: Node2D = $detectors
@onready var processors: Node = $processors

var direction: Vector2i = Vector2i.ZERO
var velocity: int = 0

func set_direction(next: Vector2i): direction = next
func set_velocity(speed: int): velocity = speed

func set_control_entity(hero: CharacterBody2D):
	stats.run.connect(set_velocity)
	stats.set_control_entity(hero)
	detectors.set_control_entity(hero)
	processors.set_control_entity(hero)

func run(delta) -> Vector2:
	return direction * velocity * delta
