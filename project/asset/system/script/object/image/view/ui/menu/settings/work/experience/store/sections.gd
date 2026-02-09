extends Node

enum { INTERFACE, ITEMS, CARD, COMBO }

const MASK: int = 0x02 # 4 options max, 2 digits
var settings: int = 0

func zeros(a: int, no: int) -> int: return a << no
func whole(a: int, no: int) -> int: return a >> no
func digit(no: int) -> int: return no * MASK

func _get_exact_value(no: int) -> int: return get_mask(no, _value_behind)
func _value_behind(no: int) -> int: return settings & Works.bit(no)

func get_mask(no: int, type: Callable = Works.bit) -> int:
	var value: int = 0
	var from: int = digit(no)
	for i in range(from, from + MASK): value += type.call(i)
	return value

func get_value(no: int) -> int: return whole(_get_exact_value(no), digit(no))
func set_value(no: int, next: int) -> void: settings = settings & ~get_mask(no) | zeros(next, digit(no))

func option(op: HFlowContainer, title: Array, options: Array) -> void:
	for i in title: options.push_back(op.get_node(i))

func set_options(op: HFlowContainer, prop: Dictionary) -> void:
	if prop.has("deep") and prop.deep:
		for i in prop.title: prop.options += op.get_node(i).get_children()
		prop.section = []
		option(op, prop.title, prop.section)
	else:
		option(op, prop.title, prop.options)
		prop.section = prop.options

func model(op: HFlowContainer, title: Array, ui: Variant, prop: Dictionary) -> Dictionary:
	var caption: String = title.pop_front()
	prop.op = op
	prop.bit = get(caption.to_upper())
	prop.title = title
	prop.toggle = op.get_node(caption)
	prop.status = prop.toggle.get_node(prop.node)
	prop.options = []
	prop.ui = ui
	set_options(op, prop)
	return prop

func show_text(op: Dictionary, key: int) -> void:
	op.status.text = op.options[key].text

func select_show(toggle: Button, options: Array) -> void:
	toggle.pressed.connect(func():
		var state: bool = !options.front().visble
		for i in options: i.visible = state)

func select_options(op: Dictionary, bit: int) -> void:
	show_text(op, get_value(bit))
	for i in len(op.options):
		op.options[i].pressed.connect(func():
			set_value(bit, i)
			op.ui.set(op.prop.prop, i) # visible
			show_text(op, i))

func tap(op: Dictionary) -> void:
	select_show(op.toggle, op.section)
	select_options(op, op.bit)

func interface() -> Array[Dictionary]:
	return [
		{ ITEMS: 0, CARD: 0 },
		{ ITEMS: 0, CARD: 1 },
		{ ITEMS: 1, CARD: 2 },
		{ ITEMS: 2, CARD: 3 }
	]
