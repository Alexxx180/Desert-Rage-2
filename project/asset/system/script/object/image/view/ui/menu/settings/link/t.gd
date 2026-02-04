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

func finish(buttons: Array) -> void:
	ui.footer.finish_input(buttons)

func set_title() -> void:
	ui.footer.title = topic.text

func set_aggregate(next: Array) -> void:
	logic.mode.aggregate = next

func set_button_input(buttons: Array) -> void:
	logic.mode.footer_status(ui.footer, logic.join(buttons))

func set_final_input(buttons: Array) -> void:
	set_aggregate(Defaults.ARRAY)
	status(of(logic.option)).text = logic.join(buttons)

func of(caption: String) -> Variant: return ui.options.get_node(caption)

func phrase(b: Control) -> Button:
	return b if b is Button else b.enter

func status(b: Control) -> Variant:
	return b.get_node("status") if b is Button else b.collapse

func connects(caption: String, type: String, mask: int) -> void:
	phrase(of(caption)).pressed.connect(logic.activate(type, mask))

func focus(b: Button, state: bool, type: String) -> void:
	b.disabled = state # false
	b.get(type + "_focus").call()

func option(named: String) -> void:
	set_title()
	logic.set_caption(named)
