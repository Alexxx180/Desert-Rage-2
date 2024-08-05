extends CollisionShape2D

var route: Dictionary
var ledge: Node2D = null
@onready var axis: Node = $axis

func front(hero: float, box: float) -> bool: return hero > box
func back(hero: float, box: float) -> bool: return hero < box

func _ready() -> void:
	axis.send_sides(front, back)

func jump(hero: CharacterBody2D) -> void:
	print("HERO JUMPED")
	if not axis.sides.has(hero.direction): return
	var boxes: Array[Node2D] = route.values()
	var i: int = boxes.size() - 1
	while i > 0 and not axis.jump(hero, boxes[i]): i = i - 1

func parallel(box: String) -> void: if route.has(box): route.erase(box)

func intersect(body: StaticBody2D) -> void:
	var id = body.get_instance_id()
	print(id)
	if route.has(id):
		printerr("Platform '", id, "' already present!")
	elif ledge == null or body.F == ledge.F:
		route[id] = body
