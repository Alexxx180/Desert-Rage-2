extends StaticBody2D

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

func push_objects(body: Node2D):
	var power: int = (hero.stats.push.value *
		hero.processing.movement.mach.value * weight)
	for track in [[body, hero, -1], [hero, body, 1]]:
		var distance = track[0].stats.size.sub(track[1].stats.size)
		_push_forward(body.block, distance, track[2] * power)
