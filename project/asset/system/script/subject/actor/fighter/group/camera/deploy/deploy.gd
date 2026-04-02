extends Node2D

@onready var edges: Array[Node2D] = [$mid, $right, $left]

const DISTANCE: int = 128

func _edge_colliding(motion: Vector2i) -> bool:
	return edges[motion.y].vertices[motion.x].is_colliding()

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
	return not _edge_colliding(dir)
