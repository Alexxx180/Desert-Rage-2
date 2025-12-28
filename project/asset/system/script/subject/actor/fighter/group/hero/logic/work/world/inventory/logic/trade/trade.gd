extends Node

#signal describe(item: Variant, trade: Node)
@onready var craft: Node = $craft
@onready var equip: Node = $equip

var logic: Node

func _ready() -> void:
	var slots: TradeSlots = TradeSlots.new()
	for i in [craft, equip]: i.slots = slots

func set_logic(l: Node) -> void:
	logic = l
	craft.placement.logic = logic
	equip.logic = logic

func description(item: Variant) -> void: #describe.emit(item, self)
	logic.items.ui.describe(item)
	craft.slots.reload()

func add_slot(slot: int, item: Variant) -> void:
	var id: int = logic.slot(slot).id
	match logic.effect.items.craft(id):
		GameItems.CRAFT: craft.add_slot(slot, item)
		GameItems.EQUIP: equip.add_slot(slot, item)
		GameItems.ITEM: description(item)

func confirm_item() -> void:
	match craft.slots.load:
		TradeSlots.CRAFT: craft.product()
