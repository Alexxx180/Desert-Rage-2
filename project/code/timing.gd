extends RefCounted

func a(fields: PackedByteArray) -> int: return Def.bytes_to_int(fields, Def.MASK3)

func _press(title: StringName) -> bool: return Input.is_action_just_pressed(title)
func _hold(title: StringName) -> bool: return Input.is_action_pressed(title)
func _power(title: StringName) -> float: return Input.get_action_strength(title)
func act(no: int) -> bool: return combo & acts[no]

enum { LEFT, RIGHT, UP, DOWN, ACT1, ACT2, ACT3, ACT4, OPT_LEFT, OPT_RIGHT, OPT_UP,
	OPT_DOWN, FIRE, AIM, MENU }
enum { DOUBLE, LUNGE, DEAD_GRIP, LOW_KICK, CRACK, FIRE_KICK,
	SPIT_KICK, BACK_SPIT, POACHING,
	GREEK_FIRE, STRAY_BULLET, AIR_FIGHT, AID, FIRE_DANCE, BREAKFLY, SHRAPNEL,
	WET_CLEANING, DEFIBRILLATOR, HORIZONTAL, ROUND_ATTACK, WASHING_OUT,
	TRANSFUSION, AIR_STRIKE, SHOCK, ELECTROCUT, THUNDER }
enum { A, B, X, Y, S, L = 8, T = 16, M = 24, R = 32, H = 40 }
var acts: PackedInt32Array = [A<<L|A, B<<L|A<<L|A, A<<T|Y<<L|A, A<<T|B<<L|A,
	B<<T|B<<L|A, B<<T|X<<L|B, B<<T|A<<L|B, B<<M|A<<T|A<<L|B, A<<M|Y<<T|A<<L|Y]
# var hero: int enum { RAY, ROCK } enum { TOOL, FIGHT, DANCE }
var combo: int
var caption: PackedStringArray = ["Двоечка"]
var combo_color: PackedStringArray = ["[color=#00AA00]2x[/color]", "[color=#FFAA00]3x[/color]"]
var logs_cache: PackedStringArray = ["", "", "", "", "", "", ""]
var log_line: int

enum { B_CRACK, B_BACKSPIT }
enum { P_CRACK = 6, C_CRACK = 3, P_BACKSPIT = 4 }

func book(no: int) -> bool: return HUD.check(HUD.BOOK, no)
func control(stat: int) -> bool: return HUD.get_stat(HUD.STATS + HUD.hero, HUD.CONTROL) >= stat
func pursuit(stat: int) -> bool: return HUD.get_stat(HUD.STATS + HUD.hero, HUD.PURSUIT) >= stat

func act_enter() -> void: HUD.level.tile[Def.offset(HUD.hero, Def.LEVER)] = Def.ofmap(HUD.level.border.local_to_map(HUD.level.entity[HUD.hero].position))
func act_exit() -> void: HUD.level.tile[Def.offset(HUD.hero, Def.LEVER)] = 0
func reset_combo() -> void: combo = 0

func add_logs(log: String) -> void:
	if HUD.game.logs.modulate == Color.TRANSPARENT:
		HUD.game.logs.text = ""
		log_line = 0
	elif log_line >= 50:
		HUD.game.logs.text = "\r\n".join(logs_cache)
		log_line = 0
	if log_line <= logs_cache.size():
		logs_cache[log_line] = log
	HUD.game.logs.append_text(log)
	log_line += 1

func add_log(text: String) -> void: HUD.game.log.text = text

func fight(combo: int, id: int, zone: int, element: int, portion: float) -> void:
	add_logs(combo_color[combo - 2] + caption[id])
	HUD.adversary.damage_zone(HUD.hero, zone, element, portion, combo)

func input(_event: InputEvent) -> void: # return #TODO FIXME disable after HUD test
	if (HUD.level == null) or Def.of(HUD.state, Def.OPEN_MENU) or Def.of(HUD.state, Def.TRANSIT):
		menu_interaction()
	else:
		action_input()
	if _hold(&"menu1"): open_menu()

func action_input() -> void:
	interact.movement(_hold(&"act1"))
	if _press(&"act1"): punch()
	elif _press(&"act2"): kick()
	elif _press(&"act3"): skill_a()
	elif _press(&"act4"): skill_b()
	elif _hold(&"aim") and _press(&"fire"): use_item()
	if _press(&"select") and HUD.interact.state[HUD.hero] == 0:
		HUD.level.deploy.select()

func punch(pallete: bool = false) -> void:
	combo = combo << Def.MASK3 | A
	# Adversary.ZONE_RADIUS
	if act(DOUBLE):
		if act(LUNGE):
			fight(3, LUNGE, Adversary.TARGET, Adversary.NORMAL, 1.35)
			HUD.game.logs.append_text("[color=#FFAA00]3x[/color] Двоечка")
			var xp: int = HUD.adversary.damage_zone(HUD.hero, Adversary.TARGET, Adversary.NORMAL, portion)
			HUD.adversary.score_up(xp * 3)
			if ui
			pass
	elif act(DEAD_GRIP):
		pass
	elif act(LOW_KICK):
		pass
	elif book(B_CRACK) and pursuit(P_CRACK) and control(C_CRACK) and act(CRACK):
		pass
	# hands("Двоечка")
	# timer.start()

func kick() -> void:
	combo = combo << Def.MASK3 | B
	if act(SPIT_KICK):
		pass
	elif book(B_BACKSPIT) and pursuit(P_BACKSPIT) and act(BACK_SPIT):
		pass
	elif act(FIRE_KICK):
		pass
	if HUD.level.tile[HUD.hero] == Def.H_SPRING_OFF:
		HUD.level.chains.jump()

func skill_a() -> void:
	combo = combo << Def.MASK3 | X
	#if act():
	#	pass

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

func update_ui():
	pass
