extends Node

enum { JUMP = 25000 } # , SINGULARITY = 35000 # JUMP = -75000, GRAVITY = 375000 / 150 - 750

var ground: Node
var slide: Node
var input: Node
var layers: Node
var platform: ShapeCast2D # func singularity_point(delta: float) -> void: if slide.height > SINGULARITY: slide.height -= delta * slide.height; else: slide.falling = true; slide.height = height#; += delta * GRAVITY

func jump(jumped: bool) -> void:
	# slide.height = -JUMP if jumped else 0 # hero.movement = gravity if jumped else floating # hero.motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED / CharacterBody2D.MOTION_MODE_FLOATING
	if jumped:
		slide.hero.velocity.y = -JUMP
	slide.falling = jumped
	layers.context(!jumped).collide_main()#.collide(Lay.BORDERS) BAD IDEA
	input.is_platformer = jumped # hero.logic.work.world.layers.context(!jumped).collide_main().collide(Lay.BORDERS) # hero.logic.work.input.modes.select(jumped)

func land() -> void:
	slide.land()
	jump(false)

func landing_crash() -> void:
	if not slide.above(ground.world_y):
		land() # hero.position.y = ground #print("GROUND: ", ground, " - Y: ", mode.hero.position.y, " - H: ", delta * height) # landing.emit()

func landing_manual() -> void: # flying and 
	if not platform.is_colliding() and Input.is_action_just_pressed("run"): # landing.emit()
		land() # height > 0

func gravity(delta: float) -> void: #if score > HEIGHT * CELL:	hero.velocity.y -= delta * TRY; score += delta * TRY # else: # if not slide.is_colliding():
	if slide.falling:
		landing_manual() #	singularity_point(delta)
		landing_crash()
