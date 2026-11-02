class_name Action extends RefCounted
enum { 
# PLATFORMS
	LEFT, RIGHT, TOP, DOWN, CROSS_STAY, CROSS_LEFT, CROSS_RIGHT, CROSS_TOP, CROSS_DOWN,
	PLATFORM_POWER = 250, HALF_TILE = 32,
# MISC
	NO_BOX = -1, NZERO = 2, VELOCITY = 4, VELOCITY_BOX = 6, PLATFORMS = 10,
	
	STATIC = 1, COUNT = 8, JUMP = 0, DURATION = 1,
	CLOSE = 0, HEIGHT = 1, SHADOW = 2, PORTION = 3, JUMP_POWER = 10,
	
	LOGIC = 0, FLOOR = 1, ENTRY = 2, WALLS = 3, 
	HINT = 7, TAGS = 7, CHESTS = 9, GROUND = 9, # ALT
	ALT1 = 3, ALT2 = 2, ALT3 = 1, ALT4 = 0,
	
	COORDS = 4, T4 = 16, T8 = 64, # ID = 0, TYPE = 1, ALT = 2, ATLAS = 3, 
	
	FLOORS = 0, ICE_MECH = 0, HELP = 1,
	
	WALL = 3, LEDGE = 4, TILE_GROUND = 10, TRIGGER_TILE = 8, LEFT_CHAIN = 61,
	MID_CHAIN, RIGHT_CHAIN, PILLAR,
	
	PUDDLE_OFF, PUDDLE_ON, ICE_FLOOR, ICE_THICK,
	
	U_WAY, D_WAY, R_WAY, L_WAY, U_WAY_OUT, D_WAY_OUT,
# LOGIC
	BLUE_OFF = 0, BLUE_ON, RED_OFF, RED_ON, GREEN_OFF, GREEN_ON, WHITE_OFF,
	WHITE_ON, BLACK_OFF, BLACK_ON, BRONZE_OFF, BRONZE_ON, SILVER_OFF, SILVER_ON,
	GOLD_OFF, GOLD_ON, PLATINUM_OFF, PLATINUM_ON, PLACE, TELEPORT_ON, SOURCE_OFF,
	SOURCE_ON, LEVER_OFF, LEVER_ON, PLATE_OFF, PLATE_ON, TELEPORT_OFF, SPIKER,
	COMFORTER, AMPLIFIER, INSPIRER, SMALL_BOX, FIRE_BOX, LARGE_BOX, STAND_OFF, STAND_ON,
	NAVIGATOR,
# LOCATION
	U_WATER = 0, U_EXIT, U_WALL_OFF, U_WALL_ON, U_LADDER, D_LADDER, ENEMY, BOSS,
	M_WATER, M_EXIT, D_WALL_OFF, D_WALL_ON, H_SPRING_OFF, H_SPRING_ON, B_SPRING_OFF,
	B_SPRING_ON, D_WATER, D_EXIT, SLIDE, PILLAR_OLD, G_SECRET_OFF, G_SECRET_ON,
	W_SECRET_OFF, W_SECRET_ON, PAGE,
} # tiles
enum { CLUSTER = 64, LEVER = 0, SOURCE, BUTTON, TRANSP,
	_ID = 0, _ATLAS = 8, _ALT = 16, _TYPE = 18, # + 2 (as real type (-alt))
# TILE MOLD ID
	SOURCE_ID = LOGIC | (SOURCE_OFF << _ATLAS), F_ID = FLOOR | (FLOORS << _TYPE),
	PUDDLE_ID = FLOOR | (PUDDLE_ON << _TYPE), ICE_ID = FLOOR | (ICE_FLOOR << _TYPE),
	GROUND_ID = WALLS | (GROUND << _ATLAS),
	WATER_ID = ENTRY | (D_WATER << _ATLAS),
	
	TELEPORT_ID = LOGIC | (TELEPORT_ON << _ATLAS),
	SECRET_ID = LOGIC | (GOLD_OFF << _ATLAS), # FIXME change both to doors
	GOLD_ID = LOGIC | (GOLD_OFF << _ATLAS),
# TILE INTERSECTION
	W_CHAIN = (1<<LEFT_CHAIN)|(1<<RIGHT_CHAIN),
	W_BOXES = (1<<SMALL_BOX)|(1<<LARGE_BOX), W_STANDS = (1<<STAND_OFF)|(1<<STAND_ON),
	W_LEVER = (1<<LEVER_OFF)|(1<<LEVER_ON), W_SOURCE = (1<<SOURCE_OFF)|(1<<SOURCE_ON),
	W_PLATE = (1<<PLATE_OFF)|(1<<PLATE_ON), W_TRANSP = (1<<TELEPORT_OFF)|(1<<PLACE),
	W_UWALL = (1<<U_WALL_OFF)|(1<<U_WALL_ON), W_DWALL = (1<<D_WALL_OFF)|(1<<D_WALL_ON),
	W_BOX_STAND = W_BOXES | (1<<STAND_ON),
	
	W_WAYS = (1<<U_WAY)|(1<<D_WAY)|(1<<R_WAY)|(1<<L_WAY)|(1<<U_WAY_OUT)|(1<<D_WAY_OUT),
	W_MECH = (1<<U_WALL_OFF)|(1<<U_WALL_ON)|(1<<D_WALL_OFF)|(1<<D_WALL_ON)|(1<<STAND_OFF)|(1<<STAND_ON)
}

var directed: PackedVector2Array = [Vector2.ZERO, Vector2.ZERO,  Vector2.ZERO, Vector2.ZERO,  Vector2.ZERO, Vector2.ZERO,  Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO,  Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)]
const position: PackedVector2Array = [Vector2(20, 22), Vector2(0, -48), Vector2(0.6, 0.72), Vector2(0.125, 0.2)]

enum { CHAIN = 0, STATE = 0, JOINT = 1, A = -2, B = -1, TIME = 4, LENGTH = 10, NONE = -1, X = 1, Y = 1 << D.LEVEL }

var puddles: PackedInt32Array = [0, 0, 0, 0, 0, 0, 0, 0]
var current: Array[PackedInt32Array] = [[0, 0], [0, 0], [0, 0], [0, 0]] # Vector2i
var size: PackedByteArray = [LENGTH, LENGTH, LENGTH, LENGTH]
var rain: Node2D = null
var ride: PackedByteArray = [-1]

var transitions_part: PackedByteArray = []
var transitions_tile: PackedInt32Array = []

const box_small: PackedScene = preload("res://def/entity/platform/box_small.tscn")
const box_large: StringName = &"res://def/entity/platform/box_large.tscn"
const box_fire: StringName = &"res://def/entity/platform/box_fire.tscn"

var sizes: PackedByteArray = [0, 0, 0, 0]
var hint: PackedInt32Array = []

# TODO BOOKS
var platforms: Array[CharacterBody2D] = []
var platform_dir: PackedByteArray = [CROSS_STAY]
var fallback: PackedByteArray = [255, 255, 255, 255, 255, 255, 255]

func on_tile(pos: Vector2) -> PackedInt32Array: return HUD.level.border.pos(pos).id().atlas().type().tile
func direct(h: int, dir: Vector2) -> void:
	var change: bool = directed[h] != dir; directed[h] = dir
	if dir != Vector2.ZERO: directed[NZERO | h] = dir
	if change: HUD.adversary.mirror_animation(h, HUD.adversary.sprite_dir[D.direct(directed[NZERO | h].round())] + HUD.level.profile[h].animation.substr(2)) # print("DIR: ", D.direct(directed_nzero[h].round()))

func movement(event: InputEvent, key2: bool) -> void:
	var h: int = HUD.settings.get_hero(event); direct(h, Input.get_vector(&"left", &"right", &"forward", &"backward"))
	if key2:
		var h2: int = HUD.settings.key_hero(); direct(h2, Input.get_vector(&"left_2", &"right_2", &"forward_2", &"backward_2"))
		if HUD.did(h2, D.DEPLOYED) and directed[h2] != Vector2.ZERO:
			HUD.dont(h2, D.DEPLOYED)
			HUD.level.entity[h2].show()
			HUD.level.entity[h2].process_mode = Node.PROCESS_MODE_ALWAYS
		move_hero(h2, Input.is_action_pressed(&"act1_2"), directed[h2] == Vector2.ZERO)
	move_hero(h, Input.is_action_pressed(&"act1"), directed[h] == Vector2.ZERO)

func get_box_height(b: int) -> int: return D.part(HUD.has(D.HEIGHTS), b)
func move_hero(h: int, act: bool, in_place: bool) -> void: # directed2
	if HUD.did(h, D.JUMPED): pass
	elif HUD.level.entity[h].box != NO_BOX: # direct(h, directed[h].round())
		ledge_jump(h, get_box_height(HUD.level.entity[h].box))
	else:
		if not in_place and not act:
			HUD.level.lever[h].position = position[CLOSE] * directed[h]
		if HUD.did(h, D.RUN):
			directed[VELOCITY | h] = directed[h] * (D.MOVE << 1)
		else:
			directed[VELOCITY | h] = directed[h] * D.MOVE
		if in_place:
			HUD.adversary.set_anim(h, Adversary.IDLE)
		elif HUD.did(h, D.RUN):
			HUD.adversary.set_anim(h, Adversary.RUN)
		else:
			HUD.adversary.set_anim(h, Adversary.WALK)

func add_particle(asset: GPUParticles2D, path: StringName, name: StringName, next: Vector2) -> void:
	if asset == null:
		asset = load(path).instantiate()
		asset.one_shot = true
		HUD.level.set(name, asset)
		HUD.level.add_child(asset)
	else:
		asset.restart()
	asset.position = next

func puddle_tile(h: int) -> void:
	var m: int = HUD.level.border.pos(HUD.level.w_lever(h)).ground().mold()
	if !(D.m(m, F_ID) or D.m(m, GROUND_ID)): return
	HUD.level.border.id(FLOOR).alt(ALT1).type(PUDDLE_OFF).paint_alt()
	add_particle(HUD.level.rain, D.rain, &"rain", HUD.level.w_lever(h)) # source
	contact(HUD.level.border.m_coords())

func melt_ice(h: int) -> void:
	HUD.level.border.set_tile(HUD.level.lever_tile, h).type(FLOORS).paint_alt()
	add_particle(HUD.level.fire, D.fire, &"fire", HUD.level.w_lever(h))

func toggle_collision(h: int, next: bool) -> void:
	HUD.level.entity[h].set_collision_layer_value(STATIC, next)
	HUD.level.entity[h].set_collision_mask_value(STATIC, next)

func toggle_stuck(h: int, next: bool) -> void:
	HUD.level.lever_body[h].set_deferred(&"disabled", not next)
	HUD.level.plate_body[h].set_deferred(&"disabled", not next)
	toggle_collision(h, next)

func can_box_jump(coords: int, f1: int, f2: int) -> int:
	for b in range(0, len(HUD.level.boxes)):
		var c: int = HUD.level.border.pos(HUD.level.boxes[b].position).ground().m_coords()
		if c == coords and (f1 == (f2 + get_box_height(b))): return b
	return -1

func get_jump_length(h: int) -> Vector2:
	var dir: Vector2 = directed[h] * 128
	if dir.x != 0 and dir.y != 0: dir.x = 0
	return dir

func boxes_jump(h: int, no: int) -> void:
	HUD.level.entity[h].reparent(HUD.level.boxes[no], true)
	HUD.adversary.set_anim(h, Adversary.JUMP)
	var delta: Vector2 = HUD.level.boxes[no].position - HUD.level.entity[h].position
	var tween: Tween = HUD.create_tween(); HUD.do(h, D.JUMPED)
	tween.tween_method(func(t: float):
		HUD.level.entity[h].position = (delta * (1.0 - t))
		HUD.level.profile[h].frame = roundi(t * 12)
		HUD.level.entity[h].shadow.scale = t * position[SHADOW] * position[PORTION][JUMP]
	, 0.0, 1.0, 0.25)
	tween.tween_callback(func(): toggle_stuck(h, true))

func place_jump(h: int, p: Vector2, m: int, c: int) -> void:
	if !(D.m(m, F_ID) or (D.m(m, LOGIC) and D.of(W_BOX_STAND, D.byte(m, D.ATLAS)))): return
	var pos: Vector2 = HUD.level.border.map_to_local(D.map(c)) # print("M: ", D.byte4(m), " - atl: ", atlas)
	var delta: Vector2 = pos - p
	HUD.adversary.set_anim(h, Adversary.JUMP)
	var tween: Tween = HUD.create_tween(); HUD.do(h, D.JUMPED)
	tween.tween_method(func(t: float):
		var slot: int = roundi(t * 12)
		HUD.level.entity[h].position = p + (delta * t)
		HUD.level.entity[h].shadow.scale = slot * position[SHADOW] * position[PORTION][JUMP]
		HUD.level.profile[h].frame = slot
	, 0.0, 1.0, 0.25)
	tween.tween_callback(func(): toggle_stuck(h, true))

func ledge_jump(h: int, height: int) -> void:
	var b: TileDecorator = HUD.level.border; var dir: Vector2 = get_jump_length(h); if dir.round() == Vector2.ZERO: return
	var pos: Vector2 = HUD.level.entity[h].position
	var f1: int = b.pos(pos).ground().extract(D.FLOOR) + height
	var f2: int = b.pos(pos + dir).ground().extract(D.FLOOR)
	var c: int = b.m_coords(); var no: int = can_box_jump(c, f1, f2)
	if no != -1:
		toggle_stuck(h, false); call_deferred(&"boxes_jump", h, no)
	elif f1 == f2:
		toggle_stuck(h, false); place_jump(h, pos, b.mold(), c)

func box_move() -> void:
	pass

func move_platform(i: int, from: int, to: int) -> void:
	var pos: Vector2 = platforms[i].position + directed[PLATFORMS | from] * HALF_TILE
	if HUD.level.border.pos(platforms[i].position).ground().tile[D.ATLAS] == TILE_GROUND:
		platform_dir[i] = to
	else:
		platforms[i].velocity += directed[PLATFORMS | from] * PLATFORM_POWER

func move_cargo_platform(i: int) -> void:
	if fallback[i] == 0 or HUD.level.border.pos(platforms[i].position).ground().tile[D.ALT] == ALT1:
		platform_dir[i] = CROSS_STAY
		fallback[i] = 255
	else:
		platforms[i].velocity += directed[PLATFORMS | platform_dir[i]] * PLATFORM_POWER
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

func select_coords(atlas: int) -> int:
	match atlas:
		PLATE_OFF: return PLATE_ON
		PLATE_ON: return PLATE_OFF
		LEVER_OFF: return LEVER_ON
		LEVER_ON: return LEVER_OFF
		SOURCE_OFF: return SOURCE_ON
		U_WALL_OFF: return U_WALL_ON
		U_WALL_ON: return U_WALL_OFF
		D_WALL_OFF: return D_WALL_ON
		D_WALL_ON: return D_WALL_OFF
		STAND_OFF: return STAND_OFF
		STAND_ON: return STAND_ON
	return -1

func toggle_close(header: int) -> void: var no: int = HUD.selected + HUD.COMPLETED; HUD.session[no] = D.t0(HUD.session[no], header)
func toggle_open(header: int) -> void: var no: int = HUD.selected + HUD.COMPLETED; HUD.session[no] = D.t1(HUD.session[no], header)
func toggle_coords(header: int) -> void:
	for i in range(HUD.level.access[header], HUD.level.access[header + 1]):
		var atlas: int = D.byte(HUD.level.border.coords(HUD.level.coords[i]).ground().mold(), D.ATLAS)
		HUD.level.border.atlas(select_coords(atlas)).paint()

func toggle_header(header: int) -> void:
	if header == -1: return
	var atlas: int = D.byte(HUD.level.border.coords(HUD.level.coords[HUD.level.access[header]]).ground().mold(), D.ATLAS)
	match atlas:
		PLATE_OFF: toggle_open(header); toggle_coords(header)
		PLATE_ON: toggle_close(header); toggle_coords(header)
		LEVER_OFF: toggle_open(header); toggle_coords(header)
		LEVER_ON: toggle_close(header); toggle_coords(header)
		SOURCE_OFF: toggle_open(header); toggle_coords(header)

func toggle_header_in(header: int) -> void:
	#match atlas
		# heavy button - # HUD.level.border.atlas(atlas).paint() # for selected
	toggle_header(header)
func toggle_header_out(header: int) -> void: toggle_header(header)
func search_header(coords: int) -> int: HUD.level.border.coords(coords).ground(); return search_header_mold()
func search_header_pos(pos: Vector2, tiles: PackedInt32Array, no: int) -> int: HUD.level.border.pos(pos).ground().get_tile(tiles, no); return search_header_mold()
func search_header_mold() -> int:
	var m: int = HUD.level.border.mold(); if !D.m(m, LOGIC): return -1
	var coords: int = HUD.level.border.m_coords(); var atlas: int = D.byte(m, D.ATLAS)
	var from: int; var to: int; var full: bool
	if D.of(W_LEVER, atlas): from = HUD.level.entry[LEVER]; to = HUD.level.entry[SOURCE]
	elif D.of(W_SOURCE, atlas): from = HUD.level.entry[SOURCE]; to = HUD.level.entry[BUTTON]
	elif D.of(W_PLATE, atlas): from = HUD.level.entry[BUTTON]; to = HUD.level.entry[TRANSP]
	elif D.m(W_TRANSP, atlas): from = HUD.level.entry[TRANSP]; to = len(HUD.level.access); full = true
	else: return -1
	for i in range(from, to):
		if full: for j in range(HUD.level.access[i], HUD.level.access[i + 1]): if HUD.level.coords[j] == coords: return i
		elif HUD.level.coords[HUD.level.access[i]] == coords: return i
	return -1

func punch_apply(h: int) -> void:
	var m: int = HUD.level.border.set_tile(HUD.level.lever_tile, h).mold()
	if D.byte(m, LOGIC):
		toggle_header(search_header(HUD.level.border.m_coords()))

func skill_a_apply(h: int) -> void:
	var m: int = HUD.level.border.set_tile(HUD.level.lever_tile, h).mold()
	match h:
		D.RAY: if D.m(m, ICE_ID): HUD.level.border.type(FLOORS).paint_alt()
		D.ROCK: if D.m(m, F_ID): HUD.level.border.type(PUDDLE_ON).paint_alt()

func skill_b_apply(h: int) -> void:
	var m: int = HUD.level.border.set_tile(HUD.level.lever_tile, h).mold()
	match h:
		D.RAY: pass
		D.ROCK:
			if D.m(m, LOGIC): toggle_header(search_header(HUD.level.border.m_coords()))
			elif D.m(m, PUDDLE_ID): HUD.level.border.type(PUDDLE_ON).paint_alt()

func lever_outer(body: Node2D, h: int) -> void:
	if body is AnimatableBody2D and body.is_in_group(&"box"):
		var no: int = body.get_meta(&"no")
		var box: int = HUD.has(D.BOX_HERO | h)
		if no == box:
			box *= D.part(HUD.has(D.WEIGHTS), no)
			HUD.hasnt(D.BOX_HERO | h)
	elif body is TileDecorator:
		body.nan_tile(HUD.level.lever_tile, h)

func lever_inner(body: Node2D, h: int) -> void:
	var hero: CharacterBody2D = HUD.level.entity[h]
	if body is AnimatableBody2D and body.is_in_group(&"box"):
		var no: int = body.get_meta(&"no"); var w: int = D.part(HUD.has(D.WEIGHTS), h)
		HUD.having(D.BOX_HERO | h, no) # print("WEIGHT: ", hero_weight[h], " - TO: ", weight_d[int(box_weight[no])])
		HUD.having(D.HERO_WEIGHT | h, D.MOVE * int(w == 0) + D.MOVE_BOX * int(w == 0))
	elif body is TileDecorator:
		var m: int = body.pos(hero.position).ground().mold() # print("F_ID: ", F_ID, " & = ", F_ID & m, " m = ", m, " ??: ", D.byte4(m))
		if D.m(m, F_ID) or (D.m(m, LOGIC) and D.of(W_BOX_STAND, D.byte(m, D.ATLAS))):
			ledge_jump(h, 0); return
		
		m = HUD.level.border.pos(HUD.level.w_lever(h)).ground().get_tile(HUD.level.lever_tile, h).mold()
		var atlas: int = D.byte(m, D.ATLAS)
		if D.m(m, LOGIC) and D.of(W_BOXES, atlas):
			add_box(atlas, body.positioned())

func lever_outer_ray(border: Node2D) -> void: lever_outer(border, D.RAY)
func lever_outer_rock(border: Node2D) -> void: lever_outer(border, D.ROCK)
func lever_inner_ray(border: Node2D) -> void: lever_inner(border, D.RAY)
func lever_inner_rock(border: Node2D) -> void: lever_inner(border, D.ROCK)

func enter_cooldown() -> void:
	var cactuses: int = HUD.has(D.CACTUSES)
	for i in range(0, 3):
		var n: int = D.part(cactuses, i); if n == 0: continue
		n -= 1; cactuses = D.to_part(cactuses, i, n)
	if cactuses == 0: HUD.station_timer.stop()
	HUD.having(D.CACTUSES, cactuses)

func enter_station(h: int, no: int) -> void:
	var cactuses: int = HUD.has(D.CACTUSES)
	if D.byte(cactuses, 0) == 0:
		if cactuses == 0: HUD.station_timer.start()
		cactuses = D.to_byte(cactuses, no, 24)
		HUD.having(D.CACTUSES, cactuses)
		match no:
			0: HUD.append_dialog(h, randi_range(65, 90))
			1: HUD.adversary.affect(h, +5, 0)
			2: HUD.adversary.affect(h, 0, +3)

func plate_outer_ray(border: TileDecorator) -> void: plate_outer(D.RAY, border)
func plate_outer_rock(border: TileDecorator) -> void: plate_outer(D.ROCK, border)
func plate_outer(hero: int, border: TileDecorator) -> void:
	var atlas: int = D.byte(HUD.level.press_tile[hero << 1], D.ATLAS)
	if D.of(atlas, W_CHAIN):
		HUD.dont(hero, D.CHAINED)
	elif atlas == HINT:
		HUD.log_help_hide()
	border.nan_tile(HUD.level.press_tile, hero)

func plate_inner_ray(border: TileDecorator) -> void: plate_inner(D.RAY, border)
func plate_inner_rock(border: TileDecorator) -> void: plate_inner(D.ROCK, border)
func plate_inner(hero: int, border: TileDecorator) -> void: # PUDDLE_OFF
	var m: int = border.pos(HUD.level.entity[hero].position).ground().get_tile(HUD.level.press_tile, hero).mold()
	var atlas: int = D.byte(m, D.ATLAS)
	if D.of(W_WAYS, atlas):
		for i in range(0, len(transitions_part)): if border.m_coords() == transitions_tile[i]: HUD.transition_part = transitions_part[i]; break
		HUD.entry_transit(HUD.GATE_IN); return
	elif D.of(W_CHAIN, atlas):
		HUD.do(hero, D.CHAINED); return
	elif D.m(m, TELEPORT_ID):
		var h: int = search_header(border.m_coords())
		HUD.level.action.teleport(hero, HUD.level.border.map_to_local(D.map(HUD.level.coords[HUD.level.access[h]])))
	match atlas:
		INSPIRER: enter_station(hero, 0) # TODO add face checks
		COMFORTER: enter_station(hero, 1)
		AMPLIFIER: enter_station(hero, 2)
		NAVIGATOR: pass
		HINT: # for hint loop
			if D.m(border.mold(), D.ID): # TODO replace did
				pass
			else:
				pass # SEARCH FOR HUD.log_help(walk_no)
		D_LADDER:
			HUD.set_part(HUD.LEVEL, HUD.DUNGEON, HUD.get_part(HUD.LEVEL, HUD.DUNGEON) + 1)
			HUD.entry_transit(HUD.LADDER_DOWN)
		U_LADDER:
			HUD.set_part(HUD.LEVEL, HUD.DUNGEON, HUD.get_part(HUD.LEVEL, HUD.DUNGEON) - 1)
			HUD.entry_transit(HUD.LADDER_UP)
		_: return

func physics_process(_delta: float) -> void:
	for i in range(0, len(HUD.level.boxes)):
		HUD.level.boxes[i].move_and_collide(directed[VELOCITY | i])

func toggle_slide(no: int, next: bool) -> void:
	if next: HUD.do(no, D.SLIDED)
	else: HUD.dont(no, D.SLIDED)

func slide_the_box(_box: CharacterBody2D) -> void:
	pass #TODO FIXME gravity
	# box.make_velocity(Vector2(box.velocity.x, GRAVITY)) # * delta

func set_box(asset: PackedScene, h: int, w: int) -> void:
	var last: int = HUD.level.boxes.size()
	HUD.having(D.HEIGHTS, D.to_part(HUD.has(D.HEIGHTS), last, h))
	HUD.having(D.WEIGHTS, D.to_part(HUD.has(D.WEIGHTS), last, w))
	HUD.level.boxes.append(asset.instantiate())
	directed[VELOCITY_BOX | last] = Vector2.ZERO
# """
func add_box(box_type: int, pos: Vector2) -> void:
	var no: int = HUD.level.boxes.size()
	assert(no < 4, "AVAILABLE TO SAVE ONLY 4 BOXES")
	match box_type:
		SMALL_BOX: set_box(box_small, 1, 2)
		LARGE_BOX: set_box(load(box_large), 2, 4)
		FIRE_BOX: set_box(load(box_fire), 0, 2)
	print("LEVEL: ", SMALL_BOX, " - B: ", box_type)
	var box: AnimatableBody2D = HUD.level.boxes[no]
	box.set_meta(&"no", no)
	box.name = str(box.name, '_', no)
	box.position = pos + Vector2(0, 28)
	HUD.level.call_deferred(&"add_child", box)
	var see: Area2D = box.get_node(^"press")
	match no:
		0: see.body_entered.connect(plate_inner_1); see.body_exited.connect(plate_outer_1)
		1: see.body_entered.connect(plate_inner_2); see.body_exited.connect(plate_outer_2)
		2: see.body_entered.connect(plate_inner_3); see.body_exited.connect(plate_outer_3)
		3: see.body_entered.connect(plate_inner_4); see.body_exited.connect(plate_outer_4)
	var fov: VisibleOnScreenNotifier2D = box.get_node(^"fov"); fov.screen_entered.connect(box.show); fov.screen_exited.connect(box.hide)
	HUD.level.border.pos(pos).atlas(GROUND).id(FLOOR).type(FLOORS).paint_alt() # coords(D.GROUND)
#"""
func plate_inner_1(border: Node2D) -> void: plate_inner_box(border, 0)
func plate_inner_2(border: Node2D) -> void: plate_inner_box(border, 1)
func plate_inner_3(border: Node2D) -> void: plate_inner_box(border, 2)
func plate_inner_4(border: Node2D) -> void: plate_inner_box(border, 3)
func plate_inner_box(_border: TileDecorator, no: int) -> void: toggle_header_in(search_header_pos(HUD.level.boxes[no].position, HUD.level.boxes_tile, no))
func plate_outer_1(border: Node2D) -> void: plate_inner_box(border, 0)
func plate_outer_2(border: Node2D) -> void: plate_inner_box(border, 1)
func plate_outer_3(border: Node2D) -> void: plate_inner_box(border, 2)
func plate_outer_4(border: Node2D) -> void: plate_inner_box(border, 3)
func plate_outer_box(border: Node2D, no: int) -> void: toggle_header_out(search_header(HUD.level.boxes_tile[(no << 1) | 1])); border.nan_tile(HUD.level.boxes_tile, no)

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
