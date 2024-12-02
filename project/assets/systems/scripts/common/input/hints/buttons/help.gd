extends Button

@onready var hotkeys: HBoxContainer = $description/stack/hotkeys
@onready var state: HBoxContainer = $description/stack/state

func _ready() -> void:
	state.set_state(false)
	hotkeys.set_control_hint()

func _input(_event: InputEvent):
	hotkeys.set_control_hint()

func _on_help_show(closed: bool) -> void:
	state.set_state(!closed)
	hotkeys.set_control_hint()
