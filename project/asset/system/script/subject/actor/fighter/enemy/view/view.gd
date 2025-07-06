extends Node2D

@export var outline: Shader
@onready var profile: AnimatedSprite2D = $profile
@onready var animation: AnimationTree = $animation

func _ready() -> void:
	profile.material = ShaderMaterial.new()
	profile.material.set("shader", outline)
