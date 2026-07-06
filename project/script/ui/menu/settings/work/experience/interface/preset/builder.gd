extends RefCounted

class_name IPresetBuilder

var _t: Dictionary = {}
var c: String = "t"
var d: Dictionary:
	get: return _t.duplicate()

func p(prop: String = "control") -> IPresetBuilder:
	_t.prop = prop ; return self

func n(node: String = "status") -> IPresetBuilder:
	_t.node = node ; return self

func t(on: String = "SON", off: String = "SOF") -> IPresetBuilder:
	_t.ON = on; _t.OFF = off ; c = "t" ; return self

func s(deep: bool = false) -> IPresetBuilder:
	_t.deep = deep ; c = "s" ; return self
