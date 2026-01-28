extends ActionsControl

var device: Dictionary

func new_controls(act: String) -> void:
	var event := InputEventJoypadButton.new() # InputEventJoypadMotion
	event.button_index = actions[act]
	event.pressed = true
	_set_event(act, event)

func search_sticks(key: int) -> void:
	for k in keys.sticks:
		if key in keys.sticks[k]:
			word = k
			break

func translate_word(key: int) -> bool:
	if super.translate_word(key):
		if keys.pad.has(key) and keys.pad.has(device.type):
			word = keys.pad[device.type][word]
	else:
		search_sticks(key)
	return true

func set_mask() -> ActionsControl:
	return super.set_mask().m("MT", [[ACT.MOVEMENT], [ACT.LEGS]])

func _ready() -> void:
	super._ready()
	actions = {
		a(ACT.MOVEMENT): [JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y],
		a(ACT.AIMING): [JOY_AXIS_TRIGGER_LEFT, JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y],
		a(ACT.HANDS): [JOY_BUTTON_A], a(ACT.LEGS): [JOY_BUTTON_B],
		a(ACT.SKILL_ONE): [JOY_BUTTON_X], a(ACT.SKILL_TWO): [JOY_BUTTON_Y],
		a(ACT.FIRE): [JOY_AXIS_TRIGGER_RIGHT],
		a(ACT.VIEW_UP): [JOY_AXIS_TRIGGER_RIGHT, JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y],
		a(ACT.VIEW_DOWN): [KEY_PLUS],
		a(ACT.INVENTORY_UP): [JOY_AXIS_TRIGGER_LEFT, JOY_BUTTON_LEFT_SHOULDER],
		a(ACT.GROUP_TEAM): [JOY_BUTTON_LEFT_SHOULDER],
		a(ACT.INVENTORY_DOWN): [JOY_AXIS_TRIGGER_RIGHT, JOY_BUTTON_RIGHT_SHOULDER],
		a(ACT.GROUP_DEPLOY): [JOY_BUTTON_RIGHT_SHOULDER],
		a(ACT.PANEL_LEFT_TOGGLE): [JOY_BUTTON_DPAD_LEFT],
		a(ACT.PANEL_RIGHT_TOGGLE): [JOY_BUTTON_DPAD_RIGHT]
	}
