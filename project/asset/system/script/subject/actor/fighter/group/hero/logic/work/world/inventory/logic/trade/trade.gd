extends Node

signal describe(item: Variant, trade: Node)

@onready var craft: Node = $craft
@onready var equip: Node = $equips

func _ready() -> void:
	var slots: TradeSlots = TradeSlots.new()
	for i in [craft, equip]:
		i.trade = self
		i.slots = slots

func slot_selected(item: Variant) -> void:
	pass
