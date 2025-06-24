extends Node

enum { THICKNESS = 5, MAX = 100, SET = 255 }

var points: float = MAX
var param: Dictionary = { "thick": "shader_param/line_thickness", "color": "shader_param/line_color" }
var colors: Dictionary = { "BLUE": 1.0, "GREEN": 0.8, "YELLOW": 0.4, "RED": 0.0 }

@onready var entity: CharacterBody2D = get_node("../..")

func decide(a: String, b: String, portion: float) -> float:
	return 1.0 / (colors[a] - colors[b]) * (portion - colors[b])

func green(portion: float) -> float: return decide("BLUE", "GREEN", portion)
func yellow(portion: float) -> float: return 1.0 - decide("GREEN", "YELLOW", portion)
func red(portion: float) -> float: return decide("YELLOW", "RED", portion)

func set_color(material: ShaderMaterial, property: String, portion: float) -> void:
	if portion == colors.BLUE:
		material.set(property, Color.from_rgba8(0, SET, SET))
	elif colors.GREEN <= portion and portion < colors.BLUE:
		material.set(property, Color.from_rgba8(0, SET, green(portion) * SET))
	elif colors.YELLOW <= portion and portion < colors.GREEN:
		material.set(property, Color.from_rgba8(yellow(portion) * SET, SET, 0))
	elif portion == colors.RED:
		material.set(property, Color.from_rgba8(SET, 0, 0))
	else: # ORANGE
		material.set(property, Color.from_rgba8(SET, red(portion) * SET, 0))

func hit(damage: int = 1) -> void:
	if points <= 0: return
	points = max(points - damage, 0)
	var portion: float = points / MAX
	var material: ShaderMaterial = entity.view.profile.material
	material.set(param.thick, portion * THICKNESS + 2)
	set_color(material, param.color, portion)
	if points <= 0 and entity.name == "eye-seeker": entity.queue_free()
