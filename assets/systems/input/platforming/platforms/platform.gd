extends Area2D

@export var ledge_path: String = ""
@onready var track: CollisionShape2D = $track

var directions

const will: int = Node.PROCESS_MODE_INHERIT
const wont: int = Node.PROCESS_MODE_DISABLED

func _ready() -> void:
	directions = get_node("..")
	print(directions.name, " / ", directions.has_method("_ready"))
	if ledge_path != "":
		track.ledge = get_node(ledge_path)

func redefine_input(hero: CharacterBody2D, jump: int, move: int):
	hero.set_platforming(jump)
	hero.set_movement(move)

func _is_player(body: Node2D) -> bool:
	return (body is CharacterBody2D and track.ledge != null
		and body.floor.F == track.ledge.F)

func _on_track(body: Node2D):
	print("GOT IT")
	if body is CharacterBody2D and track.ledge != null:
		#print(track.ledge == null)
		print("HERO: ", body.floor.F, ", LEDGE: ", track.ledge.F)
	if _is_player(body):
		redefine_input(body, will, wont)
		directions.determine_jump(body)
		body.platforming.at(directions)
		print("PLATFORMING")
	elif body is StaticBody2D:
		track.intersect(body)

func _on_untrack(body: Node2D):
	if _is_player(body):
		redefine_input(body, wont, will)
		print("MOVING")
	elif body is StaticBody2D:
		track.parallel(body)
