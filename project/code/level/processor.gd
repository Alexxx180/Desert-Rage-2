extends Control

@onready var difficulty: Button = $hud/options/game/difficulty
@onready var settings: Button = $hud/options/game/settings
@onready var start: Button = $hud/options/game/start
@onready var cursor: TextureButton = $hud/cursor
@onready var fire: GPUParticles2D = $hud/cursor/particle
@onready var caption: Label = $caption
@onready var logo: TextureRect = $shadow/logo
@onready var shadow: ColorRect = $shadow
@onready var tree: SceneTree = get_tree()

var found: int = 255
var temp: Tween = null

func _input(event: InputEvent) -> void:
	if temp == null: return
	if (event is InputEventJoypadButton or event is InputEventKey
		or event is InputEventMouseButton) and event.pressed:
		if temp.is_valid():
			temp.kill()
			logo_hide()
		temp = null

var i: int = 0

func _change_state(path: StringName) -> void:
	logo.texture = ImageTexture.create_from_image(Image.load_from_file(path))
	temp = create_tween() # var t: Tween
	temp.tween_property(logo, ^"modulate", Color.WHITE, 1.5)
	temp.tween_callback(func():
		temp = create_tween()
		temp.tween_property(logo, ^"modulate", Color.BLACK, 1).set_delay(i)
		temp.tween_callback(logo_show))
	i += 1

func logo_hide() -> void:
	var t: Tween = create_tween()
	t.tween_property(shadow, ^"color", Color(0, 0, 0, 0), 2)
	logo.queue_free()
	fire.emitting = true
	t.tween_callback(func():
		remove_child(shadow) ; caption.add_sibling(shadow)
		remove_child(caption) ; shadow.add_sibling(caption)
		shadow.color = Color.BLACK
		settings.pressed.connect(game_continue)
		start.pressed.connect(game_start)
		difficulty.pressed.connect(game_exit))

func logo_show() -> void:
	match i:
		0: _change_state(&"res://icon/logo/godot.svg")
		1: _change_state(&"res://icon/logo/logo.svg")
		_: logo_hide()

func _ready() -> void: # if Bit.of(settings, LOGO): .. logo_hide()
	logo_show()

func game_exit() -> void: tree.quit() # stats
func game_start() -> void: print_debug(tree.change_scene_to_file(Def.first_level))
func game_continue() -> void: pass # if not stats.load_progress(): stats.load_scene(Def.first_level)
