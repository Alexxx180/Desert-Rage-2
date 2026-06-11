class_name AuraResource extends RefCounted

enum { BLUE, NO = 0, AURA = 0, LIFE_BORDER = 0, WAVE = 0, THICK = 0, GREEN, COLOR = 1, AP = 1, RESOURCE_SHIFT = 1,
	PERIOD = 1, DURATION = 1, YELLOW, BAR_TYPE = 2, TRANSPORT = 2, SUMMARY = 2, RESOURCE = 2, THICKNESS = 2, RED,
	RESOURCE_VALUE = 3, LAST_THICKNESS = 3, CRITICAL = 4, BARS = 4, MAX = 10, SEMI = 100, SET = 255 }

const color: PackedFloat32Array = [1.0, 0.8, 0.4, 0.0]
var aura: PackedFloat32Array = [0.7, 0.1, 2.0, 5.0, 0.1]

var max_points: PackedByteArray = [0, 0, 0, 0]
var points: PackedByteArray = [0, 0, 0, 0]
var damage: PackedByteArray = [0, 1, 0]

var _reaction: Array[Tween]
var last_color: Color

func setup() -> void: HUD.aura_time.timeout.connect(diffusion) # burns - blink

func transport(hero: int) -> void:
	var h: CharacterBody2D = HUD.level.entity[hero]
	h.animation.transport()
	h.process_mode = Node.PROCESS_MODE_DISABLED
	var shift: int = 1 if Bit.of(h.state[TRANSPORT], hero) else -1
	h.state[2] = posmod(h.state[2] + shift, len(HUD.level.spawn))
	h.position = HUD.level.spawn[h.state[2]]

func ko(hero: int) -> void:
	var over: bool = true
	for i in Def.ENEMY:
		over = over and HUD._status != null and Bit.of(HUD.status.state[i], Def.DEAD)
	if over:
		HUD.level.group.spectrum()
	else:
		HUD.level.entity[hero].animation.play_coma()

func transport_entity(hero: int) -> void:
	if HUD.entity[hero].is_in_group("enemy"):
		transport(hero)
	else:
		ko(hero)
	HUD.status.state[hero] = Bit.to0(HUD.status.state[hero], Def.DEAD)

func diffusion() -> void:
	for hero in len(HUD.entity):
		if Bit.of(HUD.status.state[hero], Def.DEAD):
			transport_entity(hero)

func decide(a: int, b: int, segment: float) -> float:
	return 1.0 / (color[a] - color[b]) * (segment - color[b])

func _between(a: int, segment: float, b: int) -> bool:
	return color[a] > segment and segment >= color[b]

func react(hero: int) -> void:
	var segment: float = HUD.points[hero] / HUD.maximum[hero]
	aura[LAST_THICKNESS] = segment * THICKNESS + 3
	set_material(hero, &"shader_parameter/line_color", last_color)
	if segment <= color[RED]:
		last_color = Color.from_rgba8(SET, NO, NO, SEMI)
	elif segment >= color[BLUE]:
		last_color = Color.from_rgba8(NO, SET, SET, SEMI)
	elif _between(BLUE, segment, GREEN):
		last_color = Color.from_rgba8(NO, SET, int(SET * decide(BLUE, GREEN, segment)), SEMI)
	elif _between(GREEN, segment, YELLOW):
		last_color = Color.from_rgba8(int((1.0 - decide(GREEN, YELLOW, segment)) * SET), SET, NO, SEMI)
	else:
		last_color = Color.from_rgba8(SET, int(SET * decide(YELLOW, RED, segment)), NO, SEMI)

func set_material(hero: int, param: StringName, value: Variant) -> void:
	HUD.level.entity[hero].profile.material.set(param, value)

func set_points(hero: int, type: int, amount: int) -> void:
	var pts: int = clampi(HUD.points[hero][type] + amount, NO, HUD.maximum[hero][type])
	var no: int = hero * BARS + type * BAR_TYPE
	for i in range(no, no + BAR_TYPE):
		HUD.game.points[i].value = pts

func transfusion(hero: int) -> void:
	var no: int = hero * BAR_TYPE
	_reaction[no] = HUD.aura_time.create_tween()
	_reaction[no].tween_method(func():
		set_material(hero, &"shader_parameter/line_color", last_color)
		set_material(hero, &"shader_parameter/line_thickness", aura[LAST_THICKNESS]),
	0.0, 1.0, 1)

func affect_aura(hero: int, amount: int = -1) -> void:
	set_points(hero, Vector2.Axis.AXIS_X, amount)
	HUD.status.state[hero] = Bit.to(HUD.status.state[hero], Def.DEAD, HUD.points[hero] == NO)
	HUD.game.set_hp(hero, HUD.points)
	if Bit.of(HUD.status.state[hero], Def.DEAD) and HUD.entity[hero].is_in_group(&"enemy"):
		HUD.aura_time.start()
	else:
		transfusion(hero)

func costly(hero: int, cost: int) -> bool: return HUD.points[hero] - cost < NO
# TODO FIXME difficulty infinite usage
# func infinite() -> bool: return Bit.of_field(HUD.settings_state, Def.DIFFICULTY) == Def.CASUAL

func _react_resource(hero: int) -> Callable:
	return func(value: float):
		set_material(hero, &"shader_parameter/ap", HUD.points[hero].y)
		if value == 1.0:
			HUD.level.entity[hero].state[RESOURCE] = Bit.to0(HUD.level.entity[hero].state[RESOURCE], hero)
			set_material(hero, &"shader_parameter/action", false)

func affect_resource(hero: int, amount: int = 1) -> void:
	set_points(hero, Vector2.Axis.AXIS_Y, amount)
	set_material(hero, &"shader_parameter/action", true)
	if not Bit.of(HUD.level.entity[hero].state[RESOURCE], hero):
		var no: int = hero * BAR_TYPE + RESOURCE_SHIFT
		HUD.level.entity[hero].state[RESOURCE] = Bit.to1(HUD.level.entity[hero].state[RESOURCE], hero)
		_reaction[no] = HUD.aura_time.create_tween()
		_reaction[no].tween_method(_react_resource(hero), 0.0, 1.0, 1.0)

func thrown(box: CharacterBody2D) -> void:
	if box.velocity != Vector2.ZERO: affect_aura(10)
