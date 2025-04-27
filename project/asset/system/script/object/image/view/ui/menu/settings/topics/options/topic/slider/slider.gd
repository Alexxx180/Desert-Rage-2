extends HSlider

signal hold_focus(status: bool)

@onready var submit: Button = $margin/music/volume/state/info/manual
@onready var manual: Node = $manual

var _manual: bool = false
var _grabber: Texture2D = preload("res://asset/resource/engine/internal/shape/texture/grabber.tres")

func _ready() -> void:
	value_changed.connect(func(v):
		submit.text = str(v)#str(v, "%")
		if v == 100:
			add_theme_icon_override("grabber", _grabber)
		else:
			add_theme_icon_override("grabber", Defaults.TEXTURE)
	)

func focus() -> void: manual.grab_focus()

func reset(next: int) -> void:
	value = clampi(next, 0, 100)
	value_changed.emit(value)

func append(tick: int) -> void:
	reset(value + tick)

func focus_manual() -> void:
	set_manual(true)
	submit.release_focus()

func set_manual(next: bool) -> void:
	_manual = next
	Processors.turn(manual, _manual)
	hold_focus.emit(!next)

func _input(event: InputEvent) -> void:
	if not _manual: return
	if event is InputEventMouseButton:
		set_manual(false)
		return
	
	for action in ["ui_cancel", "ui_accept", "list_right", "list_left", "list_up", "list_down"]:
		if Input.is_action_just_pressed(action):
			set_manual(false)
			if action == "ui_accept":
				submit.find_next_valid_focus()
			else:
				submit.grab_focus()
			return
	
