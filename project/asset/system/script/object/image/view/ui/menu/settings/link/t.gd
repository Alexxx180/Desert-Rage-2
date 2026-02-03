extends Node

@onready var logic: Node = $logic

var management: VBoxContainer
var ui: VBoxContainer:
	get: return management.get(logic.mode.device.named)
var machine: int:
	get: return logic.mode.device.device
var topic: Button:
	get: return phrase(of(logic.option))

func finish(buttons: Array) -> void:
	ui.footer.finish_input(buttons)

func set_title() -> void:
	ui.footer.title = topic.text

func set_button_input(buttons: Array) -> void:
	ui.footer.input_button(logic.join(buttons))

func set_final_input(buttons: Array) -> void:
	status(of(logic.option)).text = logic.join(buttons)

func of(caption: String) -> Variant: return ui.options.get_node(caption)

func phrase(option: Control) -> Button:
	return option if option is Button else option.enter

func status(option: Control) -> Variant:
	return option.get_node("status") if option is Button else option.collapse

func connects(caption: String, type: String, mask: int) -> void:
	phrase(of(caption)).pressed.connect(logic.activate(type, mask))

func focus(ui: Button, state: bool, type: String) -> void:
	ui.disabled = false
	ui.get(type + "_focus").call()

func option(named: String) -> void:
	set_title()
	logic.set_caption(named)
