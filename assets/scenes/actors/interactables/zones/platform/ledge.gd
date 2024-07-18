extends Area2D

var box: Area2D
var direction: String
var acessibility: int = 0
@export var floors = [0]

func _ready():
	box = get_parent()
	direction = name

func _is_floor(body: Node2D, access: int) -> bool:
	var ledge: bool = not body is CharacterBody2D
	if ledge: acessibility = access
	return ledge

func climb_floor(next: int): if floors[-1] != next: floors.append(next)
func leave_floor(next: int): floors.pop_front()

func _on_exit(body: Node2D): _is_floor(body, acessibility - 1)
func _on_step(body: Node2D):
	#if _is_floor(body, acessibility + 1):
		#climb_floor()
	if not _is_floor(body, acessibility + 1) and box.compare(floors[-1]) and acessibility > 0:
		body.jump(direction)
