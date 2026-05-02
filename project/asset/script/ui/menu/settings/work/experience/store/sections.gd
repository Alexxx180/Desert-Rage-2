extends Node

enum { DIFFICULTY, LANGUAGE, INTERFACE, ITEMS, CARD, COMBO }
enum { MASK = 0x02, MASK2 = 0x03 }

var settings: int = 0
var mask2: Array[int] = [DIFFICULTY]
var compat: Dictionary = { DIFFICULTY: [0, 2] }

func zeros(a: int, no: int) -> int: return a << no
func whole(a: int, no: int) -> int: return a >> no
func digit(no: int) -> int: return no * MASK

func _get_exact_value(no: int) -> int: return get_mask(no, _value_behind)
func _value_behind(no: int) -> int: return settings & Works.bit(no)

func determine_mask(no: int) -> int:
	return MASK2 if no in mask2 else MASK

func get_mask(no: int, type: Callable = Works.bit) -> int:
	var value: int = 0
	var from: int = digit(no)
	var to: int = from + determine_mask(no)
	for i in range(from, to): value += type.call(i)
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

func select_show(toggle: Button, op: Dictionary) -> void:
	toggle.pressed.connect(func():
		if len(op.section) == 2:
			var state: bool = !bool(get_value(op.bit))
			set_bit_value(int(state), op.bit, op)
		else:
			var state: bool = !op.section.front().visible
			for i in op.section: i.visible = state)

func set_bit_value(i: int, bit: int, op: Dictionary) -> void:
	set_value(bit, i)
	var prop: String 
	if (op.prop is Dictionary):
		prop = op.prop.prop
	else:
		prop = op.prop
	op.ui.set(prop, i) # visible
	show_text(op, i)

func select_options(op: Dictionary, bit: int) -> void:
	show_text(op, get_value(bit))
	print("select_options - ")
	for i in len(op.options): # print(op.options[i].name)
		op.options[i].pressed.connect(func(): set_bit_value(i, bit, op))

func tap(op: Dictionary) -> void:
	select_show(op.toggle, op)
	select_options(op, op.bit)

func interface() -> Array[Dictionary]:
	return [
		{ ITEMS: 0, CARD: 0 },
		{ ITEMS: 0, CARD: 1 },
		{ ITEMS: 1, CARD: 2 },
		{ ITEMS: 2, CARD: 3 }
	]
