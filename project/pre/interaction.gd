class_name WorldInteraction extends RefCounted

enum { STATIC = 1, JUMPED = 0, JUMPING, COUNT = 8, JUMP = 0, DURATION = 1,
	CLOSE = 0, HEIGHT = 1, SHADOW = 2, PORTION = 3, JUMP_POWER = 10 }

var hero: CharacterBody2D:
	get: return HUD.level.entity[HUD.hero]
var _tile: PackedInt32Array:
	get: return HUD.level.border.tile

var directed: Vector2 ; var off: Vector2
var state: PackedByteArray = [0, 0]

const stand: PackedInt32Array = [Def.STAND_ON, Def.SMALL_BOX, Def.LARGE_BOX]
const position: PackedVector2Array = [Vector2(20, 22), Vector2(0, -48), Vector2(0.6, 0.72), Vector2(0.125, 0.2)]

func on_tile(pos: Vector2) -> PackedInt32Array: return HUD.level.border.pos(pos).id().atlas().type().tile

func movement(act: bool) -> void:
	directed = Input.get_vector(&"left", &"right", &"forward", &"backward")
	var in_place: bool = directed == Vector2.ZERO
	if Bit.of(state[HUD.hero], JUMPING): return
	
	if Bit.of(state[HUD.hero], JUMPED):
		if hero.box == -1:
			ledge_jump(hero.position) # pass
			HUD.animation.direct(directed.round())
			hero.lever.position = position[CLOSE] * directed
		elif not in_place:
			var box: AnimatableBody2D = HUD.level.boxes.get_box(hero.box)
			ledge_jump(box.position, HUD.level.boxes.height[box.get_meta(&"no")])
	else:
		var motion: Vector2 = directed * Def.MOVE
		# var dir: Vector2 = Vector2(1, 2) if directed.y != 0 else Vector2.ONE
		for box in hero.boxes: HUD.level.boxes.pushes(box, motion)# * dir) #  + directed * 2
		hero.make_velocity(motion)
		if not in_place and not act:
			hero.lever.position = position[CLOSE] * directed
	if in_place:
		HUD.animation.stop_animation()
	elif state[HUD.hero] == 0:
		HUD.animation.direct(directed.round())
		HUD.animation.animate()

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
	var pos: Vector2 = hero.position + hero.lever.position
	if on_tile(pos)[Def.ID] == Def.FLOOR and _tile[Def.TYPE] == Def.FLOORS:
		pass
	elif _tile[Def.ID] == Def.WALLS and _tile[Def.ATLAS] == Def.GROUND:
		HUD.level.border.id(Def.FLOOR).alt(Def.ALT1)
	else:
		return
	HUD.level.border.type(Def.PUDDLE_OFF).paint_alt()
	add_particle(HUD.level.rain, Def.rain, &"rain", pos)
	HUD.level.conductor.contact(_tile[Def.COORDS])

func melt_ice() -> void:
	var pos: Vector2 = hero.position + hero.lever.position
	if on_tile(pos)[Def.ID] == Def.FLOOR and _tile[Def.TYPE] == Def.ICE_FLOOR:
		HUD.level.border.type(Def.PUDDLE_OFF).paint_alt()
		add_particle(HUD.level.fire, Def.fire, &"fire", pos) # TileDecorator

func toggle_stuck(next: bool) -> void:
	hero.lever_body.set_deferred(&"disabled", not next)
	hero.plate_body.set_deferred(&"disabled", not next)
	hero.set_collision_layer_value(STATIC, next)
	hero.set_collision_mask_value(STATIC, next)

func ledge_jump(pos: Vector2, height: int = 0) -> void:
	var d: Vector2 = directed.round()
	if d == Vector2.ZERO: return
	
	var dir: Vector2 = Vector2.ONE * 128 * (Vector2(0, directed.y)
		if directed.x != 0 and directed.y != 0 else directed) ; on_tile(pos)
	var f1: int = HUD.level.border.extract(TileDecorator.FLOOR) + height
	var t: PackedInt32Array = on_tile(pos + dir).duplicate()
	var f2: int = HUD.level.border.extract(TileDecorator.FLOOR)
	var jumped: bool = false ; var no: int = -1
	if HUD.level._boxes != null:
		for i in range(0, len(HUD.level.boxes.assets)):
			var c: int = on_tile(HUD.level.boxes.assets[i].position)[Def.COORDS]
			jumped = c == t[Def.COORDS] and (f1 == f2 + HUD.level.boxes.height[i])
			if jumped: no = i; break
	if jumped:
		pos = position[HEIGHT]
	elif f1 == f2:
		pos = HUD.level.border.map_to_local(Def.tomap(t[Def.COORDS]))
		jumped = t[Def.ID] == Def.LOGIC and t[Def.ATLAS] in stand
		if jumped: off = Vector2(0, 18) ; pos -= off
		elif t[Def.ID] == Def.FLOOR and t[Def.TYPE] == Def.FLOORS:
			pos -= off ; off = Vector2.ZERO
			jumped = t[Def.ATLAS] == Def.LEDGE
		else: return
	else: return
	
	Bit.b(state, HUD.hero, JUMPED, jumped)
	toggle_stuck(false)
	if no != -1: hero.call_deferred(&"reparent", HUD.level.boxes.assets[no], true)
	
	HUD.animation.direct(d)
	HUD.animation.animate_frames(CharacterAnimation.JUMP)
	Bit.b1(state, HUD.hero, JUMPING)
	hero.make_velocity(directed * Vector2.ONE * JUMP_POWER)
	var jumping: Tween = HUD.create_tween()
	jumping.tween_method(func(slot):
		HUD.animation.sprite.frame = slot
		hero.shadow.scale = slot * position[SHADOW] * position[PORTION][JUMP],
		0, COUNT, position[PORTION][DURATION]).set_trans(Tween.TRANS_LINEAR)
	jumping.tween_callback(func():
		hero.make_velocity(Vector2.ZERO)
		HUD.animation.animate_frames(CharacterAnimation.WALK)
		if hero.box == -1:
			hero.reparent(HUD.level, true)
			if not Bit.of(state[HUD.hero], JUMPED):
				hero.lever.position = Vector2.ZERO
				hero.plate.position = Vector2.ZERO
				toggle_stuck(true)
		hero.position = pos
		HUD.animation.sprite.stop()
		Bit.b0(state, HUD.hero, JUMPING))
	hero.box = no

func box_move() -> void:
	pass

func trigger_disappear(body: Variant) -> void:
	if body is AnimatableBody2D and body.is_in_group(&"box"):
		for i in range(0, len(hero.boxes)):
			if hero.boxes[i] == body.get_meta(&"no"):
				hero.weight *= HUD.level.boxes.weight[i]
				HUD.level.boxes.pushes(i, Vector2.ZERO)
				hero.boxes.remove_at(i)
				break

func trigger_encounter(body: Variant) -> void:
	if body is AnimatableBody2D and body.is_in_group(&"box"):
		var no: int = body.get_meta(&"no")
		hero.boxes.append(no)
		var a: int = HUD.level.boxes.weight[no]
		var to: float = HUD.level.boxes.weight_d[a]
		print("WEIGHT: ", hero.weight, " - TO: ", to, " - A: ", a)
		hero.weight *= to
		return
	var pos: Vector2 = hero.position
	var id: int = on_tile(pos)[Def.ID]
	if (id == Def.FLOOR and _tile[Def.TYPE] == Def.FLOORS) or (id == Def.LOGIC and _tile[Def.ATLAS] in stand):
		ledge_jump(pos)
	elif on_tile(hero.position + hero.lever.position)[Def.ID] == Def.LOGIC and _tile[Def.ATLAS] in [Def.SMALL_BOX, Def.LARGE_BOX]:
		HUD.level.boxes.add_box(_tile[Def.ATLAS], HUD.level.border.position())
		HUD.level.border.atlas(Def.GROUND).id(Def.FLOOR).type(Def.FLOORS).paint_alt() # coords(Def.GROUND)

func plate_encounter(_body: Variant) -> void:
	HUD.level.tile[Def.offset(HUD.hero, Def.PLATE)] = Def.ofmap(HUD.level.border.local_to_map(hero.position))
	HUD.level.cluster.tile_walk(hero, true)

func plate_disappear(_body: Variant) -> void:
	HUD.level.cluster.tile_walk(hero, false)
	HUD.level.tile[Def.offset(HUD.hero, Def.PLATE)] = 0
