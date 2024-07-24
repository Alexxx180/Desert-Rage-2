extends Area2D

var box: Area2D
var direction: String

@export var opposite: String
@export var floors: Array[int] = [0]

var platform: bool = false
var F: int: get = _get_current_floor

func _get_current_floor(): return floors[-1]

func _ready(): direction = name

func _is_floor(tile: Node2D) -> bool: return "F" in tile
func is_same_floor() -> bool: return box.compare(F)

func climb_floor(next: int): floors.append(next)

func _on_exit(body: Node2D):
	if _is_floor(body):
		floors.pop_front()
		platform = false
	#else:
		#body.set_platforming(Node.PROCESS_MODE_DISABLED)

func add_direction(directions: Array[String]):
	if is_same_floor(): directions.append(opposite)

func _on_step(body: Node2D):
	if platform: return
	if _is_floor(body):
		climb_floor(body.F)
		platform = body.name == "floor"
	elif is_same_floor():
		print("PLATFORM")
		var directions: Array[String] = [direction]
		body.platforming.coordinate(directions)
		body.set_movement(Node.PROCESS_MODE_INHERIT)
		body.set_platforming(Node.PROCESS_MODE_INHERIT)
