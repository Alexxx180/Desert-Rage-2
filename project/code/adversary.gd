class_name Adversary extends RefCounted
enum { 
	BLUE, NO = 0, AURA = 0, LIFE_BORDER = 0, WAVE = 0, THICK = 0, GREEN, COLOR = 1, RESOURCE_SHIFT = 1,
	PERIOD = 1, DURATION = 1, YELLOW, BAR_TYPE = 2, TRANSPORT = 2, SUMMARY = 2, RESOURCE = 2, THICKNESS = 5, RED = 3,
	RESOURCE_VALUE = 3, LAST_THICKNESS = 3, CRITICAL = 4, BARS = 4, MAX_ = 10, SEMI = 100, SET = 255,
# ENTITIES
	RAY, ROCK, EYE_SEEKER,
# STAT
	POWER, INFLUENCE, VITALITY, REACTION, HP, AP, MAX,
# PRIORITIES
	PURSUIT, SELF_CONTROL, TENACITY,
# STATUS
	BURN, POISON, COUGH,
# STATUS POWER & POSITION
	BURN_POWER = 5, POISON_POWER = 6,
# DAMAGE TYPE & DISTANCE
	TARGET = 0, ZONE_RADIUS, TARGET_RADIUS, ZONE_ALL,
	LOW = 128, MID1 = 172, MID = 196, MID2 = 214, HIGH = 256,
	HALF_TILE = 32, TILE = 64, DISTANCE = 1024, RADIUS_DISTANCE = 4096,
# ELEMENTS
	VOID = 0, LIGHT, NORMAL, FIRE, WATER, SPARK,
# PRIORITY
	MAX_LV = 7, PRIORITY_SELECT = 7, SCORE_HALF = 1, SELECT = 3, SCORE_BIT = 24,
	SPEED = 4, DOUBLE_COMBO = 2, DIFFICULTY = 1, FROM = 0, UPTO = 1,
# ANIMATIONS
	IDLE, WALK, RUN, PUSH, STOMP, A_PUNCH, A_KICK, A_FIRE, WHIP, JUMP, HURT,
	MOVE, DIRECTED = 3, NO_ANIM = 0, A_ENV = 1, A_ACT, SHADOW_GROUND = 0,
	SHADOW_HANG, SHADOW_FLY, STATUS_TYPE = 0, STATUS_TIME, STATUS_X = -7, STATUS_Y = 25,
# MOVEMENT
	LEFT, RIGHT, UP, DOWN, ACT1, ACT2, ACT3, ACT4, OPT_LEFT, OPT_RIGHT, OPT_UP,
	OPT_DOWN, SHOT, AIM, MENU,
# ACTIONS
	A, B, X, Y, S, S2 = 8, S3 = 16, S4 = 24,
	A_DOUBLE = (A<<S2)|A, A_BACK_SPIT = (B<<S4)|(A<<S3)|(A<<S2)|B,
	A_LUNGE = (B<<S3)|(A<<S2)|A, A_PIERCE = (B<<S3)|(B<<S2)|A,
	A_POACHING = (A<<S3)|(Y<<S2)|A, A_LOW_KICK = (A<<S3)|(B<<S2)|A,
	A_CURE = (B<<S3)|(X<<S2)|B, A_SPIT_KICK = (B<<S3)|(A<<S2)|B,
	A_HUG = (A<<S4)|(Y<<S3)|(A<<S2)|Y, A_CRACK = 0,
# BOOKS
	B_LUNGE, B_CRACK, B_BACKSPIT,
# COMPETENCY
	C_CRACK = 6|3<<S2, C_BACKSPIT = 4,
# D
	D_DOUBLE, D_BACK_SPIT, D_LUNGE, D_PIERCE, D_POACHING, D_LOW_KICK,
	D_CURE, D_SPIT_KICK, D_HUG, D_CRACK,
# ACT
	PUNCH, KICK, TORCH, DROP, APPEAR = 0, TIME, DISAPPEAR, OFFSET = 10, PATH = 100,
# MENU
	PANEL_RIGHT = 0, PANEL_LEFT, PANEL_FORWARD, PANEL_BACKWARD,
	LEFT_OFF = -2000, LEFT_ON = 0, RIGHT_OFF = 1000, RIGHT_ON = -1000,
	FORWARD_OFF = -1000, FORWARD_ON = 1000, BACKWARD_OFF = 1000, BACKWARD_ON = -1000
}

const sprite_dir: PackedStringArray = ["bo", "fo", "bl", "fl", "ol", "br", "fr", "or"]
const sprites: PackedStringArray = ["", "", "_run", "_jump", "_push", "_stomp", "_punch", "_kick",  "_fire", "_whip", "c_move", "c_whip"] # _walk
const in_game: PackedStringArray = ["Гляделкинс"]
const caption: PackedStringArray = ["Двоечка"]
const combo_color: PackedStringArray = ["[color=#00AA00]2x[/color]", "[color=#FFAA00]3x[/color]", "[color=#FFAA00]4x[/color]"]
const menu_navigation: Array[StringName] = [&"right_focus", &"right", &"left_focus", &"left", &"top_focus", &"top", &"bottom_focus", &"bottom"]

const color: PackedFloat32Array = [1.0, 0.8, 0.4, 0.0]
const PRIORITY: PackedByteArray = [3, 2, 1, 1,  1, 3, 1, 2,  1, 1, 3, 2]
const aura: PackedInt32Array = [5, 7, 0] # ray, p: 5, 5  rock, p: 7, 3
const resc: PackedInt32Array = [3, 2, 5]
const shell: PackedByteArray = [0, 1, 5]
const power: PackedByteArray = [1, 2, 5]
const impac: PackedByteArray = [2, 1, 5]
const react: PackedByteArray = [2, 1, 5]
const exper: PackedByteArray = [0, 0, 1]
const weakn: PackedByteArray = [NORMAL, NORMAL, NORMAL]
const immun: PackedByteArray = [NORMAL, NORMAL, NORMAL]

const timing: PackedFloat32Array = [0.2, 0.4, 0.6]
const enemies: PackedByteArray = [0, 0,  1, 3,  2, 5,  3, 9,  4, 12]
const menu_shift: PackedInt32Array = [RIGHT_ON, LEFT_ON, FORWARD_ON, BACKWARD_ON]
const foe: Array[PackedScene] = [
	preload("res://def/entity/foe/eye_seeker.tscn"),
	preload("res://def/entity/foe/eye_seeker.tscn")
]

var max_slot: PackedByteArray = [0, 24, 12, 12]
var frames: PackedByteArray = [0, 0, 0,  0, 0, 0]

var running: int
var next_level: PackedInt32Array = [6, 12, 27, 50, 80, 115, 154,  200, 265, 340, 430,
	537, 650, 775,  900, 1040, 1220, 1420, 1667, 1960, 2333]
var aura_colors: PackedFloat32Array = [1.0 / (BLUE - GREEN), 1.0 / (GREEN - YELLOW), 1.0 / (YELLOW - RED)]

var aura_stat: PackedFloat32Array = [0.7, 0.1, 2.0, 5.0, 0.1]
var status_time: PackedByteArray = []; var status_type: PackedByteArray = []
var i_points: PackedByteArray = _number12()
var a_portion: PackedFloat32Array = _number14(); var r_portion: PackedFloat32Array = _number14()
var a_points: PackedInt32Array = _number12(); var r_points: PackedByteArray = _number12()
var target_a: PackedInt32Array = _number14(); var target_r: PackedByteArray = _number14()
var last_color: Color

var logs_cache: PackedStringArray = ["", "", "", "", "", "", ""]
var enemy_status: PackedInt64Array = []

# PARTICLES
var texture: Texture
var sprite: Sprite2D

var places: PackedInt32Array
var place_size: int

# func setup() -> void: HUD.aura_time.timeout.connect(diffusion) # burns - blink
## ENEMY
func _number14() -> Array[int]: return [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
func _number12() -> Array[int]: return [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
func status_drawback(e: int, i: int) -> void:
	var s: int = e - D.PARTY; var p: int = HUD.STATUS + e
	var status: Vector2i = D.byte_of(HUD.get_part(p, i) if e < D.PARTY else enemy_status[s])
	if status[STATUS_TIME] == 0: return

	status[STATUS_TIME] -= 1
	if status[STATUS_TYPE] == 0:
		HUD.level.entity_status[e][i].hide()
		HUD.level.entity_status[e][i].position = Vector2(0, STATUS_Y * i)
	else:
		HUD.level.entity_status[e][i].position = Vector2(STATUS_X * status[STATUS_TIME], STATUS_Y * i)
		status_feedback(4, e, status_time[i], status_type[i])

	var result: int = status[STATUS_TYPE] << D.HALF_BYTE | status[STATUS_TIME]
	if p < D.PARTY:
		HUD.set_part(p, i, result)
	else:
		enemy_status[s] = D.to_byte(enemy_status[s], i, result)

func status_feedback(limit: int, enemy: int, time: int, status: int) -> int:
	for j in range(0, limit):
		var t: int = D.half(time, j)
		if t != 0:
			match D.half(status, j):
				BURN: affect(enemy, -min(1, aura[enemy] >> BURN_POWER), 0)
				POISON: affect(enemy, -min(1, aura[enemy] >> POISON_POWER), 0)
			status_drawback(enemy, j)
			if HUD.did(D.MENU, D.STATUS_TICK):
				t -= 1
				time = D.to_half(time, j, t)
	return time

func status_timeout() -> void:
	var off: bool = true
	HUD.undo(D.MENU, D.STATUS_TICK)
	for i in range(0, D.PARTY):
		var time: int = HUD.get_half(HUD.STATUS_TIME, i)
		if time != 0:
			off = false
			HUD.set_half(HUD.STATUS_TIME, status_feedback(4, i, time, HUD.get_half(HUD.STATUS, i)))
	for i in range(0, len(status_time)):
		if status_time[i] != 0:
			off = false
			status_time[i] = status_feedback(2, i + D.PARTY, status_time[i], status_type[i])
	if off: HUD.aura_timer.stop()

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
	if !HUD.level.tweens[hero] or !HUD.level.tweens[hero].is_valid():
		HUD.level.tweens[hero] = HUD.create_tween()
		HUD.level.tweens[hero].tween_method(func(value: float):
			var segment: float = a_portion[hero]
			var h: int = hero
			var stat: int
			if hero < D.PARTY:
				stat = HUD.get_stat(HUD.AURA, hero)
			else:
				h -= D.PARTY
				stat = a_points[h]
			if target_a[hero] < stat:
				segment = (target_a[hero] + value * (stat - target_a[hero])) * segment
			else:
				segment = (target_a[hero] - value * (target_a[hero] - stat)) * segment
			HUD.level.entity[hero].profile.material.set(&"shader_parameter/line_color", color_reaction(segment))
			HUD.level.entity[hero].profile.material.set(&"shader_parameter/line_thickness", 7 - segment * THICKNESS)

			if hero < D.PARTY:
				stat = HUD.get_stat(HUD.RESOURCE, hero)
			else:
				stat = r_points[h]
			
			segment = r_portion[hero]
			if target_r[hero] < stat:
				segment = (target_r[hero] + value * (stat - target_r[hero])) * segment
			else:
				segment = (target_r[hero] + value * (stat - target_r[hero])) * segment
			HUD.level.entity[hero].profile.material.set(&"shader_parameter/ap", segment)

			if hero >= D.PARTY and i_points[hero] > 0:
				i_points[hero] -= 5
				HUD.game.ability.health.value = i_points[h],
		0, 1.0, 3).tween_callback(func():
			HUD.level.entity[hero].profile.material.set(&"shader_parameter/line_color", Color.TRANSPARENT)
			HUD.level.entity[hero].profile.material.set(&"shader_parameter/action", false)
			if hero < D.PARTY:
				if HUD.get_stat(HUD.AURA, D.RAY) == 0 and HUD.get_stat(HUD.AURA, D.ROCK) == 0:
					HUD.level.group.spectrum()
				else:
					HUD.level.entity[hero].animation.play_coma()
			elif a_points[hero] == 0 and i_points[hero] == 0:
				HUD.level.entity[hero].process_mode = Node.PROCESS_MODE_DISABLED
				HUD.level.entity[hero].animation.transport()
				var shift: int = -1 if randi_range(0, 1) == 0 else 1
				HUD.level.entity[hero].spawn_pos = posmod(HUD.level.entity[hero].spawn_pos + shift, len(places))
				HUD.level.entity[hero].position = HUD.level.spawn[HUD.level.entity[hero].state[2]]
		)
	if a != 0:
		if hero < D.PARTY:
			var stat: int = clampi(HUD.get_stat(HUD.AURA, hero) + a, 0, HUD.has(D.AURA_MAX | hero))
			HUD.set_stat(HUD.AURA, hero, stat)
			for ui in _get_ui(): ui.aura.value = stat
		else:
			var h: int = hero - D.PARTY
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
		if hero < D.PARTY:
			var stat: int = clampi(HUD.get_stat(HUD.RESOURCE, hero) + r, 0, HUD.has(D.RESC_MAX | hero))
			HUD.set_stat(HUD.RESOURCE, hero, stat)
			for ui in _get_ui(): ui.resource.value = stat
		else:
			r_points[hero] = clampi(r_points[hero] + r, 0, resc[hero])
		HUD.level.entity[hero].profile.material.set(&"shader_parameter/action", true)

func damage_zone(type: int, hero: int, element: int, combo: int, portion: float, output: float = 0) -> bool:
	match type:
		ZONE_ALL:
			var start: int = D.PARTY if hero < D.PARTY else 0
			var xp: int = 0
			for i in range(start, HUD.has(D.ENTITIES)):
				if hero != i:
					damage(hero, i, element, portion)
					xp += exper[i]
			if start == D.PARTY and xp != 0:
				score_up(xp * combo)
			return xp != 0
		TARGET:
			return damage_output(HALF_TILE * HUD.action.directed[hero], DISTANCE, hero, element, combo, portion, output)
		TARGET_RADIUS:
			return damage_output(TILE * HUD.action.directed[hero], RADIUS_DISTANCE, hero, element, combo, portion, output)
		ZONE_RADIUS:
			return damage_output(Vector2.ZERO, RADIUS_DISTANCE, hero, element, combo, portion, output)
	return false
	
func damage_output(direction: Vector2, distance: int, hero: int, element: int, combo: int, portion: float, output: float) -> bool:
	var start: int = D.PARTY if hero < D.PARTY else 0
	var xp: int = 0
	var pos: Vector2 = HUD.level.entity[hero].position
	for i in range(start, HUD.has(D.ENTITIES)):
		if hero != i and (pos + direction).distance_squared_to(pos) < distance:
			damage(hero, i, element, portion)
			HUD.level.entity[i].velocity += HUD.action.directed[hero] * TILE * output
			xp += exper[i]
	if start == D.PARTY and xp != 0:
		score_up(xp * combo)
	return xp != 0

func damage_throw(hero: int, box: int, direction: Vector2, element: int) -> void:
	var start: int = D.PARTY if hero < D.PARTY else 0
	var check: Rect2 = Rect2(HUD.level.entity[box].position + LOW * direction, HUD.level.entity[box].position + HIGH * direction)
	var ideal: Rect2 = Rect2(HUD.level.entity[box].position + MID1 * direction, HUD.level.entity[box].position + MID2 * direction)
	
	for i in range(start, HUD.has(D.ENTITIES)):
		var delta: Vector2 = HUD.level.entity[box].position + HUD.level.entity[i].position * direction
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

func teleport(h: int, pos: Vector2) -> void:
	var tween: Tween = HUD.create_tween()
	if h < D.PARTY:
		tween.tween_method(func(t): 
			if t < 0.25:
				HUD.level.entity[h].teleport_squeze = 4 * t
			elif t < 1.25:
				HUD.level.entity[h].position = pos * (t - 0.25)
			else:
				HUD.level.entity[h].teleport_squeze = 4 * (1.5 - t)
		, 0, 2.5, 1.5)
		tween.tween_callback(func(): HUD.level.entity[h].position = pos)
	else:
		tween.tween_method(func(t): pass, 0, 1, 0.5)
		tween.tween_callback(func(): HUD.level.entity[h].position = pos)

func spawn_enemy(enemy: CharacterBody2D) -> void:
	enemy.spawn_pos = (enemy.spawn_pos + 1) % places.size()
	enemy.position = HUD.level.execute.get_pos(places[enemy.spawn_pos])

func reload() -> void:
	if enemies[DIFFICULTY << 1 | 1] == 0: return
	
	var pos: PackedVector2Array = HUD.level.tags.layer.get_used_cells_by_id(4)
	HUD.size[HUD.PLACES] = 0
	for i in len(pos):
		if i < places.size():
			places[i] = D.join(pos[i])
		else:
			places.append(D.join(pos[i]))
		HUD.size[HUD.PLACES] += 1
	
	var entities: int = D.PARTY
	var count: int = randi_range(enemies[DIFFICULTY << 1], enemies[DIFFICULTY << 1 | 1])
	for i in range(0, foe.size()):
		if D.of(HUD.level.foe, i):
			for c in mini(count * HUD.level.portion[i], 1):
				HUD.level.entity[entities] = foe[i].instantiate()
				HUD.level.entity[entities].no = entities
				HUD.level.border.layer.add_child(HUD.level.entity[entities])
				a_points[entities - D.PARTY] = aura[entities]
				r_points[entities - D.PARTY] = resc[entities]
				a_portion[entities] = 1.0 / aura[entities]
				r_portion[entities] = 1.0 / resc[entities]
				HUD.level.entity[entities].position = D.map(places[randi_range(0, place_size)])
				entities += 1
	HUD.having(D.ENTITIES, entities)

func bonus(add: int, x: float) -> void: score_up(roundi(add * x))

func score_up(add: int) -> void:
	var score: int = (HUD.get_half(HUD.SCORE, SCORE_HALF) & ((1 << SCORE_BIT) - 1)) + add
	var level: int = HUD.has(D.LVL)
	if level < next_level.size() and score >= next_level[level]:
		var before: int = level
		while level < next_level.size() and score >= next_level[level]: level += 1
		HUD.having(D.LVL, level)
		var after: int = level
		var selection: int = HUD.get_part(HUD.SCORE, PRIORITY_SELECT)
		for hero in range(0, D.PARTY):
			var priority: Vector3i = Vector3i(
				HUD.get_part(HUD.PRIORITY, PURSUIT * HUD.HALF + hero),
				HUD.get_part(HUD.PRIORITY, SELF_CONTROL * HUD.HALF + hero),
				HUD.get_part(HUD.PRIORITY, TENACITY * HUD.HALF + hero))
			var select: int = D.half(selection, hero)
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

func can(priorities: int) -> bool:
	return (HUD.get_stat(HUD.STATS + HUD.hero, HUD.PURSUIT) >= D.byte(priorities, 0) and
		HUD.get_stat(HUD.STATS + HUD.hero, HUD.CONTROL) >= D.byte(priorities, 1))

func book(no: int, priorities: int = 0) -> bool:
	return D.of(HUD.check(HUD.BOOK), no) and (priorities == 0 or can(priorities))

func act_enter() -> void: HUD.level.tile[D.offset(HUD.hero, D.LEVER)] = D.join(HUD.level.border.local_to_map(HUD.level.entity[HUD.hero].position))
func act_exit() -> void: HUD.level.tile[D.offset(HUD.hero, D.LEVER)] = 0
func reset_combo(h: int) -> void: HUD.hasnt(D.COMBO_SLOTS | h)

func add_log(text: String) -> void: HUD.game.log.text = text
func add_logs(log_text: String) -> void:
	var log_line: int = HUD.has(D.LOG_LINE)
	if HUD.game.logs.modulate == Color.TRANSPARENT:
		HUD.game.logs.text = ""
		HUD.hasnt(D.LOG_LINE)
	elif log_line >= 50:
		HUD.game.logs.text = "\r\n".join(logs_cache)
		HUD.hasnt(D.LOG_LINE)
	else:
		log_line += 1
		HUD.having(D.LOG_LINE, log_line)
	if log_line <= logs_cache.size():
		logs_cache[log_line] = log_text
	HUD.game.logs.append_text(log)

func fight(h: int, combo_no: int, id: int, zone: int, element: int, portion: float, output: float) -> bool:
	add_logs(combo_color[HUD.has(D.COMBO_SLOTS | h) - 2] + caption[id])
	return damage_zone(zone, HUD.hero, element, combo_no, portion, output)

func update_ui():
	pass

func open_menu_panel(h: int) -> void:
	HUD.undo(D.MENU, D.STATED)
	HUD.game.right.split_offset = RIGHT_OFF
	HUD.game.left.split_offset = LEFT_OFF
	HUD.game.top.split_offset = FORWARD_OFF
	HUD.game.bottom.split_offset = BACKWARD_OFF
	if HUD.did(D.MENU, D.STATED):
		var menu_select: int = HUD.has(D.MENU_SELECTED | h)
		if HUD.did(D.MENU, D.READ_MODE):
			HUD.game.get(menu_navigation[(menu_select << 1)]).split_offset = menu_shift[menu_select] >> 1
		else:
			HUD.game.get(menu_navigation[(menu_select << 1)]).split_offset = menu_shift[menu_select]
			HUD.game.get(menu_navigation[(menu_select << 1) + 1]).grab_focus() # TODO FIXME ALLOW COOP
	else:
		HUD.dont(D.MENU, D.READ_MODE)
		HUD.game.no_focus.grab_focus()

func reset_running(event: InputEvent) -> void: HUD.adversary.running = D.t0(HUD.adversary.running, HUD.settings.get_hero(event))
func input_actions(event: InputEvent) -> void: # return #TODO FIXME disable after HUD test
	var key2: bool = HUD.settings.key2()
	HUD.action.movement(event, key2)
	if _hold(&"group"):
		var h: int = HUD.settings.get_hero(event)
		if _hold(&"left"):
			HUD.having(D.MENU_SELECTED | h, PANEL_LEFT)
			HUD.doing(D.MENU, D.READ_MODE, _hold(&"forward") or _hold(&"backward"))
		elif _hold(&"right"):
			HUD.having(D.MENU_SELECTED | h, PANEL_RIGHT)
			HUD.doing(D.MENU, D.READ_MODE, _hold(&"forward") or _hold(&"backward"))
		elif _press(&"forward"): HUD.having(D.MENU_SELECTED | h, PANEL_FORWARD)
		elif _press(&"backward"): HUD.having(D.MENU_SELECTED | h, PANEL_BACKWARD)
	elif _out(&"group"): open_menu_panel(HUD.settings.get_hero(event))
	elif _press(&"select"):
		if HUD.action.state[HUD.hero] == 0:
			HUD.level.deploy.select()
	elif _press(&"act1"): punch(HUD.settings.get_hero(event)); reset_running(event)
	elif key2 and _press(&"act1_2"): punch(HUD.settings.key_hero())
	elif _press(&"act2"): kick(HUD.settings.get_hero(event)); reset_running(event)
	elif key2 and _press(&"act2_2"): kick(HUD.settings.key_hero())
	elif _press(&"act3"): skill_a(HUD.settings.get_hero(event)); reset_running(event)
	elif key2 and _press(&"act3_2"): skill_a(HUD.settings.key_hero())
	elif _press(&"act4"): skill_b(HUD.settings.get_hero(event)); reset_running(event)
	elif key2 and _press(&"act4_2"): skill_b(HUD.settings.key_hero())
	elif _press(&"fire"): use_item(HUD.settings.get_hero(event))
	elif _hold(&"aim"): pass # TODO AIM
	elif _out(&"aim"):
		HUD.adversary.running = D.t1(HUD.adversary.running, HUD.settings.get_hero(event))
		pass # TODO RUN
	elif _press(&"item_left"): HUD.fast_panel_swap(HUD.settings.get_hero(event), -1)
	elif _press(&"item_right"): HUD.fast_panel_swap(HUD.settings.get_hero(event), +1)
	elif event is InputEventKey:
		var no: int = event.keycode - KEY_1
		if no >= 0 and no <= 4:
			HUD.trades.fast_panel_select(HUD.settings.get_hero(event), no)
		elif no >= 5 and no <= 9:
			HUD.trades.fast_panel_select(HUD.settings.get_hero(event) ^ 1, no)

func main_slot(weapon_type: int) -> bool:
	var i: int = D.byte(HUD.get_item(HUD.hero, HUD.inventory.fast_panel[HUD.hero]), Trades.ID) - Trades.WEAPON
	return 0 < i and HUD.inventory.type[i] == weapon_type

func fast_slot(weapon_type: int) -> bool:
	var i: int = D.byte(HUD.get_item(HUD.hero, Trades.WEAPON_SLOT), Trades.ID) - Trades.WEAPON
	return 0 < i and HUD.inventory.type[i] == weapon_type

func new_slot(h: int, s: int) -> int: var slots: int = HUD.has(D.COMBO_SLOTS); slots = s | (slots << D.HALF_BYTE); HUD.having(h, slots); return slots
func empty_hand_punch(h: int, s: int) -> bool:
	if (A_DOUBLE & s)==s:
		if (A_LUNGE & s)==s and book(B_LUNGE) and can(C_BACKSPIT):
			return fight(h, 3, D_LUNGE, TARGET, NORMAL, 1.35, 2.0)
		else:
			return fight(h, 2, D_DOUBLE, TARGET, NORMAL, 1.15, -0.2)
	else:
		return damage_zone(HUD.hero, TARGET, NORMAL, 1, 1.0, -0.1)

func empty_hand_kick(h: int, s: int) -> bool:
	if (A_LOW_KICK & s)==s:
		return fight(h, 2, D_LOW_KICK, TARGET, NORMAL, 1.25, 0.5)
	elif (A_SPIT_KICK & s)==s and book(B_BACKSPIT) and can(C_BACKSPIT):
		return false
	else:
		return damage_zone(HUD.hero, TARGET, NORMAL, 1, 1.0, 0.1)

func punch(h: int) -> void:
	var s: int = new_slot(h, A); var env: bool = true
	match HUD.hero:
		D.RAY:
			env = empty_hand_punch(h, s)
		D.ROCK:
			if (A_PIERCE & s)==s:
				env = true
			elif (A_HUG & s)==s:
				env = true
			else:
				env = empty_hand_punch(h, s)
	HUD.combo_timer.start()
	if env: HUD.action.punch_apply(h)

func kick(h: int) -> void:
	var s: int = new_slot(h, B)
	match HUD.hero:
		D.RAY:
			empty_hand_kick(h, s)
		D.ROCK:
			if (A_SPIT_KICK & s)==s:
				pass
			else:
				empty_hand_kick(h, s)
	HUD.combo_timer.start()

func skill_a(h: int) -> void:
	var s: int = new_slot(h, X); var env: bool = true
	if (A_SPIT_KICK & s)==s:
		pass
	elif (A_CRACK & s)==s and book(B_CRACK) and can(C_CRACK):
		env = fight(h, 3, D_CRACK, Adversary.TARGET, Adversary.NORMAL, 1.2, 0.5)

	if env: HUD.action.skill_a_apply(h)

func skill_b(h: int) -> void:
	var s: int = new_slot(h, Y); var env: bool = true
	if (A_POACHING & s)==s:
		pass
	elif (A_HUG & s)==s:
		env = fight(h, 4, D_HUG, Adversary.TARGET, Adversary.NORMAL, 1.4, -0.5)
	
	if env: HUD.action.skill_b_apply(h)

func use_item(h: int) -> void:
	var s: int = new_slot(h, S)
	var throw: bool = HUD.inventory.produce_item(HUD.hero, HUD.trades.fast_panel[HUD.hero]) == Trades.WEAPON_THROW
	match HUD.hero:
		D.ROCK:
			if (A_BACK_SPIT & s)==s and throw and main_slot(Trades.BOOMERANG):
				pass
			else:
				pass
		D.RAY:
			if (A_SPIT_KICK & s)==s: # OK_SHOT
				pass
			elif (A_CURE & s)==s and fast_slot(Trades.GUN): # AID
				pass
				
## ANIMATION
func get_anim(h: int) -> int: return h + (A_ACT if frames[A_ACT + h] != NO_ANIM else A_ENV)
func set_anim(h: int, type: int) -> void:
	var anim: String = sprite_dir[D.direct(HUD.action.directed[Action.NZERO | h].round())]; var hero: int = h * 3
	if A_PUNCH <= type and type <= HURT:
		frames[hero + A_ACT] = type; anim += sprites[frames[get_anim(hero)]]
	else:
		frames[hero + A_ENV] = type; anim += sprites[type]
	mirror_animation(h, anim)

func progress_animation() -> void:
	for h in range(0, D.PARTY):
		var hero: int = h * 3
		if frames[hero + A_ACT] == JUMP:
			continue
		else:
			frames[hero] += 1
			if frames[hero] >= max_slot[frames[hero + A_ENV]]: frames[hero] = 0
		HUD.level.profile[h].frame = frames[hero]
		HUD.level.mirror[h].frame = frames[hero]
# immediate - continuous
func mirror_animation(h: int, animation: String) -> void:
	HUD.level.profile[h].animation = animation
	if animation[0] == "f": animation = "b" + animation.substr(1)
	elif animation[0] == "b": animation = "f" + animation.substr(1)
	HUD.level.mirror[h].animation = animation

func set_shadow(h: int, next: int) -> void:
	HUD.level.shadow[h].visible = next != SHADOW_FLY
	HUD.level.shadow[h].position = Vector2(0, 27) if next == SHADOW_HANG else Vector2(0, -5)

func get_mirror_sprite(view: CharacterBody2D, path: StringName, mirror: AnimatedSprite2D) -> AnimatedSprite2D:
	if mirror != null: return mirror
	mirror = load(path).instantiate()
	view.set(&"_mirror", mirror)
	view.shadow.add_sibling(mirror) #view.profile.animation_changed.connect(mirror_animation) #view.profile.frame_changed.connect(mirror_frame)
	return mirror

func set_aura(h: int, thickness: float, next_color: Color, resource: bool) -> void: # MOVE & CONNECT TO LINK
	if resource:
		HUD.level.profile[h].material.set(&"shader_parameter/ability", thickness == 0)
		HUD.level.profile[h].material.set(&"shader_parameter/ap", thickness)
	else: #Color("FFFFFF7F"), 3
		HUD.level.profile[h].material.set(&"shader_parameter/line_thickness", thickness)
		HUD.level.profile[h].material.set(&"shader_parameter/line_color", next_color)

func set_direction(pos: Vector2, direction: Vector2, type: int) -> void:
	sprite = Sprite2D.new()
	match type:
		PUNCH: texture = preload("res://icon/vfx/punch.png")
		KICK: texture = preload("res://icon/vfx/kick.png")
		TORCH: texture = preload("res://icon/vfx/ray/fire.svg")
		DROP: texture = preload("res://icon/vfx/rock/water.svg")
	sprite.position = pos - Vector2(0, 32)
	var offsets: Vector2 = Vector2(OFFSET, OFFSET)
	var angle: float = D.rotate(direction)
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

func set_monitoring(no: int, value: bool) -> void:
	HUD.level.lever[no].monitoring = value
	HUD.level.plate[no].monitoring = value

func make_velocity(no: int, motion: Vector2) -> void: 
	HUD.level.velocity[no] = motion * HUD.level.weight[no]
# circle # small_circle # after_tile # sided # fireplace
func make_position(no: int, motion: Vector2) -> void:
	HUD.level.entity[no].position = motion
