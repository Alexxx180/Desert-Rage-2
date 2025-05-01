extends Control

@onready var experience: Button = $experience
@onready var controls: Button = $controls

func toggle_buttons() -> void:
	experience.visible = !experience.visible
	controls.visible = !controls.visible

func set_shortcut(hud: CanvasLayer) -> void:
	hud.visibility_changed.connect(func():
		Processors.turn(experience.short, hud.visible and experience.visible)
		Processors.turn(controls.short, hud.visible and controls.visible)
	)
	experience.visibility_changed.connect(func():
		Processors.turn(experience.short, hud.visible and experience.visible)
	)
	controls.visibility_changed.connect(func():
		Processors.turn(controls.short, hud.visible and controls.visible)
	)

func set_transition(options: VBoxContainer) -> void:
	experience.pressed.connect(options.switch_controls)
	controls.pressed.connect(options.switch_experience)
	for control in [experience, controls]:
		control.pressed.connect(toggle_buttons)
