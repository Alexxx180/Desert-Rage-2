extends Node2D

@onready var borders: RayCast2D = $borders
# @onready var center: Node2D = $center
@onready var distance: Node2D = $distance

var same_floor: Callable
var target: Vector2 = Vector2.ZERO
var F: int = 0

func get_target_pos(i: int, j: int) -> Vector2:
	print("JUMP ZONE IS: ", distance.jump_zone.name)
	var jump_zone: Node2D = distance.jump_zone
	return jump_zone.position + jump_zone.ground[i].walls[j].position
	# return ground[i].position + ground[i].last_pos[j]

func set_center() -> void:
	target = get_target_pos(1, 2)

func set_direction(direction: Vector2i) -> void:
	borders.set_direction(direction)
	distance.set_direction(direction)

func is_ledge(i: int, floors: TileMapLayer = null) -> bool:
	var gap: bool = floors == null
	var ledge: bool = false
	
	var j: int = distance.jump_zone.ground[i].walls.size()
	
	while not ledge and j > 0:
		j -= 1
		var current: ShapeCast2D = distance.jump_zone.ground[i].walls[j]
		target = get_target_pos(i, j)
		# jump.is_same_floor
		
		ledge = not current.is_colliding() and (gap or same_floor.call(floors))
	
	print("LEDGE: ", i, ", ", j, " = ", get_target_pos(i, j))

	return ledge

func are_ledges(floors: TileMapLayer = null) -> bool:
	print("TRYING ")
	var ledge: bool = false
	var i: int = distance.jump_zone.ground.size()
	
	while not ledge and i > 0:
		i -= 1
		ledge = is_ledge(i, floors)

	print("END UP TRYING, result: ", "JUMPED" if ledge else "STAY")
	return ledge
