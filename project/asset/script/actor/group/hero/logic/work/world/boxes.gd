class_name LevelBoxes extends RefCounted

enum { BORDERS, WORLD, ENTITY, GROUND, SLIDE = 2, POWER = 40000 } # , JUMP = 200000, GRAVITY = 700000 # CHARACTER = 3, BOX = 5

var boxes: Array[CharacterBody2D] = []
var pos: PackedVector2Array = []
var count: PackedByteArray = []
var state: PackedByteArray = []

func toggle_physics(no: int) -> void:
	if count[no] == 0 and not Bit.of(state[SLIDE], no):
		boxes[no].process_mode = Node.PROCESS_MODE_DISABLED
	elif count[no] == 1 or Bit.of(state[SLIDE], no):
		boxes[no].process_mode = Node.PROCESS_MODE_INHERIT

func toggle_slide(no: int, next: bool) -> void:
	state[SLIDE] = Bit.to(state[SLIDE], no, next)
	toggle_physics(no)

func slide_the_box(box: CharacterBody2D) -> void:
	box.add_velocity(Vector2(box.velocity.x, Def.GRAVITY)) # * delta

func throw_effect(hero: CharacterBody2D, motion: Vector2i) -> void: # THROW
	for box in hero.boxes:
		box.velocity = POWER * motion

func apply_velocity(hero: CharacterBody2D, velocity: Vector2) -> void:
	for box in hero.boxes:
		box.velocity = velocity # make_velocity(velocity)

func add_box(box: CharacterBody2D) -> void:
	box.no = boxes.size()
	pos.append(Vector2.ZERO)
	boxes.append(box)
	count.append(0)
# LINKING
func pushes(hero: CharacterBody2D, velocity: Vector2) -> void:
	for i in range(0, count.size()):
		if Bit.of(state[hero.no], i):
			boxes[i].add_velocity(velocity)

func fixate_box(hero: int, box: int, add: int) -> void:
	count[box] += add
	state[hero] = Bit.to1(state[hero], box)
	toggle_physics(box)

func _grab(hero: CharacterBody2D, box: CharacterBody2D) -> void:
	fixate_box(hero.no, box.no, 1)
	if Bit.one(hero.state[Def.BOX]):
		hero.to.moves.set_move_action("go")

func _release(hero: CharacterBody2D, box: CharacterBody2D) -> void:
	fixate_box(hero.no, box.no, -1)
	if hero.state[Def.BOX] == 0:
		hero.to.moves.set_move_action("pull")

func controls(box: CharacterBody2D) -> void:
	var see: Area2D = box.get_node("press")
	see.body_entered.connect(encounter)
	see.body_exited.connect(diverge)
	var fov: VisibleOnScreenNotifier2D = box.get_node("fov")
	fov.screen_entered.connect(box.show)
	fov.screen_entered.connect(box.hide)

# WORK
func turn_walls_collision(box: CharacterBody2D, value: bool) -> void:
	for mask in [WORLD, BORDERS]:
		box.set_collision_mask_value(mask, value)

func set_tiles(box: int, slide: bool) -> void:
	HUD.level.border.pos(pos[box]).id().atlas()
	match Def.of8(HUD.level.border.tile(Def.ATLAS)):
		Def.SLIDE: toggle_slide(box, slide)
		_: HUD.level.tile.tile_press(pos[box])

func encounter(no: int) -> void:
	pos[no] = boxes[no].position
	set_tiles(no, true)

func diverge(no: int) -> void: set_tiles(no, false)

# signal activate(pos: Vector2)
func act_busy(hero: CharacterBody2D) -> void:
	# hero.posed = hero.position + hero.act.position
	hero.states("ACTING", true)

func act_stop(hero: CharacterBody2D) -> void: hero.states("ACTING", false)

func pull_busy(hero: CharacterBody2D, box: CharacterBody2D) -> void:
	hero.boxes.push_back(box) #;print("START FORWARD")
	hero.to.moves.jump.pull_box(hero.boxes.size() > 0)
	
	hero.states("GRAB", not hero.to.skills.pull.ledge.is_colliding())
	# or box.compare_height(hero) DEPRECATED
	if hero.do("GRAB"):
		hero.to.topdown.move.act.velocity.weight += box.weight

func pull_stop(hero: CharacterBody2D, box: CharacterBody2D) -> void:
	hero.boxes.erase(box)
	hero.to.moves.jump.pull_box(hero.boxes.size() > 0)

	if hero.do("GRAB"): # print("STOP FORWARD")
		var v: Node = hero.to.topdown.move.act.velocity
		v.weight = max(0, v.weight - box.weight)
		box.logic.work.move.apply_velocity(Vector2.ZERO)

func press_busy(hero: CharacterBody2D) -> void:
	hero.posed = hero.position
	hero.states("STANDING", true)
	#activate.emit(hero.posed, hero)

func press_stop(hero: CharacterBody2D) -> void:
	hero.states("STANDING", false)
	#deactivate.emit(hero.posed, hero)

#func _input(_event: InputEvent) -> void:
#	if _allow and Input.is_action_pressed("action"):
#		activate.emit(_last_position)
# func take_effect() -> void: activate.emit(_last_position)
