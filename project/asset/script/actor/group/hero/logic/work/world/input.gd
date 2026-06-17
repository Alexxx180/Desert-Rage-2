class_name WorldInput extends RefCounted

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

func act_enter() -> void: HUD.level.set_tile(HUD.hero, Def.LEVER)
func act_exit() -> void: HUD.level.no_tile(HUD.hero, Def.LEVER)

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
	if _press(&"select"): HUD.level.deploy.select()

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
