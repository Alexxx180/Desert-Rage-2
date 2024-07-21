extends Area2D

var box: Area2D
var direction: String

@export var opposite: String
@export var floors: Array[int] = [0]

var F: int: get = _get_current_floor

func _get_current_floor(): return floors[-1]

func _ready():
	box = get_parent()
	direction = name

func _is_floor(tile: Node2D) -> bool: return "F" in tile
func is_same_floor() -> bool: return box.compare(F)

func climb_floor(next: int):
	print("Floor: ", next)
	floors.append(next)

func _on_exit(body: Node2D):
	if _is_floor(body):
		print("Floor: ", floors[-1])
		floors.pop_front()

func _on_step(body: Node2D):
	if _is_floor(body):
		climb_floor(body.F)
	elif is_same_floor():
		body.jump(direction)
	#print("STEP")
