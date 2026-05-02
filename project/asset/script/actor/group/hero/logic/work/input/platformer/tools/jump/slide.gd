extends Node

enum { ACCELERATION = 1000, GRAVITY = 500 } # 700000

var slide: ShapeCast2D
var walls: RayCast2D
var hero: CharacterBody2D

var falling: bool = false
var height: float = 0
var is_sliding: bool:
	get: return slide.is_colliding()
var was_sliding: bool = false

func gravity(delta: float) -> void:
	if is_sliding:
		slides(delta)
	elif falling:
		falls(delta)
	elif was_sliding:
		was_sliding = false
		hero.velocity.y = 0
	#else:
	#	hero.velocity.y = 0

func slides(delta: float) -> void:
	hero.velocity.y = ACCELERATION # delta * 
	was_sliding = true
	#if not is_sliding:
	#	hero.velocity.y = 0

func above(ground_y: float) -> bool:
	return hero.position.y <= ground_y - 1

func falls(delta: float) -> void:
	# height = max(-500, height + delta * GRAVITY) # delta * slide.height
	hero.velocity.y = GRAVITY # delta * 
	# hero.velocity.y = hero.velocity.y + delta * height
	print("Y: ", hero.position.y)#, " - HEIGHT: ", height)
	if walls.is_colliding(): land()

func land() -> void:
	hero.velocity.y = 0
	falling = false
	height = 0
