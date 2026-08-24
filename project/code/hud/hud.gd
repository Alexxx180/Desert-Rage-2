class_name WorldInput extends CanvasLayer

enum { LEVEL, LOGIC, BOX = 2, POS = 4, AURA = 6, RESOURCE = 7, STATUS = 8,
	INVENTORY = 10, BESTIARY = 38, NOTES = 39, BOOKS = 40, CHESTS = 41, SECRETS = 42 }
enum { SETTINGS, SAVES, ACHIEVEMENTS, DIFFICULTY = 0, PART, DUNGEON, PROGRESSED, BAG = 7 }

var session: PackedInt64Array

var level: LevelRoot
var adversary: Adversary
var animation: CharacterAnimation
var interact: WorldInteraction
var _inventory: HeroInventory
var menu: Menu = Menu.new()

var fire: GPUParticles2D; var rain: GPUParticles2D

func check(type: int) -> int: return session[type]
func unlock(type: int, slot: int) -> int:
	session[type] = Def.to1(session[type], slot)

func get_stat(type: int, slot: int) -> int:

	return Def.of_x(Def.SHORT, session[type], slot)
func set_stat(type: int, slot: int, value: int) -> void:
	session[type] = Def.to_x(Def.SHORT, session[type], slot, value)

func get_item(bag: int, slot: int) -> int:
	return Def.of_x(Def.SHORT, session[INVENTORY + BAG * bag + (slot >> Def.MASK)], slot & Def.MASK3)

func set_item(bag: int, slot: int, item: int) -> void:
	var no: int = INVENTORY + BAG * bag + (slot >> Def.MASK)
	session[no] = Def.to_x(Def.SHORT, session[no], slot & Def.MASK3, item)

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
	aura = Adversary.new()
	inventory = HeroInventory.new()

func next_hero() -> int: return (HUD.hero + 1) & Def.ROCK

var session: PackedInt64Array = []
 # model : L1 (SCORE)P2 E4 A2 N4 S8 B4 A2 R2 

func _init() -> void: session = FileAccess.get_file_as_bytes(Def.saves).to_int64_array()

var xp: RefCounted
@onready var tree: SceneTree = get_tree()

func load_scene(no: int) -> void:
	var scene: String
	&"dungeon/cave/dark"
	Def.level % [location.name, group_level(), location.part]
	&"res://def/dungeon/%s/%s/%d.tscn"
	var _level: int = level + diff
	
	var path: String = "%d"
	if _level > 0: path = "+/%d"
	elif _level < 0: path = "-/%d"
	path % abs(_level)
	
	print_debug(tree.change_scene_to_file(scene))

#var options: VBoxContainer = get_node("../hud/back/options")
#options.continue.pressed.connect()
#options.start.pressed.connect(game_start)

func game_exit() -> void: tree.quit()
func game_start() -> void: load_scene(Def.first_level)
func game_continue() -> void: if not load_progress(): load_scene(Def.first_level)

func a(fields: PackedByteArray) -> int: return Def.bytes_to_int(fields, Def.MASK3)

func _press(title: StringName) -> bool: return Input.is_action_just_pressed(title)
func _hold(title: StringName) -> bool: return Input.is_action_pressed(title)
func _power(title: StringName) -> float: return Input.get_action_strength(title)
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
	if (HUD.level == null) or Def.of(HUD.state, Def.OPEN_MENU) or Def.of(HUD.state, Def.TRANSIT):
		menu_interaction()
	else:
		action_input()
	if _hold(&"menu1"): open_menu()

func action_input() -> void:
	interact.movement(_hold(&"act1"))
	if _press(&"act1"): punch()
	if _press(&"act2"): kick()
	if _press(&"act3"): skill_a()
	if _press(&"act4"): skill_b()
	if _hold(&"aim") and _press(&"fire"): use_item()
	if _press(&"select") and HUD.interact.state[HUD.hero] == 0:
		HUD.level.deploy.select()

func punch() -> void:
	combo = combo << Def.MASK3 | A
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
	combo = combo << Def.MASK3 | B
	if act(SPIT_KICK):
		pass
	elif act(BACK_SPIT):
		pass
	elif act(FIRE_KICK):
		pass
	if HUD.level.tile[HUD.hero] == Def.H_SPRING_OFF:
		HUD.level.chains.jump()

func skill_a() -> void:
	combo = combo << Def.MASK3 | X
	match HUD.hero:
		Def.RAY: HUD.interact.melt_ice()
		Def.ROCK: HUD.interact.puddle_tile() # LevelRoot # TileDecorator

func skill_b() -> void:
	combo = combo << Def.MASK3 | Y
	if act(POACHING):
		pass

func use_item() -> void:
	pass

func open_menu() -> void:
	pass

func menu_interaction() -> void:
	pass
