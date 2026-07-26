class_name WorldInput extends CanvasLayer

var level: LevelRoot
var aura: Adversary ; var animation: CharacterAnimation
var interact: WorldInteraction ; var _inventory: HeroInventory
var menu: Menu = Menu.new()

var fire: GPUParticles2D ; var rain: GPUParticles2D

func new_hero(no: int) -> CharacterBody2D:
	if entity[no] == null:
		var hero: CharacterBody2D = load(Def.ray if no == Def.RAY else Def.rock).instantiate()
		hero.name = &"ray" if no == Def.RAY else &"rock"
		hero.no = no
		add_child(hero)
		return hero
	return entity[no]

func load_hero(that: int) -> void:
	if entity[that] == null:
		entity[that] = new_hero(that)

func load_level() -> void:
	HUD.level = self
	if has_node(^"execute"):
		execute = get_node(^"execute")
		cluster.help_hint(Def.HELP, Def.HINT, cluster.hint)
		#cluster.resize_clusters()
	# HUD.state = Bit.to1(HUD.state, Def.TRANSIT)

func _ready() -> void:
	layer = 2
	load_level()
	load_hero(HUD.hero)
	entity[HUD.hero].position = group.position
	group.reparent(entity[HUD.hero])
	group.position = Vector2.ZERO


func load_game_logic() -> void:
	if interact != null: return
	interact = WorldInteraction.new()
	animation = CharacterAnimation.new()
	aura = AuraResource.new()
	inventory = HeroInventory.new()

func next() -> int: return (HUD.hero + 1) & Def.ROCK
#func _ready() -> void: layer = 2 # TODO
func _input(event: InputEvent) -> void:
	if HUD.level != null:
		world.input(event)

var session: PackedInt64Array = []
var selected: int

enum { SETTINGS, ACHIEVEMENTS = 2, SAVES = 3 }
enum { LEVEL, PRIORITY, ENEMY = 3, ACCESS = 7, NOTES = 9, SECRETS = 13, BOOKS = 21,
	AURA = 25, RESOURCE = 27, COMPLETED, POSITION, BOX, ITEMS = 31 }
# model : L1 (SCORE)P2 E4 A2 N4 S8 B4 A2 R2 
enum { DIFFICULTY, PART, DUNGEON, PROGRESSED }

func save_slot(no: int) -> void:
	var slot: int = SAVES
	for i in range(0, no):
		slot += RESOURCE
		pass
	pass

func select_slot(_no: int) -> void:
	var 
	session.
	pass

"""


var xp: RefCounted
var tree: SceneTree
var level: String:
	get: return Def.level % [location.name, group_level(), location.part]

var location: Dictionary = {
	"name": "cave/origin",
	"level": 0, "part": 0,
	"save": false
}
var progress: PackedInt32Array

func _init(t: SceneTree) -> void: tree = t

func assign(path: String) -> void:
	var i: int = path.find("-", 1)
	location.level = int(path.substr(0, i))
	location.part = int(path.substr(i + 1))
	location.save = true
	print("Session stats assign: ", location)

func _file(access: FileAccess.ModeFlags) -> FileAccess:
	return FileAccess.open(Def.progress, access)

func load_scene(scene: String) -> void:
	print_debug(tree.change_scene_to_file(scene))

func save_progress() -> void:
	if location.save:
		_file(FileAccess.WRITE).store_string(JSON.stringify(location))

func group_level(diff: int = 0) -> String:
	var _level: int = location.level + diff
	var path: String = "%d"
	if _level > 0: path = "+/%d"
	elif _level < 0: path = "-/%d"
	return path % abs(_level)

func _parseable(text: String) -> bool:
	var processor: JSON = JSON.new()
	var parsed: bool = processor.parse(text) == OK
	if parsed:
		location = processor.data
		location.save = false
		load_scene(level)
	return parsed

func load_progress() -> bool:
	var exist: bool = FileAccess.file_exists(Def.progress)
	return exist and _parseable(_file(FileAccess.READ).get_as_text())

func _ready() -> void:
	pass
	#var options: VBoxContainer = get_node("../hud/back/options")
	#options.continue.pressed.connect()
	#options.start.pressed.connect(game_start)

func game_exit() -> void: tree.quit()
func game_start() -> void: load_scene(Def.first_level)
func game_continue() -> void: if not load_progress(): load_scene(Def.first_level)




static func copy(from: String, to: String, force: bool = false) -> void:
	var dir: DirAccess = DirAccess.open("user://")
	print("COPY FROM? ", from)
	if force:
		print("FORCE DELETE: ", to, " = ", dir.remove(to))
	if not dir.file_exists(to):
		print("COPY! ", to, " = ", dir.copy(from, to))

static func _parse_json(path: String) -> Dictionary:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var text: String = file.get_as_text()
	var processor: JSON = JSON.new()
	return { "json": processor, "result": processor.parse(text) == OK }

static func get_json(path: String, feedback: Callable) -> Dictionary:
	if not FileAccess.file_exists(path): return {}

	var parsed: Dictionary = _parse_json(path)
	if not parsed.result: return {}
	
	feedback.call(true)
	return parsed.json.data

static func set_json(path: String, value: Dictionary) -> void:
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	var json: String = JSON.stringify(value)
	file.store_string(json)
"""




static func a(fields: PackedByteArray) -> int: return Bit.bytes_to_int(fields, Bit.MASK3)
func _press(name: StringName) -> bool: return Input.is_action_just_pressed(name)
func _hold(name: StringName) -> bool: return Input.is_action_pressed(name)
func _power(name: StringName) -> float: return Input.get_action_strength(name)
func act(no: int) -> bool: return combo & acts[no]

enum { LEFT, RIGHT, UP, DOWN, ACT1, ACT2, ACT3, ACT4, OPT_LEFT, OPT_RIGHT, OPT_UP,
	OPT_DOWN, FIRE, AIM, MENU }
enum { DOUBLE, LUNGE, DEAD_GRIP, LOW_KICK, BACKSTAB, FIRE_KICK,
	SPIT_KICK, BACK_SPIT, POACHING,
	GREEK_FIRE, STRAY_BULLET, AIR_FIGHT, AID, FIRE_DANCE, BREAKFLY, SHRAPNEL,
	WET_CLEANING, DEFIBRILLATOR, HORIZONTAL, ROUND_ATTACK, WASHING_OUT,
	TRANSFUSION, AIR_STRIKE, SHOCK, ELECTROCUT, THUNDER }
enum { A, B, X, Y, T }
var acts: PackedInt32Array = [a([A, A]), a([B, A, A]), a([A, Y, A]), a([A, B, A]),
	a([B, B, A]), a([B, X, B]), a([B, A, B]), a([B, A, A, B]), a([A, Y, A, Y])]
# var hero: int enum { RAY, ROCK } enum { TOOL, FIGHT, DANCE }
var combo: int

func act_enter() -> void: HUD.level.tile[Def.offset(HUD.hero, Def.LEVER)] = Def.ofmap(HUD.level.border.local_to_map(HUD.level.entity[HUD.hero].position))
func act_exit() -> void: HUD.level.tile[Def.offset(HUD.hero, Def.LEVER)] = 0

func input(_event: InputEvent) -> void: # return #TODO FIXME disable after HUD test
	if Bit.of(HUD.state, Def.OPEN_MENU) or Bit.of(HUD.state, Def.TRANSIT):
		menu_interaction()
	else:
		action_input()
	if _hold(&"menu1"): open_menu()

func action_input() -> void:
	HUD.interact.movement(_hold(&"act1"))
	if _press(&"act1"): punch()
	if _press(&"act2"): kick()
	if _press(&"act3"): skill_a()
	if _press(&"act4"): skill_b()
	if _hold(&"aim") and _press(&"fire"): use_item()
	if _press(&"select") and HUD.interact.state[HUD.hero] == 0:
		HUD.level.deploy.select()

func punch() -> void:
	combo = combo << Bit.MASK3 | A
	if act(DOUBLE):
		if act(LUNGE):
			pass
	elif act(DEAD_GRIP):
		pass
	elif act(LOW_KICK):
		pass
	elif act(BACKSTAB):
		pass
	# hands("Двоечка")
	# timer.start()

func kick() -> void:
	combo = combo << Bit.MASK3 | B
	if act(SPIT_KICK):
		pass
	elif act(BACK_SPIT):
		pass
	elif act(FIRE_KICK):
		pass
	if HUD.level.tile[HUD.hero] == Def.H_SPRING_OFF:
		HUD.level.chains.jump()

func skill_a() -> void:
	combo = combo << Bit.MASK3 | X
	match HUD.hero:
		Def.RAY: HUD.interact.melt_ice()
		Def.ROCK: HUD.interact.puddle_tile() # LevelRoot # TileDecorator

func skill_b() -> void:
	combo = combo << Bit.MASK3 | Y
	if act(POACHING):
		pass

func use_item() -> void:
	pass

func open_menu() -> void:
	pass

func menu_interaction() -> void:
	pass
