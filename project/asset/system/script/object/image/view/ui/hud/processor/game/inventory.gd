extends Node

enum { EMPTY = 0, KNIFE = 1 }

@onready var preview: Timer = $preview
@onready var panel: Timer = $panel

var inventory: Array = []
var markers: HFlowContainer

var showed: bool = false
var selection: int = 0
var mask: Array[int] = [0, 2]
var items: Array[int] = [EMPTY, EMPTY, KNIFE, EMPTY, EMPTY]

static func cline(value: int, length: int) -> int:
	return length + value if value < 0 else value % length

func _toggle_selection(a: int, b: int) -> void:
	markers.items[a].hide_item()
	markers.items[b].show_item()
	for element in inventory:
		element.primary[a].selection.hide()
		element.primary[b].selection.show()

func _fast_panel_selection(offset: int) -> void:
	if not showed:
		showed = true
		for item in markers.items: item.show()

	var length: int = mask.size()
	var next: int = cline(selection + offset, length)

	_toggle_selection(mask[selection], mask[next])
	preview.start()
	panel.start()
	selection = next

func hide_preview() -> void:
	markers.items[mask[selection]].preview.hide()

func hide_items() -> void:
	showed = false
	for item in markers.items: item.hide()

func _input(_event: InputEvent) -> void:
	if not Input.is_action_pressed("item_select"):
		return
	var axis: float = Input.get_axis("item_left", "item_right")
	if axis != 0: _fast_panel_selection(roundi(axis))
