extends Node2D

var F: int = 0

var ray: RayCast2D
var tracking: Node
var center: Vector2:
	get: return (tracking.get_contact(Vector2i.ZERO)
		+ (ray.target_position + deployment.shape.size / 2))

@onready var deployment = $deployment
@onready var rays: Array[Dictionary] = [
	$center.side, $right.side, $left.side]

func route(hero: CharacterBody2D) -> Vector2:
	return hero.position + ray.target_position

func floor_search(direction: Vector2i) -> bool:
	if direction == Vector2i.ZERO: return false

	ray = rays[direction.x][direction.y]

	var reach: bool = ray.is_colliding()
	if reach:
		deployment.position = ray.target_position
		F = Tiler.get_tile(ray.get_collider(), center)
	
	reach = reach and not deployment.is_colliding()
	deployment.position = Vector2.ZERO
	
	return reach

func set_control_entity(hero: CharacterBody2D) -> void:
	tracking = hero.detectors.platform.floors.ground.tilemap.tracking
