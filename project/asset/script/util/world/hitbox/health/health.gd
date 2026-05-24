class_name AuraResource extends RefCounted

enum { DEAD, FREEZE }

signal interrogation()

var state: int
LevelRoot

func _ready() -> void:
	HUD.aura_time.timeout.connect(burns)
	timeout.connect()
	diffuse.timeout.connect(diffusion)
	timeout.connect(blink)
	tween = create_tween()
	tween.set_loops()
	tween.tween_method(aura_waving, 0.0, 0.9, DURATION)

func diffusion() -> void:
	for i in len(HUD.entity):
		if HUD.level.points[i] <= aura[CRITICAL]:
			pass
		if Bit.of(HUD.entity[i], ):
			pass

func delay_diffuse() -> void:
	diffuse.start()
	material.set(param.color, colors.diffuse())

func thrown(box: CharacterBody2D) -> void:
	if box.logic.processors.movement.push.flying:
		hit(10)

func hit(amount: int = 1) -> void:
	print("points alive: ", points.alive)
	if points > damage[LIFE_BORDER]:
		if not _apply_damage(amount): points.hit()
	else:
		interrogate()

func interrogate() -> void:
	aura.delay_diffuse()
	interrogation.emit()

func is_dead(no_points: bool) -> bool:
	if no_points: points.death()
	aura.delay_diffuse()
	return no_points

func restore() -> void: refill(points.maximum)

func refill(amount: int = 1) -> void:
	points.refill(amount)
	aura.react(points.segment)
	aura.delay_diffuse()

func _apply_damage(amount: int = 1) -> bool:
	points.damage(amount)
	aura.react(points.segment)
	return is_dead(not points.alive)


func dead() -> void:
	damage[SUMMARY] = 0
	HUD.aura_time.stop()

func contact(damage: int) -> void:
	damage[SUMMARY] += damage
	if damage[SUMMARY] > 0 and is_stopped():
		HUD.aura_time.start()

func burns() -> void:
	if points.alive: _apply_damage(amount)
	
	damage[SUMMARY] = max(damage[SUMMARY] - period, 0)
	if damage[SUMMARY] == 0:
		HUD.aura_time.stop()

enum { LIFE_BORDER, PERIOD, SUMMARY }
enum { WAVE, DURATION, THICKNESS, LAST_THICKNESS, CRITICAL }
enum { THICK, COLOR }

var damage: PackedByteArray = [0, 1, 0]
var aura: PackedFloat32Array = [0.7, 0.1, 2.0, 5.0, 0.1]
var param: PackedStringArray = ["shader_parameter/line_thickness", "shader_parameter/line_color"]

var last_color: Color
var blinked: bool = false
var colors: AuraHealthColor = AuraHealthColor.new()
var entity: CharacterBody2D
var tween: Tween

var material: ShaderMaterial:
	get: return entity.view.profile.material

func react(no: int, segment: float) -> void:
	last_color = colors.get_color(segment)
	last_thickness = segment * THICKNESS + 3
	HUD.entity[no].view.profile.material.set(param.color, last_color)
	if segment < 0.1:
		start_blinking()

func aura_waving(offset: float) -> void:
	material.set(param.thick, last_thickness + offset * WAVE) #  * 0.75

func is_blinking() -> bool: return not HUD.aura_time.is_stopped()
func diffuse_start() -> void: HUD.aura_time.start()
func diffuse_stop() -> void: HUD.aura_time.stop()

func blink() -> void:
	blinked = !blinked
	if blinked:
		material.set(param.color, Color.TRANSPARENT)
	else:
		material.set(param.color, last_color)


signal update_bar(current: int)



var is_just_dead: bool = false
var is_dead: bool = false

func is_alive(no: int) -> void:
	return HUD.points[no] > damage[LIFE_BORDER]

var segment: float:
	get: return points / maximum

func set_contested_health() -> void: contested = int(points)

func setup(next: int) -> void:
	timeout.connect(set_contested_health)
	maximum = next
	contested = maximum
	points = next # maximum - 50 # TODO TEST JARS
#	update_bar.emit(points)

func revive() -> void: points = maximum

func refill(amount: int = 1) -> void:
	points = min(points + amount, maximum)
	update_bar.emit(points)
	is_dead = points == damage[LIFE_BORDER]

func damage(amount: int = 1) -> void:
	points = max(points - amount, damage[LIFE_BORDER])
	is_just_dead = points == damage[LIFE_BORDER] and not is_dead
	if is_just_dead: is_dead = true
	update_bar.emit(points)
	start()
