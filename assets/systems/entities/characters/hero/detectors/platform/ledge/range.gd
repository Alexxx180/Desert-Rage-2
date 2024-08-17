extends Node2D

const SIDE: Vector3i = Vector3i(-1, 0, 1)

var ray: RayCast2D

@onready var deployment = $deployment
@onready var rays: Array[Dictionary] = [
	{ SIDE.x: $center/top, SIDE.z: $center/bottom },
	{ SIDE.x: $right/top, SIDE.y: $right/center, SIDE.z: $right/bottom },
	{ SIDE.x: $left/top, SIDE.y: $left/center, SIDE.z: $left/bottom },
]

func detect_floor(direction: Vector2i) -> void:
	assert(direction != Vector2i.ZERO)
	ray = rays[direction.x][direction.y]
	if ray.is_colliding():
		deployment.detect(ray.target_position)

func floor_detected() -> bool:

#	deployment.floors.monitoring = false
#	set_deffered("deployment.floors.monitoring", false)
	# deployment.floors.set_deffered("monitoring", false)
	# deployment.floors.process_mode = Node.PROCESS_MODE_DISABLED
	deployment.call_deferred("disable")
	return not deployment.walls.is_colliding()

func set_control_entity(hero: CharacterBody2D) -> void:
	deployment.hero = hero
