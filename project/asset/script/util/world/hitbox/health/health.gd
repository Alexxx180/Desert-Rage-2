class_name AuraResource extends RefCounted

enum { NO = 0, MAX = 10, SEMI = 100, SET = 255 }
enum { BLUE, GREEN, YELLOW, RED }
enum { THICK, COLOR, RESOURCE, RESOURCE_VALUE }
enum { LIFE_BORDER, PERIOD, SUMMARY }
enum { WAVE, DURATION, THICKNESS, LAST_THICKNESS, CRITICAL }

const param: PackedStringArray = ["shader_parameter/line_thickness", "shader_parameter/line_color"]
const color: PackedFloat32Array = [1.0, 0.8, 0.4, 0.0]

var state: PackedByteArray
var _aura: Array[Tween]
var _resource: Array[Tween]
var damage: PackedByteArray = [0, 1, 0]
var aura: PackedFloat32Array = [0.7, 0.1, 2.0, 5.0, 0.1]
var last_color: Color
var last_thickness: float

var status: GameStatuses

func setup() -> void: HUD.aura_time.timeout.connect(diffusion) # burns - blink

func transport() -> void:
	HUD.level.
	pass

func ko(hero: int) -> void:
	var over: bool = true
	for i in len(Def.ENEMY):
		over = over and Bit.of(HUD.state[i], Def.DEAD)
	if over:
		HUD.level.group.spectrum()
	else:
		HUD.level.entity[hero].animation.play_coma()

func transport_entity(hero: int) -> void:
	if HUD.entity[hero].is_in_group("enemy"):
		transport(hero)
	else:
		ko(hero)
	HUD.state[hero] = Bit.to(HUD.state[hero], Def.DEAD, false)

func diffusion() -> void:
	for hero in len(HUD.entity):
		if Bit.of(HUD.state[hero], Def.DEAD):
			transport_entity(hero)

func decide(a: int, b: int, segment: float) -> float:
	return 1.0 / (color[a] - color[b]) * (segment - color[b])

func _between(a: int, segment: float, b: int) -> bool:
	return color[a] > segment and segment >= color[b]

func react(hero: int) -> void:
	var segment: float = HUD.points[hero] / HUD.maximum[hero]
	last_thickness = segment * THICKNESS + 3
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
		set_material(hero, THICK, last_thickness),
	0.0, 1.0, 1)

func affect_aura(hero: int, amount: int = -1) -> void:
	set_points(hero, Vector2.Axis.AXIS_X, amount)
	HUD.state[hero] = Bit.to(HUD.state[hero], Def.DEAD, HUD.points[hero] == NO)
	HUD.game.set_hp(hero, HUD.points)
	if Bit.of(HUD.state[hero], Def.DEAD) and HUD.entity[hero].is_in_group(&"enemy"):
		HUD.aura_time.start()
	else:
		transfusion()

func costly(hero: int, cost: int) -> bool: return HUD.points[hero] - cost < NO

func infinite() -> bool: return Bit.of_field(HUD.settings_state, Def.DIFFICULTY) == Def.CASUAL

func _react_resource(hero: int) -> Callable:
	return func(value: float):
		set_material(hero, RESOURCE_VALUE, HUD.points[hero].y)
		if value == 1.0:
			state[RESOURCE] = Bit.to(state[RESOURCE], hero, false)
			set_material(hero, RESOURCE, false)

func affect_resource(hero: int, amount: int = 1) -> void:
	set_points(hero, Vector2.Axis.AXIS_Y, amount)
	set_material(hero, RESOURCE, true)
	if not Bit.of(state[RESOURCE], hero):
		state[RESOURCE] = Bit.to(state[RESOURCE], hero, true)
		_resource[hero] = HUD.aura_time.create_tween()
		_resource[hero].tween_method(_react_resource(hero), 0.0, 1.0, 1.0)

func thrown(box: CharacterBody2D) -> void:
	if box.velocity != Vector2.ZERO: affect_aura(10)
