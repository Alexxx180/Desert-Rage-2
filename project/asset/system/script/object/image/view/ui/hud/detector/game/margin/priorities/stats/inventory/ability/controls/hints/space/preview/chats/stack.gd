extends PanelContainer

var _stack: HBoxContainer = null
var stack: HBoxContainer:
	get:
		if _stack == null:
			_stack = load("res://asset/system/scene/object/canvas/ui/hud/detector/game/menu/ability/controls/hints/stack/%s.tscn" % name).instantiate()
			add_child(_stack)
		return _stack
