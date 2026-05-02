extends Node

enum { LISTEN, REPEAT, PLAYER, GENRE, NARRATIVE, QUOTES, HELP, EMOTIONS, OPTIONS,
	SCREEN, AURA, RESOURCE, DAMAGE, VENDOR, REORDER, ORDER_A, ORDER_X, PRESS }

@onready var bits: Node = $bits

func get_value(no: int) -> bool: return bits.get_value(no)
func set_value(no: int, next: bool) -> void: bits.set_value(no, next)
func switch(no: int, next: int) -> bool: return bits.switch(no, next)

func toggle(next: int, op: Dictionary) -> void:
	var state: bool = switch(next, !get_value(next))
	op.ui.set(op.prop, state) # visible
	show_text(op, state)

func toggles(next: int, ui: Array) -> void:
	var state: bool = switch(next, !get_value(next))
	for i in ui: i.visible = state

func show_text(op: Dictionary, state: bool) -> void:
	op.status.text = op.ON if state else op.OFF

func tap(op: Dictionary) -> void:
	show_text(op, op.bit)
	op.toggle.pressed.connect(func(): toggle(op.bit, op))

func model(op: HFlowContainer, title: String, ui: Variant, prop: Dictionary) -> Dictionary:
	prop.bit = get(title.to_upper())
	prop.toggle = op.get_node(title)
	prop.status = prop.toggle.get_node(prop.node)
	prop.ui = ui
	return prop

func interface() -> Array[Dictionary]:
	return [
		{ AURA: false, RESOURCE: false, DAMAGE: false, OPTIONS: false },
		{ AURA: true, RESOURCE: true, DAMAGE: false, OPTIONS: false },
		{ AURA: true, RESOURCE: true, DAMAGE: true, OPTIONS: false },
		{ AURA: true, RESOURCE: true, DAMAGE: true, OPTIONS: true },
	]
