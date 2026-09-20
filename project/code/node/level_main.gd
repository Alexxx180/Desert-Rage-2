extends Control

@onready var exit: Button = $hud/options/game/exit
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
var is_start: bool = false

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
		remove_child(shadow); caption.add_sibling(shadow)
		remove_child(caption); shadow.add_sibling(caption)
		shadow.color = Color.BLACK
		settings.pressed.connect(HUD.game_settings)
		start.pressed.connect(game_start)
		difficulty.pressed.connect(difficulty_select)
		exit.pressed.connect(HUD.game_exit))

func logo_show() -> void:
	match i:
		0: _change_state(&"res://icon/logo/godot.svg")
		1: _change_state(&"res://icon/logo/logo.svg")
		_: logo_hide()

func _ready() -> void: # if Bit.of(settings, LOGO): .. logo_hide()
	logo_show()
	exit.pressed.connect(HUD.game_exit)
	start.pressed.connect(HUD.game_start)

func game_start() -> void:
	if is_start:
		HUD.game_start()
	else:
		HUD.game_continue()

func game_exit() -> void: tree.quit() # stats
func difficulty_select() -> void: pass
