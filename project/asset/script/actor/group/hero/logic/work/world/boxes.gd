class_name Boxes extends RefCounted

enum { BORDERS, WORLD, ENTITY, GROUND, SLIDE = 2 } # , JUMP = 200000, GRAVITY = 700000 # CHARACTER = 3, BOX = 5

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
