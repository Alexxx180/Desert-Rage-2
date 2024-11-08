extends Node2D

@onready var center: ShapeCast2D = $center
@onready var walls: Array[ShapeCast2D] = [$left, $right, center]

var current: ShapeCast2D = center
var F: int = 0

func set_center() -> void:
	current = center

func set_direction(direction: Vector2i) -> void:
	for wall in walls:
		wall.set_direction(direction)

func are_ledges(feet: Node, floors: TileMapLayer, overview: Node) -> bool:
	var same_floor: bool = false
	var i: int = walls.size()

	while not same_floor and i > 0:
		i -= 1
		current = walls[i]
		same_floor = (not current.is_colliding()
			and feet.is_same_floor(floors, overview))

	return same_floor
