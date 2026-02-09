extends Node

@onready var t: Node = $toggles
@onready var s: Node = $sections

var p: IPresetBuilder = IPresetBuilder.new()

func tap(op: HFlowContainer, title: String, ui: Variant, prop: Dictionary) -> void:
	t.tap(t.model(op, title, ui, prop))

func select(op: HFlowContainer, title: Array, ui: Variant, prop: Dictionary) -> void:
	s.tap(s.model(op, title, ui, prop))

func sets(op: HFlowContainer, vendor: Node, opts: Array) -> void:
	for i in opts: tap(op, i[0], vendor, p.p(i[0]).t(i[1], i[2]).d)

func interface() -> Array:
	var a: Array = t.interface()
	var b: Array = s.interface()
	for i in len(a): a[i].assign(b[i])
	return a
