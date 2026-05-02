extends Node

signal interrogation()

@onready var points: Node = $points
@onready var aura: Node = $aura
@onready var burn: Timer = $burn

func _ready() -> void: burn.hit.timeout.connect(burns)

func thrown(box: CharacterBody2D) -> void:
	if box.logic.processors.movement.push.flying:
		hit(10)

func hit(amount: int = 1) -> void:
	print("points alive: ", points.alive)
	if points.alive:
		if not _apply_damage(amount): points.hit()
	else:
		interrogate()

func interrogate() -> void:
	aura.delay_diffuse()
	interrogation.emit()

func burns(amount: int = 1) -> void:
	if points.alive: _apply_damage(amount)

func is_dead(no_points: bool) -> bool:
	if no_points: points.death()
	aura.delay_diffuse()
	return no_points

func restore() -> void: refill(points.maximum)

func refill(amount: int = 1) -> void:
	points.refill(amount)
	aura.react(points.segment)
	aura.delay_diffuse()

func _apply_damage(amount: int = 1) -> bool:
	points.damage(amount)
	aura.react(points.segment)
	return is_dead(not points.alive)
