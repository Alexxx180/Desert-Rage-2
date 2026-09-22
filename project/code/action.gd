class_name Action extends RefCounted

enum { STATIC = 1, JUMPED = 0, JUMPING, COUNT = 8, JUMP = 0, DURATION = 1,
	CLOSE = 0, HEIGHT = 1, SHADOW = 2, PORTION = 3, JUMP_POWER = 10 }

enum { LOGIC = 0, FLOOR = 1, ENTRY = 2, WALLS = 3, 
	HINT = 7, TAGS = 7, CHESTS = 9, GROUND = 9, # ALT
	ALT1 = 3, ALT2 = 2, ALT3 = 1, ALT4 = 0,
	
	ID = 0, TYPE = 1, ALT = 2, ATLAS = 3, COORDS = 4, T4 = 16, T8 = 64,
	
	FLOORS, ICE_MECH = 0, HELP = 1,
	
	WALL = 3, LEDGE = 4, TILE_GROUND = 10, LEFT_CHAIN = 61, MID_CHAIN,
	RIGHT_CHAIN, PILLAR,
	
	PUDDLE_OFF, PUDDLE_ON, ICE_FLOOR, ICE_THICK,

	BLUE_OFF = 0, BLUE_ON, RED_OFF, RED_ON, GREEN_OFF, GREEN_ON, WHITE_OFF,
	WHITE_ON, BLACK_OFF, BLACK_ON, BRONZE_OFF, BRONZE_ON, SILVER_OFF, SILVER_ON,
	GOLD_OFF, GOLD_ON, PLATINUM_OFF, PLATINUM_ON, PLACE, TELEPORT_ON, SOURCE_OFF,
	SOURCE_ON, LEVER_OFF, LEVER_ON, PLATE_OFF, PLATE_ON, TELEPORT_OFF, SPIKER,
	COMFORTER, SUPPLIER, COOLER, SMALL_BOX, FIRE_BOX, LARGE_BOX, STAND_OFF, STAND_ON,
	
	U_WATER = 0, U_EXIT, U_WALL_OFF, U_WALL_ON, U_LADDER, D_LADDER, ENEMY, BOSS,
	M_WATER, M_EXIT, D_WALL_OFF, D_WALL_ON, H_SPRING_OFF, H_SPRING_ON, B_SPRING_OFF,
	B_SPRING_ON, D_WATER, D_EXIT, SLIDE, PILLAR_OLD, G_SECRET_OFF, G_SECRET_ON,
	W_SECRET_OFF, W_SECRET_ON, PAGE,
} # tiles

var _tile: PackedInt32Array:
	get: return HUD.level.border.tile

var box_height: PackedByteArray = []
var box_hero: PackedByteArray = [0, 0]
var directed: Vector2; var off: Vector2
var hero_state: PackedByteArray = [0, 0]

const stand: PackedInt32Array = [STAND_ON, SMALL_BOX, LARGE_BOX]
const position: PackedVector2Array = [Vector2(20, 22), Vector2(0, -48), Vector2(0.6, 0.72), Vector2(0.125, 0.2)]

func on_tile(pos: Vector2) -> PackedInt32Array: return HUD.level.border.pos(pos).id().atlas().type().tile
func _of(type: int) -> bool: return Def.of(hero_state[HUD.hero], type)
func _to(type: int, value: int) -> void: Def.b(hero_state, HUD.hero, type, value)
func _t0(type: int) -> void: Def.b0(hero_state, HUD.hero, type)
func _t1(type: int) -> void: Def.b1(hero_state, HUD.hero, type)

func movement(act: bool) -> void:
	directed = Input.get_vector(&"left", &"right", &"forward", &"backward")
	var in_place: bool = directed == Vector2.ZERO
	if _of(JUMPING): return
	var hero: CharacterBody2D = HUD.level.entity[HUD.hero]
	if _of(JUMPED):
		if hero.box == -1:
			ledge_jump(hero.position) # pass
			HUD.direct(directed.round())
			hero.lever.position = position[CLOSE] * directed
		elif not in_place:
			var box: AnimatableBody2D = HUD.level.boxes[hero.box]
			ledge_jump(box.position, box_height[hero.box])
	else:
		var motion: Vector2 = directed * Def.MOVE
		# var dir: Vector2 = Vector2(1, 2) if directed.y != 0 else Vector2.ONE
		for box in hero.boxes: pushes(box, motion)# * dir) #  + directed * 2
		hero.make_velocity(motion)
		if not in_place and not act:
			hero.lever.position = position[CLOSE] * directed
	if in_place:
		HUD.stop_animation()
	elif hero_state[HUD.hero] == 0:
		HUD.direct(directed.round())
		HUD.animate()

func add_particle(asset: GPUParticles2D, path: StringName, name: StringName, next: Vector2) -> void:
	if asset == null:
		asset = load(path).instantiate()
		asset.one_shot = true
		HUD.level.set(name, asset)
		HUD.level.add_child(asset)
	else:
		asset.restart()
	asset.position = next

func puddle_tile() -> void:
	var hero: CharacterBody2D = HUD.level.entity[HUD.hero]
	var pos: Vector2 = hero.position + hero.lever.position
	if on_tile(pos)[ID] == FLOOR and _tile[TYPE] == FLOORS:
		pass
	elif _tile[ID] == WALLS and _tile[ATLAS] == GROUND:
		HUD.level.border.id(FLOOR).alt(ALT1)
	else:
		return
	HUD.level.border.type(PUDDLE_OFF).paint_alt()
	add_particle(HUD.level.rain, Def.rain, &"rain", pos)
	HUD.level.conductor.contact(_tile[COORDS])

func melt_ice() -> void:
	var hero: CharacterBody2D = HUD.level.entity[HUD.hero]
	var pos: Vector2 = hero.position + hero.lever.position
	if on_tile(pos)[ID] == FLOOR and _tile[TYPE] == ICE_FLOOR:
		HUD.level.border.type(PUDDLE_OFF).paint_alt()
		add_particle(HUD.level.fire, Def.fire, &"fire", pos) # TileDecorator

func toggle_collision(next: bool) -> void:
	HUD.level.entity[HUD.hero].set_collision_layer_value(STATIC, next)
	HUD.level.entity[HUD.hero].set_collision_mask_value(STATIC, next)

func toggle_stuck(next: bool) -> void:
	HUD.level.entity[HUD.hero].lever_body.set_deferred(&"disabled", not next)
	HUD.level.entity[HUD.hero].plate_body.set_deferred(&"disabled", not next)
	toggle_collision(next)

func ledge_jump(pos: Vector2, height: int = 0) -> void:
	var d: Vector2 = directed.round()
	if d == Vector2.ZERO: return
	
	var dir: Vector2 = Vector2.ONE * 128 * (Vector2(0, directed.y)
		if directed.x != 0 and directed.y != 0 else directed) ; on_tile(pos)
	var f1: int = HUD.level.border.extract(TileDecorator.FLOOR) + height
	var t: PackedInt32Array = on_tile(pos + dir).duplicate()
	var f2: int = HUD.level.border.extract(TileDecorator.FLOOR)
	var jumped: bool = false
	var no: int = -1
	for i in range(0, len(HUD.level.boxes)):
		var c: int = on_tile(HUD.level.boxes[i].position)[COORDS]
		jumped = c == t[COORDS] and (f1 == (f2 + box_height[i])) 
		if jumped: no = i; break
	if jumped:
		pos = position[HEIGHT]
	elif f1 == f2:
		pos = HUD.level.border.map_to_local(Def.map(t[COORDS]))
		jumped = t[ID] == LOGIC and t[ATLAS] in stand
		if jumped: off = Vector2(0, 18) ; pos -= off
		elif t[ID] == FLOOR and t[TYPE] == FLOORS:
			pos -= off ; off = Vector2.ZERO
			jumped = t[ATLAS] == LEDGE
		else: return
	else: return
	
	Def.b(hero_state, HUD.hero, JUMPED, jumped)
	toggle_stuck(false)
	var hero: CharacterBody2D = HUD.level.entity[HUD.hero]
	if no != -1: hero.call_deferred(&"reparent", HUD.level.boxes[no], true)
	
	HUD.direct(d)
	HUD.animate_frames(HUD.JUMP)
	_t1(JUMPING)
	hero.make_velocity(directed * Vector2.ONE * JUMP_POWER)
	var jumping: Tween = HUD.create_tween()
	jumping.tween_method(func(slot):
		HUD.sprite.frame = slot
		hero.shadow.scale = slot * position[SHADOW] * position[PORTION][JUMP],
		0, COUNT, position[PORTION][DURATION]).set_trans(Tween.TRANS_LINEAR)
	jumping.tween_callback(func():
		hero.make_velocity(Vector2.ZERO)
		HUD.animate_frames(HUD.WALK)
		if hero.box == -1:
			hero.reparent(HUD.level, true)
			if not _of(JUMPED):
				hero.lever.position = Vector2.ZERO
				toggle_stuck(true)
		hero.position = pos
		HUD.sprite.stop()
		_t0(JUMPING))
	hero.box = no

func box_move() -> void:
	pass

func trigger_disappear(body: Variant) -> void:
	var hero: CharacterBody2D = HUD.level.entity[HUD.hero]
	if body is AnimatableBody2D and body.is_in_group(&"box"):
		for i in range(0, len(hero.boxes)):
			if hero.boxes[i] == body.get_meta(&"no"):
				hero.weight *= box_weight[i]
				pushes(i, Vector2.ZERO)
				box_hero[i] = 0
				break

func trigger_encounter(body: Variant) -> void:
	var hero: CharacterBody2D = HUD.level.entity[HUD.hero]
	if body is AnimatableBody2D and body.is_in_group(&"box"):
		var no: int = -1
		for i in range(0, len(HUD.level.boxes)):
			if body.get_instance_id() == HUD.level.boxes[i].get_instance_id():
				no = i
				break
		if no == -1: return
		hero.boxes.append(no)
		var a: int = int(box_weight[no])
		var to: float = weight_d[a]
		print("WEIGHT: ", hero.weight, " - TO: ", to, " - A: ", a)
		hero.weight *= to
		return
	var pos: Vector2 = hero.position
	var id: int = on_tile(pos)[ID]
	if (id == FLOOR and _tile[TYPE] == FLOORS) or (id == LOGIC and _tile[ATLAS] in stand):
		ledge_jump(pos)
	elif on_tile(hero.position + hero.lever.position)[ID] == LOGIC and _tile[ATLAS] in [SMALL_BOX, LARGE_BOX]:
		add_box(_tile[ATLAS], HUD.level.border.position())
		HUD.level.border.atlas(GROUND).id(FLOOR).type(FLOORS).paint_alt() # coords(Def.GROUND)

# TODO BOOKS
var chest_pos: Vector2 = Vector2.ZERO
var logic: Node


enum { SHOW = 1, HIDE = 2, SHOW_TIME = 1 }

var platforms: Array[CharacterBody2D] = []
var platform_dir: PackedByteArray = [CROSS_STAY]
var directions: PackedVector2Array = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)]
var fallback: PackedByteArray = [255, 255, 255, 255, 255, 255, 255]

enum { LEFT, RIGHT, TOP, DOWN, CROSS_STAY, CROSS_LEFT, CROSS_RIGHT, CROSS_TOP, CROSS_DOWN,
	PLATFORM_POWER = 250, HALF_TILE = 32 }

func move_platform(i: int, from: int, to: int) -> void:
	var pos: Vector2 = platforms[i].position + directions[from] * HALF_TILE
	if HUD.level.border.pos(platforms[i].position).id().atlas().type().tile[ATLAS] == TILE_GROUND:
		platform_dir[i] = to
	else:
		platforms[i].velocity += directions[from] * PLATFORM_POWER

func move_cargo_platform(i: int) -> void:
	if fallback[i] == 0 or HUD.level.border.pos(platforms[i].position).id().atlas().type().tile[ALT] == ALT1:
		platform_dir[i] = CROSS_STAY
		fallback[i] = 255
	else:
		platforms[i].velocity += directions[platform_dir[i]] * PLATFORM_POWER
		fallback[i] -= 1

func move_platforms() -> void:
	for i in range(0, HUD.size[HUD.PLATFORMS]):
		match platform_dir[i]:
			LEFT: move_platform(i, LEFT, RIGHT)
			RIGHT: move_platform(i, RIGHT, LEFT)
			TOP: move_platform(i, TOP, DOWN)
			DOWN: move_platform(i, DOWN, TOP)
			CROSS_STAY: pass
			_: move_cargo_platform(i)

func platforms_process(_delta: float) -> void:
	for i in range(0, HUD.size[HUD.PLATFORMS]):
		platforms[i].move_and_slide()


enum { BUTTON, LEVER, SOURCE, TELEPORT, SIZE = 16, CLUSTER = 64 }

func resize_clusters() -> void:
	var casual_mode: bool = true # get difficulty from vault
	if casual_mode:
		var platinum_off: PackedVector2Array = HUD.level.border.get_used_cells_by_id(LOGIC, Def.map8(PLATINUM_OFF))
		
		var chests_off: PackedByteArray = [BRONZE_OFF, SILVER_OFF, GOLD_OFF, PLATINUM_OFF]
		var chests_on: PackedByteArray = [BRONZE_ON, SILVER_ON, GOLD_ON, PLATINUM_ON]
		for i in range(0, len(chests_on)):
			HUD.level.border.id(LOGIC).atlas(chests_off[i])
			for coords in HUD.level.border.get_used_cells_by_id(LOGIC, Def.map8(chests_on[i])): HUD.level.border.coords(Def.join(coords)).paint()
		
		HUD.level.border.id(LOGIC).atlas(PLATINUM_ON)
		for coords in platinum_off: HUD.level.border.coords(Def.join(coords)).paint()
	
	var button: PackedInt32Array = []
	var lever: PackedInt32Array = []
	var source: PackedInt32Array = []
	var teleport: PackedInt32Array = []
	
	if len(cluster) == 0: cluster.resize(CLUSTER)
	var count: int = 0
	for y in range(0, T8):
		var tiles: PackedVector2Array = HUD.level.execute.get_used_cells_by_id(TAGS, Def.map8(y))
		if tiles.size() == 0: break
		if count + tiles.size() > cluster.size(): cluster.resize(cluster.size() * 2)
		
		var search: bool = true
		for x in range(0, tiles.size()):
			cluster[count + x] = Def.join(tiles[x])
			if search:
				search = false
				match HUD.level.border.coords(Def.join(tiles[x])).tile[ATLAS]:
					PLATE_OFF, PLATE_ON: button.append(Def.of(tiles.size(), count))
					LEVER_OFF, LEVER_ON: lever.append(Def.of(tiles.size(), count))
					SOURCE_OFF, SOURCE_ON: source.append(Def.of(tiles.size(), count))
					TELEPORT_ON, PLACE: teleport.append(Def.of(tiles.size(), count))
					_: search = true
		count += tiles.size()
	var types: Array[PackedInt32Array] = [button, lever, source, teleport]
	access.clear()
	for i in range(0, len(types)):
		access.append_array(types[i])
		sizes[i] = types[i].size()

var cluster: PackedInt32Array = []
var access: PackedInt32Array = []
var sizes: PackedByteArray = [0, 0, 0, 0]
var buttons: Dictionary[int, int] = {}
var hint: PackedInt32Array = []

func button_press(no: int, add: int, compare: int, tag: int) -> void:
	var coords: int = cluster[no]
	
	if HUD.level.buttons.has(coords):
		HUD.level.buttons[coords] = HUD.level.buttons[coords] + add
	else:
		HUD.level.buttons[coords] = compare
	if HUD.level.buttons[coords] == compare:
		HUD.level.border.atlas(tag).paint()

func toggle_openning(no: int, on: bool, enter: bool) -> void:
	var tag: int = HUD.level.border.coords(cluster[no]).atlas().tile[ATLAS]
	if !on:
		match tag:
			U_WALL_OFF, U_WALL_ON, D_WALL_OFF, D_WALL_ON, STAND_OFF, STAND_ON:
				HUD.level.border.atlas(tag).paint()
			PLATE_OFF: button_press(no, +1, 1, tag)
			PLATE_ON: button_press(no, +1 if enter else -1, 0, tag)
	else:
		match tag:
			PLATE_OFF: button_press(no, +1, 1, PLATE_ON)
			PLATE_ON: button_press(no, +1 if enter else -1, 0, PLATE_OFF)
			U_WALL_OFF: HUD.level.border.atlas(U_WALL_ON).paint()
			U_WALL_ON: HUD.level.border.atlas(U_WALL_OFF).paint()
			D_WALL_OFF: HUD.level.border.atlas(D_WALL_ON).paint()
			D_WALL_ON: HUD.level.border.atlas(D_WALL_OFF).paint()
			STAND_OFF: HUD.level.border.atlas(STAND_OFF).paint()
			STAND_ON: HUD.level.border.atlas(STAND_ON).paint()

func switch_cluster(section: int, enter: bool) -> void:
	var c: int = get_cluster(section, HUD.level.border.tile[COORDS])
	var no: int = HUD.selected + HUD.COMPLETED
	var state: bool = !Def.of(HUD.session[no], c)
	HUD.session[no] = Def.to(HUD.session[no], c, state)
	for i in range(Def.x(access[c]), Def.y(access[c])):
		toggle_openning(i, state, enter)

func get_cluster(section: int, coords: int) -> int:
	var from: int = 0
	for x in range(0, section): from += sizes[x]
	for y in range(from, from + sizes[section]):
		for i in range(Def.x(access[y]), Def.y(access[y])):
			if coords == cluster[i]: return y
	return -1

enum { ACT, SPARK, FIRE, PRESS }

func tile_press(coords: int, type: int, enter: bool = true) -> void:
	if type == FIRE:
		HUD.level.border.coords(coords).id().type() # .alt(ALT1).
		if HUD.level.border.tile[TYPE] == ICE_FLOOR:
			HUD.level.border.type(TYPE).paint_alt()
		return

	match HUD.level.border.coords(coords).id().atlas().tile[ATLAS]:
		PLATE_OFF: if type == PRESS: switch_cluster(BUTTON, enter)
		PLATE_ON: if type == PRESS: switch_cluster(BUTTON, enter)
		LEVER_OFF: if type == ACT: switch_cluster(LEVER, true)
		LEVER_ON: if type == ACT: switch_cluster(LEVER, true)
		SOURCE_OFF: if type == SPARK: switch_cluster(SOURCE, true)
		SOURCE_ON: if type == SPARK: switch_cluster(SOURCE, true)

var walk_no: int = -1

func tile_walk(hero: CharacterBody2D, enter: bool = true) -> void:
	if not enter and walk_no != -1:
		HUD.log_help_hide()
		walk_no = -1
	
	var atlas: int = HUD.level.border.coords(HUD.level.tile[Def.offset(hero.no, Def.PLATE)]).atlas().tile[ATLAS]
	if atlas == TELEPORT_ON:
		var c: int = get_cluster(TELEPORT, HUD.level.border.tile[COORDS])
		for i in range(Def.x(access[c]), Def.y(access[c])):
			if HUD.level.border.coords(cluster[i]).tile[ATLAS] == PLACE:
				hero.teleport(HUD.level.border.map_to_local(Def.map(cluster[i])))
				break
	elif atlas == HINT and HUD.level.border.tile[ID] == TYPE:
		# no = help_show(HUD.level.border.local_to_map(hero.position), hint)
		if walk_no != -1: HUD.log_help(walk_no)
	else:
		tile_press(HUD.level.border.tile[COORDS], PRESS, enter)

func secret_reveal() -> void:
	pass




const small: PackedScene = preload("res://def/entity/platform/box_small.tscn")

var grab: PackedByteArray = []

const weight_d: PackedFloat32Array = [0, 1, 0.5, 0.33, 0.25]

func is_sliding(no: int) -> bool: return Def.of(hero_state[SLIDE], no)

func physics_process(_delta: float) -> void:
	for i in range(0, len(HUD.level.boxes)):
		HUD.level.boxes[i].move_and_collide(velocity[i])

func toggle_slide(no: int, next: bool) -> void:
	hero_state[SLIDE] = Def.to(hero_state[SLIDE], no, next)

func slide_the_box(_box: CharacterBody2D) -> void:
	pass #TODO FIXME gravity
	# box.make_velocity(Vector2(box.velocity.x, GRAVITY)) # * delta

func set_box(asset: PackedScene, data: PackedByteArray) -> void:
	HUD.level.boxes.append(asset.instantiate())
	box_height.append(data[0])
	box_weight.append(data[1])
	velocity.append(Vector2.ZERO)
# """
func add_box(box_type: int, pos: Vector2) -> void:
	var no: int = HUD.level.boxes.size()
	match box_type:
		SMALL_BOX: set_box(small, [1, 2])
		LARGE_BOX: set_box(load(&"res://def/entity/platform/box_large.tscn"), [2, 4])
		FIRE_BOX: set_box(load(&"res://def/entity/platform/box_fire.tscn"), [0, 2])
	print("LEVEL: ", SMALL_BOX, " - B: ", box_type)
	var box: AnimatableBody2D = HUD.level.boxes[no]
	HUD.level.call_deferred(&"add_child", box)
	box.set_meta(&"no", no)
	box.position = pos + Vector2(0, 28)
	box.name = str(box.name, '_', no)
	var see: Area2D = box.get_node(^"press")
	see.body_entered.connect(encounter)
	see.body_exited.connect(diverge)
	var fov: VisibleOnScreenNotifier2D = box.get_node(^"fov")
	fov.screen_entered.connect(box.show)
	fov.screen_exited.connect(box.hide)
#"""
func throw(box: int, motion: Vector2i) -> void: velocity[box] = motion # * POWER
func pushes(box: int, motion: Vector2) -> void: velocity[box] = motion * weight_d[box_weight[box]]

func fixate_box(hero: int, box: int, _add: int) -> void:
	hero_state[hero] = Def.to1(hero_state[hero], box)

func encounter() -> void: pass
func diverge() -> void: pass

var press: PackedByteArray = [0, 0]
var press_coords: PackedInt32Array = [0, 0]
var press_button: PackedByteArray = [0, 0]
var button_coord: PackedInt32Array = [0, 0]
var rope_length: PackedByteArray = [1, 1]
var tile_motion: PackedVector2Array = [Vector2.ONE, Vector2.ONE]

func rope_fall() -> void:
	for i in range(0, Def.PARTY):
		if rope_length[i] == 0:
			var tween: Tween = HUD.create_tween()
			var pos: Vector2 = HUD.level.border.map_to_local(Def.map(HUD.level.border.tile[COORDS]))
			tween.tween_property(HUD.adversary.entity[HUD.hero], ^"position", pos, 1.5)
		else:
			rope_length[i] -= 1

func chain_enter(tile: int, y: int) -> void:
	press[HUD.hero] = tile
	tile_motion[HUD.hero].y = y

func plate_encounter(_body: Variant) -> void:
	HUD.level.tile[Def.offset(HUD.hero, Def.PLATE)] = Def.join(HUD.level.border.local_to_map(HUD.level.entity[HUD.hero].position))
	HUD.level.cluster.tile_walk(HUD.level.entity[HUD.hero], true)

func plate_disappear(_body: Variant) -> void:
	HUD.level.cluster.tile_walk(HUD.level.entity[HUD.hero], false)
	HUD.level.tile[Def.offset(HUD.hero, Def.PLATE)] = 0

func tile_exit(_border: TileDecorator) -> void:
	match HUD.level.press_tile[TileDecorator.TILE_DATA * HUD.hero + HUD.ATLAS]:
		LEFT_CHAIN: chain_enter(0, 1)
		RIGHT_CHAIN: chain_enter(0, 1)
		H_SPRING_OFF: pass

func tile_enter(border: TileDecorator) -> void:
	var tile: PackedInt32Array = border.pos(HUD.level.entity[HUD.hero].position).id().atlas().type(PUDDLE_OFF).tile
	match tile[ATLAS]:
		LEFT_CHAIN:
			press_coords[HUD.hero] = tile[COORDS]
			chain_enter(tile[ATLAS], 0)
		RIGHT_CHAIN:
			press_coords[HUD.hero] = tile[COORDS]
			chain_enter(tile[ATLAS], 0)
		H_SPRING_ON:
			press[HUD.hero] = tile[ATLAS]
			HUD.level.entity[HUD.hero].velocity += Vector2(0, -60)
		_: return
	border.get_tile(HUD.level.press_tile, HUD.hero)

enum { CHAIN = 0, STATE = 0, JOINT = 1, A = -2, B = -1, TIME = 4, LENGTH = 10, NONE = -1 }

var puddles: PackedInt32Array = [0, 0, 0, 0, 0, 0, 0, 0]
var current: Array[PackedInt32Array] = [[0, 0], [0, 0], [0, 0], [0, 0]] # Vector2i
var size: PackedByteArray = [LENGTH, LENGTH, LENGTH, LENGTH]
var rain: Node2D = null

var box_weight: PackedFloat32Array = [1.0]
var ride: PackedByteArray = [-1]
var velocity: PackedVector2Array = []

func draw_the_puddle() -> void:
	if rain == null:
		rain = load(Def.rain).instantiate()
		HUD.level.border.add_child(rain)
	HUD.level.border.add_chip(rain)
	rain.shows()

func setup_sources() -> void:
	HUD.size[HUD.CURRENTS] = 0
	for coords in HUD.level.border.get_used_cells_by_id(LOGIC, Def.map8(SOURCE_ON)):
		initiate_source(Def.join(coords))

func initiate_source(coords: int) -> void:
	if HUD.size[HUD.CURRENTS] < len(size):
		size[HUD.size[HUD.CURRENTS]] = LENGTH
		for i in range(0, 2): current[HUD.size[HUD.CURRENTS]][i] = coords
	else:
		size.append(LENGTH)
		current.append([coords, coords])
	HUD.level.border.coords(coords).id().atlas().type().atlas(SOURCE_ON).paint()
	contact(coords)
	HUD.size[HUD.CURRENTS] += 1

func diffusion() -> void:
	for i in range(1, 8):
		var state: int = Def.half(puddles[STATE], i)
		if state == 0: continue
		if state - 1 == 0:
			HUD.level.border.coords(puddles[i]).id().atlas().type(PUDDLE_OFF).paint_alt()
			puddles[STATE] = Def.to_half(puddles[STATE], 0, Def.half(puddles[STATE], 0) - 1)
		puddles[STATE] = Def.to_half(puddles[STATE], i, state - 1)
	if puddles[STATE] == 0: HUD.sparking.stop()

func sparking(tile: int) -> void:
	if puddles[STATE] & 7 == 7: return
	for i in range(1, 8):
		if Def.half(puddles[STATE], i) == 0:
			puddles[i] = tile
			HUD.level.border.coords(tile).id().atlas().type(PUDDLE_ON).paint_alt()
			puddles[STATE] = Def.to_half(puddles[STATE], i, TIME)
			puddles[STATE] = Def.to_half(puddles[STATE], 0, Def.half(puddles[STATE], 0) + 1)
			break
	if Def.half(puddles[STATE], 0) == 1:
		HUD.sparking.start()

func activate_puddle(pos: Vector2) -> void:
	if HUD.level.border.pos(pos).tile[TYPE] == PUDDLE_OFF:
		if _around(HUD.level.border.tile[COORDS]):
			sparking(HUD.level.border.tile[COORDS])
	else:
		contact(HUD.level.border.tile[COORDS])

func _around(tile: int) -> bool:
	var t: PackedInt32Array = HUD.level.border.coords(tile).id().type().tile
	return ((t[ID] == LOGIC and t[ATLAS] == SOURCE_OFF) or (t[ID] == FLOOR and t[ATLAS] != WALL and t[TYPE] == PUDDLE_ON))

func contact(map_coords: int) -> void:
	var y: int = 1 << Def.LEVEL
	if not (_around(map_coords + y) or _around(map_coords + 1) or
		_around(map_coords - y) or _around(map_coords - 1)): return
	
	map_coords = HUD.level.border.tile[COORDS]
	if HUD.level.border.tile[TYPE] == PUDDLE_OFF:
		charge_unit(map_coords)
		return
	
	initiate_source(map_coords)
	if conduct(map_coords, current.size() - 1):
		HUD.level.border.coords(map_coords).id().atlas().type().atlas(SOURCE_ON).paint()
		contact(map_coords)

func conduct(map_coords: int, chain: int) -> bool:
	if size[chain] == 0: return false
	var delta: int = current[chain][B] - current[chain][A]
	if delta == 0:
		current[chain][B] = map_coords
	elif map_coords - current[chain][B] == delta:
		current[chain][B] += delta
	elif map_coords != current[chain][B]:
		# if size[AVAILABLE + chain] # TODO FIXME rework electro chains
		current[chain].append(map_coords)
	else:
		return false
	size[chain] -= 1
	return true

func at_dimension(a: int, b: int, x: int) -> bool: return (a <= x and x <= b) or (a >= x and x >= b)
func get_site_to_discharge(map_coords: Vector2i) -> Vector2i:
	var tile: Vector2i = Vector2i(current.size(), 0)
	for c in range(tile[CHAIN], 0, -1):
		tile[CHAIN] = c
		for j in range(current[c].size(), 1, -1):
			tile[JOINT] = j
			var a: int = current[c][j - 1]
			var b: int = current[c][j]
			if not ((map_coords.y == Def.y(b) and at_dimension(Def.x(a), Def.x(b), map_coords.x)) or
				(map_coords.x == Def.x(b) and at_dimension(Def.y(a), Def.y(b), map_coords.y))):
				return tile
	return tile

func charge_unit(map_coords: int) -> void:
	for chain in range(current.size(), 0, -1):
		var delta: int = map_coords - current[chain][B]
		if ((Def.x(delta) ^ Def.y(delta)) & 1 == 1) and conduct(map_coords, chain):
			HUD.level.border.coords(map_coords).id().atlas().type().atlas(PUDDLE_ON).paint()
			contact(map_coords)
			return

func get_direction(a: int, b: int) -> int: return clampi(Def.y(a) - Def.y(b), -1, 1) | clampi(Def.x(a) - Def.x(b), -1, 1)
func discharge_unit(map_coords: int) -> void:
	var site: Vector2i = get_site_to_discharge(Def.map(map_coords))
	if site[CHAIN] == 0: return
	
	var direction: int = get_direction(map_coords, current[site[CHAIN]][site[JOINT] - 1])
	while current[site[CHAIN]].size() - 1 > site[JOINT]:
		discharge(current[site[CHAIN]][A], site[CHAIN])
		current[site[CHAIN]].remove_at(current[site[CHAIN]].size() - 1)
	discharge(map_coords, site[CHAIN])
	_turn_points(Vector2i(map_coords, map_coords - direction), site[CHAIN])

func discharge(target: int, chain: int) -> void: # var track: Rect2i = get_track(chain)
	var map_position: int = current[chain][B]
	var direction: int = get_direction(current[chain][B], current[chain][A])
	HUD.level.border.coords(map_position).id().atlas().type(PUDDLE_OFF)
	while map_position != target and size[chain] < 1000:
		size[chain] += 1
		HUD.level.border.coords(map_position).paint_alt()
		map_position -= direction

func _turn_points(coords: Vector2i, chain: int) -> void:
	if current[chain].size() == 2: # source
		current[chain][B] = coords.y
	elif coords.x == current[chain][A]: # map_coords
		current[chain].remove_at(current[chain].size() - 1)
		current[chain][B] -= get_direction(current[chain][B], current[chain][A])
	else:
		if coords.y == current[chain][A]:
			current[chain].remove_at(current[chain].size() - 1)
		current[chain][B] = coords.y # target_coords
	size[chain] += 1
	contact(current[chain][B])
