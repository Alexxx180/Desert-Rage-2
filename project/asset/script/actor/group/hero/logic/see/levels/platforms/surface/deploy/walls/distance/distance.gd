extends RayCast2D

const distance: int = 57

@onready var directions: Dictionary = {
	Vector2i(-1, -1): $top_left, Vector2i(0, -1): $top_center,
	Vector2i(1, -1): $top_right, Vector2i(-1, 0): $left_center,
	Vector2i(1, 0): $right_center, Vector2i(-1, 1): $bottom_left,
	Vector2i(0, 1): $bottom_center, Vector2i(1, 1): $bottom_right
}
@onready var jump_zone: Node2D = directions[Vector2i(0, -1)]
@onready var dir: Vector2i

var target_ground: Vector2 = Vector2.ZERO
var floors: Node
var recursed: int = 0

func _set_jumpzone(direction: Vector2i) -> void:
	dir = direction
	if directions.has(direction):
		jump_zone = directions[direction]

func set_direction(direction: Vector2) -> void:
	var next: Vector2i = Vector2i(roundi(direction.x), roundi(direction.y))
	target_position = distance * next
	if direction != Vector2.ZERO:
		next.y = clampi(next.y, -1, 1)
		_set_jumpzone(next)

func same_ground(ground_offset: ShapeCast2D) -> bool:
	target_ground = jump_zone.position + ground_offset.position
	return not ground_offset.is_colliding() and floors.same_to_hero(target_ground)

func _is_ledge(ledges: Variant, check: Callable) -> bool:
	var ledge: bool = false
	var j: int = ledges.size()
	
	while not ledge and j > 0:
		j -= 1
		recursed += 1 # print("Ledge name is: ", ledges[j].name, " - R: ", recursed)
		ledge = check.call(ledges[j])
	
	return ledge

func are_ledges() -> bool:
	recursed = 0
	var ledge: bool = _is_ledge(jump_zone.ground, func(env): # var check: Callable = same_ground
		return _is_ledge(env.walls, same_ground))
	print("Jumped to" if ledge else "Stayed at", " ledge", (" = " + str(target_ground)) if ledge else "")
	return ledge
