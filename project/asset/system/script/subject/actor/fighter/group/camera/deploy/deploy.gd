extends Node2D

@onready var border: Node2D = $border
# @onready var heroes: Node2D = $heroes

var _count: int = 0

const DISTANCE: int = 128

func is_colliding(leader: Vector2, follow: Vector2) -> bool:
	if leader.distance_to(follow) >= DISTANCE:
		return false
	
	var dir: Vector2 = leader.direction_to(follow)
	print("DIR TO PARTNER: ", dir)
	dir = Vector2(roundi(dir.x), roundi(dir.y))
	
	if dir == Vector2.ZERO:
		return true
	# _count == HeroParty.COUNT and
	#print("DIR: ", dir, " - BORDER: ", not border.is_colliding(dir))
	#print("HEROES: ", heroes.is_colliding(dir)) # heroes.is_colliding(dir) and 
	return not border.is_colliding(dir)
