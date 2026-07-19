extends Timer

@onready var ui: Control = get_parent()
@onready var modulator: Node = $modulator

func _ready():
	if ui.has_method("disappear"):
		timeout.connect(ui.disappear)
	else:
		timeout.connect(disappear)

func disappear() -> Tween:
	return modulator.disappear(ui)

func appear() -> void:
	modulator.appear(ui)
	start()


extends Node

const TIME: float = 0.25
const MARGIN: int = 20

var appeared: bool = false
@onready var m: MarginContainer = get_node("../content/margin")

func set_margin(v: int) -> void:
	m.add_theme_constant_override("margin_top", -v)
	m.add_theme_constant_override("margin_bottom", v)

func disappear(ui: Control) -> Tween:
	appeared = false
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_method(set_margin, 0, MARGIN, TIME)
	tween.tween_property(ui, "modulate", Color.TRANSPARENT, TIME)
	return tween

func appear(ui: Control) -> Tween:
	var tween: Tween = create_tween()
	if not appeared:
		tween.set_parallel(true)
		tween.tween_property(ui, "modulate", Color.WHITE, TIME)
		tween.tween_method(set_margin, MARGIN, 0, TIME)
		appeared = true
	return tween


extends Node

@export_range(0.5, 4.0, 0.5) var time: float = 0.75

func disappear(ui: Control) -> Tween:
	var tween: Tween = create_tween()
	tween.tween_property(ui, "modulate", Color.TRANSPARENT, time)
	return tween

func appear(ui: Control) -> void:
	ui.modulate = Color.WHITE


class_name ControlTimeHooder extends Timer

const TIME: float = 0.5

@export var fix_on_press: bool = false
@export var target_path: String = ".."

var state: Control
var target: Control
var fixed: bool = false

func _ready() -> void:
	state = get_parent()
	target = get_node(target_path)
	if fix_on_press: state.pressed.connect(set_fixed)
	for s in [state.focus_entered, state.mouse_entered]: s.connect(in_focus)
	for s in [state.focus_exited, state.mouse_exited]: s.connect(out_focus)
	_start_hide()

func _change_state(color: Color) -> void:
	create_tween().tween_property(target, "modulate", color, TIME)

func set_fixed() -> void:
	fixed = !fixed
	if fixed:
		_stop_hide()

func out_focus() -> void: if not fixed: _start_hide()
func in_focus() -> void: _stop_hide()

func _start_hide() -> void:
	start()

func _stop_hide() -> void:
	stop()
	_show_pause()

func _show_pause() -> void: _change_state(Color.WHITE)

func hide_pause() -> void: _change_state(Color.TRANSPARENT)



extends Node

@onready var caption: RichTextLabel = get_parent().get_locale()
@onready var locale: String = caption.text
@export var keys: Array[String] = ["KAL+KAU+KAD+KAR", "KB"]

func merge_controls(help: String) -> String:
	if not help.contains("+"): return tr(help)
	
	var result: String = ""
	for text in help.split("+"): result += tr(text)
	return result

func update_locale() -> void:
	var result: Array[String] = []
	for key in keys: result.append(merge_controls(key))
	caption.text = tr(locale) % result

func _ready() -> void: update_locale()
