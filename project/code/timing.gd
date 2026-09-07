extends RefCounted

func a(fields: PackedByteArray) -> int: return Def.bytes_to_int(fields, Def.MASK3)

func _press(title: StringName) -> bool: return Input.is_action_just_pressed(title)
func _hold(title: StringName) -> bool: return Input.is_action_pressed(title)
func _out(title: StringName) -> bool: return Input.is_action_just_released(title)
func _power(title: StringName) -> float: return Input.get_action_strength(title)
func act(no: int) -> bool: return combo & acts[no]

enum { LEFT, RIGHT, UP, DOWN, ACT1, ACT2, ACT3, ACT4, OPT_LEFT, OPT_RIGHT, OPT_UP,
	OPT_DOWN, FIRE, AIM, MENU }
enum { DOUBLE, LUNGE, HUG, LOW_KICK, CRACK, GRILL_KICK, SLIPPERANG,
	SPIT_KICK, BACK_SPIT, POACHING, CURE, OK_SHOT, PIERCE, BLADE_RUN, TACKLE,
	GREEK_FIRE, STRAY_BULLET, AIR_FIGHT, AID, FIRE_DANCE, BREAKFLY, SHRAPNEL,
	WET_CLEANING, DEFIBRILLATOR, HORIZONTAL, ROUND_ATTACK, WASHING_OUT,
	TRANSFUSION, AIR_STRIKE, SHOCK, ELECTROCUT, THUNDER }
enum { A, B, X, Y, S, L = 8, T = 16, M = 24, R = 32, H = 40 }
var acts: PackedInt32Array = [A<<L|A, B<<L|A<<L|A, A<<T|Y<<L|A, A<<T|B<<L|A,
	B<<T|B<<L|A, B<<T|X<<L|B, B<<T|A<<L|B, B<<M|A<<T|A<<L|B, A<<M|Y<<T|A<<L|Y]
# var hero: int enum { RAY, ROCK } enum { TOOL, FIGHT, DANCE }
var combo: int
var caption: PackedStringArray = ["Двоечка"]
var combo_color: PackedStringArray = ["[color=#00AA00]2x[/color]", "[color=#FFAA00]3x[/color]", "[color=#FFAA00]4x[/color]"]
var logs_cache: PackedStringArray = ["", "", "", "", "", "", ""]
var log_line: int

enum { B_CRACK, B_BACKSPIT }
enum { P_CRACK = 6, C_CRACK = 3, P_BACKSPIT = 4 }

func book(no: int, pursuit: int = 0, control: int = 0) -> bool:
	return Def.of(HUD.check(HUD.BOOK), no) and (pursuit == 0 or HUD.get_stat(HUD.STATS + HUD.hero, HUD.PURSUIT) >= pursuit) and (
		control == 0 or HUD.get_stat(HUD.STATS + HUD.hero, HUD.CONTROL) >= control)

func act_enter() -> void: HUD.level.tile[Def.offset(HUD.hero, Def.LEVER)] = Def.join(HUD.level.border.local_to_map(HUD.level.entity[HUD.hero].position))
func act_exit() -> void: HUD.level.tile[Def.offset(HUD.hero, Def.LEVER)] = 0
func reset_combo() -> void: combo = 0

func add_logs(log_text: String) -> void:
	if HUD.game.logs.modulate == Color.TRANSPARENT:
		HUD.game.logs.text = ""
		log_line = 0
	elif log_line >= 50:
		HUD.game.logs.text = "\r\n".join(logs_cache)
		log_line = 0
	if log_line <= logs_cache.size():
		logs_cache[log_line] = log_text
	HUD.game.logs.append_text(log)
	log_line += 1

func add_log(text: String) -> void: HUD.game.log.text = text

func fight(combo_no: int, id: int, zone: int, element: int, portion: float, output: float) -> void:
	add_logs(combo_color[combo - 2] + caption[id])
	HUD.adversary.damage_zone(zone, HUD.hero, element, combo_no, portion, output)

func menu_interaction() -> void:
	pass

func update_ui():
	pass

func open_menu_panel() -> void:
	stated = !stated
	HUD.game.right.split_offset = RIGHT_OFF
	HUD.game.left.split_offset = LEFT_OFF
	HUD.game.top.split_offset = FORWARD_OFF
	HUD.game.bottom.split_offset = BACKWARD_OFF
	if stated:
		if read_mode:
			HUD.game.get(menu_navigation[(menu_select << 1)]).split_offset = menu_shift[menu_select] >> 1
		else:
			HUD.game.get(menu_navigation[(menu_select << 1)]).split_offset = menu_shift[menu_select]
			HUD.game.get(menu_navigation[(menu_select << 1) + 1]).grab_focus()
	else:
		HUD.game.no_focus.grab_focus()

const menu_navigation: Array[StringName] = [
	&"right_focus", &"right", &"left_focus", &"left",
	&"top_focus", &"top", &"bottom_focus", &"bottom"]
const menu_shift: PackedInt32Array = [RIGHT_ON, LEFT_ON, FORWARD_ON, BACKWARD_ON]

enum { PANEL_RIGHT = 0, PANEL_LEFT, PANEL_FORWARD, PANEL_BACKWARD,
	LEFT_OFF = -2000, LEFT_ON = 0, RIGHT_OFF = 1000, RIGHT_ON = -1000,
	FORWARD_OFF = -1000, FORWARD_ON = 1000, BACKWARD_OFF = 1000, BACKWARD_ON = -1000 }
var menu_select: int = 0
var stated: bool = false
var read_mode: bool = false

func input(_event: InputEvent) -> void: # return #TODO FIXME disable after HUD test
	if HUD.level == null:
		menu_interaction()
		return
	
	HUD.interact.movement(_hold(&"act1"))
	if _hold(&"group"):
		read_mode = false
		if _hold(&"left"):
			menu_select = PANEL_LEFT
			read_mode = _hold(&"forward") or _hold(&"backward")
		elif _hold(&"right"):
			menu_select = PANEL_RIGHT
			read_mode = _hold(&"forward") or _hold(&"backward")
		elif _press(&"forward"): menu_select = PANEL_FORWARD
		elif _press(&"backward"): menu_select = PANEL_BACKWARD
	elif _out(&"group"): open_menu_panel()
	if _press(&"act1"): punch()
	elif _press(&"act2"): kick()
	elif _press(&"act3"): skill_a()
	elif _press(&"act4"): skill_b()
	elif _hold(&"aim") and _press(&"fire"): use_item()
	if _press(&"select") and HUD.interact.state[HUD.hero] == 0:
		HUD.level.deploy.select()

func main_slot(weapon_type: int) -> bool:
	var i: int = Def.of_x(Def.BYTE, HUD.get_item(HUD.hero, HUD.inventory.fast_panel[HUD.hero]), HeroInventory.ID) - HeroInventory.WEAPON
	return 0 < i and HUD.inventory.type[i] == weapon_type

func fast_slot(weapon_type: int) -> bool:
	var i: int = Def.of_x(Def.BYTE, HUD.get_item(HUD.hero, HeroInventory.WEAPON_SLOT), HeroInventory.ID) - HeroInventory.WEAPON
	return 0 < i and HUD.inventory.type[i] == weapon_type

func empty_hand_punch() -> void:
	if act(DOUBLE):
		if act(LUNGE) and book(LUNGE, P_BACKSPIT, BACK_SPIT):
			fight(3, LUNGE, Adversary.TARGET, Adversary.NORMAL, 1.35, 2.0)
		else:
			fight(2, DOUBLE, Adversary.TARGET, Adversary.NORMAL, 1.15, -0.2)
	else:
		HUD.adversary.damage_zone(HUD.hero, Adversary.TARGET, Adversary.NORMAL, 1, 1.0, -0.1)

func empty_hand_kick() -> void:
	if act(LOW_KICK):
		fight(2, LOW_KICK, Adversary.TARGET, Adversary.NORMAL, 1.25, 0.5)
	elif act(SPIT_KICK) and book(B_BACKSPIT, P_BACKSPIT, BACK_SPIT):
		pass
	else:
		HUD.adversary.damage_zone(HUD.hero, Adversary.TARGET, Adversary.NORMAL, 1, 1.0, 0.1)

func punch(_pallete: bool = false) -> void:
	combo = combo << Def.MASK3 | A
	match HUD.hero:
		Def.RAY:
			empty_hand_punch()
		Def.ROCK:
			if act(PIERCE):
				pass
			elif act(BLADE_RUN):
				pass
			else:
				empty_hand_punch()
	HUD.combo_timer.start()

func kick() -> void:
	combo = combo << Def.MASK3 | B
	match HUD.hero:
		Def.RAY:
			empty_hand_kick()
		Def.ROCK:
			if act(TACKLE):
				pass
			else:
				empty_hand_kick()
	HUD.combo_timer.start()
	if HUD.level.tile[HUD.hero] == Def.H_SPRING_OFF:
		HUD.level.chains.jump()

func skill_a() -> void:
	combo = combo << Def.MASK3 | X
	if act(GRILL_KICK):
		pass
	elif act(CRACK) and book(B_CRACK, P_CRACK, C_CRACK):
		fight(3, CRACK, Adversary.TARGET, Adversary.NORMAL, 1.2, 0.5)

	match HUD.hero:
		Def.RAY: HUD.interact.melt_ice()
		Def.ROCK: HUD.interact.puddle_tile() # LevelRoot # TileDecorator

func skill_b() -> void:
	combo = combo << Def.MASK3 | Y
	if act(POACHING):
		pass
	elif act(HUG):
		fight(4, HUG, Adversary.TARGET, Adversary.NORMAL, 1.4, -0.5)

func use_item() -> void:
	var throw: bool = HUD.inventory.produce_item(HUD.hero, HUD.inventory.fast_panel[HUD.hero])  == HeroInventory.WEAPON_THROW
	match HUD.hero:
		Def.ROCK:
			if act(SLIPPERANG) and throw and main_slot(HeroInventory.BOOMERANG):
				pass
			else:
				pass
		Def.RAY:
			if act(OK_SHOT):
				pass
			elif act(AID) and fast_slot(HeroInventory.GUN):
				pass
