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
		update_stack()
		return _stack

func update_stack() -> void:
	if _stack == null:
		_stack = scroll.get_node("margin/stack")
		loaded.emit(_stack)

func update_scroll() -> void:
	if _scroll == null:
		var asset: PackedScene = load("res://asset/system/scene/object/canvas/ui/hud/detector/game/menu/inventory/content.tscn")
		_scroll = asset.instantiate()
		add_child(_scroll)
