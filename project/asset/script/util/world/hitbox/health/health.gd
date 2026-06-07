class_name AuraResource extends RefCounted

enum { BLUE, NO = 0, AURA = 0, LIFE_BORDER = 0, WAVE = 0, THICK = 0, GREEN, COLOR = 1, AP = 1,
	PERIOD = 1, DURATION = 1, YELLOW, TRANSPORT = 2, SUMMARY = 2, RESOURCE = 2, THICKNESS = 2, RED,
	RESOURCE_VALUE = 3, LAST_THICKNESS = 3, CRITICAL = 4, MAX = 10, SEMI = 100, SET = 255 }

const param: PackedStringArray = [&"shader_parameter/line_thickness", &"shader_parameter/line_color"]
const color: PackedFloat32Array = [1.0, 0.8, 0.4, 0.0]

var max_points: PackedByteArray = [0, 0]
var points: PackedByteArray = [0, 0]
var max_resource: PackedByteArray = [0, 0]
var resource: PackedByteArray = [0, 0]

var state: PackedByteArray
var _aura: Array[Tween]
var _resource: Array[Tween]
var damage: PackedByteArray = [0, 1, 0]
var aura: PackedFloat32Array = [0.7, 0.1, 2.0, 5.0, 0.1]
var last_color: Color

func setup() -> void: HUD.aura_time.timeout.connect(diffusion) # burns - blink

func transport(hero: int) -> void:
	HUD.level.entity[hero].animation.transport()
	HUD.level.entity[hero].process_mode = Node.PROCESS_MODE_DISABLED
	var shift: int = 1 if Bit.of(state[TRANSPORT], hero) else -1
	HUD.level.entity[hero].state[2] = posmod(HUD.level.entity[hero].state[2] + shift, len(HUD.level.spawn))
	HUD.level.entity[hero].position = HUD.level.spawn[HUD.level.entity[hero].state[2]]

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
	set_material(hero, COLOR, last_color)
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

func set_material(hero: int, type: int, value: Variant) -> void:
	HUD.level.entity[hero].profile.material.set(param[type], value)

func set_points(hero: int, type: int, amount: int) -> void:
	HUD.status.set_points(hero, type, clampi(HUD.points[hero][type] + amount, NO, HUD.maximum[hero][type]))

func transfusion(hero: int) -> void:
	_aura[hero] = HUD.aura_time.create_tween()
	_aura[hero].tween_method(func():
		set_material(hero, COLOR, last_color)
		set_material(hero, THICK, aura[LAST_THICKNESS]),
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
		set_material(hero, RESOURCE_VALUE, HUD.points[hero].y)
		if value == 1.0:
			state[RESOURCE] = Bit.to0(state[RESOURCE], hero)
			set_material(hero, RESOURCE, false)

func affect_resource(hero: int, amount: int = 1) -> void:
	set_points(hero, Vector2.Axis.AXIS_Y, amount)
	set_material(hero, RESOURCE, true)
	if not Bit.of(state[RESOURCE], hero):
		state[RESOURCE] = Bit.to1(state[RESOURCE], hero)
		_resource[hero] = HUD.aura_time.create_tween()
		_resource[hero].tween_method(_react_resource(hero), 0.0, 1.0, 1.0)

func thrown(box: CharacterBody2D) -> void:
	if box.velocity != Vector2.ZERO: affect_aura(10)
