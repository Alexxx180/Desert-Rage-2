class_name IPreset extends Node

var mask: Array = Def.ARRAY
var preset: Array = []
var s: Node

func masks(value: Array) -> IPreset: mask = value ; return self

func add(op: HFlowContainer, title: Variant, ui: Control) -> void:
	preset.push_back(s.get(s.p.c).model(op, title, ui, s.p.d))

func bit(value: int) -> Variant:
	return Def.DICT if mask == Def.ARRAY else mask[value]

func set_toggle(value: Variant, ref: Dictionary) -> void:
	ref.ui.set(ref.prop, value)
	s.t.show_text(ref, value)
	s.t.set_value(ref.bit)

func set_section(value: Variant, ref: Dictionary) -> void:
	ref.ui.set(ref.prop.prop, value)
	s.s.show_text(ref, value)
	s.s.set_value(ref.prop.bit)

func switch(value: bool) -> void: select(value)
func select(value: int) -> void:
	var m: Dictionary = bit(value)
	for i in preset:
		var r: int = value
		var b: int = i.prop.bit
		if m.has(b): r = m[b]
		if i.has("ON"):
			set_toggle(r, i)
		else:
			set_section(r, i)

func link() -> void:
	for i in preset: s.get("t" if i.has("ON") else "s").tap(i)
