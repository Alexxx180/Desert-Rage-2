extends Node2D

var hero: CharacterBody2D
var tracking: Node
var center: Vector2:
	get: return (tracking.get_contact(Vector2i.ZERO)
		+ (position + geometry.shape.size / 2))

@onready var walls: ShapeCast2D = $walls
@onready var floors: Area2D = $floors
@onready var geometry: CollisionShape2D = floors.get_node("geometry")

func disable():
	position = Vector2.ZERO
	floors.process_mode = Node.PROCESS_MODE_DISABLED

func detect(target: Vector2) -> void:
	position = target
	floors.process_mode = Node.PROCESS_MODE_INHERIT

func set_control_entity(entity: CharacterBody2D):
	hero = entity
	tracking = hero.detectors.platform.floors.ground.tilemap.tracking
