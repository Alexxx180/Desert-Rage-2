extends Node2D

const SIDE: Vector3i = Vector3i(-1, 0, 1)

var ray: RayCast2D

@onready var deployment = $deployment
@onready var rays: Array[Dictionary] = [
	{ SIDE.x: $center/top, SIDE.z: $center/bottom },
	{ SIDE.x: $right/top, SIDE.y: $right/center, SIDE.z: $right/bottom },
	{ SIDE.x: $left/top, SIDE.y: $left/center, SIDE.z: $left/bottom },
]

func route(hero: CharacterBody2D) -> Vector2:
	return hero.position + ray.target_position

func floor_search(direction: Vector2i) -> void:
	assert(direction != Vector2i.ZERO)
	ray = rays[direction.x][direction.y]
	if ray.is_colliding():
		deployment.detect(ray.target_position)

func reachable() -> bool:
	deployment.call_deferred("disable")
	return not deployment.walls.is_colliding()

func set_control_entity(hero: CharacterBody2D) -> void:
	deployment.hero = hero
