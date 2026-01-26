extends ActionsControl

func new_controls(act: String) -> void:
	var event := InputEventKey.new()
	event.keycode = actions[act]
	event.pressed = true
	_set_event(act, event)

func set_mask() -> ActionsControl:
	return super.set_mask().m(
		"MT", [[ACT.UP, ACT.LEFT, ACT.DOWN, ACT.RIGHT], [ACT.LEGS]])

func _ready() -> void:
	super._ready()
	actions = {
		a(ACT.LEFT): [KEY_LEFT], a(ACT.UP): [KEY_UP], a(ACT.RIGHT): [KEY_RIGHT],
		a(ACT.DOWN): [KEY_DOWN], a(ACT.HANDS): [KEY_Z, KEY_E], a(ACT.LEGS): [KEY_X, KEY_Q],
		a(ACT.SKILL_ONE): [KEY_C], a(ACT.SKILL_TWO): [KEY_V], a(ACT.FIRE): [KEY_F],
		a(ACT.VIEW_UP): [KEY_MINUS], a(ACT.VIEW_DOWN): [KEY_PLUS],
		a(ACT.INVENTORY_UP): [KEY_TAB, KEY_1], a(ACT.GROUP_TEAM): [KEY_T], 
		a(ACT.INVENTORY_DOWN): [KEY_TAB, KEY_2], a(ACT.GROUP_DEPLOY): [KEY_G],
		a(ACT.SAVES): [KEY_F2], a(ACT.SETTINGS): [KEY_F3],
		a(ACT.MAIN_MENU): [KEY_F4], a(ACT.OST_SYSTEM): [KEY_F5],
		a(ACT.CHECKPOINT): [KEY_F6], a(ACT.FAST_SAVE): [KEY_F7],
		a(ACT.FAST_LOAD): [KEY_F8], a(ACT.FULLSCREEN): [KEY_F11],
		a(ACT.PHOTOMODE): [KEY_F12],
		a(ACT.PANEL_LEFT_TOGGLE): [KEY_TAB, KEY_3],
		a(ACT.PANEL_RIGHT_TOGGLE): [KEY_TAB, KEY_4],
		a(ACT.PANEL_LEFT_SHOW): [KEY_TAB, KEY_QUOTELEFT],
		a(ACT.PANEL_RIGHT_SHOW): [KEY_TAB, KEY_5],
	}
