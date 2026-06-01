class_name HeroDeploy extends RefCounted

var initial: Vector2

func next() -> int: return (HUD.hero + 1) % Def.ENEMY

func switch_hero(hero: int, process: bool) -> void:
	HUD.level.entity[hero].visible = process
	HUD.level.entity[hero].process_mode = (int(process) << 2) ^ Node.PROCESS_MODE_DISABLED
	HUD.state = Bit.to(HUD.state, Def.DEPLOYED, process)

func select() -> void:
	if HUD.level.entity[next()] == null:
		HUD.level.entity[next()]
	if Bit.of(HUD.state, Def.DEPLOYED):
		HUD.level.entity[HUD.hero].position = HUD.level.entity[next()].position
	traverse_camera()
	HUD.hero = next()

func deploy() -> void:
	var delta: float = HUD.level.entity[HUD.hero].position.distance_squared_to(
		HUD.level.entity[next()].position)
	if delta >= Def.DEPLOY_DELTA: return
	if (Bit.of(HUD.level.state[HUD.hero], Def.BOX) or 
		Bit.of(HUD.level.state[next()], Def.BOX)): return
	var f1: int = HUD.level.border.extract_at_pos(HUD.level.entity[HUD.hero])
	var f2: int = HUD.level.border.extract_at_pos(HUD.level.entity[next()])
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
	if not Bit.of(HUD.level.state[HUD.hero], Def.CAMERA):
		HUD.level.state[HUD.hero] = Bit.to(HUD.level.state[HUD.hero], Def.CAMERA, true)
		HUD.level.state[next()] = Bit.to(HUD.level.state[next()], Def.CAMERA, false)
		if HUD.level.state[HUD.hero][Def.BOX]:
			HUD.level.group.position = Vector2.ZERO
			HUD.level.group.reparent(HUD.level)
		else:
			HUD.level.group.position = HUD.level.entity[HUD.hero].position
			HUD.level.group.reparent(HUD.level.entity[HUD.hero])

var zoom: PackedFloat32Array = [0, 0, 0]

func set_zoom(zmin: float, z: float, zmax: float) -> void:
	zoom[0] = z; zoom[1] = zmin ; zoom[2] = zmax

func dungeon() -> void: set_zoom(0.5, 0.1, 1.5)
func overworld() -> void:
	set_zoom(0.1, 0.05, 0.5)
	HUD.level.group.zoom = Vector2(0.2, 0.2)

func zoom_camera() -> void:
	var z: float = Input.get_axis("view_left", "view_right")
	if z != 0: HUD.level.group.zoom = new_zoom(zoom[0], z)

func new_zoom(original: float, value: float) -> Vector2:
	value = clampf(original + value, zoom[1], zoom[2])
	return Vector2(value, value)
