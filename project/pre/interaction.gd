class_name WorldInteraction extends RefCounted

var hero: CharacterBody2D:
	get: return HUD.level.entity[HUD.hero]
var _tile: PackedInt32Array:
	get: return HUD.level.border.tile
var directed: Vector2
const close: Vector2 = Vector2.ONE * 20

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
		
	hero.make_velocity(directed * Def.MOVE)
	HUD.animation.direct(directed)
	if directed != Vector2.ZERO and not act:
	#	directed = dir
		hero.lever.position = close * directed
	#else:
	#	directed = dir

func puddle_tile() -> void:
	var pos: Vector2 = lever()
	if on_tile(pos)[Def.ID] == Def.FLOOR and _tile[Def.TYPE] == Def.FLOORS:
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
			HUD.level.fire.restart()
		TileDecorator
		HUD.level.fire.position = pos

func ledge_jump(pos: Vector2) -> void:
	var f1: int = HUD.level.border.extract(TileDecorator.FLOOR)
	on_tile(pos + Vector2.ONE * 128 * direct4())
	var f2: int = HUD.level.border.extract(TileDecorator.FLOOR)
	if f1 == f2:
		var boxes: bool = Def.SMALL_BOX >= _tile[Def.ATLAS] and _tile[Def.ATLAS] <= Def.LARGE_BOX
		if _tile[Def.ID] == Def.FLOOR and _tile[Def.TYPE] == Def.FLOORS:
			hero.position = HUD.level.border.position()
		elif _tile[Def.ID] == Def.LOGIC and (_tile[Def.ATLAS] == Def.STAND_ON or boxes):
			hero.position = HUD.level.border.position()
			if boxes: hero.position += Vector2(0, -12)

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
	if body is CharacterBody2D:
		hero.boxes.append(body.no)
		hero.weight += body.weight
	elif body is StaticBody2D:
		
		pass
	else:
		leverage()

func trigger_disappear(body: Variant) -> void:
	if body is CharacterBody2D:
		for i in range(0, len(hero.boxes)):
			if hero.boxes[i] == body.no:
				hero.weight -= body.weight
				hero.boxes.remove_at(i)

func plate_encounter(_body: Variant) -> void:
	HUD.level.tile[Def.offset(HUD.hero, Def.PLATE)] = Def.ofmap(HUD.level.border.local_to_map(hero.position))
	HUD.level.cluster.tile_walk(hero, true)

func plate_disappear(_body: Variant) -> void:
	HUD.level.cluster.tile_walk(hero, false)
	HUD.level.tile[Def.offset(HUD.hero, Def.PLATE)] = 0
