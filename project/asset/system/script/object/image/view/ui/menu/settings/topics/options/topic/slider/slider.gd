extends HSlider

class_name FocusedSlider

signal hold_focus(status: bool)

@onready var submit: Button = $margin/music/volume/state/info/manual
@onready var manual: Node = $manual

var _manual: bool = false
var released: bool:
	get: return not _manual
var _grabber: Texture2D = preload("res://asset/resource/engine/internal/shape/image/texture/grabber.tres")

func _ready() -> void:
	value_changed.connect(func(v: int):
		submit.text = str(v)#str(v, "%")
		if v == max_value:
			add_theme_icon_override("grabber", _grabber)
		else:
			add_theme_icon_override("grabber", Defaults.TEXTURE)
	)

func get_root() -> String: return "../../../../../../"

func get_neighbor() -> String:
	return "../" + name + "/margin/music/volume/state/info/manual"

func set_neighbor(left: String, right: String) -> void:
	var root: String = get_root()
	submit.focus_neighbor_left = root + left
	submit.focus_neighbor_right = root + right

func focus() -> void: manual.grab_focus()

func set_to(next: int) -> void:
	value = next
	value_changed.emit(value)

func safe_set(next: int) -> void:
	set_to(clampi(next, int(min_value), int(max_value)))

func append(tick: int) -> void:
	safe_set(int(value) + tick)

func focus_manual() -> void:
	set_manual(true)
	submit.release_focus()

func set_manual(next: bool) -> void:
	_manual = next
	Processors.turn(manual, _manual)
	hold_focus.emit(!next)

func check_actions(_event: InputEvent) -> void:
	var actions: Array[String] = ["ui_cancel", "ui_accept", "list_right",
		"list_left", "list_up", "list_down", "ui_focus_next", "ui_focus_prev"]
	var i: int = actions.size() - 1
	var minimum: int = -1
	while i > minimum and not Input.is_action_just_pressed(actions[i]):
		i -= 1
	if i > minimum:
		set_manual(false)
		match actions[i]:
			"ui_accept": submit.find_next_valid_focus().grab_focus()
			#"ui_focus_next": submit.find_next_valid_focus().grab_focus()
			#"ui_focus_prev": submit.find_prev_valid_focus().grab_focus()
			_: submit.grab_focus()

func _input(event: InputEvent) -> void:
	if not _manual: return
	if event is InputEventMouseButton:
		set_manual(false)
	else:
		check_actions(event)
