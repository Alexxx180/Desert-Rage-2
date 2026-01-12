extends Node

@onready var select: Node = $select
@onready var craft: Node = $craft
@onready var equip: Node = $equip
@onready var ui: Node = $ui

var group: Node2D
var inventory: Node

func _ready() -> void:
	craft.selection.drag = self
	craft.selection.select = select
	craft.select = select
	craft.trade = get_parent()

func trade(cell: CellDrag) -> void: # ui.remove_item
	ui.reset_texture(cell.image)
	select.trades(cell.slot)

func trades(prev: CellDrag, next: CellDrag) -> void:
	select.set_selection(prev.drag.inventory, prev.slot)
	trade(next)

func moving_items(view: Control) -> void:
	if not select.is_selected():
		select.from_ui(view)
	else:
		select.release_item(view)

func select_item(option: Button) -> void:
	if craft.items(option): return
	if equip.items(): return
	moving_items(option.margin.view)
