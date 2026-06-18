class_name WorldInteraction extends RefCounted

enum { STATIC = 1, JUMPED = 0, COUNT = 8 }

var hero: CharacterBody2D:
	get: return HUD.level.entity[HUD.hero]
var _tile: PackedInt32Array:
	get: return HUD.level.border.tile

var directed: Vector2
var target_pos: Vector2
var source_pos: Vector2
var state: PackedByteArray = [0, 0]

const portion: float = 0.125
const close: Vector2 = Vector2.ONE * 20
const box_height: Vector2 = Vector2(0, -53)

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
	if hero.box != -1:
		if not in_place:
			var box: CharacterBody2D = HUD.level.boxes.get_box(hero.box)
			ledge_jump(box.position, box.height)
	else:
		hero.make_velocity(directed * Def.MOVE)
		if not in_place and not act:
			hero.lever.position = close * directed
	if state[HUD.hero] == 0:
		if in_place:
			HUD.animation.stop_animation()
		else:
			HUD.animation.direct(directed)
			HUD.animation.animate()
	# elif not in_place:
		# HUD.animation.direct(directed)

func puddle_tile() -> void:
	var pos: Vector2 = lever()
	if on_tile(pos)[Def.ID] == Def.FLOOR and _tile[Def.TYPE] == Def.FLOORS:
		pass
	elif _tile[Def.ID] == Def.WALLS and _tile[Def.ATLAS] == Def.GROUND:
		HUD.level.border.id(Def.FLOOR).alt(Def.ALT1)
	else:
		return
	HUD.level.border.type(Def.PUDDLE_OFF).paint_alt()
	if HUD.level.rain == null:
		HUD.level.rain = load(Def.rain).instantiate()
		HUD.level.rain.one_shot = true
		HUD.level.add_child(HUD.level.rain)
	else:
		HUD.level.rain.restart()
	HUD.level.rain.position = pos
	HUD.level.conductor.contact(_tile[Def.COORDS])

func melt_ice() -> void:
	var pos: Vector2 = lever()
	if on_tile(pos)[Def.ID] == Def.FLOOR and _tile[Def.TYPE] == Def.ICE_FLOOR:
		HUD.level.border.type(Def.PUDDLE_OFF).paint_alt()
		if HUD.level.fire == null:
			HUD.level.fire = load(Def.fire).instantiate()
			HUD.level.fire.one_shot = true
			HUD.level.add_child(HUD.level.fire)
		else:
			HUD.level.fire.restart() # TileDecorator
		HUD.level.fire.position = pos

func jump_to_box(f1: int, coords: int) -> int:
	var f2: int = HUD.level.border.extract(TileDecorator.FLOOR)
	if HUD.level._boxes == null: return f2
	
	for box in HUD.level.boxes.boxes:
		var c: int = on_tile(box.position)[Def.COORDS]
		if c == coords and (f1 == f2 + box.height): # HUD.interact.hero.position = box.ledge
			Bit.b1(state, HUD.hero, JUMPED)
			toggle_stuck(false)
			#if hero.box != -1:
			# 	hero.position = box.position - HUD.level.boxes.get_box(hero.box).position
			# else:
				# pass
				# var pos: Vector2 = HUD.level.border.position() - hero.position
				# hero.position = pos
			hero.reparent(box)
			source_pos = hero.position
			if hero.box == -1: source_pos -= box_height
			target_pos = box_height
			hero.box = box.no
			print(source_pos, target_pos)
			animate_jump()
			return f2
	return f2

func animate_jump() -> void:
	HUD.animation.animate_frames(CharacterAnimation.JUMP)
	var jumping: Tween = HUD.create_tween()
	jumping.tween_method(intermediate_jump, 0.0, COUNT, 1.5).set_trans(Tween.TRANS_LINEAR)

func toggle_stuck(next: bool) -> void:
	# hero.lever.set_monitoring(next)
	# hero.plate.set_monitoring(next)
	hero.lever_body.set_deferred("disabled", not next)
	hero.plate_body.set_deferred("disabled", not next)
	# hero.lever_body.disabled = not next 
	# hero.plate_body.disabled = not next
	#var v: Area2D
	#v.monitoring 
	hero.set_collision_layer_value(STATIC, next)
	hero.set_collision_mask_value(STATIC, next)

func jump_from_box(dir: Vector2) -> bool:
	Bit.b1(state, HUD.hero, JUMPED)
	if hero.box == -1: return true
	# hero.reparent(HUD.level)
	# hero.position = HUD.level.boxes.get_box(hero.box).position + box_height
	# var delta: int = HUD.level.border.tile[Def.COORDS] - on_tile()
	source_pos = dir - HUD.level.boxes.get_box(hero.box).position
	target_pos = box_height # HUD.level.border.position() - on_tile() # hero.position =  # hero.box
	print(source_pos, target_pos)
	hero.box = -1
	animate_jump()
	return false

const shadow: Vector2 = Vector2(0.6, 0.72)

func intermediate_jump(slot: int) -> void:
	HUD.animation.sprite.frame = slot
	var of: float = slot * portion
	if hero.box != -1: of = 1.0 - of
	hero.shadow.scale = shadow * of
	var pos: Vector2 = target_pos + (source_pos * of)
	
	if slot == COUNT:
		hero.make_velocity(Vector2.ZERO)
		HUD.animation.animate_frames(CharacterAnimation.WALK)
		if hero.box == -1:
			hero.reparent(HUD.level)
			toggle_stuck(true)
			Bit.b0(state, HUD.hero, JUMPED)
		else:
			hero.position = pos
		HUD.animation.sprite.stop()
	else:
		hero.position = pos
		
	# if slot == COUNT:
		# if hero.box == -1:
			# if not hero.is_ancestor_of(HUD.level):
		# 		hero.position = box_height
		# else:
			# hero.reparent(HUD.level.boxes.get_box(hero.box))
			# hero.position = box_height # Vector2.ZERO + 

func ledge_jump(pos: Vector2, height: int = 0) -> void:
	var dir: Vector2 = pos + Vector2.ONE * 128 * direct4()
	var f1: int = HUD.level.border.extract(TileDecorator.FLOOR) + height
	var f2: int = jump_to_box(f1, on_tile(dir)[Def.COORDS])
	# on_tile(dir)
	# var f2: int = HUD.level.border.extract(TileDecorator.FLOOR)
	if f1 == f2:
		var boxes: bool = Def.SMALL_BOX >= on_tile(dir)[Def.ATLAS] and _tile[Def.ATLAS] <= Def.LARGE_BOX
		# var t: PackedInt32Array = _tile
		if _tile[Def.ID] == Def.FLOOR and _tile[Def.TYPE] == Def.FLOORS:
			if jump_from_box(dir):
				hero.position = HUD.level.border.position()
		elif _tile[Def.ID] == Def.LOGIC and (_tile[Def.ATLAS] == Def.STAND_ON or boxes):
			if jump_from_box(dir):
				hero.position = HUD.level.border.position()
				if boxes: hero.position += box_height
			

func leverage() -> void:
	var pos: Vector2 = plate()
	if (on_tile(pos)[Def.ID] == Def.FLOOR and _tile[Def.TYPE] == Def.FLOORS) or (
		_tile[Def.ID] == Def.LOGIC and (_tile[Def.ATLAS] == Def.STAND_ON or (
		Def.SMALL_BOX >= _tile[Def.ATLAS] and _tile[Def.ATLAS] <= Def.LARGE_BOX))):
		ledge_jump(pos)
	elif on_tile(lever())[Def.ID] == Def.LOGIC and Def.SMALL_BOX >= _tile[Def.ATLAS] and _tile[Def.ATLAS] <= Def.FIRE_BOX:
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
				var h = hero
				hero.weight -= body.weight
				break
				# h.boxes.remove_at(i)

func plate_encounter(_body: Variant) -> void:
	HUD.level.tile[Def.offset(HUD.hero, Def.PLATE)] = Def.ofmap(HUD.level.border.local_to_map(hero.position))
	HUD.level.cluster.tile_walk(hero, true)

func plate_disappear(_body: Variant) -> void:
	HUD.level.cluster.tile_walk(hero, false)
	HUD.level.tile[Def.offset(HUD.hero, Def.PLATE)] = 0
