class_name Action extends RefCounted

enum { STATIC = 1, JUMPED = 0, JUMPING, COUNT = 8, JUMP = 0, DURATION = 1,
	CLOSE = 0, HEIGHT = 1, SHADOW = 2, PORTION = 3, JUMP_POWER = 10 }
enum { LOGIC = 0, FLOOR = 1, ENTRY = 2, WALLS = 3, 
	HINT = 7, TAGS = 7, CHESTS = 9, GROUND = 9, # ALT
	ALT1 = 3, ALT2 = 2, ALT3 = 1, ALT4 = 0,
	
	COORDS = 4, T4 = 16, T8 = 64, # ID = 0, TYPE = 1, ALT = 2, ATLAS = 3, 
	
	FLOORS = 0, ICE_MECH = 0, HELP = 1,
	
	WALL = 3, LEDGE = 4, TILE_GROUND = 10, LEFT_CHAIN = 61, MID_CHAIN,
	RIGHT_CHAIN, PILLAR,
	
	PUDDLE_OFF, PUDDLE_ON, ICE_FLOOR, ICE_THICK,
	
	U_WAY, D_WAY, R_WAY, L_WAY, U_WAY_OUT, D_WAY_OUT,

	BLUE_OFF = 0, BLUE_ON, RED_OFF, RED_ON, GREEN_OFF, GREEN_ON, WHITE_OFF,
	WHITE_ON, BLACK_OFF, BLACK_ON, BRONZE_OFF, BRONZE_ON, SILVER_OFF, SILVER_ON,
	GOLD_OFF, GOLD_ON, PLATINUM_OFF, PLATINUM_ON, PLACE, TELEPORT_ON, SOURCE_OFF,
	SOURCE_ON, LEVER_OFF, LEVER_ON, PLATE_OFF, PLATE_ON, TELEPORT_OFF, SPIKER,
	COMFORTER, AMPLIFIER, INSPIRER, SMALL_BOX, FIRE_BOX, LARGE_BOX, STAND_OFF, STAND_ON,
	
	U_WATER = 0, U_EXIT, U_WALL_OFF, U_WALL_ON, U_LADDER, D_LADDER, ENEMY, BOSS,
	M_WATER, M_EXIT, D_WALL_OFF, D_WALL_ON, H_SPRING_OFF, H_SPRING_ON, B_SPRING_OFF,
	B_SPRING_ON, D_WATER, D_EXIT, SLIDE, PILLAR_OLD, G_SECRET_OFF, G_SECRET_ON,
	W_SECRET_OFF, W_SECRET_ON, PAGE,
} # tiles
enum { _ID, _ATLAS = 8, _ALT = 16, _TYPE = 18, # + 2 (as real type (-alt))
	
	BOXES = (1<<SMALL_BOX)|(1<<LARGE_BOX), STAND = BOXES | (1<<STAND_ON),
	C_LEVER = (1<<LEVER_OFF)|(1<<LEVER_ON), C_SOURCE = (1<<SOURCE_OFF)|(1<<SOURCE_ON),
	SOURCE_ID = LOGIC | (SOURCE_OFF << _ATLAS), F_ID = FLOOR | (FLOORS << _TYPE),
	PUDDLE_ID = FLOOR | (PUDDLE_ON << _TYPE), ICE_ID = FLOOR | (ICE_FLOOR << _TYPE),
	GROUND_ID = WALLS | (GROUND << _ATLAS),
	WATER_ID = ENTRY | (D_WATER << _ATLAS),
	
	SECRET_ID = LOGIC | (GOLD_OFF << _ATLAS), # FIXME change both to doors
	GOLD_ID = LOGIC | (GOLD_OFF << _ATLAS),
	WAYS = (1<<U_WAY)|(1<<D_WAY)|(1<<R_WAY)|(1<<L_WAY)|(1<<U_WAY_OUT)|(1<<D_WAY_OUT),
	MECH_ID = (1<<U_WALL_OFF)|(1<<U_WALL_ON)|(1<<D_WALL_OFF)|(1<<D_WALL_ON)|(1<<STAND_OFF)|(1<<STAND_ON)
}

var _tile: PackedInt32Array:
	get: return HUD.level.border.tile

var box_height: PackedByteArray = []
var box_hero: PackedByteArray = [0, 0]
var directed: PackedVector2Array = [Vector2.ZERO, Vector2.ZERO]
var directed_nzero: PackedVector2Array = [Vector2.ZERO, Vector2.ZERO]
var off: Vector2
var hero_state: PackedByteArray = [0, 0]

const position: PackedVector2Array = [Vector2(20, 22), Vector2(0, -48), Vector2(0.6, 0.72), Vector2(0.125, 0.2)]

func on_tile(pos: Vector2) -> PackedInt32Array: return HUD.level.border.pos(pos).id().atlas().type().tile
func _hero_has(h: int, type: int) -> bool: return D.of(hero_state[h], type)
func _hero_dont(h: int, type: int) -> void: D.b0(hero_state, h, type)
func _hero_do(h: int, type: int) -> void: D.b1(hero_state, h, type)

var deployed: bool = true

func direct(h: int, dir: Vector2) -> void:
	var change: bool = directed[h] != dir
	directed[h] = dir
	if dir != Vector2.ZERO: directed_nzero[h] = dir
	if change:
		print("DIR: ", D.direct(directed_nzero[h].round()))
		var anim: String = HUD.adversary.sprite_dir[D.direct(directed_nzero[h].round())]
		HUD.adversary.mirror_animation(h, anim + HUD.level.profile[h].animation.substr(2))

func movement(event: InputEvent, key2: bool) -> void:
	var h: int = HUD.settings.get_hero(event)
	direct(h, Input.get_vector(&"left", &"right", &"forward", &"backward"))
	if key2:
		var h2: int = HUD.settings.key_hero()
		direct(h2, Input.get_vector(&"left_2", &"right_2", &"forward_2", &"backward_2"))
		if deployed and directed[h2] != Vector2.ZERO:
			deployed = false
			HUD.level.entity[h2].show()
			HUD.level.entity[h2].process_mode = Node.PROCESS_MODE_ALWAYS
		move_hero(h2, Input.is_action_pressed(&"act1_2"), directed[h2] == Vector2.ZERO)
	move_hero(h, Input.is_action_pressed(&"act1"), directed[h] == Vector2.ZERO)

func move_hero(h: int, act: bool, in_place: bool) -> void:
	# directed2
	if _hero_has(h, JUMPING): return
	var hero: CharacterBody2D = HUD.level.entity[h]
	
	if _hero_has(h, JUMPED):
		if hero.box == -1:
			ledge_jump(h, hero.position) # pass
			HUD.direct(directed[h].round())
			hero.lever.position = position[CLOSE] * directed[h]
		elif not in_place:
			var box: AnimatableBody2D = HUD.level.boxes[hero.box]
			ledge_jump(h, box.position, box_height[hero.box])
	else:
		if D.of(HUD.adversary.running, h):
			velocity[h] = directed[h] * (D.MOVE << 1)
		else:
			velocity[h] = directed[h] * D.MOVE
		if not in_place and not act:
			HUD.level.lever[h].position = position[CLOSE] * directed[h]
	if in_place:
		HUD.adversary.set_anim(h, Adversary.IDLE)
	else:
		if D.of(HUD.adversary.running, h):
			HUD.adversary.set_anim(h, Adversary.RUN)
		else:
			HUD.adversary.set_anim(h, Adversary.WALK)
	
	#if in_place:
	#	HUD.adversary.stop_animation(h)
	#elif hero_state[h] == 0:
	#	HUD.adversary.direct(h, directed[h].round())
	#	HUD.adversary.animate(h)

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
	var m: int = HUD.level.border.pos(pos).ground().mold()
	if D.m(m, F_ID): pass
	elif D.m(m, GROUND_ID): HUD.level.border.id(FLOOR).alt(ALT1)
	else: return
	HUD.level.border.type(PUDDLE_OFF).paint_alt()
	add_particle(HUD.level.rain, D.rain, &"rain", pos)
	HUD.level.conductor.contact(_tile[COORDS])

func melt_ice() -> void:
	var hero: CharacterBody2D = HUD.level.entity[HUD.hero]
	var pos: Vector2 = hero.position + hero.lever.position
	var m: int = HUD.level.border.pos(pos).ground().mold()
	if D.m(m, ICE_ID):
		HUD.level.border.type(PUDDLE_OFF).paint_alt()
		add_particle(HUD.level.fire, D.fire, &"fire", pos) # TileDecorator

func toggle_collision(h: int, next: bool) -> void:
	HUD.level.entity[h].set_collision_layer_value(STATIC, next)
	HUD.level.entity[h].set_collision_mask_value(STATIC, next)

func toggle_stuck(h: int, next: bool) -> void:
	HUD.level.lever_body[h].set_deferred(&"disabled", not next)
	HUD.level.plate_body[h].set_deferred(&"disabled", not next)
	toggle_collision(h, next)

func box_jump(coords: int, f1: int, f2: int) -> int:
	for i in range(0, len(HUD.level.boxes)):
		var c: int = HUD.level.border.pos(HUD.level.boxes[i].position).ground().m_coords()
		if c == coords and (f1 == (f2 + box_height[i])): return i
	return -1

func jump_animate(h: int, slot: int) -> void:
	HUD.sprite.frame = slot
	HUD.level.entity[h].shadow.scale = slot * position[SHADOW] * position[PORTION][JUMP]

func stop_jump(h: int) -> void:
	var pos: Vector2
	var hero: CharacterBody2D = HUD.level.entity[h]
	hero.make_velocity(Vector2.ZERO)
	HUD.adversary.animate_frames(h, HUD.WALK)
	if hero.box == -1:
		hero.reparent(HUD.level, true)
		if not _hero_has(h, JUMPED):
			hero.lever.position = Vector2.ZERO
			toggle_stuck(h, true)
	hero.position = pos
	HUD.sprite.stop()
	_hero_dont(h, JUMPING)

func set_to() -> void:
	pass

func get_jump_length(h: int) -> Vector2:
	var dir: Vector2 = directed[h] * 128
	if dir.x != 0 and dir.y != 0: dir.x = 0
	return dir

var jumped: bool

func get_stand_pos(h: int, m: int, c: int) -> Vector2:
	var pos: Vector2 = HUD.level.border.map_to_local(D.map(c)); var atlas: int = D.byte(m, D.ATLAS)
	print("M: ", D.byte4(m), " - atl: ", atlas)
	if D.byte(m, D.ID) == LOGIC and D.of(STAND, atlas):
		off = Vector2(0, 18); pos -= off
		_hero_do(h, JUMPED)
	elif D.m(m, F_ID):
		pos -= off; off = Vector2.ZERO
		if atlas == LEDGE: _hero_do(h, JUMPED)
		else: _hero_dont(h, JUMPED)
	else:
		pos = Vector2.ZERO
	return pos

func ledge_jump(h: int, pos: Vector2, height: int = 0) -> void:
	var dir: Vector2 = get_jump_length(h); if dir.round() == Vector2.ZERO: return
	var b: TileDecorator = HUD.level.border
	var f1: int = b.pos(pos).ground().extract(D.FLOOR) + height
	var m: int = b.pos(pos + dir).ground().mold(); var c: int = b.m_coords()
	var f2: int = b.extract(D.FLOOR)
	var no: int = box_jump(c, f1, f2)
	if no != -1:
		pos = position[HEIGHT]
		D.b1(hero_state, HUD.hero, JUMPED)
	elif f1 == f2:
		pos = get_stand_pos(h, m, c)
		if pos == Vector2.ZERO: return
	else: return
	
	toggle_stuck(h, false)
	if no != -1: HUD.level.entity[h].call_deferred(&"reparent", HUD.level.boxes[no], true)
	
	HUD.adversary.set_anim(h, JUMP) # HUD.adversary.animate_frames(h, HUD.JUMP) # _t1(JUMPING)
	# HUD.level.entity[h].box = no

func box_move() -> void:
	pass

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
	if HUD.level.border.pos(platforms[i].position).ground().tile[D.ATLAS] == TILE_GROUND:
		platform_dir[i] = to
	else:
		platforms[i].velocity += directions[from] * PLATFORM_POWER

func move_cargo_platform(i: int) -> void:
	if fallback[i] == 0 or HUD.level.border.pos(platforms[i].position).ground().tile[D.ALT] == ALT1:
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
	var tag: int = D.byte(HUD.level.border.coords(cluster[no]).atlas().mold(), D.ATLAS)
	if !on:
		if D.of(MECH_ID, tag): HUD.level.border.atlas(tag).paint()
		elif tag == PLATE_OFF: button_press(no, +1, 1, tag)
		elif tag == PLATE_ON: button_press(no, +1 if enter else -1, 0, tag)
	else:
		var atlas: int
		match tag:
			PLATE_OFF: button_press(no, +1, 1, PLATE_ON); return
			PLATE_ON: button_press(no, +1 if enter else -1, 0, PLATE_OFF); return
			U_WALL_OFF: atlas = U_WALL_ON
			U_WALL_ON: atlas = U_WALL_OFF
			D_WALL_OFF: atlas = D_WALL_ON
			D_WALL_ON: atlas = D_WALL_OFF
			STAND_OFF: atlas = STAND_OFF
			STAND_ON: atlas = STAND_ON
			_: return
		HUD.level.border.atlas(STAND_ON).paint()

func switch_cluster(section: int, enter: bool) -> void:
	var c: int = get_cluster(section, HUD.level.border.tile[COORDS])
	var no: int = HUD.selected + HUD.COMPLETED
	var state: bool = !D.of(HUD.session[no], c)
	HUD.session[no] = D.to(HUD.session[no], c, state)
	for i in range(D.x(access[c]), D.y(access[c])):
		toggle_openning(i, state, enter)

func get_cluster(section: int, coords: int) -> int:
	var from: int = 0
	for x in range(0, section): from += sizes[x]
	for y in range(from, from + sizes[section]):
		for i in range(D.x(access[y]), D.y(access[y])):
			if coords == cluster[i]: return y
	return -1

enum { ACT, SPARK, FIRE, PRESS }

var walk_no: int = -1
var hero_box: PackedByteArray = [0, 0]
var hero_weight: PackedFloat32Array = [1, 1]

func lever_outer(body: Node2D, h: int) -> void:
	if body is AnimatableBody2D and body.is_in_group(&"box"):
		var no: int = body.get_meta(&"no")
		if no == hero_box[h]:
			hero_weight[h] *= box_weight[no]
			pushes(h, Vector2.ZERO)
			box_hero[h] = 0
	elif body is TileDecorator:
		body.nan_tile(HUD.level.lever_tile, h)

func lever_near(h: int) -> TileDecorator: return HUD.level.border.pos(HUD.level.entity[h].position + HUD.level.lever[h].position)
func lever_inner(body: Node2D, h: int) -> void:
	var hero: CharacterBody2D = HUD.level.entity[h]
	if body is AnimatableBody2D and body.is_in_group(&"box"):
		var no: int = body.get_meta(&"no"); hero_box[h] = no
		print("WEIGHT: ", hero_weight[h], " - TO: ", weight_d[int(box_weight[no])])
		hero_weight[h] *= weight_d[int(box_weight[no])]
	elif body is TileDecorator:
		var m: int = body.pos(hero.position).ground().mold()
		print("F_ID: ", F_ID, " & = ", F_ID & m, " m = ", m, " ??: ", D.byte4(m))
		if D.m(m, F_ID) or (D.byte(m, D.ID) == LOGIC and D.of(STAND, D.byte(m, D.ATLAS))):
			ledge_jump(h, hero.position); return
		
		m = lever_near(h).ground().get_tile(HUD.level.lever_tile, h).mold()
		var atlas: int = D.byte(m, D.ATLAS)
		if D.byte(m, D.ID) == LOGIC and D.of(BOXES, atlas):
			add_box(atlas, body.positioned())

func lever_outer_ray(border: Node2D) -> void: lever_outer(border, D.RAY)
func lever_outer_rock(border: Node2D) -> void: lever_outer(border, D.ROCK)
func lever_inner_ray(border: Node2D) -> void: lever_inner(border, D.RAY)
func lever_inner_rock(border: Node2D) -> void: lever_inner(border, D.ROCK)
func lever_apply(hero: int, type: int) -> void:
	var m: int = HUD.level.lever_tile[hero * 2]
	var atlas: int = D.byte(m, D.ATLAS)
	if atlas == 0: return
	elif type == FIRE: if (D.short(m, D.ALT) >> 2) == ICE_FLOOR: HUD.level.border.set_tile(HUD.level.lever_tile, hero).paint_alt()
	elif type == ACT: if D.of(C_LEVER, atlas): switch_cluster(LEVER, true)
	elif type == SPARK: if D.of(C_SOURCE, atlas): switch_cluster(SOURCE, true)

var transitions_part: PackedByteArray = []
var transitions_tile: PackedInt32Array = []
var cactus_stations: PackedByteArray = [0, 0, 0]

func enter_cooldown() -> void:
	for i in range(0, 3):
		if cactus_stations[0] > 0:
			cactus_stations[0] -= 1
	if cactus_stations[0] == 0 and cactus_stations[1] == 0 and cactus_stations[2] == 0:
		HUD.station_timer.stop()

func enter_station(no: int) -> void:
	if cactus_stations[0] == 0 and cactus_stations[1] == 0 and cactus_stations[2] == 0:
		HUD.station_timer.start()
	if cactus_stations[no] == 0:
		pass # replace cactus
	cactus_stations[no] = 24

func plate_outer_ray(border: TileDecorator) -> void: plate_outer(D.RAY, border)
func plate_outer_rock(border: TileDecorator) -> void: plate_outer(D.ROCK, border)
func plate_outer(hero: int, border: TileDecorator) -> void:
	if walk_no != -1: # not enter and 
		HUD.log_help_hide()
		walk_no = -1

	match HUD.level.press_tile[hero * 2 + D.ATLAS]:
		LEFT_CHAIN: chain_enter(hero, 0, 1)
		RIGHT_CHAIN: chain_enter(hero, 0, 1)
		H_SPRING_OFF: pass
	border.nan_tile(HUD.level.press_tile, hero)

func plate_inner_ray(border: TileDecorator) -> void: plate_inner(D.RAY, border)
func plate_inner_rock(border: TileDecorator) -> void: plate_inner(D.ROCK, border)
func plate_inner(hero: int, border: TileDecorator) -> void:
	var m: int = border.pos(HUD.level.entity[hero].position).id().atlas().type(PUDDLE_OFF).get_tile(HUD.level.press_tile, hero).mold()
	var atlas: int = D.byte(m, D.ATLAS)
	if D.of(WAYS, atlas):
		for i in range(0, len(transitions_part)):
			if border.m_coords() == transitions_tile[i]:
				HUD.transition_part = transitions_part[i]
				break
		HUD.entry_transit(HUD.GATE_IN); return
	match atlas:
		INSPIRER: HUD.append_dialog(hero, randi_range(65, 90)); enter_station(0) # TODO add face checks
		COMFORTER: HUD.adversary.affect(hero, +5, 0); enter_station(1)
		AMPLIFIER: HUD.adversary.affect(hero, 0, +3); enter_station(2)
		PLATE_OFF: switch_cluster(BUTTON, true) # enter
		PLATE_ON: switch_cluster(BUTTON, true)
		TELEPORT_ON:
			var c: int = get_cluster(TELEPORT, border.tile[COORDS])
			for i in range(D.x(access[c]), D.y(access[c])):
				if D.byte(HUD.level.border.coords(cluster[i]).mold(), D.ATLAS) == PLACE:
					HUD.level.entity[hero].teleport(HUD.level.border.map_to_local(D.map(cluster[i])))
					break
		HINT:
			# for hint loop
			if walk_no != -1: # border.tile[D.ID] == TYPE and 
				HUD.log_help(walk_no)
			elif D.byte(border.mold(), D.ID) == D.ID: # TODO replace did
				pass
		D_LADDER:
			HUD.set_part(HUD.LEVEL, HUD.DUNGEON, HUD.get_part(HUD.LEVEL, HUD.DUNGEON) + 1)
			HUD.entry_transit(HUD.LADDER_DOWN)
		U_LADDER:
			HUD.set_part(HUD.LEVEL, HUD.DUNGEON, HUD.get_part(HUD.LEVEL, HUD.DUNGEON) - 1)
			HUD.entry_transit(HUD.LADDER_UP)
		LEFT_CHAIN: chain_enter(hero, border.tile[D.ATLAS], 0)
		RIGHT_CHAIN: chain_enter(hero, border.tile[D.ATLAS], 0)
		H_SPRING_ON:
			# logic to disable collision
			HUD.level.entity[hero].velocity += Vector2(0, 60)
		_: return


const small: PackedScene = preload("res://def/entity/platform/box_small.tscn")

var grab: PackedByteArray = []

const weight_d: PackedFloat32Array = [0, 1, 0.5, 0.33, 0.25]

func is_sliding(no: int) -> bool: return D.of(hero_state[SLIDE], no)

func physics_process(_delta: float) -> void:
	for i in range(0, len(HUD.level.boxes)):
		HUD.level.boxes[i].move_and_collide(velocity[i])

func toggle_slide(no: int, next: bool) -> void:
	hero_state[SLIDE] = D.to(hero_state[SLIDE], no, next)

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
	var box: AnimatableBody2D = HUD.level.boxes[no]; box.set_meta(&"no", no)
	box.name = str(box.name, '_', no); box.position = pos + Vector2(0, 28)
	HUD.level.call_deferred(&"add_child", box)
	var see: Area2D = box.get_node(^"press")
	see.body_entered.connect(func(b: Node2D): plate_inner_box(b, no))
	see.body_exited.connect(func(b: Node2D): plate_outer_box(b, no))
	var fov: VisibleOnScreenNotifier2D = box.get_node(^"fov"); fov.screen_entered.connect(box.show); fov.screen_exited.connect(box.hide)
	HUD.level.border.atlas(GROUND).id(FLOOR).type(FLOORS).paint_alt() # coords(D.GROUND)
#"""
func throw(box: int, motion: Vector2i) -> void: velocity[box] = motion # * POWER
func pushes(box: int, motion: Vector2) -> void: velocity[box] = motion * weight_d[box_weight[box]]

func fixate_box(hero: int, box: int, _add: int) -> void:
	hero_state[hero] = D.t1(hero_state[hero], box)

func plate_inner_box(border: Node2D, no: int) -> void:
	border.pos(HUD.level.boxes[no].position).id().atlas().type(PUDDLE_OFF).get_tile(HUD.level.boxes_tile, no)
	if border.tile[D.ATLAS] == PLATE_OFF or border.tile[D.ATLAS] == PLATE_ON:
		switch_cluster(BUTTON, true)

func plate_outer_box(border: Node2D, no: int) -> void:
	match HUD.level.boxes_tile[no * 2 + D.ATLAS]:
		PLATE_OFF, PLATE_ON:
			switch_cluster(BUTTON, true)
	border.nan_tile(HUD.level.boxes_tile, no)

var press: PackedByteArray = [0, 0]
var press_coords: PackedInt32Array = [0, 0]
var press_button: PackedByteArray = [0, 0]
var button_coord: PackedInt32Array = [0, 0]
var rope_length: PackedByteArray = [1, 1]
var tile_motion: PackedVector2Array = [Vector2.ONE, Vector2.ONE]

func rope_fall(hero: int) -> void:
	for i in range(0, D.PARTY):
		if rope_length[i] == 0:
			var tween: Tween = HUD.create_tween()
			var pos: Vector2 = HUD.level.border.map_to_local(D.map(HUD.level.border.tile[COORDS]))
			tween.tween_property(HUD.adversary.entity[hero], ^"position", pos, 1.5)
		else:
			rope_length[i] -= 1

func chain_enter(hero: int, tile: int, y: int) -> void:
	press[hero] = tile
	tile_motion[hero].y = y

enum { CHAIN = 0, STATE = 0, JOINT = 1, A = -2, B = -1, TIME = 4, LENGTH = 10, NONE = -1, X = 1, Y = 1 << D.LEVEL }

var puddles: PackedInt32Array = [0, 0, 0, 0, 0, 0, 0, 0]
var current: Array[PackedInt32Array] = [[0, 0], [0, 0], [0, 0], [0, 0]] # Vector2i
var size: PackedByteArray = [LENGTH, LENGTH, LENGTH, LENGTH]
var rain: Node2D = null

var box_weight: PackedFloat32Array = [1.0]
var ride: PackedByteArray = [-1]
var velocity: PackedVector2Array = [Vector2.ZERO, Vector2.ZERO]

func draw_the_puddle() -> void:
	if rain == null:
		rain = load(D.rain).instantiate()
		HUD.level.border.add_child(rain)
	HUD.level.border.add_chip(rain)
	rain.shows()

func setup_sources() -> void:
	HUD.size[HUD.CURRENTS] = 0
	for coords in HUD.level.border.get_used_cells_by_id(LOGIC, D.map8(SOURCE_ON)):
		initiate_source(D.join(coords))

func initiate_source(coords: int) -> void:
	if HUD.size[HUD.CURRENTS] < len(size):
		size[HUD.size[HUD.CURRENTS]] = LENGTH
		for i in range(0, 2): current[HUD.size[HUD.CURRENTS]][i] = coords
	else:
		size.append(LENGTH)
		current.append([coords, coords])
	HUD.level.border.coords(coords).ground().atlas(SOURCE_ON).paint()
	contact(coords)
	HUD.size[HUD.CURRENTS] += 1

func diffusion() -> void:
	for i in range(1, 8):
		var state: int = D.half(puddles[STATE], i)
		if state == 0: continue
		if state - 1 == 0:
			HUD.level.border.coords(puddles[i]).id().atlas().type(PUDDLE_OFF).paint_alt()
			puddle_diffuse()
		puddles[STATE] = D.to_half(puddles[STATE], i, state - 1)
	if puddles[STATE] == 0: HUD.sparking.stop()

func puddle_diffuse() -> void: puddles[STATE] = D.to_half(puddles[STATE], 0, D.half(puddles[STATE], 0) - 1)
func sparking(tile: int) -> void:
	if D.m(puddles[STATE], 7): return
	for i in range(1, 8):
		if D.half(puddles[STATE], i) == 0:
			puddles[i] = tile
			HUD.level.border.coords(tile).id().atlas().type(PUDDLE_ON).paint_alt()
			puddles[STATE] = D.to_half(puddles[STATE], i, TIME)
			puddle_diffuse()
			break
	if D.half(puddles[STATE], 0) == 1:
		HUD.sparking.start()

func activate_puddle(pos: Vector2) -> void:
	if HUD.level.border.pos(pos).m_type() == PUDDLE_OFF:
		var coords: int = HUD.level.border.m_coords()
		if _around(coords): sparking(coords)
	else:
		contact(HUD.level.border.m_coords())

func _around(tile: int) -> bool:
	var m: int = HUD.level.border.coords(tile).id().type().mold()
	return D.m(m, SOURCE_ID) or (D.m(m, PUDDLE_ID) and D.byte(m, D.ATLAS) != WALL)

func contact(map_coords: int) -> void:
	if not (_around(map_coords + Y) or _around(map_coords + X) or
		_around(map_coords - Y) or _around(map_coords - X)): return
	
	map_coords = HUD.level.border.m_coords()
	if HUD.level.border.m_type() == PUDDLE_OFF:
		charge_unit(map_coords); return
	
	initiate_source(map_coords)
	if conduct(map_coords, current.size() - 1):
		HUD.level.border.coords(map_coords).ground().atlas(SOURCE_ON).paint()
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
			if not ((map_coords.y == D.y(b) and at_dimension(D.x(a), D.x(b), map_coords.x)) or
				(map_coords.x == D.x(b) and at_dimension(D.y(a), D.y(b), map_coords.y))):
				return tile
	return tile

func charge_unit(map_coords: int) -> void:
	for chain in range(current.size(), 0, -1):
		var delta: int = map_coords - current[chain][B]
		if D.m(D.x(delta) ^ D.y(delta), 1) and conduct(map_coords, chain):
			HUD.level.border.coords(map_coords).ground().atlas(PUDDLE_ON).paint()
			contact(map_coords)
			return

func get_direction(a: int, b: int) -> int: return clampi(D.y(a) - D.y(b), -1, 1) | clampi(D.x(a) - D.x(b), -1, 1)
func discharge_unit(map_coords: int) -> void:
	var site: Vector2i = get_site_to_discharge(D.map(map_coords))
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

func open_secret(h: int) -> bool: return D.m(HUD.level.lever_tile[h << 1], SECRET_ID)
func open_door(h: int) -> bool: return D.m(HUD.level.lever_tile[h << 1], GOLD_ID)
func near_water(h: int) -> bool: return D.m(HUD.level.lever_tile[h << 1], WATER_ID)
