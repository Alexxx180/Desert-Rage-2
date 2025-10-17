extends Node2D

@onready var border: Node2D = $border
@onready var heroes: Node2D = $heroes

var _count: int = 0

func is_colliding(leader: Vector2, follow: Vector2) -> bool:
	var dir: Vector2 = leader.direction_to(follow)
	dir = Vector2(roundi(dir.x), roundi(dir.y))
	# _count == HeroParty.COUNT and
	#print("DIR: ", dir, " - BORDER: ", not border.is_colliding(dir))
	#print("HEROES: ", heroes.is_colliding(dir))
	return heroes.is_colliding(dir) and not border.is_colliding(dir)
