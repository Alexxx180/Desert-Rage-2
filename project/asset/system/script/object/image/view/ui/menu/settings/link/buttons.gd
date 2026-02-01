extends Node

var resolve: Node

func connect_button(button: Button, named: String, ui: VBoxContainer, machine: int) -> void:
	button.pressed.connect(resolve.option(button, named, ui, machine))

func connect_footer(modes: Dictionary, ui: VBoxContainer, machine: int) -> void:
	for key in modes: for n in modes[key]:
		connect_button(resolve.agg(ui, n), n, ui, machine)

func connect_logic(modes: Dictionary, key: String, ui: VBoxContainer) -> void:
	for n in modes[key]:
		if modes.has("MASK") and modes.MASK.has(n):
			resolve.logic(ui, n, key, modes.MASK[n])
		else:
			resolve.logic(ui, n, key)

func connect_modes(modes: Dictionary, ui: VBoxContainer) -> void:
	for key in modes:
		if not key == "MASK":
			connect_logic(modes, key, ui)

func connect_all(keys: Dictionary, ui: VBoxContainer, machine: int) -> void:
	resolve.finish(ui)
	connect_footer(keys, ui, machine)
	connect_modes(keys, ui)

func connect_mouse(ui: VBoxContainer, nodes: Array[Node]) -> void:
	var machine: int = resolve.mode.device.MOUSE
	resolve.finish(ui)
	for button in nodes:
		# resolve.agg(ui, n)
		connect_button(button, button.name, ui, machine)
		resolve.connects(button, "HOT")
