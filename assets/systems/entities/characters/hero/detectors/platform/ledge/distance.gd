extends Node2D

var F: int = 0
var can_jump: bool = false

var ray: RayCast2D
var tracking: Node
var center: Vector2:
	get: return (tracking.get_contact(Vector2i.ZERO)
		+ (ray.target_position + deployment.geometry.shape.size / 2))

@onready var deployment = $deployment
@onready var rays: Array[Dictionary] = [
	$center.side, $right.side, $left.side]

func route(hero: CharacterBody2D) -> Vector2:
	return hero.position + ray.target_position

func floor_search(direction: Vector2i) -> void:
	assert(direction != Vector2i.ZERO)
	ray = rays[direction.x][direction.y]

	can_jump = ray.is_colliding()
	if can_jump:
		deployment.detect(ray.target_position)
		var map: TileMap = ray.get_collider()
		F = Tiler.get_tile(map, center)

func unreachable() -> bool:
	return not can_jump or deployment.walls.is_colliding()

func set_control_entity(hero: CharacterBody2D) -> void:
	deployment.set_control_entity(hero)
	tracking = hero.detectors.platform.floors.ground.tilemap.tracking
