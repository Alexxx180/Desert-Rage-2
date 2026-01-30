extends Node

@onready var devices: Node = $devices

func _card_hint(card: Control, determine: Node) -> Callable:
	return func(): card.translate(determine.selected)

func connect_ui(work: Node, ui: VBoxContainer) -> void:
	var l: Node = work.experience.language
	var d: Node = work.controls.determine
	for card in ui.get_children():
		l.update.connect(_card_hint(card, d))
		d.hints.connect(_card_hint(card, d))

func connect_controls(ui: Panel, work: Node) -> void:	
	var manage: VBoxContainer = ui.topics.options.controls.management
	var m: Node = work.controls.manage
	devices.setup(work)
	for i in devices.buttons.mode.device_types:
		devices.get("connect_" + i).call(manage.get(i))
	m.mode.keys = work.controls.keys
	m.mouse.manage = m
	m.keyboard.sequence.manage = m
	m.gamepad.button.manage = m

func controls(work: Node, ui: Control) -> void:
	for i in [ui.ui]:
		connect_ui(work, i)
	connect_controls(ui, work)
