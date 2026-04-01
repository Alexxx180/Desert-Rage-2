extends Node

const THICKNESS: int = 2
const WAVE: float = 0.7
const DURATION: float = 0.1

@onready var timer: Timer = $blink

var param: Dictionary = {
	"thick": "shader_parameter/line_thickness",
	"color": "shader_parameter/line_color"
}
var last_color: Color
var last_thickness: float = 5.0
var blinked: bool = false
var colors: AuraHealthColor = AuraHealthColor.new()
var entity: CharacterBody2D
var tween: Tween

var material: ShaderMaterial:
	get: return entity.view.profile.material

func react(segment: float) -> void:
	last_color = colors.get_color(segment)
	last_thickness = segment * THICKNESS + 3
	material.set(param.color, last_color)
	if segment < 0.1:
		start_blinking()

func aura_waving(offset: float) -> void:
	material.set(param.thick, last_thickness + offset * WAVE) #  * 0.75

func diffusion() -> void:
	# DIFFUSE SETTINGS
	material.set(param.color, colors.diffuse())
	#pass

func is_blinking() -> bool: return not timer.is_stopped()
func start_blinking() -> void: timer.start()
func stop_blinking() -> void: timer.stop()

func _ready() -> void:
	tween = create_tween()
	tween.set_loops()
	tween.tween_method(aura_waving, 0.0, 0.9, DURATION)

func blink() -> void:
	blinked = !blinked
	if blinked:
		material.set(param.color, Color.TRANSPARENT)
	else:
		material.set(param.color, last_color)
