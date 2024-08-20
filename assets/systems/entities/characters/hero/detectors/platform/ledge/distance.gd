extends Node2D

var ray: RayCast2D

@onready var deployment = $deployment
@onready var rays: Array[Dictionary] = [
	$center.side, $right.side, $left.side]

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
