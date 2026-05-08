extends PanelContainer

signal loaded(stack: Container)

var _scroll: ScrollContainer = null
var scroll: ScrollContainer:
	get: return update_scroll()

var _stack: VBoxContainer = null
var stack: VBoxContainer:
	get: return update_stack()

func update_stack() -> VBoxContainer:
	if _stack == null:
		_stack = scroll.get_node("margin/stack")
		loaded.emit(_stack)
	return _stack

func update_scroll() -> ScrollContainer:
	return Works.upload(self, _scroll, LoadBus.game % "ability", "ability")
