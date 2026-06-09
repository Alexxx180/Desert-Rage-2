extends Button

const ATB: Color = Color8(255, 255, 150, 255)
const TIME: float = 0.25

@onready var barrier: ColorRect = $barrier

func set_atb(portion: float) -> void:
	print("ATB PORTION: ", portion)

func set_block() -> void:
	create_tween().tween_property(barrier, "color", ATB, TIME)

func appear(ui: Control) -> void: ui.modulate = Color.WHITE


signal sync_view(hero: Node2D)

@onready var profile: AnimatedSprite2D = $profile
@onready var shadow: Sprite2D = $shadow
@onready var animation: AnimationTree = $animation
@onready var whip: Sprite2D = $whip

var _mirror: AnimatedSprite2D = null
var mirror: AnimatedSprite2D:
	get:
		if _mirror == null:
			_mirror = load(Def.ray_mirror).instantiate()
			shadow.add_sibling(_mirror)
			profile.animation_changed.connect(HUD.level.animation.mirror_animation)
			profile.frame_changed.connect(HUD.level.animation.mirror_frame)
		return _mirror

var param: Dictionary = {
	"thick": "shader_parameter/line_thickness",
	"color": "shader_parameter/line_color",
	"invis": "shader_parameter/invisible",
	"ability": "shader_parameter/ability",
	"ap": "shader_parameter/ap"
}

func move(direction: Vector2) -> void:
	animation.move(direction)
	barrier.set_direction(direction)

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
	if invisible: set_aura(Color("FFFFFF7F"), 3)
	else: set_aura(Color("FFFFFF00"), 0)
	
func _go_behind_scene(_curtain: TileMapLayer) -> void: _set_invis(true) # MOVE & CONNECT TO LINK
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
