extends Node

const THICKNESS: int = 2

@onready var timer: Timer = $blink

var param: Dictionary = {
	"thick": "shader_parameter/line_thickness",
	"color": "shader_parameter/line_color"
}
var last_color: Color
var blinked: bool = false
var colors: AuraHealthColor = AuraHealthColor.new()
var entity: CharacterBody2D

var material: ShaderMaterial:
	get: return entity.view.profile.material

func react(segment: float) -> void:
	last_color = colors.get_color(segment)
	material.set(param.thick, segment * THICKNESS + 3)
	material.set(param.color, last_color)
	if segment < 0.1:
		start_blinking()

func diffusion() -> void:
	material.set(param.color, colors.diffuse())

func is_blinking() -> bool: return not timer.is_stopped()
func start_blinking() -> void: timer.start()
func stop_blinking() -> void: timer.stop()

func blink() -> void:
	blinked = !blinked
	if blinked:
		material.set(param.color, Color.TRANSPARENT)
	else:
		material.set(param.color, last_color)
