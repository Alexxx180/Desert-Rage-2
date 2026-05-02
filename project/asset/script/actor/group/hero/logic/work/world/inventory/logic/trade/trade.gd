extends Node

@onready var craft: Node = $craft
@onready var equip: Node = $equip
@onready var drag: Node = $drag
@onready var ui: Node = $ui

var logic: Node

func equipped() -> Dictionary:
	return logic.item(equip.space.id)

func _ready() -> void:
	drag.craft.selection.craft = craft
	ui.trade = self
	craft.slots = TradeSlots.new()

func set_logic(l: Node) -> void:
	logic = l
	craft.placement.search.logic = logic
	equip.logic = logic

func description(item: Variant) -> void: #describe.emit(item, self)
	craft.slots.reload()
	ui.describe(item)

func trades(cell: CellDrag) -> void:
	drag.ui.reset_texture(cell.image)
	add_slot(cell.slot)

func check_weapon(id: int, slot: int) -> bool:
	var i: GameItems = logic.items.items
	if i.is_equipable(id):
		equip.select_weapon(slot)
	elif equip.available and i.equip.in_items(id):
		equip.add_slot(slot)
		ui.equipment()
		return false
	return true

func add_slot(slot: int) -> void:
	var id: int = logic.slot(slot).id
	var type: int = logic.items.items.craft(id)
	match type:
		GameItems.CRAFT: craft.add_slot(slot)
		GameItems.EQUIP, GameItems.ITEM:
			if check_weapon(id, slot):
				description(logic.item(id))

func confirm_item() -> void:
	match craft.slots.load:
		TradeSlots.CRAFT: craft.product()
