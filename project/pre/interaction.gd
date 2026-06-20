class_name WorldInteraction extends RefCounted

enum { STATIC = 1, JUMPED = 0, JUMPING, COUNT = 8, PORTION = 0, DURATION = 1 }

var hero: CharacterBody2D:
	get: return HUD.level.entity[HUD.hero]
var _tile: PackedInt32Array:
	get: return HUD.level.border.tile

var directed: Vector2
var target: Rect2
var state: PackedByteArray = [0, 0]

const duration: PackedFloat32Array = [0.125, 0.2]
const close: Rect2 = Rect2(Vector2.ONE * 20, Vector2(0, -53))
const shadow: Vector2 = Vector2(0.6, 0.72)

func direct4() -> Vector2: return Vector2(0, directed.y) if directed.x != 0 and directed.y != 0 else directed
func tile_atlas(h: CharacterBody2D, no: int) -> int: return HUD.level.border.coords(get_tile(h.no, no)).atlas().tile[Def.ATLAS]

func get_tile(h: int, no: int) -> int: return HUD.level.tile[Def.offset(h, no)]
func set_tile(h: int, no: int, pos: Vector2) -> void: HUD.level.tile[Def.offset(h, no)] = Def.ofmap(HUD.level.border.local_to_map(pos))
func no_tile(h: int, no: int) -> void: HUD.level.tile[Def.offset(h, no)] = 0

func on_tile(pos: Vector2) -> PackedInt32Array: return HUD.level.border.pos(pos).id().atlas().type().tile
func plate() -> Vector2: return hero.position
func lever() -> Vector2: return hero.position + hero.lever.position

func movement(act: bool) -> void:
	directed = Input.get_vector(&"left", &"right", &"forward", &"backward")
	var in_place: bool = directed == Vector2.ZERO
	if Bit.of(state[HUD.hero], JUMPING): return
	
	if Bit.of(state[HUD.hero], JUMPED):
		if hero.box == -1:
			ledge_jump(hero.position) # pass
			HUD.animation.direct(directed)
			hero.lever.position = close.position * directed
			# if not in_place: hero.lever.position = close.position * directed
		elif not in_place:
			var box: CharacterBody2D = HUD.level.boxes.get_box(hero.box)
			ledge_jump(box.position, box.height)
	else:
		hero.make_velocity(directed * Def.MOVE)
		if not in_place and not act:
			hero.lever.position = close.position * directed
	if state[HUD.hero] == 0:
		if in_place:
			HUD.animation.stop_animation()
		else:
			HUD.animation.direct(directed)
			HUD.animation.animate()
	# elif not in_place:
	elif in_place:
		HUD.animation.stop_animation()
		# HUD.animation.direct(directed)

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
	var pos: Vector2 = lever()
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
	var pos: Vector2 = lever()
	if on_tile(pos)[Def.ID] == Def.FLOOR and _tile[Def.TYPE] == Def.ICE_FLOOR:
		HUD.level.border.type(Def.PUDDLE_OFF).paint_alt()
		add_particle(HUD.level.fire, Def.fire, &"fire", pos) # TileDecorator

func animate_jump(next: Rect2) -> void:
	target = next
	print(target)
	HUD.animation.animate_frames(CharacterAnimation.JUMP)
	Bit.b1(state, HUD.hero, JUMPING)
	var jumping: Tween = HUD.create_tween()
	jumping.tween_method(intermediate_jump, 0, COUNT, duration[DURATION]).set_trans(Tween.TRANS_LINEAR)
	jumping.tween_callback(finish_jump)

func toggle_stuck(next: bool) -> void:
	hero.lever_body.set_deferred("disabled", not next)
	hero.plate_body.set_deferred("disabled", not next)
	hero.set_collision_layer_value(STATIC, next)
	hero.set_collision_mask_value(STATIC, next)

func jump_to_box(f1: int, coords: int) -> int:
	var f2: int = HUD.level.border.extract(TileDecorator.FLOOR)
	if HUD.level._boxes == null: return f2
	
	for box in HUD.level.boxes.boxes:
		var c: int = on_tile(box.position)[Def.COORDS]
		if c == coords and (f1 == f2 + box.height): # HUD.interact.hero.position = box.ledge
			Bit.b1(state, HUD.hero, JUMPED)
			toggle_stuck(false)
			#hero.call_deferred(&"reparent", box, true) # await
			# hero.call_deferred(&"reparent", box, true)
			hero.reparent(box, true)
			var dir: Vector2 = (close.size if hero.box == -1 else Vector2.ZERO)# + box.position)
			# var delta: Vector2 = hero.position - dir
			var pos = hero.position
			print("P: ", pos, " + D: ", dir)
			hero.box = box.no
			animate_jump(Rect2(pos, pos - dir))
			return f2
	return f2

func jump_from_box(pos: Vector2, dir: Vector2) -> void:
	# dir = pos + dir
	if hero.box == -1:
		animate_jump(Rect2(pos, -dir)) #  + dir + dir
	else:
		animate_jump(Rect2(close.size, -dir))
	hero.box = -1 # HUD.level.boxes.get_box(hero.box).position +  # delta = HUD.level.boxes.get_box(hero.box).position - dir # close.size # close.size

func finish_jump() -> void:
	hero.make_velocity(Vector2.ZERO)
	HUD.animation.animate_frames(CharacterAnimation.WALK)
	if hero.box == -1:
		hero.reparent(HUD.level, true)
		if not Bit.of(state[HUD.hero], JUMPED):
			hero.lever.position = Vector2.ZERO
			hero.plate.position = Vector2.ZERO
			toggle_stuck(true) # hero.position = HUD.level.border.position() #  HUD.animation.stop_animation()
		# Bit.b0(state, HUD.hero, JUMPED)
		print(state)
	#if not Bit.of(state[HUD.hero], JUMPED):
		#toggle_stuck(true)
	#else:
	#	hero.position = target.size # HUD.create_tween().tween_callback(func(): Bit.b0(state, HUD.hero, JUMPED)).set_delay(2)
	HUD.animation.sprite.stop()
	Bit.b0(state, HUD.hero, JUMPING)

func intermediate_jump(slot: int) -> void:
	HUD.animation.sprite.frame = slot
	var of: float = slot * duration[PORTION]
	hero.shadow.scale = shadow * of
	var a: Vector2 = target.position
	var b: Vector2 = target.size
	var pos: Vector2 = target.position - target.size * of # + (target.position * of)
	var pos2: Vector2 = hero.position
	print("SLOT: ", slot, " - POS: ", pos, " - HERO: ", pos2, " - A: ", a, " - B: ", b)
	hero.position = pos

func ledge_jump(pos: Vector2, height: int = 0) -> void:
	var dir: Vector2 = Vector2.ONE * 128 * direct4() # pos +
	var f1: int = HUD.level.border.extract(TileDecorator.FLOOR) + height
	var f2: int = jump_to_box(f1, on_tile(pos + dir)[Def.COORDS])
	if f1 == f2:
		if _tile[Def.ID] == Def.FLOOR and _tile[Def.TYPE] == Def.FLOORS:
			var next: bool = _tile[Def.ATLAS] == Def.LEDGE
			Bit.b(state, HUD.hero, JUMPED, next)
			toggle_stuck(false)
			jump_from_box(pos, dir)
			var result: bool = Bit.of(state[HUD.hero], JUMPED)
			print("RES: ", result)
		elif are_box_ledges(_tile[Def.ID], _tile[Def.ATLAS]): # _tile[Def.ID] == Def.LOGIC and (_tile[Def.ATLAS] == Def.STAND_ON or boxes):
			Bit.b1(state, HUD.hero, JUMPED)
			toggle_stuck(false)
			jump_from_box(pos, dir)

func is_platform_box(atlas: int) -> bool:
	return Def.SMALL_BOX >= atlas and atlas <= Def.LARGE_BOX

func are_box_ledges(id: int, atlas: int) -> bool:
	return id == Def.LOGIC and (atlas == Def.STAND_ON or is_platform_box(atlas))

func are_floors(id: int, type: int, atlas: int) -> bool:
	return (id == Def.FLOOR and type == Def.FLOORS) or (
		id == Def.LOGIC and (atlas == Def.STAND_ON or is_platform_box(atlas)))

func are_boxes(id: int, atlas: int) -> bool:
	return id == Def.LOGIC and Def.SMALL_BOX >= atlas and atlas <= Def.FIRE_BOX

func leverage() -> void:
	var pos: Vector2 = plate()
	if are_floors(on_tile(pos)[Def.ID], _tile[Def.TYPE], _tile[Def.ATLAS]):
		ledge_jump(pos)
	elif are_boxes(on_tile(lever())[Def.ID], _tile[Def.ATLAS]):
		var atlas: int = _tile[Def.ATLAS]
		HUD.level.border.atlas(Def.GROUND).id(Def.FLOOR).type(Def.FLOORS).paint_alt() # coords(Def.GROUND)
		HUD.level.boxes.add_box(atlas, HUD.level.border.position())

func box_move() -> void:
	pass

func trigger_encounter(body: Variant) -> void:
	if body is CharacterBody2D and body.is_in_group(&"box"):
		hero.boxes.append(body.no)
		hero.weight += body.weight
	elif body is StaticBody2D:
		
		pass
	else:
		leverage()

func trigger_disappear(body: Variant) -> void:
	if body is CharacterBody2D and body.is_in_group(&"box"):
		for i in range(0, len(hero.boxes)):
			if hero.boxes[i] == body.no:
				#var h = hero
				#hero.weight -= body.weight
				break
				# h.boxes.remove_at(i)

func plate_encounter(_body: Variant) -> void:
	set_tile(HUD.hero, Def.PLATE, hero.position)
	HUD.level.cluster.tile_walk(hero, true)

func plate_disappear(_body: Variant) -> void:
	HUD.level.cluster.tile_walk(hero, false)
	HUD.level.tile[Def.offset(HUD.hero, Def.PLATE)] = 0
