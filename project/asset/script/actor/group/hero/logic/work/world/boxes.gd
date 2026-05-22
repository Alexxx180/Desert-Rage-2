class_name Boxes extends RefCounted

enum { WORLD, BORDERS, ENTITY, GROUND, TRIGGER, GAP = 7, UPLAND = 8, GRAVITY = 700000 } # , JUMP = 200000, GRAVITY = 700000 # CHARACTER = 3, BOX = 5

var boxes: Array[CharacterBody2D] = []
var pos: PackedVector2Array = []
var count: PackedByteArray = []
var slides: int

func toggle_physics(box: CharacterBody2D) -> void:
	if count[box.no] == 0 and not Bit.of(slides, box.no):
		box.process_mode = Node.PROCESS_MODE_DISABLED
	elif count[box.no] == 1 or Bit.of(slides, box.no):
		box.process_mode = Node.PROCESS_MODE_INHERIT

func toggle_slide(box: CharacterBody2D, state: bool) -> void:
	slides = Bit.to(slides, box.no, state)
	toggle_physics(box)

func slide_the_box(box: CharacterBody2D) -> void:
	box.add_velocity(Vector2(box.velocity.x, GRAVITY)) # * delta

func add_box(box: CharacterBody2D) -> void:
	box.no = boxes.size()
	pos.append(Vector2.ZERO)
	boxes.append(box)
	count.append(0)
# LINKING
func pushes(hero: CharacterBody2D, velocity: Vector2) -> void:
	for i in range(0, count.size()):
		if Bit.of(hero.state[Def.BOX], i):
			boxes[i].add_velocity(velocity)

func fixate_box(hero: CharacterBody2D, box: CharacterBody2D, add: int) -> void:
	count[box.no] += add
	hero.state[Def.BOX] = Bit.to(hero.state[Def.BOX], box.no, true)
	toggle_physics(box)

func animate_hero(hero: CharacterBody2D, action: String, condition: Callable) -> void:
	if condition.call(hero.state[Def.BOX]): #  == 0
		hero.to.moves.set_move_action(action)

func _grab(hero: CharacterBody2D, box: CharacterBody2D) -> void:
	fixate_box(hero, box, 1)
	animate_hero(hero, "pull", Bit.single)

func _release(hero: CharacterBody2D, box: CharacterBody2D) -> void:
	fixate_box(hero, box, -1)
	animate_hero(hero, "go", Bit.empty)

func controls(box: CharacterBody2D) -> void:
	var see: Area2D = box.get_node("press")
	see.body_entered.connect(encounter)
	see.body_exited.connect(diverge)
	var fov: VisibleOnScreenNotifier2D = box.get_node("fov")
	fov.screen_entered.connect(box.show)
	fov.screen_entered.connect(box.hide)

# WORK
func turn_walls_collision(box: CharacterBody2D, value: bool) -> void:
	for mask in [WORLD, GAP, UPLAND, BORDERS]:
		box.set_collision_mask_value(mask, value)

func set_tiles(box: CharacterBody2D, border: TileDecorator, slide: bool) -> void:
	match Def.from8(border.tpos(pos[box.no])):
		Def.DESCENT: toggle_slide(box, slide)
		_: HUD.level.tile.tile_press(pos[box.no], border)

func encounter(box: CharacterBody2D, border: TileDecorator) -> void:
	pos[box.no] = box.position
	set_tiles(box, border, true)

func diverge(box: CharacterBody2D, border: TileDecorator) -> void:
	set_tiles(box, border, false)
