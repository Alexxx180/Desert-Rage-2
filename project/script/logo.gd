extends ColorRect

@onready var timer: Timer = $show
@onready var state: TextureRect = $logo
@onready var tree = get_tree()

@export_file var scene: String = "res://asset/system/scene/usable/level/caves/origin/0/0/level.tscn"
@export var i: int = -1

var stats: SessionStats
var time: Array[Vector2] = [Vector2(1.5, 2), Vector2(2.5, 1)]

func _change_state(tint: Color) -> void:
	create_tween().tween_property(state, "modulate", tint, time[i].x)

func _input(event: InputEvent) -> void:
	if not i in [0, 1]: return
	var gamepad: bool = event is InputEventJoypadButton
	var mouse: bool = event is InputEventMouseButton
	var keyboard: bool = event is InputEventKey
	
	if (gamepad or mouse or keyboard) and event.pressed:
		state.hide()
		_scene_change()

func _scene_change() -> void:
	timer.stop()
	stats.load_scene(scene)

func _show() -> void:
	i += 1
	match i:
		0: _change_state(Color.WHITE)
		1: _change_state(Color.BLACK)
		_: _scene_change(); return
	timer.wait_time = time[i].x + time[i].y
	timer.start()





class_name Lockers extends Node

enum { MECH = 0, SOURCE = 2 }

var border: TileDecorator:
	get: return HUD.level.root.border
var execute: TileDecorator:
	get: return HUD.level.root.execute

func set_lockers(_ability: Node) -> void: _ability.lockers = self

var ability: Node:
	get: return Works.uploads(self, LoadBus.ability % "ability", "ability", set_lockers)

var activator: Node:
	get: return Works.uploads(self, LoadBus.activator, "activator")

const STAND_ID: int = 3

var logic: Dictionary = { "trigger": {}, "connector": {}, "machine": {} }
var act: Dictionary = TilesTape.new(4, 1).next(0, 2).add("PLATE").add("LEVER"
	).from(0, 2).next(3, -2).add("STAND").on(0, 1).add("GATE").result()

func unique(map_coords: Array, i: int) -> void: map_coords.remove_at(i)
func builder(_empty: Object) -> LockersStorage: return self

func has_trigger(map_coords: Vector2i) -> bool: return logic.trigger.has(map_coords)
func set_trigger(tile: Dictionary): logic.trigger[tile.coords] = tile
func get_trigger(map_coords: Vector2i) -> Dictionary: return logic.trigger[map_coords]

func add_trigger(tile: Dictionary) -> LockersStorage: return builder(set_trigger(tile))
func add_plate(tile: Dictionary) -> LockersStorage:
	tile.count = 0 # tile.atlas.x
	return add_trigger(tile)

func _setup_machine(data: Dictionary, type: String) -> void:
	data.type = type
	logic.machine[data.coords] = data

func setup_mech(data: Dictionary) -> void: _setup_machine(data, "mech")

func add_stand(data: Dictionary) -> void:
	data.id = STAND_ID
	_setup_machine(data, "tile")

func add_gate(data: Dictionary) -> void:
	data.eraser = { "erase": false, "tile": data.atlas, "id": STAND_ID }
	add_stand(data)

func get_atlas(map_coords: Vector2i, tag: Vector2i) -> Dictionary:
	return HUD.level.root.border.from_coords(map_coords).add_prop("tag", tag).context.duplicate()

func setup(tag: Vector2i, map_coords: Array[Vector2i]) -> void:
	for i in range(map_coords.size(), -1, -1): # print("TAG: ", tag)
		var tile: Dictionary = get_atlas(border, map_coords[i], tag)
		tile.offset = Vector2i(1, 0)
		match tile.atlas:
			act.OFF.LEVER, act.ON.LEVER: add_trigger(tile).unique(map_coords, i)
			FlowConductor.SOURCE_OFF: add_trigger(tile).unique(map_coords, i)
			act.OFF.PLATE, act.ON.PLATE: add_plate(tile).unique(map_coords, i)
			act.OFF.STAND, act.ON.STAND: add_stand(tile)
			act.OFF.GATE, act.ON.GATE: add_gate(tile)
	logic.connector[tag] = map_coords

# var search: StorageSearch = StorageSearch.new()

func empty(tile: Vector2i) -> bool: return tile == Def.VECTI

func check_weight(map_coords: Vector2i, appendix: int) -> bool:
	var trigger: Dictionary = get_trigger(map_coords)
	trigger.count += appendix
	return trigger.count == clamp(appendix, 0, 1)
	
func switch(pos: Vector2, appendix: int) -> void:
	var map_coords: Vector2i = search.get_border_tile_coords(pos)
	if not empty(map_coords) and check_weight(map_coords, appendix):
		map_activate(map_coords)

func activate_trigger(pos: Vector2) -> void:
	var map_coords: Vector2i = search.get_border_tile_coords(pos)
	if not empty(map_coords): map_activate(map_coords)

func deactivate_button(pos: Vector2) -> void: switch(pos, -1)

func activate_button(pos: Vector2) -> void: switch(pos, 1)

func map_activate(map_coords: Vector2i) -> void: search.activate(map_coords)

func setup_sparks() -> void:
	for x in range(5):
		for y in range(5):
			var atlas: Vector2i = Vector2i(x, y)
			var busy: Array[Vector2i] = execute.busy(atlas, Lockers.SOURCE)
			search.storage.setup(root.border, atlas, busy)



# TRIGGER

const LOCKER_DEFAULT_TILE: Vector2i = Vector2i(2, 4)

var root: LevelRoot
var storage: LockersStorage = LockersStorage.new()

func activate(map_coords: Vector2i) -> void:
	var activator: Dictionary = storage.logic.trigger[map_coords]
	set_tile(activator, Vector2i(1, 0))
	set_mechs(activator.tag)

func get_border_tile_coords(pos: Vector2) -> Vector2i:
	return root.border.from_pos(pos).tcoords

func has_trigger(map_coords: Vector2i) -> bool:
	var has: bool = has_trigger(map_coords)
	if not has: border.select(Transitions.MISSING).paint() # assert "no trigger found"
	return has

func get_mech_atlas(tags: TileDecorator, pos: Vector2) -> Dictionary:
	var tag: Vector2i = tags.from_pos(pos).context.coords
	return { "connector": tag, "coords": tag }

func get_prop(config: Dictionary, prop: String, default: Variant) -> Variant:
	return config[prop] if config.erase else default

func smart_erase(mech: Dictionary, config: Dictionary) -> void:
	mech.atlas = get_prop(config, "tile", LOCKER_DEFAULT_TILE)
	mech.id = get_prop(config, "id", Lockers.MECH)
	root.border.paint(mech)
	config.erase = !config.erase

func set_tile(mech: Dictionary, o: Vector2i) -> void:
	mech.atlas[o.y] += o.x if mech.atlas[o.y] % 2 == 0 else -o.x
	root.border.paint(mech)

func check_tile(mech: Dictionary) -> void:
	if not mech.has("eraser"): set_tile(mech, mech.offset)
	else: smart_erase(mech, mech.eraser)

func set_mechs(tag: Vector2i) -> void: # print("LOG: ", sactivatorearch.storage.logic.connector) # print("TAG: ", tag)
	for tile in storage.logic.connector[tag]:
		var mech: Dictionary = storage.logic.machine[tile]
		match mech.type:
			"tile": check_tile(mech)
			"mech": mech.processor.toggle_logic()



# BUTTON

var location: Node

func switch(pos: Vector2, appendix: int) -> void:
	var map_coords: Vector2i = location.search.atlas.find_cell(pos)
	if map_coords != Lockers.EMPTY and check_weight(map_coords, appendix):
		location.search.activate(map_coords)

func check_weight(map_coords: Vector2i, appendix: int) -> bool:
	var trigger: Dictionary = location.storage.logic.trigger[map_coords]
	trigger.count += appendix
	return trigger.count == clamp(appendix, 0, 1)

func deactivate(pos: Vector2) -> void: switch(pos, -1)

func activate(pos: Vector2) -> void: switch(pos, 1)



# FREEZE

var root: LevelRoot
var act: Dictionary = TilesTape.new(2, 1).add("ICE").add("PUDDLE").result()

func evaporation() -> void:
	root.execute.erase().add_chip(PreloadBus.fire.instantiate())
	fire_drain.emit(root.execute.tcoords)

func break_ice(damage: int) -> void:
	if root.execute.extract(Tile.BREAK) <= damage: evaporation()

func activate(pos: Vector2, damage: int) -> void:
	match root.execute.from_pos(pos).tatlas:
		act.OFF.ICE, act.ON.ICE: break_ice(damage)
		act.OFF.PUDDLE, act.ON.PUDDLE: evaporation() 



func setup_ability(execute: TileDecorator, border: TileDecorator) -> void:
	ability.execute = execute
	ability.border = border
	var charge: Node = ability.puddle.spark.chains.charge
	charge.activate.connect(activator.trigger.map_activate)

func setup(location: Node, execute: TileDecorator) -> void:
	setup_ability(execute, location.search.execute)
	activator.set_location(location)




@onready var spawn: Node = $spawn
@onready var pool: Node = $pool
@onready var hud_reseter: Timer = $hud

var hud: EnemyHUD = EnemyHUD.new()

func _enemy(tag: Vector2i) -> String:
	match spawn.lay.tags.from_coords(tag).context.atlas:
		Vector2i(1, 0): return "boss"
		_: return "foe"

func set_enemies_spawn(lay: Node) -> void:
	spawn.set_spawn(lay)
	var type: Dictionary = spawn.select(pool)
	for i in range(0, spawn.places.size()):
		set_enemy(i, spawn.places[i], type)

func setup(lay: Node, casual_mode: bool) -> void:
	hud.set_timer(self)
	if not casual_mode: set_enemies_spawn(lay)

func set_enemy(i: int, tag: Vector2i, type: Dictionary) -> void:
	var enemy: CharacterBody2D = spawn.from_pool(type, pool, _enemy(tag))
	spawn.initiate(enemy, i, tag)
	enemy.view.animation.dead.transport.connect(func(): spawn.dead(enemy))
	hud.setup(enemy)
