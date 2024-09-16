extends Node2D

@onready var block: Timer = $blocker
@onready var transporter: Node = $transporter

var _size: Node
var _impulse: int = 0

func set_impulse(next: int) -> void: _impulse = next

func set_control_entity(hero: Node2D) -> void:
	var stats: Node = hero.logic.stats
	_size = stats.size
	stats.impulse.connect(set_impulse)
	transporter.set_control_entity(hero)

func _on_push(box: StaticBody2D) -> void:
	block.is_pushing = false

	var power: int = _impulse * box.weight
	var tracks: Array = PushTrack.plane(box.stats.size, _size, power)

	for track in tracks: _push_along(track, box)

func _push_along(track: PushTrack, box: StaticBody2D) -> void:
	var i: int = -1
	while not block.is_pushing and i < 1:
		i += 1
		if block.is_close(track.distance[i]):
			transporter.push(i, track.velocity, box)
