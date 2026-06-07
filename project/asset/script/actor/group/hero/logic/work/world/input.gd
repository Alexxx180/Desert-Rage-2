class_name WorldInput extends RefCounted

static func a(fields: PackedByteArray) -> int:
	var value: int = 0 ; for i in range(0, len(fields)): value |= fields[i] << (i * Bit.MASK3)
	return value
func _moves() -> Vector2: return Input.get_vector(action[LEFT], action[RIGHT], action[UP], action[DOWN])
func _press(no: int) -> bool: return Input.is_action_just_pressed(action[no])
func _hold(no: int) -> bool: return Input.is_action_pressed(action[no])
func _power(no: int) -> float: return Input.get_action_strength(action[no])
func act(no: int) -> bool: return combo & acts[no]

enum { A, B, X, Y, T }
enum { LEFT, RIGHT, UP, DOWN, ACT1, ACT2, ACT3, ACT4, OPT_LEFT, OPT_RIGHT, OPT_UP,
	OPT_DOWN, FIRE, AIM, MENU }
enum { DOUBLE, LUNGE, DEAD_GRIP, LOW_KICK, BACKSTAB, FIRE_KICK,
	SPIT_KICK, BACK_SPIT, POACHING,
	GREEK_FIRE, STRAY_BULLET, AIR_FIGHT, AID, FIRE_DANCE, BREAKFLY, SHRAPNEL,
	WET_CLEANING, DEFIBRILLATOR, HORIZONTAL, ROUND_ATTACK, WASHING_OUT,
	TRANSFUSION, AIR_STRIKE, SHOCK, ELECTROCUT, THUNDER }

var acts: PackedInt32Array = [a([A, A]), a([B, A, A]), a([A, Y, A]), a([A, B, A]),
	a([B, B, A]), a([B, X, B]), a([B, A, B]), a([B, A, A, B]), a([A, Y, A, Y])]
# var hero: int enum { RAY, ROCK } enum { TOOL, FIGHT, DANCE }
var action: PackedStringArray = ["left", "right", "up", "down", "action", "run",
	"skill_one", "skill_two", "fire", "targeting", "menu", "alt_left",
	"alt_right", "alt_up", "alt_down"]
var combo: int

func act_enter() -> void: HUD.level.set_tile(HUD.hero, Def.LEVER)
func act_exit() -> void: HUD.level.no_tile(HUD.hero, Def.LEVER)

func tile_enter() -> void:
	HUD.level.set_tile(Def.PLATE)
	HUD.level.cluster.tile_walk(HUD.level.entity[HUD.hero], true)

func tile_exit() -> void:
	HUD.level.cluster.tile_walk(HUD.level.entity[HUD.hero], false)
	HUD.level.no_tile(Def.PLATE)

func input(_event: InputEvent) -> void:
	if Bit.of(HUD.state, HUD.OPEN_MENU) or Bit.of(HUD.state, HUD.TRANSITION):
		menu_interaction()
	else:
		action_input()
	if _hold(MENU): open_menu()

func action_input() -> void:
	movement()
	if _press(ACT1): punch()
	if _press(ACT2): kick()
	if _press(ACT3): skill_a()
	if _press(ACT4): skill_b()
	if _hold(AIM) and _press(FIRE): use_item()

func movement() -> void:
	var moves: Vector2 = Input.get_vector(action[LEFT], action[RIGHT], action[UP], action[DOWN])
	# if HUD.level 
	HUD.level.entity[HUD.hero].velocity = moves

func punch() -> void:
	combo = combo << Bit.MASK3 | A
	if act(DOUBLE):
		if act(LUNGE):
			pass
	if act(DEAD_GRIP):
		pass
	if act(LOW_KICK):
		pass
	if act(BACKSTAB):
		pass
	# hands("Двоечка")
	# timer.start()

func kick() -> void:
	combo = combo << Bit.MASK3 | B
	if act(SPIT_KICK):
		pass
	if act(BACK_SPIT):
		pass
	if act(FIRE_KICK):
		pass
	if HUD.level.tile[HUD.hero] == Def.H_SPRING_OFF:
		HUD.level.chains.jump()

func skill_a() -> void:
	combo = combo << Bit.MASK3 | X

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
