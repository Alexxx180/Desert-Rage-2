extends Node2D

@onready var borders: RayCast2D = $borders
@onready var center: ShapeCast2D = $center
@onready var walls: Array[ShapeCast2D] = [$left, $right, center]

var current: ShapeCast2D = center
var F: int = 0

func set_center() -> void:
	current = center

func set_direction(direction: Vector2i) -> void:
	borders.set_direction(direction)
	for wall in walls:
		wall.set_direction(direction)

func are_ledges(feet: Node, overview: Node, floors: TileMapLayer = null) -> bool:
	var gap: bool = floors == null
	var ledge: bool = false
	var i: int = walls.size()

	while not ledge and i > 0:
		i -= 1
		current = walls[i]
		ledge = (not current.is_colliding() and
			(gap or feet.is_same_floor(floors, overview)))

	return ledge
