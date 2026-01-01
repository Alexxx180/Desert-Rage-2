extends Node

@onready var select: Node = $select
@onready var craft: Node = $craft
@onready var equip: Node = $equip
@onready var ui: Node = $ui

var group: Node2D

func trade(cell: CellDrag) -> void:
	ui.reset_holder(cell.image)
	select.trades(cell.slot)

func moving_items(view: Control) -> void:
	if not select.is_selected():
		select.from_ui(view)
	else:
		select.release_item(view)

func select_item(ui: Button) -> void:
	if craft.items(ui): return
	if equip.items(): return
	moving_items(ui.margin.view)
