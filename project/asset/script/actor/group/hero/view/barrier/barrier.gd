extends Button

const ATB: Color = Color8(255, 255, 150, 255)
const TIME: float = 0.25

@onready var barrier: ColorRect = $barrier

func set_fill(horizont: Control.SizeFlags, vertical: Control.SizeFlags) -> void:
	barrier.size_flags_horizontal = horizont
	barrier.size_flags_vertical = vertical

func set_direction(dir: Vector2) -> void:
	match dir:
		Vector2.ZERO: return
		Vector2(1, 0), Vector2(1, -1): set_fill(Control.SIZE_SHRINK_END, Control.SIZE_FILL)
		Vector2(0, 1), Vector2(1, 1): set_fill(Control.SIZE_FILL, Control.SIZE_SHRINK_END)
		Vector2(-1, 0), Vector2(-1, 1): set_fill(Control.SIZE_SHRINK_BEGIN, Control.SIZE_FILL)
		Vector2(0, -1), Vector2(1, 1): set_fill(Control.SIZE_FILL, Control.SIZE_SHRINK_BEGIN)

func set_atb(portion: float) -> void:
	print("ATB PORTION: ", portion)

func set_block() -> void:
	create_tween().tween_property(barrier, "color", ATB, TIME)

func appear(ui: Control) -> void: ui.modulate = Color.WHITE


signal sync_view(hero: Node2D)

@export var is_hero: bool = false

@onready var profile: AnimatedSprite2D = $profile
@onready var shadow: Sprite2D = $shadow
@onready var animation: AnimationTree = $animation
# @onready var barrier: VBoxContainer = $barrier
# @onready var ap: TextureProgressBar = $influence
@onready var whip: Sprite2D = $whip

var _mirror: AnimatedSprite2D = null
var mirror: AnimatedSprite2D:
	get:
		if _mirror == null:
			var caption: String = get_parent().name
			_mirror = load(Def.mirror % caption).instantiate()
			shadow.add_sibling(_mirror)
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

func _ready() -> void: visible = is_hero; mirror.sync(profile)

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
