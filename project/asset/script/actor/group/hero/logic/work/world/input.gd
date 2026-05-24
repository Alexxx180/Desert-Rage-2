class_name WorldInput extends RefCounted

static func b(fields: PackedByteArray) -> int: return Bit.take8(fields)
func _moves() -> Vector2: return Input.get_vector(action[LEFT], action[RIGHT], action[UP], action[DOWN])
func _press(no: int) -> bool: return Input.is_action_just_pressed(action[no])
func _hold(no: int) -> bool: return Input.is_action_pressed(action[no])
func _power(no: int) -> float: return Input.get_action_strength(action[no])
func act(no: int) -> bool: return Bit.from(combo, acts[no])

enum { LEFT, RIGHT, UP, DOWN, ACT1, ACT2, ACT3, ACT4, OPT_LEFT, OPT_RIGHT, OPT_UP,
	OPT_DOWN, FIRE, AIM, MENU }
enum { A, B, X, Y, T }
enum { DOUBLE, LUNGE, DEAD_GRIP, LOW_KICK, BACKSTAB, FIRE_KICK,
	SPIT_KICK, BACK_SPIT, POACHING,
	GREEK_FIRE, STRAY_BULLET, AIR_FIGHT, AID, FIRE_DANCE, BREAKFLY, SHRAPNEL,
	WET_CLEANING, DEFIBRILLATOR, HORIZONTAL, ROUND_ATTACK, WASHING_OUT,
	TRANSFUSION, AIR_STRIKE, SHOCK, ELECTROCUT, THUNDER }
var acts: PackedInt32Array = [b([A, A]), b([B, A, A]), b([A, Y, A]), b([A, B, A]),
	b([B, B, A]), b([B, X, B]), b([B, A, B]), b([B, A, A, B]), b([A, Y, A, Y])]
# var hero: int enum { RAY, ROCK } enum { TOOL, FIGHT, DANCE }
var action: PackedStringArray = ["left", "right", "up", "down", "action", "run",
	"skill_one", "skill_two", "fire", "targeting", "menu", "alt_left",
	"alt_right", "alt_up", "alt_down"]
var combo: int

func input(_event: InputEvent) -> void:
	if Bit.of(HUD.state, HUD.OPEN_MENU) or Bit.of(HUD.state, HUD.TRANSITION):
		menu_interaction()
	else:
		action_input()
	if _hold(MENU): open_menu()

func action_input() -> void:
	if _press(ACT1): punch()
	if _press(ACT2): kick()
	if _press(ACT3): skill_a()
	if _press(ACT4): skill_b()
	if _hold(AIM) and _press(FIRE): use_item()

func punch() -> void:
	combo = Bit.add(combo, A)
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
	timer.start()

func kick() -> void:
	combo = Bit.add(combo, B)
	if act(SPIT_KICK):
		pass
	if act(BACK_SPIT):
		pass
	if act(FIRE_KICK):
		pass

func skill_a() -> void:
	combo = Bit.add(combo, X)

func skill_b() -> void:
	combo = Bit.add(combo, Y)
	if act(POACHING):
		pass

func use_item() -> void:
	pass

func open_menu() -> void:
	pass

func menu_interaction() -> void:
	pass
