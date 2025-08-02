extends Node

#class_name GravityControl

signal landing()

enum { JUMP = 200000, SINGULARITY = 35000, GRAVITY = 700000 } # JUMP = -75000, GRAVITY = 375000 / 150 - 750

var mode: Node
var height: float = 0
var ground: float = 0
var platform: ShapeCast2D
var slide: ShapeCast2D

func jump() -> void: select_mode(true, -JUMP)
func land() -> void: select_mode(false, 0)

func select_mode(jumped: bool, target: float) -> void:
	height = target
	mode.hero.movement = gravity if jumped else floating # hero.motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED / CharacterBody2D.MOTION_MODE_FLOATING

func floating(delta: float) -> void:
	if slide.is_colliding():
		mode.hero.velocity.y = delta * (SINGULARITY + 10000)
	mode.hero.move_and_slide()

func gravity(delta: float) -> void: # if score > HEIGHT * CELL:	hero.velocity.y -= delta * TRY; score += delta * TRY # else:
	if slide.is_colliding():
		mode.hero.velocity.y = delta * (JUMP / 2.0) #
		print("SLIDING")
	else:
		mode.hero.velocity.y += delta * height

	if mode.hero.position.y >= ground + 1:
		# print("GROUND: ", ground, " - Y: ", mode.hero.position.y, " - H: ", delta * height)
		mode.hero.position.y = ground
		landing.emit()

	if height > SINGULARITY:
		height -= delta * height
	else:
		height += delta * GRAVITY
	
	if height > 0 and not platform.is_colliding() and Input.is_action_just_pressed("run"):
		landing.emit()
	#print("HEIGHT: ", height)
	mode.hero.move_and_slide()
