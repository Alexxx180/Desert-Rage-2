extends Node2D

@export_range(0.2, 2.0, 0.1) var weight: float = 1

@onready var stats: Node
@onready var block: Timer = $blocker
@onready var transporter = $transporter

func _ready() -> void:
	block.rollback.connect(transporter.booking.rollback.emit)

func set_control_entity(box: Node2D) -> void:
	stats = box.stats
	transporter.set_control_entity(box)

func get_impulse_from(body: Node2D) -> void:
	if body is CharacterBody2D:
		block.is_pushing = false
		push_object(body.stats)
	else:
		block.stop_impulse()

func _on_push(body: Node2D) -> void:
	if block.is_contact(): get_impulse_from(body)

func _push_along(track: PushTrack) -> void:
	var i: int = -1
	while not block.is_pushing and i < 1:
		i += 1
		if block.is_close(track.distance[i]):
			transporter.push(i, track.velocity)

func push_object(hero: Node):
	var power: int = hero.impulse() * weight
	var tracks: Array = PushTrack.plane(stats, hero, power)
	for track in tracks: _push_along(track)
