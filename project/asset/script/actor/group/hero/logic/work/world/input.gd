class_name WorldInput extends RefCounted

static func a(fields: PackedByteArray) -> int:
	var value: int = 0 ; for i in range(0, len(fields)): value |= fields[i] << (i * Bit.MASK3)
	return value
func _press(name: StringName) -> bool: return Input.is_action_just_pressed(name)
func _hold(name: StringName) -> bool: return Input.is_action_pressed(name)
func _power(name: StringName) -> float: return Input.get_action_strength(name)
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
var combo: int

const close: Vector2 = Vector2(24, 20)

func act_enter() -> void: HUD.level.set_tile(HUD.hero, Def.LEVER)
func act_exit() -> void: HUD.level.no_tile(HUD.hero, Def.LEVER)

func input(_event: InputEvent) -> void:
	# return #TODO FIXME disable after HUD test
	if Bit.of(HUD.state, Def.OPEN_MENU) or Bit.of(HUD.state, Def.TRANSIT):
		menu_interaction()
	else:
		action_input()
	if _hold(&"menu1"): open_menu()

func _movement() -> void:
	var direction: Vector2 = Input.get_vector(&"left", &"right", &"forward", &"backward")
	HUD.level.entity[HUD.hero].make_velocity(direction * Def.MOVE)
	HUD.animation.direct(direction)
	if direction != Vector2.ZERO:
		HUD.level.entity[HUD.hero].lever.position = close * direction

func action_input() -> void:
	_movement()
	if _press(&"act1"): punch()
	if _press(&"act2"): kick()
	if _press(&"act3"): skill_a()
	if _press(&"act4"): skill_b()
	if _hold(&"aim") and _press(&"fire"): use_item()

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

func melt_ice() -> void:
	var pos: Vector2 = HUD.level.tile_lever()
	var tile: PackedInt32Array = HUD.level.on_tile(pos)
	if tile[Def.ID] == Def.FLOOR and tile[Def.TYPE] == Def.ICE_FLOOR:
		HUD.level.border.type(Def.FLOORS).paint_alt()
		if HUD.level.fire == null:
			HUD.level.fire = load(Def.fire).instantiate()
			HUD.level.fire.one_shot = true
			HUD.level.add_child(HUD.level.fire)
		else:
			HUD.level.fire.restart()
		HUD.level.fire.position = pos

func skill_a() -> void:
	combo = combo << Bit.MASK3 | X
	match HUD.hero:
		Def.RAY: melt_ice()
	LevelRoot
	TileDecorator

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
