class_name HeroDeploy extends RefCounted

var initial: Vector2

func next() -> int: return (HUD.hero + 1) & Def.ROCK

func switch_hero(hero: int, process: bool) -> void:
	HUD.level.entity[hero].visible = process
	HUD.level.entity[hero].process_mode = (int(process) << 2) ^ Node.PROCESS_MODE_DISABLED
	HUD.state = Bit.to_(HUD.state, Def.DEPLOYED)

func load_hero(that: int) -> void:
	if HUD.level.entity[that] == null:
		HUD.level.new_hero(that)

func select() -> void:
	var that: int = next()
	load_hero(that)
	if Bit.of(HUD.state, Def.DEPLOYED):
		HUD.level.entity[HUD.hero].position = HUD.level.entity[that].position
	traverse_camera()
	HUD.hero = that

func deploy() -> void:
	var that: int = next()
	load_hero(that)
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
	if not Bit.of(HUD.level.state[HUD.hero], Def.CAMERA):
		HUD.level.state[HUD.hero] = Bit.to1(HUD.level.state[HUD.hero], Def.CAMERA)
		HUD.level.state[next()] = Bit.to0(HUD.level.state[next()], Def.CAMERA)
		if HUD.level.state[HUD.hero][Def.BOX]:
			HUD.level.group.position = HUD.level.entity[HUD.hero].position
			HUD.level.group.reparent(HUD.level)
		else:
			HUD.level.group.position = Vector2.ZERO
			HUD.level.group.reparent(HUD.level.entity[HUD.hero])

var zoom: Vector3 = Vector3(0.5, 0.1, 1.5)

func overworld() -> void: zoom = Vector3(0.1, 0.05, 0.5)
func zoom_camera() -> void:
	var z: float = Input.get_axis("view_left", "view_right")
	if z != 0:
		zoom.x = clampf(zoom.x + z, zoom.y, zoom.z)
		HUD.level.group.zoom = Vector2(zoom.x, zoom.x)
