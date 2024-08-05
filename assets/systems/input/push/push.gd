extends Node

var is_pushing: bool = false
var previous: Vector2
var entity: Node2D
var size: Node

@export var box: String = "../../.."
@export var gap: int = 2
@onready var block: Timer = $blocker

func _ready():
	entity = get_node(box)
	size = get_node(box + "/base/size")
	save()

func check_distance(distance: float):
	is_pushing = distance < gap

func save(): previous = entity.position
func pull(): entity.position = previous

func push(axis: int, velocity: int):
	save()
	entity.position[axis] += velocity

func _on_push(body: Node2D):
	if not block.can_push(): return

	if not body is CharacterBody2D:
		if is_pushing: block.cancel_push()
	else:
		is_pushing = false
		body.interaction.push_objects(self)
