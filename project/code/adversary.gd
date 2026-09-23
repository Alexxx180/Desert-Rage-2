class_name Adversary extends RefCounted

enum { BLUE, NO = 0, AURA = 0, LIFE_BORDER = 0, WAVE = 0, THICK = 0, GREEN, COLOR = 1, AP = 1, RESOURCE_SHIFT = 1,
	PERIOD = 1, DURATION = 1, YELLOW, BAR_TYPE = 2, TRANSPORT = 2, SUMMARY = 2, RESOURCE = 2, THICKNESS = 5, RED = 3,
	RESOURCE_VALUE = 3, LAST_THICKNESS = 3, CRITICAL = 4, BARS = 4, MAX = 10, SEMI = 100, SET = 255 }

var aura_stat: PackedFloat32Array = [0.7, 0.1, 2.0, 5.0, 0.1]
var status_time: PackedByteArray = []; var status_type: PackedByteArray = []
var entities: int = 0
var i_points: PackedByteArray = _number12()
var a_portion: PackedFloat32Array = _number14(); var r_portion: PackedFloat32Array = _number14()
var a_points: PackedInt32Array = _number12(); var r_points: PackedByteArray = _number12()
var target_a: PackedInt32Array = _number14(); var target_r: PackedByteArray = _number14()

var a_max: PackedByteArray = [0, 0]
var r_max: PackedByteArray = [0, 0]
var h_pow: PackedByteArray = [1, 2]
var h_shl: PackedByteArray = [0, 1]
var h_imp: PackedByteArray = [2, 1]
var h_rct: PackedByteArray = [2, 1]
var last_color: Color

enum { RAY, ROCK, EYE_SEEKER }
enum STAT { POWER = 0, INFLUENCE = 1, VITALITY = 2, REACTION = 3, HP = 4, AP = 5, MAX = 6 }
enum PRIORITIES { PURSUIT, SELF_CONTROL, TENACITY }
enum { BURN, POISON, COUGH }

const color: PackedFloat32Array = [1.0, 0.8, 0.4, 0.0]
const PRIORITY: PackedByteArray = [3, 2, 1, 1,  1, 3, 1, 2,  1, 1, 3, 2]
const aura: PackedInt32Array = [100, 100,  0] # ray, p: 5, 5  rock, p: 7, 3
const resc: PackedInt32Array = [ 20,  20, 50]
const shell: PackedByteArray = [  0,   1,  5]
const power: PackedByteArray = [  1,   2,  5]
const impac: PackedByteArray = [  2,   1,  5]
const react: PackedByteArray = [  2,   1,  5]
const exper: PackedByteArray = [  0,   0,  1]
const weakn: PackedByteArray = [NORMAL, NORMAL, NORMAL]
const immun: PackedByteArray = [NORMAL, NORMAL, NORMAL]

var in_game: PackedStringArray = ["Гляделкинс"]
var s_power: PackedByteArray = [5, 6]
var status_tick: bool = false

# func setup() -> void: HUD.aura_time.timeout.connect(diffusion) # burns - blink
## ENEMY
func _number14() -> Array[int]: return [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
func _number12() -> Array[int]: return [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

func status_feedback(limit: int, enemy: int, time: int, status: int) -> int:
	for j in range(0, limit):
		var t: int = Def.of_x(Def.MASK3, time, j)
		if t != 0:
			match Def.of_x(Def.MASK3, status, j):
				BURN: affect(enemy, -min(1, aura[enemy] >> s_power[BURN]), 0)
				POISON: affect(enemy, -min(1, aura[enemy] >> s_power[POISON]), 0)
			if status_tick:
				t -= 1
				time = Def.to_x(Def.MASK3, time, j, t)
	return time

func status_timeout() -> void:
	var off: bool = true
	status_tick = !status_tick
	for i in range(0, Def.PARTY):
		var time: int = HUD.get_half(HUD.STATUS_TIME, i)
		if time != 0:
			off = false
			HUD.set_half(HUD.STATUS_TIME, status_feedback(4, i, time, HUD.get_half(HUD.STATUS, i)))
	for i in range(0, len(status_time)):
		if status_time[i] != 0: # Def.of_x(Def.MASK4, , )
			off = false
			status_time[i] = status_feedback(2, i + Def.PARTY, status_time[i], status_type[i])
	if off: HUD.aura_timer.stop()

var aura_colors: PackedFloat32Array = [1.0 / (BLUE - GREEN), 1.0 / (GREEN - YELLOW), 1.0 / (YELLOW - RED)]

func color_reaction(segment: float) -> Color:
	if segment <= color[RED]: return Color.from_rgba8(SET, NO, NO, SEMI)
	elif segment >= color[BLUE]: return Color.from_rgba8(NO, SET, SET, SEMI)
	elif BLUE > segment and segment >= GREEN:
		return Color.from_rgba8(NO, SET, int(SET * aura_colors[0] * (segment - GREEN)), SEMI)
	elif GREEN > segment and segment >= YELLOW:
		return Color.from_rgba8(int((1.0 - aura_colors[1] * (segment - YELLOW)) * SET), SET, NO, SEMI)
	return Color.from_rgba8(SET, int(SET * aura_colors[2] * (segment - RED)), NO, SEMI)

func _get_ui() -> Array[Control]: return [HUD.game.inventory.points, HUD.game.priorities.points]

func affect(hero: int, a: int, r: int) -> void:
	if !tweens[hero] or !tweens[hero].is_valid():
		tweens[hero] = HUD.create_tween()
		tweens[hero].tween_method(func(value: float):
			var segment: float = a_portion[hero]
			var h: int = hero
			var stat: int
			if hero < Def.PARTY:
				stat = HUD.get_stat(HUD.AURA, hero)
			else:
				h -= Def.PARTY
				stat = a_points[h]
			if target_a[hero] < stat:
				segment = (target_a[hero] + value * (stat - target_a[hero])) * segment
			else:
				segment = (target_a[hero] - value * (target_a[hero] - stat)) * segment
			entity[hero].profile.material.set(&"shader_parameter/line_color", color_reaction(segment))
			entity[hero].profile.material.set(&"shader_parameter/line_thickness", 7 - segment * THICKNESS)

			if hero < Def.PARTY:
				stat = HUD.get_stat(HUD.RESOURCE, hero)
			else:
				stat = r_points[h]
			
			segment = r_portion[hero]
			if target_r[hero] < stat:
				segment = (target_r[hero] + value * (stat - target_r[hero])) * segment
			else:
				segment = (target_r[hero] + value * (stat - target_r[hero])) * segment
			entity[hero].profile.material.set(&"shader_parameter/ap", segment)

			if hero >= Def.PARTY and i_points[hero] > 0:
				i_points[hero] -= 5
				HUD.game.ability.health.value = i_points[h],
		0, 1.0, 3).tween_callback(func():
			entity[hero].profile.material.set(&"shader_parameter/line_color", Color.TRANSPARENT)
			entity[hero].profile.material.set(&"shader_parameter/action", false)
			if hero < Def.PARTY:
				if HUD.get_stat(HUD.AURA, Def.RAY) == 0 and HUD.get_stat(HUD.AURA, Def.ROCK) == 0:
					HUD.level.group.spectrum()
				else:
					HUD.level.entity[hero].animation.play_coma()
			elif a_points[hero] == 0 and i_points[hero] == 0:
				entity[hero].process_mode = Node.PROCESS_MODE_DISABLED
				entity[hero].animation.transport()
				var shift: int = -1 if randi_range(0, 1) == 0 else 1
				entity[hero].spawn_pos = posmod(entity[hero].spawn_pos + shift, len(places))
				entity[hero].position = HUD.level.spawn[entity[hero].state[2]]
		)
	if a != 0:
		if hero < Def.PARTY:
			var stat: int = clampi(HUD.get_stat(HUD.AURA, hero) + a, 0, a_max[hero])
			HUD.set_stat(HUD.AURA, hero, stat)
			for ui in _get_ui(): ui.aura.value = stat
		else:
			var h: int = hero - Def.PARTY
			a_points[h] = clampi(a_points[h] + a, 0, aura[h])
			if a <= 0:
				i_points[h] = 255
				HUD.game.ability.health.modulate = Color.WHITE
				HUD.game.ability.health.max_value = i_points[h]
				HUD.game.ability.health.value = i_points[h]
			else:
				HUD.game.ability.health.modulate = Color.GRAY
				HUD.game.ability.health.max_value = aura[h]
				HUD.game.ability.health.value = a_points[h]
	if r != 0:
		if hero < Def.PARTY:
			var stat: int = clampi(HUD.get_stat(HUD.RESOURCE, hero) + r, 0, r_max[hero])
			HUD.set_stat(HUD.RESOURCE, hero, stat)
			for ui in _get_ui(): ui.resource.value = stat
		else:
			r_points[hero] = clampi(r_points[hero] + r, 0, resc[hero])
		entity[hero].profile.material.set(&"shader_parameter/action", true)

enum { TARGET, ZONE_RADIUS, TARGET_RADIUS, ZONE_ALL,
	HALF_TILE = 32, TILE = 64, DISTANCE = 1024, RADIUS_DISTANCE = 4096 }
enum { VOID, LIGHT, NORMAL, FIRE, WATER, SPARK }

var directed: PackedVector2Array = []

func damage_zone(type: int, hero: int, element: int, combo: int, portion: float, output: float = 0) -> void:
	match type:
		ZONE_ALL:
			var start: int = Def.PARTY if hero < Def.PARTY else 0
			var xp: int = 0
			for i in range(start, entities):
				if hero != i:
					damage(hero, i, element, portion)
					xp += exper[i]
			if start == Def.PARTY and xp != 0:
				score_up(xp * combo)
		TARGET:
			damage_output(HALF_TILE * directed[hero], DISTANCE, hero, element, combo, portion, output)
		TARGET_RADIUS:
			damage_output(TILE * directed[hero], RADIUS_DISTANCE, hero, element, combo, portion, output)
		ZONE_RADIUS:
			damage_output(Vector2.ZERO, RADIUS_DISTANCE, hero, element, combo, portion, output)
	
func damage_output(direction: Vector2, distance: int, hero: int, element: int, combo: int, portion: float, output: float) -> void:
	var start: int = Def.PARTY if hero < Def.PARTY else 0
	var xp: int = 0
	for i in range(start, entities):
		if hero != i and (entity[hero].position + direction).distance_squared_to(entity[i].position) < distance:
			damage(hero, i, element, portion)
			entity[i].velocity += directed[hero] * TILE * output
			xp += exper[i]
	if start == Def.PARTY and xp != 0:
		score_up(xp * combo)

enum { LOW = 128, MID1 = 172, MID = 196, MID2 = 214, HIGH = 256 }

func damage_throw(hero: int, box: int, direction: Vector2, element: int) -> void:
	var start: int = Def.PARTY if hero < Def.PARTY else 0
	var check: Rect2 = Rect2(entity[box].position + LOW * direction, entity[box].position + HIGH * direction)
	var ideal: Rect2 = Rect2(entity[box].position + MID1 * direction, entity[box].position + MID2 * direction)
	
	for i in range(start, entities):
		var delta: Vector2 = entity[box].position + entity[i].position * direction
		if hero != i and delta >= check.position and check.size <= delta:
			var attack: int = power[hero]
			var countr: int = shell[i]
			if element != NORMAL:
				attack = (attack >> 1) + (impac[hero] >> 1)
				countr = (countr >> 1) + (react[i] >> 1)
			
			var portion: float = 1.0
			if delta >= ideal.position and ideal.size <= delta:
				portion = 1.5
				
			if weakn[i] == element:
				affect(i, min((countr >> 1) - attack * portion, -10 * portion), 0)
			elif immun[i] == element:
				affect(i, min((countr << 1) - attack * portion, -10 * portion), 0)

func damage(hero: int, enemy: int, element: int, portion: float) -> void:
	var attack: int = impac[hero]
	var countr: int = react[enemy]
	if element == NORMAL:
		attack = power[hero]
		countr = shell[enemy]
	attack = int(attack * portion)
	if element == LIGHT:
		affect(enemy, countr >> 1 + attack, 0)
	elif weakn[enemy] == element:
		affect(enemy, min(countr >> 1 - attack, -1), 0)
	elif immun[enemy] == element:
		affect(enemy, min(countr << 1 - attack, -1), 0)
	else:
		affect(enemy, min(countr - attack, -1), 0)

var places: PackedInt32Array
var place_size: int
var min_enemy: PackedByteArray = [0, 1, 2, 3, 4]
var max_enemy: PackedByteArray = [0, 3, 5, 9, 12]
const foe: Array[PackedScene] = [
	preload("res://def/entity/foe/eye_seeker.tscn"),
	preload("res://def/entity/foe/eye_seeker.tscn")
]

enum { DIFFICULTY = 1, FROM = 0, UPTO = 1 }

func teleport(enemy: CharacterBody2D) -> void:
	enemy.spawn_pos = (enemy.spawn_pos + 1) % places.size()
	enemy.position = HUD.level.execute.get_pos(places[enemy.spawn_pos])

func reload() -> void:
	if max_enemy[DIFFICULTY] == 0: return
	
	var pos: PackedVector2Array = HUD.level.tags.layer.get_used_cells_by_id(4)
	HUD.size[HUD.PLACES] = 0
	for i in len(pos):
		if i < places.size():
			places[i] = Def.join(pos[i])
		else:
			places.append(Def.join(pos[i]))
		HUD.size[HUD.PLACES] += 1
		
	entities = Def.PARTY
	var count: int = randi_range(min_enemy[DIFFICULTY], max_enemy[DIFFICULTY])
	for i in range(0, foe.size()):
		if Def.of(HUD.level.foe, i):
			for c in mini(count * HUD.level.portion[i], 1):
				entity[entities] = foe[i].instantiate()
				entity[entities].no = entities
				HUD.level.border.layer.add_child(entity[entities])
				a_points[entities - Def.PARTY] = aura[entities]
				r_points[entities - Def.PARTY] = resc[entities]
				a_portion[entities] = 1.0 / aura[entities]
				r_portion[entities] = 1.0 / resc[entities]
				entity[entities].position = Def.map(places[randi_range(0, place_size)])
				entities += 1

enum { MAX_LV = 7, PRIORITY_SELECT = 7, SCORE_HALF = 1,
	PURSUIT = 0, SELF_CONTROL = 1, TENACITY = 2, SELECT = 3, SCORE_BIT = 24 }

var level: int
var next_level: PackedInt32Array = [6, 12, 27, 50, 80, 115, 154,  200, 265, 340, 430,
	537, 650, 775,  900, 1040, 1220, 1420, 1667, 1960, 2333]

func bonus(add: int, x: float) -> void: score_up(roundi(add * x))

func score_up(add: int) -> void:
	var score: int = (HUD.get_half(HUD.SCORE, SCORE_HALF) & (Def.bit(SCORE_BIT) - 1)) + add
	if level < next_level.size() and score >= next_level[level]:
		var before: int = level
		while level < next_level.size() and score >= next_level[level]: level += 1
		var after: int = level
		var selection: int = HUD.get_part(HUD.SCORE, PRIORITY_SELECT)
		for hero in range(0, Def.PARTY):
			var priority: Vector3i = Vector3i(
				HUD.get_part(HUD.PRIORITY, PURSUIT * HUD.HALF + hero),
				HUD.get_part(HUD.PRIORITY, SELF_CONTROL * HUD.HALF + hero),
				HUD.get_part(HUD.PRIORITY, TENACITY * HUD.HALF + hero))
			var select: int = Def.of_x(Def.MASK2, selection, hero)
			var delta: int = after - before
			
			if hero == HUD.hero: HUD.game.ability.priority[select].background = Color.GRAY
			
			while delta != 0:
				if priority[select] + delta <= MAX_LV:
					priority[select] += delta
					delta = 0
				else:
					delta -= MAX_LV - priority[select]
					select = (select + 1) % SELECT
			
			if hero == HUD.hero: HUD.game.ability.priority[select].background = Color.WHITE
			
		for xp in [HUD.game.ability, HUD.game.priorities]:
			if level < next_level.size():
				xp.bar.max_value = next_level[level]
	for xp in [HUD.game.ability, HUD.game.priorities]:
		xp.bar.value = next_level[level]
		xp.score.text = str(next_level[level])




## TIMING

func _press(title: StringName) -> bool: return Input.is_action_just_pressed(title)
func _hold(title: StringName) -> bool: return Input.is_action_pressed(title)
func _out(title: StringName) -> bool: return Input.is_action_just_released(title)
func _power(title: StringName) -> float: return Input.get_action_strength(title)
func act(no: int) -> bool: return combo_slots & acts[no]

enum { LEFT, RIGHT, UP, DOWN, ACT1, ACT2, ACT3, ACT4, OPT_LEFT, OPT_RIGHT, OPT_UP,
	OPT_DOWN, SHOT, AIM, MENU }
enum { DOUBLE, LUNGE, HUG, LOW_KICK, CRACK, GRILL_KICK, SLIPPERANG,
	SPIT_KICK, BACK_SPIT, POACHING, CURE, OK_SHOT, PIERCE, BLADE_RUN, TACKLE,
	GREEK_FIRE, STRAY_BULLET, AIR_FIGHT, AID, FIRE_DANCE, BREAKFLY, SHRAPNEL,
	WET_CLEANING, DEFIBRILLATOR, HORIZONTAL, ROUND_ATTACK, WASHING_OUT,
	TRANSFUSION, AIR_STRIKE, SHOCK, ELECTROCUT, THUNDER }
enum { A, B, X, Y, S, L = 8, T = 16, M = 24, R = 32, H = 40 }
var acts: PackedInt32Array = [A<<L|A, B<<L|A<<L|A, A<<T|Y<<L|A, A<<T|B<<L|A,
	B<<T|B<<L|A, B<<T|X<<L|B, B<<T|A<<L|B, B<<M|A<<T|A<<L|B, A<<M|Y<<T|A<<L|Y]
# var hero: int enum { RAY, ROCK } enum { TOOL, FIGHT, DANCE }
var combo_slots: int
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
func reset_combo() -> void: combo_slots = 0

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
	add_logs(combo_color[combo_slots - 2] + caption[id])
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

func input(event: InputEvent) -> void: # return #TODO FIXME disable after HUD test
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
	elif _press(&"select"):
		if HUD.interact.state[HUD.hero] == 0:
			HUD.level.deploy.select()
	elif _press(&"act1"): punch()
	elif _press(&"act2"): kick()
	elif _press(&"act3"): skill_a()
	elif _press(&"act4"): skill_b()
	elif _hold(&"aim"):
		if _press(&"fire"): use_item()
		elif _press(&"item_left"): HUD.fast_panel_swap(-1)
		elif _press(&"item_right"): HUD.fast_panel_swap(+1)
	elif _press(&"item_left"): pass # left_pattern
	elif _press(&"item_right"): pass # right_pattern
	elif event is InputEventKey:
		var no: int = event.keycode - KEY_1
		if no >= 0 and no <= 4:
			if Input.is_key_pressed(KEY_TAB):
				HUD.pallete_pattern_select(no)
			else:
				HUD.fast_panel_select(no)
		elif no == 5 and Input.is_key_pressed(KEY_TAB):
			HUD.pallete_pattern_fight()

func main_slot(weapon_type: int) -> bool:
	var i: int = Def.byte(HUD.get_item(HUD.hero, HUD.inventory.fast_panel[HUD.hero]), Trades.ID) - Trades.WEAPON
	return 0 < i and HUD.inventory.type[i] == weapon_type

func fast_slot(weapon_type: int) -> bool:
	var i: int = Def.byte(HUD.get_item(HUD.hero, Trades.WEAPON_SLOT), Trades.ID) - Trades.WEAPON
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
	combo_slots = combo_slots << Def.HALF_BYTE | A
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
	combo_slots = combo_slots << Def.HALF_BYTE | B
	match HUD.hero:
		Def.RAY:
			empty_hand_kick()
		Def.ROCK:
			if act(TACKLE):
				pass
			else:
				empty_hand_kick()
	HUD.combo_timer.start()
	#if HUD.level.tile[HUD.hero] == Def.H_SPRING_OFF: TODO CHANGE TO ROPE
	#	HUD.level.chains.jump()

func skill_a() -> void:
	combo_slots = combo_slots << Def.HALF_BYTE | X
	if act(GRILL_KICK):
		pass
	elif act(CRACK) and book(B_CRACK, P_CRACK, C_CRACK):
		fight(3, CRACK, Adversary.TARGET, Adversary.NORMAL, 1.2, 0.5)

	match HUD.hero:
		Def.RAY: HUD.interact.melt_ice()
		Def.ROCK: HUD.interact.puddle_tile() # LevelRoot # TileDecorator

func skill_b() -> void:
	combo_slots = combo_slots << Def.HALF_BYTE | Y
	if act(POACHING):
		pass
	elif act(HUG):
		fight(4, HUG, Adversary.TARGET, Adversary.NORMAL, 1.4, -0.5)

func use_item() -> void:
	var throw: bool = HUD.inventory.produce_item(HUD.hero, HUD.trades.fast_panel[HUD.hero])  == Trades.WEAPON_THROW
	match HUD.hero:
		Def.ROCK:
			if act(SLIPPERANG) and throw and main_slot(Trades.BOOMERANG):
				pass
			else:
				pass
		Def.RAY:
			if act(OK_SHOT):
				pass
			elif act(AID) and fast_slot(Trades.GUN):
				pass
				
## ANIMATION

enum { POWER, INFLUENCE, VITALITY, REACTION, SPEED = 4, DOUBLE_COMBO = 2 } # signal sync_anim(animation: String, frame: int)

enum { WALK, RUN, JUMP, A_KICK, A_PUNCH, PUSH, A_FIRE, WHIP, STOMP, MOVE, DIRECTED = 3 }

var frames: PackedByteArray = [0, 0]
var sprites: PackedStringArray = ["b", "f", "bl", "fl", "l", "br", "fr", "r",
	"b_run", "f_run", "bl_run", "fl_run", "l_run", "br_run", "fr_run", "r_run",
	"b_jump", "f_jump", "bl_jump", "fl_jump", "l_jump", "br_jump", "fr_jump", "r_jump",
	"b_kick", "f_kick", "bl_kick", "fl_kick", "l_kick", "br_kick", "fr_kick", "r_kick",
	"b_punch", "f_punch", "bl_punch", "fl_punch", "l_punch", "br_punch", "fr_punch", "r_punch",
	"b_push", "f_push", "bl_push", "fl_push", "l_push", "br_push", "fr_push", "r_push",
	"b_fire", "f_fire", "bl_fire", "fl_fire", "l_fire", "br_fire", "fr_fire", "r_fire",
	"b_whip", "f_whip", "bl_whip", "fl_whip", "l_whip", "br_whip", "fr_whip", "r_whip",
	"b_stomp", "f_stomp", "bl_stomp", "fl_stomp", "l_stomp", "br_stomp", "fr_stomp", "r_stomp",
	"b_c_move", "f_c_move", "bl_c_move", "fl_c_move", "l_c_move", "br_c_move", "fr_c_move", "r_c_move",
	"b_c_whip", "f_c_whip", "bl_c_whip", "fl_c_whip", "l_c_whip", "br_c_whip", "fr_c_whip", "r_c_whip"]

func direct(dir: Vector2i) -> void: directed[HUD.hero] = dir
func animate_frames(type: int) -> void:
	frames[HUD.hero] = type
	HUD.level.profile[HUD.hero].sprite.animation = sprites[get_anim(HUD.hero)]

func stop_animation() -> void:
	HUD.level.profile[HUD.hero].sprite.stop()
	HUD.level.profile[HUD.hero].sprite.animation = sprites[get_anim(HUD.hero)]
	HUD.level.profile[HUD.hero].sprite.frame = 0

func get_anim(hero: int) -> int: return (frames[hero] << DIRECTED) | Def.direct(directed[hero]) # if Bit.of(state[BODY], RUN):

func animate() -> void:# motion: Vector2
	var anim: int = get_anim(HUD.hero)
	HUD.level.profile[HUD.hero].sprite.animation = sprites[anim]
	if not HUD.level.profile[HUD.hero].sprite.is_playing():
		HUD.level.profile[HUD.hero].sprite.play(sprites[anim])
	return

func mirror_animation() -> void:
	var animation: String = HUD.level.profile[HUD.hero].animation
	if animation.contains("forward"): animation = animation.replace("forward", "backward")
	elif animation.contains("backward"): animation = animation.replace("backward", "forward")
	HUD.level.mirror[HUD.hero].animation = animation

func mirror_frame() -> void:
	HUD.level.mirror[HUD.hero].frame = HUD.level.profile[HUD.hero].frame

enum { SHADOW_GROUND, SHADOW_HANG, SHADOW_FLY }

func set_shadow(next: int) -> void:
	HUD.level.shadow[HUD.hero].visible = next != SHADOW_FLY
	HUD.level.shadow[HUD.hero].position = Vector2(0, 27) if next == SHADOW_HANG else Vector2(0, -5)

func get_mirror_sprite(view: CharacterBody2D, path: StringName, mirror: AnimatedSprite2D) -> AnimatedSprite2D:
	if mirror != null: return mirror
	mirror = load(path).instantiate()
	view.set(&"_mirror", mirror)
	view.shadow.add_sibling(mirror)
	view.profile.animation_changed.connect(mirror_animation)
	view.profile.frame_changed.connect(mirror_frame)
	return mirror

func set_aura(thickness: float, next_color: Color, resource: bool) -> void: # MOVE & CONNECT TO LINK
	if resource:
		HUD.level.profile[HUD.hero].material.set(&"shader_parameter/ability", thickness == 0)
		HUD.level.profile[HUD.hero].material.set(&"shader_parameter/ap", thickness)
	else: #Color("FFFFFF7F"), 3
		HUD.level.profile[HUD.hero].material.set(&"shader_parameter/line_thickness", thickness)
		HUD.level.profile[HUD.hero].material.set(&"shader_parameter/line_color", next_color)
# PARTICLES
enum { PUNCH, KICK, TORCH, DROP, APPEAR = 0, TIME, DISAPPEAR, OFFSET = 10, PATH = 100 }

const timing: PackedFloat32Array = [0.2, 0.4, 0.6]

var texture: Texture
var sprite: Sprite2D

func set_direction(pos: Vector2, direction: Vector2, type: int) -> void:
	sprite = Sprite2D.new()
	match type:
		PUNCH: texture = preload("res://icon/vfx/punch.png")
		KICK: texture = preload("res://icon/vfx/kick.png")
		TORCH: texture = preload("res://icon/vfx/ray/fire.svg")
		DROP: texture = preload("res://icon/vfx/rock/water.svg")
	sprite.position = pos - Vector2(0, 32)
	var offsets: Vector2 = Vector2(OFFSET, OFFSET)
	var angle: float = Def.rotate(direction)
	sprite.rotation = angle
	var delta: Vector2 = Vector2(PATH, PATH) * direction
	if direction.x != 0 and direction.y != 0:
		var axis: int = randi_range(0, 2)
		if axis != 2:
			direction[axis] *= -1
			sprite.position += offsets * direction
		delta *= 0.75
		sprite.modulate = Color.TRANSPARENT
		set_track(sprite.position + delta)
	for i in range(0, 2):
		if direction.x != 0:
			var track: int = randi_range(-1, 1)
			if track != 0:
				direction[i] = track
				sprite.position += offsets * direction * 2
			break # modulate = Color.from_rgba8(127, 127, 127, 127)
	sprite.modulate = Color.TRANSPARENT
	set_track(sprite.position + delta)

func set_track(target: Vector2) -> void:
	var tween: Tween = HUD.create_tween() # .set_parallel(true)
	tween.tween_property(self, ^"modulate", Color.from_rgba8(127, 127, 127, 200), timing[APPEAR])
	tween.parallel().tween_property(self, ^"position", target, timing[TIME])
	tween.tween_property(self, ^"modulate", Color.TRANSPARENT, timing[APPEAR])
	tween.tween_callback(sprite.queue_free)

func set_interaction(hero: CharacterBody2D, no: int) -> void:
	hero.set_meta(&"no", no) # animation.timeout.connect(stop_animation)
	HUD.level.plate[no] = hero.get_node(^"plate")
	HUD.level.plate[no].body_entered.connect(HUD.level.plate_encounter)
	HUD.level.plate[no].body_exited.connect(HUD.level.plate_disappear)
	HUD.level.lever[no] = hero.get_node(^"lever")
	HUD.level.lever[no].body_entered.connect(HUD.level.lever_encounter)
	HUD.level.lever[no].body_exited.connect(HUD.level.lever_disappear)

func set_monitoring(no: int, value: bool) -> void:
	HUD.level.lever[no].monitoring = value
	HUD.level.plate[no].monitoring = value

func make_velocity(no: int, motion: Vector2) -> void: 
	HUD.level.velocity[no] = motion * HUD.level.weight[no]
# circle # small_circle # after_tile # sided # fireplace
func make_position(no: int, motion: Vector2) -> void:
	HUD.level.entity[no].position = motion
