extends Node

var mode: Node
var _caption: String
var key: int:
	get: return mode.type.KEY

func _g(ui: VBoxContainer, caption: String) -> Variant:
	return ui.options.get_node(caption)

func button(b: Variant, wrap_a: Callable, wrap_b: Callable) -> Variant:
	return wrap_b.call(b) if b is Button else wrap_a.call(b)

func agg(ui: VBoxContainer, caption: String) -> Button:
	return button(_g(ui, caption), func(b): return b.enter, func(b): return b)

func status(ui: VBoxContainer, caption: String) -> Variant:
#	return _g(ui, caption).get_node("status")
	return button(_g(ui, caption), func(b): return b.collapse, func(b): return b.get_node("status"))

func join(sequence: Array) -> String:
	return mode.type.separator.join(sequence)

func activate(type: String, mask: int = key) -> Callable:
	return func(): mode.select(type, mask)

func connects(ui: Button, type: String, mask: int = key) -> void:
	ui.pressed.connect(activate(type, mask))

func logic(ui: VBoxContainer, caption: String, type: String, mask: int = key) -> void:
	connects(agg(ui, caption), type, mask)

func show(b: Variant, buttons: Array) -> void: b.text = join(buttons)

func enter(ui: VBoxContainer) -> Callable:
	return func(buttons: Array):
		if mode.device.named != ui.name: return
		ui.footer.input_button(join(buttons))

func controls(ui: VBoxContainer) -> Callable:
	return func(buttons: Array):
		if mode.device.named != ui.name: return
		
		agg(ui, _caption).disabled = false
		ui.footer.finish_input(buttons)
		var device: Node = mode.keys.get(mode.device.named)
		device.set_action(_caption, buttons)
		show(status(ui, _caption), buttons)

func option(button: Button, named: String, ui: VBoxContainer, machine: int) -> Callable:
	return func():
		button.disabled = true
		
		button.release_focus()
		mode.device.set_as(machine)
		ui.footer.title = button.text
		_caption = named

func finish(ui: VBoxContainer) -> void:
	mode.input.enter_keys.connect(enter(ui))
	mode.input.finish_combo.connect(controls(ui))
