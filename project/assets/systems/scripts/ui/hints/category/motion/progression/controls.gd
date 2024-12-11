extends PanelContainer

@export var caption: String = ""

@export var keyboard: Array[String] = []
@export var gamepad: Array[String] = []

@onready var controls: Label = $margin/controls

func _ready() -> void:
	controls.text = caption % keyboard

func _input(_event: InputEvent) -> void:
	if Input.get_connected_joypads().size() > 0:
		controls.text = caption % gamepad
	else:
		controls.text = caption % keyboard
