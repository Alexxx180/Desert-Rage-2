extends Node2D

signal sync_view(hero: Node2D)

@export var is_hero: bool = false

@onready var profile: AnimatedSprite2D = $profile
@onready var shadow: Sprite2D = $shadow
@onready var animation: AnimationTree = $animation
# @onready var ap: TextureProgressBar = $influence
@onready var whip: Sprite2D = $whip

var param: Dictionary = {
	"thick": "shader_parameter/line_thickness",
	"color": "shader_parameter/line_color",
	"invis": "shader_parameter/invisible",
	"ability": "shader_parameter/ability",
	"ap": "shader_parameter/ap"
}

func _ready() -> void: visible = is_hero

func set_aura(next_color: Color, thickness: float) -> void:
	profile.material.set(param.thick, thickness)
	profile.material.set(param.color, next_color)

func show_ap(value: float) -> void:
	profile.material.set(param.ability, true)
	profile.material.set(param.ap, value)

func hide_ap() -> void:
	profile.material.set(param.ability, false)

func _set_invis(invisible: bool) -> void:
	profile.material.set(param.invis, invisible)
	if invisible: set_aura(Color("FFFFFFFF"), 3)
	else: set_aura(Color("FFFFFF00"), 0)
	
func _go_behind_scene(_curtain: TileMapLayer) -> void: _set_invis(true)
func _go_on_scene(_curtain: TileMapLayer) -> void: _set_invis(false)

func sync_image(hero: Node2D) -> void:
	animation.syncer.sync(hero.animation)

func update_image() -> void:
	sync_view.emit(self)
 
func enable_sync(_seat: Node, hero: CharacterBody2D) -> void:
	#visible = true
	hero.to.act.moving.connect(animation.move)
	hero.view.sync_view.connect(sync_image)
	hero.view.update_image()
	#TODO: Comment: actual only for builds without character separation
	#profile.modulate = hero.modulate

func disable_sync(_seat: Node, hero: CharacterBody2D) -> void:
#	visible = false
	hero.view.sync_view.disconnect(sync_image)
	hero.to.act.moving.disconnect(animation.move)
