extends Node

class_name KeyAndButtonEscapes

@onready var mouse: Node = $mouse
@onready var keyboard: Node = $keyboard
@onready var gamepad: Node = $gamepad

func _ready() -> void:
	for i in [mouse, keyboard, gamepad]:
		i.keys = self
		i.defaults = keyboard

enum PAD { XBOX = 0, PS = 1, NINTENDO = 2 }

var pad: Dictionary = {
	PAD.PS: {
		"BTX": "BRT", "BTY": "BTR", "BTA": "BCR", "BTB": "BCL",
		"BLB": "BL1", "BRB": "BR1", "BLT": "BL2", "BRT": "BR2"
	},
	PAD.NINTENDO: {
		"BTX": "BTY", "BTY": "BTX", "BTA": "BTB", "BTB": "BTA",
		"BLB": "BL1", "BRB": "BR1", "BLT": "BL2", "BRT": "BR2"
	}
}

var sticks: Dictionary = {
	"BLS": [JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y],
	"BRS": [JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y]
}

var escapes: Dictionary = {
	KEY_LEFT: "KAL", KEY_RIGHT: "KAR", KEY_DOWN: "KAD", KEY_UP: "KAU",
	KEY_SHIFT: "KSH", KEY_BACKSPACE: "BSP", KEY_TAB: "TAB", KEY_NUMLOCK: "KNL",
	KEY_SPACE: "KSP", KEY_ESCAPE: "KEC", KEY_INSERT: "KIN", KEY_DELETE: "KDL",
	KEY_PRINT: "KPS", KEY_CAPSLOCK: "KCL", KEY_PAUSE: "KPB", KEY_PAGEUP: "KPU",
	KEY_PAGEDOWN: "KPD", KEY_HOME: "KHM", KEY_END: "KED", KEY_KP_PERIOD: "KGM",
	KEY_KP_DIVIDE: "KGD", KEY_KP_ADD: "KGA", KEY_KP_SUBTRACT: "KGS",
	JOY_BUTTON_DPAD_LEFT: "KAL", JOY_BUTTON_DPAD_UP: "KAU",
	JOY_BUTTON_DPAD_RIGHT: "KAR", JOY_BUTTON_DPAD_DOWN: "KAD",
	JOY_BUTTON_A: "BTA", JOY_BUTTON_B: "BTB", JOY_BUTTON_X: "BTX", JOY_BUTTON_Y: "BTY",
	JOY_AXIS_TRIGGER_LEFT: "BLT", JOY_AXIS_TRIGGER_RIGHT: "BRT",
	JOY_BUTTON_LEFT_SHOULDER: "BLB", JOY_BUTTON_RIGHT_SHOULDER: "BRB",
}
