extends Node2D

var F: int = 0
var can_jump: bool = false
var hero: CharacterBody2D
var tracking: Node
var center: Vector2:
	get: return (tracking.get_contact(Vector2i.ZERO)
		+ (position + geometry.shape.size / 2))

@onready var walls: ShapeCast2D = $walls
@onready var floors: Area2D = $floors
@onready var geometry: CollisionShape2D = floors.get_node("geometry")

func set_mode(processing: ProcessMode):
	walls.process_mode = processing
	#floors.process_mode = processing

func disable():
	#set_mode(Node.PROCESS_MODE_DISABLED)
	#position = Vector2.ZERO
	F = 0
	can_jump = false

func detect(target: Vector2) -> void:
	print("TARGETING: ", target)
	position = target
	set_mode(Node.PROCESS_MODE_INHERIT)

func set_control_entity(entity: CharacterBody2D):
	hero = entity
	tracking = hero.detectors.platform.floors.ground.tilemap.tracking

func jump_to_floor(surface: TileMap) -> void:
	F = Tiler.get_tile(surface, center)
	print("FLOOR IS? ", F)
	can_jump = true
