extends Node

@onready var logic: Node = $logic

var management: VBoxContainer
var ui: VBoxContainer:
	get: return management.get(logic.mode.device.named)
var machine: int:
	get: return logic.mode.device.device
var topic: Button:
	get: return phrase(of(logic.option))
var aggregate: Array = Defaults.ARRAY

func finish() -> void:
	ui.footer.finish_input()

func set_title() -> void:
	ui.footer.title = topic.text

func set_aggregate(next: Array) -> void:
	logic.mode.aggregate = next

func set_button_input(buttons: Array) -> void:
	logic.mode.footer_status(ui.footer, logic.join(buttons))

func set_final_input(buttons: Array) -> void:
	status(of(logic.option)).text = logic.join(buttons)
	set_aggregate(Defaults.ARRAY)

func of(caption: String) -> Variant:
	var r = ui.options.get_node(caption)
	return r # ui.options.get_node(caption)

func phrase(b: Variant) -> Button:
	return b if b is Button else b.enter

func status(b: Variant) -> Variant:
	return b.get_node("status") if b is Button else b.collapse

func connects(caption: String, type: String, mask: int) -> void:
	phrase(of(caption)).pressed.connect(logic.activate(type, mask))

func focus(b: Button, type: String) -> void:
	b.get(type + "_focus").call() # b.disabled = state # false

func option(named: String) -> void:
	set_title()
	logic.set_caption(named)
