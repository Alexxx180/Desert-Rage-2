extends Node

@onready var t: Node = $t
@onready var options: Node = $options

func _ready() -> void: options.t = t

func connect_button(button: Button, named: String) -> void:
	button.pressed.connect(options.option(button, named, t.machine))

func connect_footer(modes: Dictionary) -> void:
	for key in modes: for n in modes[key]:
		connect_button(t.phrase(t.of(n)), n)

func connect_logic(modes: Dictionary, key: String) -> void:
	for n in modes[key]:
		t.connects(n, key, t.logic.custom_mask(modes, n))

func connect_modes(modes: Dictionary) -> void:
	for key in modes: if t.logic.valid(key): connect_logic(modes, key)

func connect_all(keys: Dictionary, machine: int) -> void:
	t.logic.mode.device.device = machine
	t.logic.connects(options)
	connect_footer(keys)
	connect_modes(keys)
"""
func connect_mouse(nodes: Array[Node]) -> void:
	t.logic.connects(options)
	for button in nodes:
		connect_button(button, button.name, resolve.mode.device.MOUSE)
		resolve.connects(button, "HOT")
"""
