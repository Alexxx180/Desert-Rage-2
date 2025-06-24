extends Node

enum { THICKNESS = 2, MAX = 100, SET = 255 }

var points: float = MAX
var param: Dictionary = { "thick": "shader_parameter/line_thickness", "color": "shader_parameter/line_color" }
var colors: Dictionary = { "BLUE": 1.0, "GREEN": 0.8, "YELLOW": 0.4, "RED": 0.0 }

@onready var entity: CharacterBody2D = get_node("../..")
@onready var timer: Timer = $timer
var material: ShaderMaterial:
	get: return entity.view.profile.material

func decide(a: String, b: String, portion: float) -> float:
	return 1.0 / (colors[a] - colors[b]) * (portion - colors[b])

func green(portion: float) -> float: return decide("BLUE", "GREEN", portion)
func yellow(portion: float) -> float: return 1.0 - decide("GREEN", "YELLOW", portion)
func red(portion: float) -> float: return decide("YELLOW", "RED", portion)

func set_color(portion: float) -> void:
	var property: String = param.color
	
	if portion == colors.BLUE:
		material.set(property, Color.from_rgba8(0, SET, SET))
	elif colors.GREEN <= portion and portion < colors.BLUE:
		material.set(property, Color.from_rgba8(0, SET, int(green(portion) * SET)))
	elif colors.YELLOW <= portion and portion < colors.GREEN:
		material.set(property, Color.from_rgba8(int(yellow(portion) * SET), SET, 0))
	elif portion == colors.RED:
		material.set(property, Color.from_rgba8(SET, 0, 0))
	else: # ORANGE
		material.set(property, Color.from_rgba8(SET, int(red(portion) * SET), 0))

func hit(damage: int = 1) -> void:
	if points <= 0: return
	points = max(points - damage, 0)
	var portion: float = points / MAX
	material.set(param.thick, portion * THICKNESS + 3)
	set_color(portion)
	if points <= 0 and entity.name == "eye-seeker": entity.queue_free()
	timer.start()

func aura_diffusion() -> void:
	material.set(param.color, Color.from_rgba8(0, 0, 0, 0))
	#material.set(param.thick, 1.5)
