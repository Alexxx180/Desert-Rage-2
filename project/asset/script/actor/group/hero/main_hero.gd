extends CharacterBody2D

@onready var lever: Area2D = $lever
@onready var plate: Area2D = $plate
@onready var profile: AnimatedSprite2D = $profile
@onready var shadow: Sprite2D = $shadow
@onready var animation: Timer = $animation
# @onready var animation: AnimationTree = $animation

var _mirror: AnimatedSprite2D = null
var mirror: AnimatedSprite2D:
	get: return HUD.animation.get_mirror_sprite(self, Def.ray_mirror, _mirror)

var state: PackedInt32Array = [0, 0, 0]
var boxes: PackedByteArray = []
var is_monitoring: bool: set = set_monitoring

func stop_animation() -> void:
	HUD.animation.stop_animation()

func _ready() -> void:
	animation.timeout.connect(stop_animation)
	plate.body_entered.connect(HUD.level.plate_encounter)
	plate.body_exited.connect(HUD.level.plate_diverge)
	lever.body_entered.connect(HUD.level.lever_encounter)
	lever.body_exited.connect(HUD.level.lever_diverge)

func set_monitoring(value: bool) -> void:
	lever.monitoring = value
	plate.monitoring = value

func make_velocity(motion: Vector2) -> void: 
	velocity = motion

func make_position(motion: Vector2) -> void: position = motion
func _physics_process(_delta: float) -> void: move_and_slide()
