extends Node2D

@onready var borders: RayCast2D = $borders # @onready var center: Node2D = $center
@onready var distance: Node2D = $distance

var target_ground: Vector2 = Vector2.ZERO
var floors: Node
var recursed: int = 0

func same_ground(ground_offset: ShapeCast2D) -> bool:
	target_ground = distance.jump_zone.position + ground_offset.position
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
	var ledge: bool = _is_ledge(distance.jump_zone.ground, func(env):
		# var check: Callable = same_ground
		return _is_ledge(env.walls, same_ground))
	print("Jumped to" if ledge else "Stayed at", " ledge", (" = " + str(target_ground)) if ledge else "")
	return ledge
