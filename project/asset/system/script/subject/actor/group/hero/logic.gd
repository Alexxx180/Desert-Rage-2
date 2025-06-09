extends Node2D

@export var stats: EntityStats

@onready var hero: CharacterBody2D = get_parent()
@onready var detectors: Node2D = $detectors
@onready var processors: Node = $processors
@onready var relations: Node = $relations

func _ready() -> void: stats.update_stats()

func jump_sequence(started: bool) -> void:
	var ended: bool = !started
	hero.turn_walls_collision(ended)
	processors.freeze_input[started].call()
	detectors.platforming.platforms.surface.overleap.turn_monitoring(ended)
	if ended: hero.forget_velocity()
