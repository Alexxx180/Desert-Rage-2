extends Node

enum { ACCELERATION = 45000, GRAVITY = 700000 }

var slide: ShapeCast2D
var walls: ShapeCast2D
var hero: CharacterBody2D

var falling: bool = false
var height: float = 0
var is_sliding: bool:
	get: return slide.is_colliding()

func gravity(delta: float) -> void:
	if is_sliding:
		slides(delta)
	elif falling:
		falls(delta)

func slides(delta: float) -> void:
	hero.velocity.y = delta * ACCELERATION

func falls(delta: float) -> void:
	height -= delta * GRAVITY # delta * slide.height
	slides(hero.velocity.y + delta * height)
	if walls.is_colliding(): land()

func land() -> void:
	falling = false
	height = 0
