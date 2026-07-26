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





enum { GROUND = 1, TILE_SIZE = 6 }

func is_chest(atlas: Vector2i) -> bool:
	return Def.of8(atlas) in [Def.BRONZE_OFF, Def.SILVER_OFF, Def.GOLD_OFF,
		Def.PLATINUM_OFF, Def.BRONZE_ON, Def.SILVER_ON, Def.GOLD_ON, Def.PLATINUM_ON]

func _paint(places: Array[Vector2i]) -> void:
	for coords in places:
		HUD.level.border.paint({ "id": GROUND, "atlas": Vector2i.ONE, "coords": coords })

func _set_casual_mode(casual_mode: bool) -> void:
	if not casual_mode: return # for chest in [0, 1, 2]: _paint(tags.get_used_cells_by_id(ENEMY, Vector2i(0, chest)))

func setup(_casual_mode: bool) -> void:
	for tag in HUD.level.execute.layer.get_used_cells_by_id(Def.FLOOR):
		set_pages(tag)
	# _set_casual_mode(casual_mode)

func drink_water(inventory: Node, pos: Vector2) -> void:
	match Def.of8(HUD.level.border.tpos(pos)):
		Def.D_WATER:
			inventory.logic.effect.restore() # USE WATER

func _get_id(tile: Dictionary) -> int:
	var tag: Vector2i = HUD.level.execute.tile(tile.coords)
	return Def.of8(tag)# - Tile.FLOOR

func open_chest(tile: Dictionary) -> void:
	var id: int = _get_id(tile)
	var hero: CharacterBody2D = HUD.level.group.deploy.party.leader
	var logic: Node = hero.to.inventory.logic
	# lay.border.switch(chest.offset.on) # TODO NEED TO ADD CHECK BEFORE CHANGE
	var slot: int = logic.put_to_inventory(id)
	if logic.items.ui.have(slot):
		logic.trade.equip.add_weapon(slot)
	logic.effect.remember(id)

func open_chests() -> void:
	var tile: Dictionary = HUD.level.border.context # print("FOUND ID: ", id) # logic.effect.status.hero = hero
	match Def.of8(tile.atlas):
		Def.BRONZE_OFF, Def.SILVER_OFF, Def.GOLD_OFF, Def.PLATINUM_OFF:
			open_chest(tile)
		Def.BRONZE_ON, Def.SILVER_ON, Def.GOLD_ON, Def.PLATINUM_ON:
			var logic: Node = HUD.level.group.deploy.party.leader.to.inventory.logic
			logic.effect.remember(_get_id(tile))

# TODO BOOKS
func check_book() -> void:
	var tile: Dictionary = HUD.level.border.context
	var books: Dictionary = HUD.level.execute.manual.books
	if books[tile.atlas].size() > 0:
		var manual: String = books[tile.atlas][0]#[message]
		set_page(tile.coords, [tile.atlas, manual])

func set_book(tag: Vector2i) -> void:
	match Def.of8(HUD.level.border.tile(tag)):
		Def.BLUE_OFF, Def.RED_OFF, Def.GREEN_OFF, Def.BLACK_OFF, Def.WHITE_OFF: check_book()

func set_page(coords: Vector2i, value: Array) -> void:
	HUD.level.execute.books[coords] = value

func _manual(coords: Vector2i) -> String:
	return Def.pages[Def.of8(HUD.level.execute.coords(coords).id().atlas().tile[Def.ATLAS])]

func set_pages(tag: Vector2i) -> void:
	var tile: Dictionary = HUD.level.execute.from_coords(tag).context
	match Def.of8(tile.atlas):
		Def.PAGE: set_page(tile.coords, [tile.atlas, _manual(tile.coords)])
		_: set_book(tile.coords)


var chest_pos: Vector2 = Vector2.ZERO
var logic: Node

func enter_chest(border: TileMapLayer) -> void:
	var h: CharacterBody2D = HUD.level.entity[HUD.hero]
	chest_pos = h.position + h.logic.see.world.skills.chest.position
	# print("ENTER THE CHEST!")

func exit_chest(_border: TileMapLayer) -> void:
	chest_pos = Vector2.ZERO
	# print("EXIT THE CHEST!")

func _input(_event: InputEvent) -> void:
	if chest_pos != Vector2.ZERO and Input.is_action_just_pressed("action"):
		drink_water(HUD.level.entity[HUD.hero].logic.work.ui.inventory, chest_pos)


func open_lock(no: int) -> void:
	pass

func open_mystic(no: int) -> void:
	pass






@onready var secret: Label = $secret
@onready var view: Sprite2D = $view

enum { SHOW = 1, HIDE = 2 }

const TIME: int = 1

const OPENED: PackedStringArray = [
	"Неплохо 👍", "Так держать! 🥳", "Ловко придумано 🌠", "Мощно 💪",
	"Ну ты крут 😎", "Чел хорош 🔥", "Хорошая мысль ✅", "Машина 🦾",
	"Только никому 🤫", "Бомбезно 🧨", "Идеально 🤌", "Молодец 😇",
	"Бу! Испугался? 👻", "Мегамозг 🧠", "Не сдавайся ⛳️", "В яблочко 🎯",
	"Такси! Я застрял 🚕", "Отличный вид 🏙", "Пометь себе 💾",
	"Улыбочку 📷", "Хорошо движешься ⚙️", "Отметим? 😎🎁",
	"А я тут прячусь 😉", "А как ты попал сюда? 🤨", "Картинка 💰",
	"Нелегка доля грузчика 📦", "Знаю, что ты лучший 😏", "Ты потрясающий 🦒",
	"Наш слон 🐘", "Просто мечта ⭐️", "Ты мое солнышко ☀️", "Еще повезет 🍀",
	"А здесь прохладно ❄️", "Дело раскрыто 🔓", "Он меня нашел 📣",
	"Отлично идем 📈", "Это кто-то читает? 📖", "Во закинул ⚓️", "Ракета 🚀",
	"Ну и везунчик 🎲", "Все встало на свои места 🧩", "Продолжаем 🎬",
	"Вручаю медаль 🎖", "Вам грамота 🧧", "Остро-актуальная мысль 🌶",
	"Перекус? 🍏", "Вот это изюминка 🍇", "По сути вкусно 🫑", "Прибрать бы тут 🪣",
	"Варит котелок ведь 🧭", "Тонко 🔬", "Жду свершений 🔭", "Растем 🌱", "Секрет 🕵️‍♂️"
]

func _on_open(body: PhysicsBody2D) -> void:
	if body.is_in_group("enemy"): return

	if secret.text == "": # secret.text = OPENED.pick_random()
		_change_state(view, Color.TRANSPARENT)
	_change_state(secret, Color.WHITE)

func _on_close(body: PhysicsBody2D) -> void:
	if not body.is_in_group("enemy"):
		_change_state(secret, Color.BLACK)

func _change_state(subject: CanvasItem, tint: Color) -> void:
	create_tween().tween_property(subject, "modulate", tint, TIME)



"""
extends Area2D

@export_multiline var plot_text: Array[String] = []

var completed: bool = false

func _plot_unfolding(hero: CharacterBody2D) -> void:
	if completed: return
	completed = true
	print("encounter")
	# hero.logic.work.hud.dialog(plot_text) # TODO FIXME plot text dialogs
	get_parent().call_deferred("remove_child", self)
	call_deferred("queue_free")


extends Area2D

@export var hud: Node

@export_group("Hint preview location")
@export var head: String = ""
@export var body: String = ""

func _on_hint_collected(_hero: CharacterBody2D) -> void:
	var act: Node2D = get_parent()
	var category: Node2D = act.get_parent()
	var hints: VBoxContainer = hud.game.detector.game.controls.preview.help.hints
	# .hints

	if head == "": head = category.name
	if body == "": body = name

	print("hide progress")

	hints.progress(head, body)
	act.call_deferred("remove_child", self)
	call_deferred("queue_free")


extends Area2D

@export var hud: Node

func _on_hint_collected(_hero: CharacterBody2D) -> void:
	var act: Node2D = get_parent()

	print("hide progress")
	hud.game.detector.game.controls.preview.help.hints.clear_progress()
	act.call_deferred("remove_child", self)
	call_deferred("queue_free")
"""













extends CharacterBody2D

@onready var view: Node2D = $view
@onready var logic: Node2D = $logic
@export var caption: String = "eye-seeker"

var spawn_pos: int = 0

func _ready() -> void: logic.relation.controls(self)

func burn(damage: int) -> void: logic.processor.health.burn(damage)

func hit(damage: int) -> void:
	logic.processor.health.hit(damage)
	view.hit(damage)

func teleport(pos: Vector2) -> void: logic.processor.path.teleport(pos)




extends Node

@onready var track: Node = $track
@onready var enemy: CharacterBody2D = get_node("../../..")

var target: Rect2

func teleport(next: Vector2) -> void:
	enemy.velocity = Vector2.ZERO
	enemy.position = next

func dash(force: Vector2) -> void:
	teleport(enemy.position + force)

func reset_velocity(motion: Vector2) -> void:
	enemy.velocity = motion

func forget_velocity() -> void:
	reset_velocity(Vector2.ZERO)
	enemy.view.animation.move(Vector2.ZERO)

func travel(motion: Vector2) -> void:
	motion *= track.speed
	reset_velocity(motion)

func _physics_process(_delta: float) -> void:
	var motion: Vector2 = track.motion
	enemy.view.animation.move(motion)
	reset_velocity(motion)
	enemy.move_and_slide()




extends Node

@export var speed: int = 200
@export var vertical: bool = false
@onready var hit: Timer = $hit

var paralyzed: bool = false
var direction: float = -1.0
var _motion_path: Callable
var motion: Vector2
var obstacles_counter: int = 0

func update_movement():
	motion = _motion_path.call() # print("MOTION: ", motion)

func _ready() -> void: ignite_motion()

func ignite_motion() -> void:
	_motion_path = _vertical_motion if vertical else _horizontal_motion
	update_movement()

func freeze_motion() -> void:
	_motion_path = _no_motion
	update_movement()

func _no_motion() -> Vector2: return Vector2.ZERO
func _horizontal_motion() -> Vector2: return Vector2(0, direction * speed)
func _vertical_motion() -> Vector2: return Vector2(direction * speed, 0)

func temporary_freeze() -> void:
	if not paralyzed:
		freeze_motion()
		hit.start()

func paralyze(_body) -> void:
	paralyzed = true
	freeze_motion()

func stop_paralyze(_body) -> void:
	ignite_motion()
	paralyzed = false

func enter_obstacle(_body) -> void:
	obstacles_counter += 1
	if obstacles_counter == 1:
		avoid_obstale()

func exit_obstacle(_body) -> void:
	obstacles_counter -= 1

func avoid_obstale() -> void:
	direction *= -1
	update_movement()




extends AdvancedCharacterAnimation

@onready var dead: Node = $dead
@onready var timer: Timer = $timer

func _ready() -> void: direct()

func direct_animations() -> Array[String]:
	return ["rolling"]

func move(motion: Vector2) -> bool:
	var turned: bool = super.move(motion)
	if turned: request("enemy", "active")
	#else: request("enemy", "passive")
	return turned

func dead_animation() -> void:
	dead.start()
	interrogate()

func interrogate() -> void:
	timer.start()

func interrogation_end() -> void:
	dead.health.aura.stop_blinking()
	dead.health.aura.diffusion()
	request("enemy", "dead")

func dead_animation_end() -> void:
	dead.effect()
	request("enemy", "alive")

func live_animation_end() -> void:
	dead.path.ignite_motion()
	dead.damage.monitoring = true
	request("enemy", "active")





extends Node2D

@export var outline: Shader
@onready var timer: Timer = $timer
@onready var profile: AnimatedSprite2D = $profile
@onready var animation: AnimationTree = $animation
@onready var sand: GPUParticles2D = $particle

var hit_direction: int = 1

func _ready() -> void:
	profile.material = ShaderMaterial.new()
	profile.material.set("shader", outline)

func hit(_damage: int) -> void:
	skew = deg_to_rad(randf_range(4.0, 18.0) * hit_direction)
	hit_direction *= -1
	sand.process_material.direction.x = hit_direction
	sand.appear()
	timer.start()
	# create_tween().tween_property(self, "skew", deg_to_rad(0), 1.5)

func normalize_skew() -> void: skew = 0











extends CharacterBody2D

@onready var see: Node2D = $see
@onready var work: Node = $work
@onready var link: Node = $link

func _ready() -> void: link.controls(self)



extends Node

@onready var timer: Timer = $timer

func controls(platform: CharacterBody2D) -> void:
	var stand: Area2D = platform.see.stand
	var work: Node = platform.work

	work.cargo.platform = platform
	stand.body_entered.connect(work.cargo.load_cargo)
	stand.body_exited.connect(work.cargo.free_cargo)

	timer.timeout.connect(platform.see.ledge.sync_traps)
	timer.start()


extends Node

@onready var timer: Timer = $timer
var tags: TileMapLayer = null
var _platform: CharacterBody2D

func bind_lever() -> void:
	var location: Node = tags.lockers.location
	var pos: Vector2 = _platform.position + _platform.see.position
	var data: Dictionary = location.search.atlas.get_mech_atlas(tags.lay.tags, pos)
	data.processor = _platform.work
	location.storage.setup_mech(data)

func controls(platform: CharacterBody2D) -> void:
	#TODOT CARGO CONNECT
	var stand: Area2D = platform.see.stand
	var work: Node = platform.work
	#bind_lever(platform)
	_platform = platform
	if tags == null: tags = platform.get_node("../tags")

	work.cargo.platform = platform
	stand.body_entered.connect(work.cargo.load_cargo)
	stand.body_exited.connect(work.cargo.free_cargo)

	timer.timeout.connect(platform.see.ledge.sync_traps)
	timer.timeout.connect(bind_lever)
	timer.start()
	work.timer.timeout.connect(work.enable_control)





extends Node

var platform: CharacterBody2D
var weight: Dictionary = {}

func load_cargo(cargo: AnimatableBody2D) -> void:
	if platform.see.ledge.sync_traps():
		weight[cargo.get_instance_id()] = cargo
		toggle(cargo, false)

func free_cargo(cargo: CharacterBody2D) -> void:
	if platform.see.ledge.sync_traps():
		weight.erase(cargo.get_instance_id())
		toggle(cargo, true)

func toggle_platforming(hero: CharacterBody2D, state: bool) -> void:
	hero.to.platform.surface.border.turn_monitoring(state)

func toggle_mask(gravity, state: bool) -> Lay:
	return gravity.context(state).collide_main().collide(Lay.BORDERS)

func is_weight_box(entity: AnimatableBody2D) -> bool:
	return entity is PlatformingBox

func toggle(cargo: AnimatableBody2D, state: bool) -> void:
	if is_weight_box(cargo):
		toggle_mask(cargo.logic.work.move.gravity, state)
	else:
		toggle_mask(cargo.to.layers, state).hero_collide(true)
		toggle_platforming(cargo, state)

func _move_certain(box: CharacterBody2D, motion: Vector2) -> void:
	box.velocity = motion

func _move_objects(motion: Vector2) -> void:
	_move_certain(platform, motion)
	for cargo in weight.values():
		_move_certain(cargo, motion)

func move_cargo(motion: Vector2) -> void:
	if platform.see.ledge.caution.is_colliding():
		_move_certain(platform, Vector2.ZERO) #_move_objects(Vector2.ZERO)
	else:
		_move_objects(motion)




extends Node

@export var direction: Vector2 = Vector2(250, 0)

@onready var timer: Timer = $timer
@onready var cargo: Node = $cargo

const INVERSE: Vector2 = Vector2(-1, -1)
var enabled: bool = false

func control_cargo() -> void:
	if enabled or not cargo.platform.see.ledge.sync_traps():
		cargo.move_cargo(direction) #move_cargo()

func enable_control() -> void:
	enabled = false

func toggle_logic() -> void:
	direction *= INVERSE
	enabled = true
	timer.start()

func _physics_process(_delta: float) -> void:
	#if cargo.weight.size() >= 1:
	control_cargo()
	cargo.platform.move_and_slide()




extends Node

const POWER: int = 250

@onready var cargo: Node = $cargo

func control_cargo() -> void:
	var motion: Vector2 = cargo.platform.see.ledge.move()
	if motion != Vector2.ZERO:
		print("MOVING CARGO: ", motion)
		cargo.move_cargo(motion * POWER)

func _physics_process(_delta: float) -> void:
	if cargo.weight.size() >= 1:
		control_cargo()
	cargo.platform.move_and_slide()




extends Node2D

@onready var axis_a: ShapeCast2D = $axis_a
@onready var axis_b: ShapeCast2D = $axis_b

func is_colliding() -> bool:
	return axis_a.is_colliding() and axis_b.is_colliding()


extends Node2D

@onready var trap: Sprite2D = $trap
@onready var wall: StaticBody2D = $wall
@onready var plane: Node2D = $plane
@onready var hero: ShapeCast2D = $hero
@onready var current: ShapeCast2D = $current

var open: bool

func sync_trap() -> bool:
	open = plane.is_colliding() # wall.visible = not open
	Works.turn(wall, not open)
	trap.visible = open
	return open

func move() -> bool:
	#sync_trap() #not sync_trap() and  
	return not sync_trap() and hero.is_colliding()

func rail() -> bool:
	return current.is_colliding()




extends Node2D

@onready var stand: Area2D = $stand
@onready var ledge: Node2D = $ledge


extends Node2D

@onready var top: Node2D = $top
@onready var left: Node2D = $left
@onready var right: Node2D = $right
@onready var bottom: Node2D = $bottom
@onready var caution: ShapeCast2D = $caution

func get_directions() -> Array:
	return [
		[top, Vector2(0, -1)], [bottom, Vector2(0, 1)],
		[left, Vector2(-1, 0)], [right, Vector2(1, 0)]
	]

func sync_traps() -> bool:
	var open: bool = false
	for direction in [top, left, right, bottom]:
		open = open or direction.sync_trap()
	return open

func move() -> Vector2:
	var directions: Array = get_directions()
	for motion in directions:
		if motion[0].rail() and motion[0].move():
			#print("CarGo on rails: ", motion[1])
			# print("CarGo moves: ", motion[1])
			return motion[1]
	return Vector2.ZERO




class_name TileCluster extends RefCounted

enum { BUTTON, LEVER, SOURCE, TELEPORT, SIZE = 16, CLUSTER = 64 }

func help_show(pos: Vector2i, type: PackedInt32Array) -> int:
	for i in range(0, len(hint), 2):
		if Def.tomap(type[i]) >= pos and pos <= Def.tomap(type[i + 1]):
			return i
	return -1

func help_hint(tag_id: int, atlas: int, type: PackedInt32Array) -> void:
	if HUD.level.execute.get_used_cells_by_id(Def.TAGS, Vector2i.ONE * -1, tag_id).size() == 0: return
	for tile in range(0, Def.T8):
		var tiles: PackedVector2Array = HUD.level.execute.get_used_cells_by_id(Def.TAGS, Def.to8(tile), tag_id) # Def.to8(tile)
		if tiles.size() == 0: continue
		var i: int = int(tiles.size() == 2)
		var a: Vector2i = tiles[0].min(tiles[i]) ; type.append(Def.ofmap(a))
		var b: Vector2i = tiles[i].max(tiles[0]) ; type.append(Def.ofmap(b))
		for t in tiles: HUD.level.execute.erase_cell(t)
		for y in range(a.y, b.y + 1):
			for x in range(a.x, b.x + 1):
				HUD.level.border.coords(Def.of(x, y)).type().id().atlas()
				if (HUD.level.border.tile[Def.ATLAS] == Def.GROUND and
					HUD.level.border.tile[Def.ID] in [Def.FLOOR, Def.WALLS]):
					HUD.level.border.atlas(atlas).id(Def.FLOOR).paint_alt()


func reset_button_completion() -> void:
	if sizes[BUTTON] == 0: return
	
	
	
	pass

func resize_clusters() -> void:
	var button: PackedInt32Array = []
	var lever: PackedInt32Array = []
	var source: PackedInt32Array = []
	var teleport: PackedInt32Array = []
	
	cluster.resize(CLUSTER)
	var count: int = 0
	for y in range(0, Def.T8):
		var tiles: PackedVector2Array = HUD.level.execute.get_used_cells_by_id(Def.TAGS, Def.to8(y))
		if tiles.size() == 0: break
		if count + tiles.size() > cluster.size(): cluster.resize(cluster.size() * 2)
		
		var search: bool = true
		for x in range(0, tiles.size()):
			cluster[count + x] = Def.ofmap(tiles[x])
			if search:
				search = false
				match Def.of8(HUD.level.border.coords(tiles[x]).tile[Def.ATLAS]):
					Def.PLATE_OFF, Def.PLATE_ON: button.append(Def.of(tiles.size(), count))
					Def.LEVER_OFF, Def.LEVER_ON: lever.append(Def.of(tiles.size(), count))
					Def.SOURCE_OFF, Def.SOURCE_ON: source.append(Def.of(tiles.size(), count))
					Def.TELEPORT_ON, Def.PLACE: teleport.append(Def.of(tiles.size(), count))
					_: search = true
		count += tiles.size()
	var types: Array[PackedInt32Array] = [button, lever, source, teleport]
	for i in range(0, len(types)):
		access.append_array(types[i])
		sizes[i] = types[i].size()

func button_press(no: int, add: int, compare: int, tag: int) -> void:
	var coords: int = cluster[no]
	if buttons.has(coords):
		buttons[coords] = buttons[coords] + add
	else:
		buttons[coords] = compare
	if buttons[coords] == compare: executes(tag)

func toggle_openning(no: int, on: bool, enter: bool) -> void:
	var tag: int = Def.of8(HUD.level.border.coords(cluster[no]).tile[Def.ATLAS])
	match tag:
		Def.PLATE_OFF: button_press(no, +1, 1, Def.PLATE_ON if on else tag)
		Def.PLATE_ON: button_press(no, +1 if enter else -1, 0, Def.PLATE_OFF if on else tag)
		Def.U_WALL_OFF: executes(Def.U_WALL_ON if on else tag)
		Def.U_WALL_ON: executes(Def.U_WALL_OFF if on else tag)
		Def.D_WALL_OFF: executes(Def.D_WALL_ON if on else tag)
		Def.D_WALL_ON: executes(Def.D_WALL_OFF if on else tag)
		Def.STAND_OFF: executes(Def.STAND_OFF if on else tag)
		Def.STAND_ON: executes(Def.STAND_ON if on else tag)

func executes(next: int) -> void: HUD.level.border.switch(Def.to8(next))
func next_cluster(cursor: Vector2, count: int) -> Vector2: return Vector2(cursor.x + count, cursor.y + 1)

func switch_cluster(section: int, enter: bool) -> void:
	var c: int = get_cluster(section, Def.ofmap(HUD.level.border.tile[Def.COORDS]))
	var no: int = HUD.selected + HUD.COMPLETED
	var state: bool = !Bit.of(HUD.session[no], c)
	HUD.session[no] = Bit.to(HUD.session[no], c, state)
	for i in range(Def.x(access[c]), Def.y(access[c])):
		toggle_openning(i, state, enter)

func get_cluster(section: int, coords: int) -> int:
	var from: int = 0
	for x in range(0, section): from += sizes[x]
	for y in range(from, from + sizes[section]):
		for i in range(Def.x(access[y]), Def.y(access[y])):
			if coords == cluster[i]: return y
	return -1

func tile_press(coords: int, enter: bool = true) -> void:
	match HUD.level.border.coords(coords).id().atlas().tile[Def.ATLAS]:
		Def.PLATE_OFF: switch_cluster(BUTTON, enter)
		Def.PLATE_ON: switch_cluster(BUTTON, enter)

func tile_act(coords: int) -> void:
	match HUD.level.border.coords(coords).id().atlas().tile[Def.ATLAS]:
		Def.LEVER_OFF: switch_cluster(LEVER, true)
		Def.LEVER_ON: switch_cluster(LEVER, true)

func tile_spark(coords: int) -> void:
	match HUD.level.border.coords(coords).id().atlas().tile[Def.ATLAS]:
		Def.SOURCE_OFF: switch_cluster(SOURCE, true)
		Def.SOURCE_ON: switch_cluster(SOURCE, true)

func tile_melt(coords: int) -> void:
	HUD.level.border.coords(coords).id().alt().type()
	if HUD.level.border.tile[Def.TYPE] == Def.ICE_FLOOR:
		HUD.level.border.type(Def.FLOOR).paint_alt()

var no: int = -1

func tile_walk(hero: CharacterBody2D, enter: bool = true) -> void:
	if not enter and no != -1:
		HUD.menu.log_help_hide()
		no = -1
	
	var atlas: int = HUD.level.border.coords(HUD.level.tile[Def.offset(hero.no, Def.PLATE)]).atlas().tile[Def.ATLAS]
	if atlas == Def.TELEPORT_ON:
		var c: int = get_cluster(TELEPORT, Def.ofmap(HUD.level.border.tile[Def.COORDS]))
		for i in range(Def.x(access[c]), Def.y(access[c])):
			if HUD.level.border.coords(cluster[i]).tile[Def.ATLAS] == Def.PLACE:
				hero.teleport(HUD.level.border.map_to_local(Def.tomap(cluster[i])))
				break
	elif atlas == Def.HINT and HUD.level.border.tile[Def.ID] == Def.FLOOR:
		no = help_show(HUD.level.border.local_to_map(hero.position), hint)
		if no != -1: HUD.menu.log_help(no)
	else:
		tile_press(HUD.level.border.tile[Def.COORDS], enter)

func secret_reveal() -> void:
	pass




enum { BORDERS, WORLD, ENTITY, GROUND, SLIDE = 2, POWER = 40000 } # , JUMP = 200000, GRAVITY = 700000 # CHARACTER = 3, BOX = 5
"""
const small: PackedScene = preload("res://pre/box/small.tscn")
const large: PackedScene = preload("res://pre/box/large.tscn")
const fire: PackedScene = preload("res://pre/box/fire.tscn")
"""
var velocity: PackedVector2Array = []
var assets: Array[AnimatableBody2D] = []
var height: PackedByteArray = []
var weight: PackedByteArray = []

var state: PackedByteArray = []
var grab: PackedByteArray = []

const weight_d: PackedFloat32Array = [0, 1, 0.5, 0.33, 0.25]

func is_sliding(no: int) -> bool: return Bit.of(state[SLIDE], no)

func _physics_process(_delta: float) -> void:
	for i in range(0, len(assets)):
		assets[i].move_and_collide(velocity[i])

func toggle_slide(no: int, next: bool) -> void:
	state[SLIDE] = Bit.to(state[SLIDE], no, next)

func slide_the_box(box: CharacterBody2D) -> void:
	box.make_velocity(Vector2(box.velocity.x, Def.GRAVITY)) # * delta

func set_box(asset: PackedScene, data: PackedByteArray) -> void:
	assets.append(asset.instantiate())
	height.append(data[0])
	weight.append(data[1])
	velocity.append(Vector2.ZERO)
"""
func add_box(box_type: int, position: Vector2) -> void:
	var no: int = assets.size()
	match box_type:
		Def.SMALL_BOX: set_box(small, [1, 2])
		Def.LARGE_BOX: set_box(large, [2, 4])
		Def.FIRE_BOX: set_box(fire, [0, 2])
	print("LEVEL: ", Def.SMALL_BOX, " - B: ", box_type)
	HUD.level.call_deferred(&"add_child", assets[no])
	assets[no].set_meta(&"no", no)
	assets[no].position = position + Vector2(0, 28)
	assets[no].name = str(assets[no].name, '_', no)
	controls(assets[no])
"""
func get_box(no: int) -> AnimatableBody2D: return assets[no]

func throw(box: int, motion: Vector2i) -> void: # THROW
	velocity[box] = POWER * motion

func pushes(box: int, motion: Vector2) -> void: # for i in range(0, count.size()) # if Bit.of(state[hero.no], i):
	velocity[box] = motion * weight_d[weight[box]]

func fixate_box(hero: int, box: int, _add: int) -> void:
	state[hero] = Bit.to1(state[hero], box)

func encounter() -> void: pass
func diverge() -> void: pass

func controls(box: AnimatableBody2D) -> void:
	var see: Area2D = box.get_node("press")
	see.body_entered.connect(encounter)
	see.body_exited.connect(diverge)
	var fov: VisibleOnScreenNotifier2D = box.get_node(^"fov")
	fov.screen_entered.connect(box.show)
	fov.screen_exited.connect(box.hide)








enum { ID = 4, CONSTRAINT = 5, HEIGHT = 5, CELL = 64, ACCELERATION = 1000, GRAVITY = 500, JUMP = 25000 } # 700000  # , TRY = 75000 , SINGULARITY = 35000 # JUMP = -75000, GRAVITY = 375000 / 150 - 750
# TOOLS CHAINS

# CHAINS MOVE
var see: Node2D
var slide: ShapeCast2D # # var slide: Node
var walls: RayCast2D
var hero: CharacterBody2D
var ground: Node
var input: Node
var layers: Node
#var input: Node
var control: Node
var view: Node2D
var platform: ShapeCast2D # func singularity_point(delta: float) -> void: if slide.height > SINGULARITY: slide.height -= delta * slide.height; else: slide.falling = true; slide.height = height#; += delta * GRAVITY
var height: float = 0
var world_y: float = 0.0 # @onready var deactivation: Timer = $deactivation
var is_sliding: bool:
	get: return slide.is_colliding()

var hanging: bool = false
var is_pressed: bool = false
var was_sliding: bool = false
var falling: bool = false

func hold_chains(hero: int) -> void:
	# HUD.level.state[hero] = Bit.to0(Bit.to1(HUD.level.state[hero], Def.CHAINS), Def.JUMP)
	HUD.level.entity[hero].set_collision_mask_value(1, false)
	# view.shadow.hanging = active
	view.animation.moves.set_environment(&"chains")

func pull_chains(hero: int) -> void:
	# HUD.level.state[hero] = Bit.to0(HUD.level.state[hero], Def.CHAINS)
	HUD.level.entity[hero].set_collision_mask_value(1, true)
	view.shadow.set
	HUD.level.entity[hero].view.animation.moves.set_environment(&"ground")

# CHAINS CATCH
func ledge_in_midair() -> void:
	control.land()
	encounter_ledge(true)

func encounter_ledge(active: bool) -> void:
	disable_collision(active)
	chains_animation(active)

func chains_animation(active: bool) -> void:
	view.shadow.hanging = active
	view.animation.moves.set_environment(&"chains" if active else &"ground")

func disable_collision(active: bool) -> void:
	input.is_platformer = active
	# chained.emit(active)
	control.layers.context(!active).collide_main()

# TOOLS JUMP
# JUMP SLIDE
func gravity(hero: int) -> void:
	var state: int = HUD.level.state[hero]
	if Bit.of(state, Def.JUMP) and Bit.of(state, Def.FALL): # CHAINS
		HUD.level.entity[hero].velocity.y = 0
	elif Bit.of(state, Def.FALL): # FALL
		HUD.level.entity[hero].add_velocity(Vector2(0, GRAVITY))
	elif Bit.of(state, Def.JUMP): # JUMP
		HUD.level.entity[hero].add_velocity(Vector2(0, -GRAVITY))

# SPRING CONTROL
func jump(jumped: bool) -> void:
	# slide.height = -JUMP if jumped else 0 # hero.movement = gravity if jumped else floating # hero.motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED / CharacterBody2D.MOTION_MODE_FLOATING
	if jumped:
		slide.hero.velocity.y = -JUMP
	slide.falling = jumped
	layers.context(!jumped).collide_main()#.collide(Lay.BORDERS) BAD IDEA
	input.is_platformer = jumped # hero.logic.work.world.layers.context(!jumped).collide_main().collide(Lay.BORDERS) # hero.logic.work.input.modes.select(jumped)

func falls(delta: float) -> void:
	hero.velocity.y = GRAVITY # delta * 
	print("Y: ", hero.position.y)#, " - HEIGHT: ", height)
	if walls.is_colliding(): land()

func land() -> void:
	hero.velocity.y = 0
	falling = false
	height = 0

# SPRING JUMP
var spring: ShapeCast2D

func perform_jump(_force: float) -> void:
	ground.activate_spring(control.slide.hero.position)
	control.jump(true)

func return_input() -> void:
#	ground.deactivate_spring()
	control.jump(false)




func landing_crash() -> void:
	if not slide.above(ground.world_y):
		land() # hero.position.y = ground #print("GROUND: ", ground, " - Y: ", mode.hero.position.y, " - H: ", delta * height) # landing.emit()

func landing_manual() -> void: # flying and 
	if not platform.is_colliding() and Input.is_action_just_pressed("run"): # landing.emit()
		land() # height > 0

# SPRING GROUND
func switch_spring_tile() -> void:
	pass
	# HUD.execute.switch(Def.to4(Def.SPRING_ON))

func press(condition: bool) -> bool:
	if condition: is_pressed = !is_pressed
	return condition

func activate_spring(hero_pos: Vector2) -> void:
	if press(not is_pressed):
		HUD.level.entity
		HUD.execute.from_pos(hero_pos)
		switch_spring_tile()
		# deactivation.start()

func deactivate_spring() -> void:
	if press(is_pressed):
		switch_spring_tile()

func save(hero_y: float) -> void: world_y = hero_y + CONSTRAINT

















enum { CHAIN = 0, STATE = 0, JOINT = 1, A = -2, B = -1, TIME = 4, LENGTH = 10, NONE = -1, PUDDLE = 0, SOURCE = 1 }

var puddles: PackedInt32Array = [0, 0, 0, 0, 0, 0, 0, 0]
var current: Array[PackedInt32Array] = [] # Vector2i
var size: PackedByteArray = []
var rain: Node2D = null

func setup() -> void:
	for coords in HUD.level.border.busy(Def.SOURCE_ON, Def.LOGIC):
		initiate_source(Def.ofmap(coords))

func initiate_source(coords: int) -> void:
	current.append([coords, coords])
	size.append(LENGTH)
	draw_tile(coords, SOURCE)
	contact(coords)
	TileCluster

func diffusion() -> void:
	for i in range(1, 8):
		var state: int = Bit.of_x(Bit.MASK3, puddles[STATE], i)
		if state == 0: continue
		if state - 1 == 0:
			HUD.level.border.coords(puddles[i]).id().atlas().alt().type(Def.PUDDLE_OFF).paint_alt()
			puddles[STATE] = Bit.edit_x(Bit.MASK3, puddles[STATE], 0, -1)
		puddles[STATE] = Bit.to_x(Bit.MASK3, puddles[STATE], i, state - 1)
	if puddles[STATE] == 0: HUD.sparking.stop()

func sparking(tile: int) -> void:
	if puddles[STATE] & 7 == 7: return
	for i in range(1, 8):
		if Bit.of_x(Bit.MASK3, puddles[STATE], i) == 0:
			puddles[i] = tile
			HUD.level.border.coords(tile).id().atlas().alt().type(Def.PUDDLE_ON).paint_alt()
			puddles[STATE] = Bit.to_x(Bit.MASK3, puddles[STATE], i, TIME)
			puddles[STATE] = Bit.edit_x(Bit.MASK3, puddles[STATE], 0, +1)
			break
	if Bit.of_x(Bit.MASK3, puddles[STATE], 0) == 1:
		HUD.sparking.start()

func activate_puddle(pos: Vector2) -> void:
	if not _around(Def.ofmap(HUD.level.border.local_to_map(pos))): return
	
	if HUD.level.border.tile[Def.TYPE] == Def.PUDDLE_OFF:
		sparking(HUD.level.border.tile[Def.COORDS])
	else:
		contact(HUD.level.border.tile[Def.COORDS])

#func draw_the_puddle() -> void:
#	if rain == null:
#		rain = Def.rain.instantiate()
#		HUD.level.border.add_child(rain)
#	HUD.level.border.add_chip(rain)
#	rain.shows()

func draw_tile(map_coords: int, no: int) -> void:
	HUD.level.border.coords(map_coords).id().atlas().type()
	match no:
		SOURCE: HUD.level.border.atlas(Def.SOURCE_ON).paint()
		PUDDLE: HUD.level.border.type(Def.PUDDLE_ON).paint_alt()

func _around(tile: int) -> bool:
	var t: PackedInt32Array = HUD.level.border.coords(tile).id().type().tile
	return ((t[Def.ID] == Def.LOGIC and t[Def.ATLAS] == Def.SOURCE_OFF) or
		(t[Def.ID] == Def.FLOOR and t[Def.ATLAS] != Def.WALL and t[Def.TYPE] == Def.PUDDLE_ON))

func contact(map_coords: int) -> void:
	if not (_around(map_coords + Def.yof(1)) or _around(map_coords + 1) or
		_around(map_coords - Def.yof(1)) or _around(map_coords - 1)): return
	
	map_coords = HUD.level.border.tile[Def.COORDS]
	if HUD.level.border.tile[Def.TYPE] == Def.PUDDLE_OFF:
		charge_unit(map_coords)
		return
	
	initiate_source(map_coords)
	if conduct(map_coords, current.size() - 1):
		draw_tile(map_coords, SOURCE)
		contact(map_coords)

func conduct(map_coords: int, chain: int) -> bool:
	if size[chain] == 0: return false
	var delta: int = current[chain][B] - current[chain][A]
	if delta == 0:
		current[chain][B] = map_coords
	elif map_coords - current[chain][B] == delta:
		current[chain][B] += delta
	elif map_coords != current[chain][B]:
		current[chain].append(map_coords)
	else:
		return false
	size[chain] -= 1
	return true

func at_dimension(a: Vector2i, b: Vector2i, map_coords: Vector2i, axis: int) -> bool:
	if not map_coords[axis] == b[axis]: return false
	var back: int = axis ^ 1
	var x: int = map_coords[back]
	return (a[back] <= x and x <= b[back]) or (a[back] >= x and x >= b[back])

func get_site_to_discharge(map_coords: Vector2i) -> Vector2i:
	var tile: Vector2i = Vector2i(current.size(), 0)
	for c in range(tile[CHAIN], 0, -1):
		tile[CHAIN] = c
		for j in range(current[c].size(), 1, -1):
			tile[JOINT] = j
			var a: Vector2i = Def.tomap(current[c][j - 1])
			var b: Vector2i = Def.tomap(current[c][j])
			if not (at_dimension(a, b, map_coords, Vector2.AXIS_Y) or
				at_dimension(a, b, map_coords, Vector2.AXIS_X)):
				return tile
	return tile

func charge_unit(map_coords: int) -> void:
	for chain in range(current.size(), 0, -1):
		var delta: int = map_coords - current[chain][B]
		if ((Def.x(delta) ^ Def.y(delta)) & 1 == 1) and conduct(map_coords, chain):
			draw_tile(map_coords, PUDDLE)
			contact(map_coords)
			return

func get_direction(a: int, b: int) -> int:
	return clampi(Def.y(a) - Def.y(b), -1, 1) | clampi(Def.x(a) - Def.x(b), -1, 1)

func discharge_unit(map_coords: int) -> void:
	var site: Vector2i = get_site_to_discharge(Def.tomap(map_coords))
	if site[CHAIN] == 0: return
	
	var direction: int = get_direction(map_coords, current[site[CHAIN]][site[JOINT] - 1])
	while current[site[CHAIN]].size() - 1 > site[JOINT]:
		discharge(current[site[CHAIN]][A], site[CHAIN])
		shrink_chain(site[CHAIN])
	discharge(map_coords, site[CHAIN])
	_turn_points(Vector2i(map_coords, map_coords - direction), site[CHAIN])

func discharge(target: int, chain: int) -> void: # var track: Rect2i = get_track(chain)
	var position: int = current[chain][B]
	var direction: int = get_direction(current[chain][B], current[chain][A])
	HUD.level.border.coords(position).id().alt().atlas().type(Def.PUDDLE_OFF)
	while position != target and size[chain] < 1000:
		size[chain] += 1
		HUD.level.border.coords(position).paint_alt()
		position -= direction

func shrink_chain(chain: int) -> void:
	current[chain].remove_at(current[chain].size() - 1)

func _turn_points(coords: Vector2i, chain: int) -> void:
	if current[chain].size() == 2: # source
		current[chain][B] = coords.y
	elif coords.x == current[chain][A]: # map_coords
		shrink_chain(chain)
		current[chain][B] -= get_direction(current[chain][B], current[chain][A])
	else:
		if coords.y == current[chain][A]: shrink_chain(chain)
		current[chain][B] = coords.y # target_coords
	size[chain] += 1
	contact(current[chain][B])
