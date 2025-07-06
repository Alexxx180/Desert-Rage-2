extends Node

const THICKNESS: int = 2

var param: Dictionary = {
	"thick": "shader_parameter/line_thickness",
	"color": "shader_parameter/line_color"
}
var colors: AuraHealthColor = AuraHealthColor.new()
var entity: CharacterBody2D

var material: ShaderMaterial:
	get: return entity.view.profile.material

func react(segment: float) -> void:
	material.set(param.thick, segment * THICKNESS + 3)
	material.set(param.color, colors.get_color(segment))

func diffusion() -> void:
	material.set(param.color, colors.diffuse())
