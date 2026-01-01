extends Node

@onready var craft: Node = $craft
@onready var equip: Node = $equip
@onready var drag: Node = $drag

var logic: Node

func _ready() -> void:
	var slots: TradeSlots = TradeSlots.new()
	for i in [craft, equip]: i.slots = slots

func set_logic(l: Node) -> void:
	logic = l
	craft.placement.search.logic = logic
	equip.logic = logic

func description(item: Variant) -> void: #describe.emit(item, self)
	logic.items.ui.describe(item)
	craft.slots.reload()

func trades(cell: CellDrag) -> void:
	drag.ui.reset_texture(cell.image)
	add_slot(cell.slot)

func add_slot(slot: int) -> void: # , item: Variant
	var id: int = logic.slot(slot).id
	var type: int = logic.items.items.craft(id)
	match type:
		GameItems.CRAFT: craft.add_slot(slot)
		GameItems.EQUIP: equip.add_slot(slot)
		GameItems.ITEM: description(logic.item(id))

func confirm_item() -> void:
	match craft.slots.load:
		TradeSlots.CRAFT: craft.product()
