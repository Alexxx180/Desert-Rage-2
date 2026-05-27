class_name PillarChains extends RefCounted

enum { ID = 4, CONSTRAINT = 5, HEIGHT = 5, CELL = 64, ACCELERATION = 1000, GRAVITY = 500, JUMP = 25000 } # 700000  # , TRY = 75000 , SINGULARITY = 35000 # JUMP = -75000, GRAVITY = 375000 / 150 - 750
# TOOLS CHAINS

# CHAINS MOVE
var see: Node2D
var slide: ShapeCast2D
var walls: RayCast2D
var hero: CharacterBody2D
var height: float = 0
var is_sliding: bool:
	get: return slide.is_colliding()

var hanging: bool = false
var is_pressed: bool = false
var was_sliding: bool = false
var falling: bool = false


var world_y: float = 0.0 # @onready var deactivation: Timer = $deactivation

func process_physics(delta: float) -> void:
	if see.border.is_colliding():
		if hanging:
			hanging = false
			catch.encounter_ledge(false)
		return
	#view.animation.moves.hero.to.act.velocity.forget()

	if see.pillar.is_colliding():
		hanging = see.unit.is_colliding()
		if not hanging:
			encounter_ledge(false)
	
	if see.unit.is_colliding() and catch.hero_in_midair():
		hanging = true
		catch.ledge_in_midair()
	elif hanging:
		encounter_ledge(true)


# CHAINS CATCH
var input: Node
var control: Node
var view: Node2D

func hero_in_midair() -> bool: return control.slide.falling

func ledge_in_midair() -> void:
	control.land()
	encounter_ledge(true)

func encounter_ledge(active: bool) -> void:
	disable_collision(active)
	chains_animation(active)
	
func chains_animation(active: bool) -> void:
	view.shadow.hanging = active
	view.animation.moves.set_environment("chains" if active else "ground")

func disable_collision(active: bool) -> void:
	input.is_platformer = active
	chained.emit(active)
	control.layers.context(!active).collide_main()

# TOOLS JUMP
func _ready() -> void:
	spring.control.slide = slide

func process_physics(delta: float) -> void:
	slide.gravity(delta)
	spring.gravity(delta)

# JUMP SLIDE
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
	hero.velocity.y = GRAVITY # delta * 
	print("Y: ", hero.position.y)#, " - HEIGHT: ", height)
	if walls.is_colliding(): land()

func land() -> void:
	hero.velocity.y = 0
	falling = false
	height = 0

# SPRING JUMP
var spring: ShapeCast2D

func perform_jump(_force: float) -> void:
	ground.activate_spring(control.slide.hero.position)
	control.jump(true)

func return_input() -> void:
#	ground.deactivate_spring()
	control.jump(false)

func gravity(delta: float) -> void:
	if spring.is_colliding() and Input.is_action_just_released("run"):
		perform_jump(1.0)
		ground.save(control.slide.hero.position.y)
	control.gravity(delta)


# SPRING CONTROL
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

# SPRING GROUND
func switch_spring_tile() -> void:
	HUD.execute.switch(Def.to4(Def.SPRING_ON))

func press(condition: bool) -> bool:
	if condition: is_pressed = !is_pressed
	return condition

func activate_spring(hero_pos: Vector2) -> void:
	if press(not is_pressed):
		HUD.level.entity
		HUD.execute.from_pos(hero_pos)
		switch_spring_tile()
		deactivation.start()

func deactivate_spring() -> void:
	if press(is_pressed):
		switch_spring_tile()

func save(hero_y: float) -> void: world_y = hero_y + CONSTRAINT
