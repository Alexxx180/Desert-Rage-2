extends Control
"""
@onready var experience: Button = $experience
@onready var controls: Button = $controls

func toggle_buttons() -> void:
	experience.visible = !experience.visible
	controls.visible = !controls.visible

func toggle(exp, hud) -> Callable:
	return func(): Works.turn(exp.short, hud.visible and exp.visible)

func set_shortcut(hud: CanvasLayer) -> void:
	hud.visibility_changed.connect(func(): for i in [experience, controls]: toggle(i, hud))
	experience.visibility_changed.connect(toggle(experience, hud))
	controls.visibility_changed.connect(toggle(controls, hud))

func set_transition(options: VBoxContainer) -> void:
	experience.pressed.connect(options.switch_controls)
	controls.pressed.connect(options.switch_experience)
	for control in [experience, controls]:
		control.pressed.connect(toggle_buttons)
"""
