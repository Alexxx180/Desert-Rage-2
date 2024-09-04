extends Node

@export_range(0.2, 2.0, 0.1) var weight: float = 1

var hero: CharacterBody2D

func _push_forward(block: Timer, distance: Vector2, velocity: int):
	if block.is_pushing: return

	var i: int = -1
	while i < 1 and not block.is_pushing:
		i += 1
		block.check_distance(distance[i])

	if block.is_pushing:
		block.transporter.push(i, velocity)

func _push_along_the_trajectory(block: Timer, trajectory: Array):
	var power: int = hero.stats.impulse() * weight
	for track in trajectory:
		var distance: Vector2 = track[0].sub(track[1])
		_push_forward(block, distance, track[2] * power)

func push_objects(body: Node2D):
	var block: Node = body.stats.size
	var mover: Node = hero.stats.size
	var tracks: Array = [[block, mover, -1], [mover, block, 1]]
	_push_along_the_trajectory(body.block, tracks)
