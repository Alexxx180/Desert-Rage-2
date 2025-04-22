extends Control

@onready var experience: Button = $experience
@onready var controls: Button = $controls

func toggle_buttons() -> void:
	experience.visible = !experience.visible
	controls.visible = !controls.visible

func set_transition(options: VBoxContainer) -> void:
	experience.pressed.connect(options.switch_controls)
	experience.pressed.connect(toggle_buttons)
	controls.pressed.connect(options.switch_experience)
	controls.pressed.connect(toggle_buttons)
