extends Node

enum { EMPTY = 0, KNIFE = 1 }

@onready var preview: Timer = $preview
@onready var panel: Timer = $panel

var inventory: VSplitContainer
var markers: HFlowContainer

var showed: bool = false
var selection: int = 0
var mask: Array[int] = [0, 2]
var items: Array[int] = [EMPTY, EMPTY, KNIFE, EMPTY, EMPTY]

static func cline(value: int, length: int) -> int:
	return length + value if value < 0 else value % length

func _fast_panel_selection(offset: int) -> void:
	if not showed:
		showed = true
		for item in markers.items: item.show()

	var length: int = mask.size()
	var next: int = cline(selection + offset, length)

	markers.items[mask[selection]].hide_item()
	markers.items[mask[next]].show_item()
	preview.start()
	panel.start()
	selection = next

func hide_preview() -> void:
	markers.items[mask[selection]].preview.hide()

func hide_items() -> void:
	showed = false
	for item in markers.items: item.hide()

func _input(_event: InputEvent) -> void:
	var axis: float = Input.get_axis("item_left", "item_right")
	if axis != 0: _fast_panel_selection(roundi(axis))
