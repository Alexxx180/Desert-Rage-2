class_name HeroDeploy extends RefCounted

var initial: Vector2

func next() -> int: return (HUD.hero + 1) % Def.ENEMY

func switch_hero(hero: int, process: bool) -> void:
	HUD.level.entity[hero].visible = process
	HUD.level.entity[hero].process_mode = (int(process) << 2) ^ Node.PROCESS_MODE_DISABLED
	HUD.state = Bit.to(HUD.state, Def.GROUP, process)

func select() -> void:
	if Bit.of(HUD.state, Def.GROUP):
		HUD.level.entity[HUD.hero].position = HUD.level.entity[next()].position
	traverse_camera()
	HUD.hero = next()

func deploy() -> void:
	var delta: float = HUD.level.entity[main].position.distance_squared_to(
		HUD.level.entity[next()].position)
	if delta >= 4096: return
	if (Bit.of(HUD.level.state[main], Def.STANDING) or 
		Bit.of(HUD.level.state[next()], Def.STANDING)): return
	var f1: int = HUD.level.border.extract_at_pos(HUD.level.entity[main])
	var f2: int = HUD.level.border.extract_at_pos(HUD.level.entity[next()])
	if f1 != f2: return
	switch_hero(main, !Bit.of(HUD.state, Def.GROUP))

func traverse_camera() -> void:
	pass

func setup_location() -> void:
	traverse_camera()
	for i in [Def.RAY, Def.ROCK]:
		HUD.level.entity[i].position = HUD.level.group.position
	HUD.level.group.position = Vector2.ZERO

func init(group: Node2D, deployed: bool) -> void:
	setup_location(group)
	select(group, group._rock, group.ray)
	if deployed: regroup(group)


func controls(_root: LevelRoot) -> void:
	root = root
	deploy.init(self, Bit.of(mode, DEPLOYED))
	if Bit.of(HUD.level.group.mode, OVERWORLD): camera.set_overworld()

func upload_hero(ref: CharacterBody2D) -> void:
	ref.update_stats()
	ref.controls()

func sync_pos() -> void:
	var next: int = posmod(HUD.hero, Def.ENEMY)
	HUD.level.entity[next].position = HUD.level.entity[HUD.hero]
	
func locate(next: Vector2) -> void:
	for hero in party: hero.position = next

func forget_velocity() -> void:
	leader().logic.work.input.topdown.move.act.velocity.forget()

func traverse(node: Node, hero: CharacterBody2D):
	if node != null:
		node.remove_child(camera)
	else:
		remove_child(camera)
	hero.add_child(camera)

func _ready() -> void: get_parent().set_script(PreloadBzus.root)

func _input(_event: InputEvent) -> void:
	if deploy.is_select(): deploy.select(self, leader(), follower())
	elif deploy.is_group(): deploy.regroup(self)

var zoom: PackedFloat32Array = [0, 0, 0]

func set_zoom(zmin: float, z: float, zmax: float) -> void:
	zoom[0] = z; zoom[1] = zmin ; zoom[2] = zmax

func dungeon() -> void: set_zoom(0.5, 0.1, 1.5)
func overworld() -> void:
	set_zoom(0.1, 0.05, 0.5)
	HUD.level.group.camera.zoom = Vector2(0.2, 0.2)

func zoom_camera() -> void:
	var z: float = Input.get_axis("view_left", "view_right")
	if z != 0: HUD.level.group.camera.zoom = new_zoom(zoom[0], z)

func new_zoom(original: float, value: float) -> Vector2:
	value = clampf(original + value, zoom[1], zoom[2])
	return Vector2(value, value)
