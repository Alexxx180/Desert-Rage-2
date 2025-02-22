extends Node2D

@onready var borders: RayCast2D = $borders
@onready var center: Node2D = $center
@onready var ground: Array[Node2D] = [$bottom, center, $top]

var target: Vector2 = Vector2.ZERO
var F: int = 0

func get_target_pos(i: int, j: int) -> Vector2:
	return ground[i].position + ground[i].walls[j].position

func set_center() -> void:
	target = get_target_pos(1, 2)

func set_direction(direction: Vector2i) -> void:
	borders.set_direction(direction)
	for landing in ground:
		landing.set_direction(direction)

func is_ledge(i: int, jump: Node, floors: TileMapLayer = null) -> bool:
	var gap: bool = floors == null
	var ledge: bool = false
	var j: int = ground[i].walls.size()
	
	while not ledge and j > 0:
		j -= 1
		var current: ShapeCast2D = ground[i].walls[j]
		target = get_target_pos(i, j)
		print("target: ", target," - JUMP: ", gap or jump.is_same_floor(floors))
		ledge = not current.is_colliding() and (gap or jump.is_same_floor(floors))

	return ledge

func are_ledges(jump: Node, floors: TileMapLayer = null) -> bool:
	print("TRYING ")
	var ledge: bool = false
	var i: int = ground.size()
	
	while not ledge and i > 0:
		i -= 1
		ledge = is_ledge(i, jump, floors)

	print("END UP TRYING")
	return ledge
