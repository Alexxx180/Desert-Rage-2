extends PanelContainer

signal loaded(stack: Container)

var _scroll: ScrollContainer = null
var scroll: ScrollContainer:
	get:
		update_scroll()
		return _scroll

var _stack: VBoxContainer = null
var stack: VBoxContainer:
	get:
		if _stack == null: _stack = scroll.get_node("space/scroll/margin/stack")
		return _stack

func update_stack() -> void:
	if _stack == null:
		_stack = scroll.get_node("space/scroll/margin/stack")
		loaded.emit(_stack)

func update_scroll() -> void:
	if _scroll == null:
		_scroll = Def.priorities.instantiate()
		add_child(_scroll)
