"""
extends ActionsControl

func get_escapes() -> Dictionary: return keys.mouses

func new_controls(act: String) -> void:
	var event := InputEventMouseButton.new()
	event.button_index = actions[act]
	event.pressed = true
	_set_event(act, event)

func set_mask() -> ActionsControl:
	return m("CF", [[ACT.UI_LMB]]).m("AY", [[ACT.UI_LMB]])

func _ready() -> void:
	super._ready()
	actions = {
		a(ACT.HANDS): [MOUSE_BUTTON_LEFT],
		a(ACT.LEGS): [MOUSE_BUTTON_RIGHT],
		a(ACT.SKILL_ONE): [MOUSE_BUTTON_WHEEL_DOWN],
		a(ACT.SKILL_TWO): [MOUSE_BUTTON_WHEEL_UP],
		a(ACT.MOVEMENT): [MOUSE_BUTTON_LEFT],
		a(ACT.FIRE): [MOUSE_BUTTON_RIGHT, MOUSE_BUTTON_LEFT],
		a(ACT.UI_LMB): [MOUSE_BUTTON_LEFT]
		#, # a.GD: MOUSE_BUTTON_LEFT, # a.GT: MOUSE_BUTTON_LEFT,
	}
"""
