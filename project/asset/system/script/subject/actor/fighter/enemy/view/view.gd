extends Node2D

@export var outline: Shader
@onready var timer: Timer = $timer
@onready var profile: AnimatedSprite2D = $profile
@onready var animation: AnimationTree = $animation
@onready var sand: GPUParticles2D = $particle

var hit_direction: int = 1

func _ready() -> void:
	profile.material = ShaderMaterial.new()
	profile.material.set("shader", outline)

func hit(_damage: int) -> void:
	skew = deg_to_rad(randf_range(4.0, 18.0) * hit_direction)
	hit_direction *= -1
	sand.process_material.direction.x = hit_direction
	sand.appear()
	timer.start()
	# create_tween().tween_property(self, "skew", deg_to_rad(0), 1.5)

func normalize_skew() -> void: skew = 0
