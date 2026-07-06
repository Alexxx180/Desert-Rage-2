class_name HeroDeploy extends RefCounted

enum { SPEED, HOLD = 0, WORLD = 0, MIN, RELEASE = 1, BORDERS = 1, MAX, ENTITY = 2,
	INCREMENT, GROUND = 3, TRIGGER = 4, GAP = 7, UPLAND = 8, GRAVITY = 700000, JUMP = 200000 }

var initial: Vector2
var meter: PackedFloat32Array = [1.0, 1.0, 2.25, 0.05]
var timer: Timer
var hero: int
var _hero: Node:
	get: return HUD.level.group.hero[hero]
var state: PackedByteArray = [0, 0]

func speeding() -> void:
	meter[SPEED] += meter[INCREMENT]
	_hero.to.moves.set_walk_speed(meter[SPEED])
	if meter[SPEED] >= meter[MAX]:
		HUD.level.states = Bit.to(HUD.level.states, RELEASE, true)
		timer.stop()
	elif meter[SPEED] >= meter[MAX] * 0.5:
		_hero.to.moves.set_running(true)

func run_hold() -> void:
	if not Bit.of(HUD.level.states, HOLD):
		_hero.state = Bit.to(_hero.state, _hero.RUN, true)
		HUD.level.states = Bit.to(HUD.level.states, HOLD, true)
		timer.start()

func run_release() -> void:
	if not Bit.of(HUD.level.states, RELEASE):
		_hero.state = Bit.to(_hero.state, _hero.RUN, false)
		HUD.level.states = 0
		meter[SPEED] = meter[MIN]
		_hero.to.moves.set_walk_speed(meter[SPEED])
		_hero.to.moves.set_running(false)
	timer.stop()

func walk(velocity: Vector2) -> void:
	_hero.add_velocity(velocity * meter[SPEED])

func next() -> int: return (HUD.hero + 1) & Def.ROCK

func switch_hero(hero: int, process: bool) -> void:
	HUD.level.entity[hero].visible = process
	HUD.level.entity[hero].process_mode = (int(process) << 2) ^ Node.PROCESS_MODE_DISABLED
	HUD.state = Bit.to_(HUD.state, Def.DEPLOYED)

func select() -> void:
	var that: int = next()
	HUD.level.load_hero(that)
	# if Bit.of(HUD.state, Def.DEPLOYED):
	HUD.level.entity[that].position = HUD.level.entity[HUD.hero].position
	traverse_camera()
	HUD.hero = that

func deploy() -> void:
	var that: int = next()
	HUD.level.load_hero(that)
	var delta: float = HUD.level.entity[HUD.hero].position.distance_squared_to(
		HUD.level.entity[that].position)
	if delta >= Def.DEPLOY_DELTA: return
	if (Bit.of(HUD.level.state[HUD.hero], Def.BOX) or 
		Bit.of(HUD.level.state[that], Def.BOX)): return
	var f1: int = HUD.level.border.extract_at_pos(HUD.level.entity[HUD.hero])
	var f2: int = HUD.level.border.extract_at_pos(HUD.level.entity[that])
	if f1 != f2: return
	switch_hero(HUD.hero, !Bit.of(HUD.state, Def.DEPLOYED))

func setup_location() -> void:
	traverse_camera()
	for i in [Def.RAY, Def.ROCK]:
		HUD.level.entity[i].position = HUD.level.group.position
	HUD.level.group.position = Vector2.ZERO
	if Bit.of(HUD.state, Def.DEPLOYED): deploy()

func controls() -> void:
	setup_location()
	if Bit.of(HUD.level.group.mode, Def.OVERWORLD): overworld()

func sync_pos() -> void:
	HUD.level.entity[next()].position = HUD.level.entity[HUD.hero]

func forget_velocity() -> void:
	for i in Def.ENEMY:
		HUD.level.entity[i].add_velocity(Vector2.ZERO)

func traverse_camera():
	#var h: CharacterBody2D = HUD.level.entity[HUD.hero]
	var n: CharacterBody2D = HUD.level.entity[next()]
	# if not Bit.of(h.state[HUD.hero], Def.CAMERA):
		# h.state[Def.STATUS] = Bit.to1(h.state[Def.STATUS], Def.CAMERA)
		# n.state[Def.STATUS] = Bit.to0(n.state[Def.STATUS], Def.CAMERA)
	#if Bit.of(state[HUD.hero], Def.BOX): # TODO FIXME Box group
	#	HUD.level.group.position = h.position
	#	HUD.level.group.reparent(HUD.level)
	#else:
	HUD.level.group.position = Vector2.ZERO
	HUD.level.group.reparent(n)

var zoom: Vector3 = Vector3(0.5, 0.1, 1.5)

func overworld() -> void: zoom = Vector3(0.1, 0.05, 0.5)
func zoom_camera() -> void:
	var z: float = Input.get_axis("view_left", "view_right")
	if z != 0:
		zoom.x = clampf(zoom.x + z, zoom.y, zoom.z)
		HUD.level.group.zoom = Vector2(zoom.x, zoom.x)
