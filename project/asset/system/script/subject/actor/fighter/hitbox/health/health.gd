extends Node

@onready var points: Node = $points
@onready var aura: Node = $aura
@onready var timer: Timer = $timer
@onready var burn: Timer = $burn

func thrown(box: CharacterBody2D) -> void:
	if box.logic.processors.movement.push.flying:
		hit(10)

func hit(amount: int = 1) -> void:
	if points.alive and not _apply_damage(amount): points.hit()

func burns(amount: int = 1) -> void:
	if points.alive: _apply_damage(amount)

func is_dead(no_points: bool) -> bool:
	if no_points: points.death()
	timer.start()
	return no_points

func refill(amount: int = 1) -> void:
	points.refill(amount)
	aura.react(points.segment)

func _apply_damage(amount: int = 1) -> bool:
	points.damage(amount)
	aura.react(points.segment)
	return is_dead(not points.alive)
