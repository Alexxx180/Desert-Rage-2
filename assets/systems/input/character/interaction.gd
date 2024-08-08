extends StaticBody2D

@export var push: int = 2

var hero: CharacterBody2D

func _push_forward(entity: Node2D, tracks: Array[float], velocity: int):
	if entity.is_pushing: return

	var i: int = -1
	while i < 1 and not entity.is_pushing:
		i += 1
		entity.check_distance(tracks[i])

	if entity.is_pushing:
		entity.push(i, velocity)

func push_objects(body: Node2D):
	var power: int = push * hero.movement.mach
	_push_forward(body, body.size.subtract(hero.size), -power)
	_push_forward(body, hero.size.subtract(body.size), power)
