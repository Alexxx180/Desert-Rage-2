extends Node

var mode: Node
var _caption: String

func _g(ui: VBoxContainer, caption: String) -> Button:
	return ui.options.get_node(caption)

func connect_button(button: Button, ui: VBoxContainer, machine: int) -> void:
	button.pressed.connect(func():
		mode.as_device(machine)
		ui.footer.title = button.text
		_caption = button.name)

func connect_footer(buttons: Array, ui: VBoxContainer, machine: int) -> void:
	for i in buttons:
		for j in i:
			connect_button(_g(ui, j), ui, machine)

func connect_logic(logic: Array, ui: VBoxContainer) -> void:
	for i in len(logic.front()):
		for j in logic[0][i]: _g(ui, j).pressed.connect(mode.get(logic[1][i]))

func connect_finish(ui: VBoxContainer) -> void:
	mode.finish_combo.connect(ui.footer.finish_input)
	mode.input_a_key.connect(func(buttons: Array):
		ui.footer.input_button(mode.separator.join(buttons)))

func connect_all(names: Array, logic: Array, ui: VBoxContainer, machine: int) -> void:
	connect_finish(ui)
	connect_footer(names, ui, machine)
	connect_logic([names, logic], ui)
	
	mode.finish_combo.connect(func(buttons: Array):
		mode.keys.get(mode.device_name).set_action(_caption, buttons)
		_g(ui, _caption).get_node("status").text = mode.separator.join(buttons))
