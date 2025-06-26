extends Node

signal dead()

const THICKNESS: int = 2

@export var entity_path: String = "../../../.."
@export_range(1, 500, 1, "Define entity HP") var points: float = 100

var param: Dictionary = { "thick": "shader_parameter/line_thickness", "color": "shader_parameter/line_color" }
var aura: AuraHealthColor = AuraHealthColor.new()
var max_points: int

@onready var entity: CharacterBody2D = get_node(entity_path)
@onready var timer: Timer = $timer

var material: ShaderMaterial:
	get: return entity.view.profile.material

func _ready() -> void: max_points = int(points)
func revive() -> void: points = max_points

func update_aura() -> void:
	var segment: float = points / max_points
	material.set(param.thick, segment * THICKNESS + 3)
	material.set(param.color, aura.get_color(segment))

func hit(damage: int = 1) -> void:
	if points <= 0: return
	points = max(points - damage, 0)
	update_aura()
	
	if points <= 0: dead.emit()
	timer.start()

func aura_diffusion() -> void:
	material.set(param.color, aura.diffuse())
