extends Node

@onready var tracking: Node = $tracking
@onready var tilemap: Node = $tilemap
@onready var floors: FloorsQueue = FloorsQueue.new()

# func _is_same(body: Node2D) -> bool: return body.get_instance_id() == get_instance_id()

func set_control_entity(entity: Node2D, velocity: Node, geometry: CollisionShape2D) -> void:
	tracking.entity = entity
	tracking.set_contacts(geometry.shape.size)
	velocity.directing.connect(tracking.set_direction)

func at_old_floor(body) -> void:
	if not (body == StaticBody2D or body != TileMap):
		floors.remove()

func at_new_floor(body) -> void:
	match body:
		StaticBody2D: floors.append(body.F) # StaticBody2D: not _is_same(body)
		TileMap: floors.append(tilemap.find_tile(body, tracking))
