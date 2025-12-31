extends HBoxContainer

@onready var slot: Button = $slot
@onready var workspace: PanelContainer = $workspace

var inventory: Node

func set_weapon(trade: Node) -> void: workspace.update_slots(trade.craft.slots, TradeSlots.EQUIP)
func set_resource(trade: Node) -> void: workspace.update_slots(trade.craft.slots, TradeSlots.CRAFT)
func describe(item: Dictionary) -> void:
	workspace.set_item(item)

func _ready() -> void: helping()

func put_product(item: Item) -> void:
	slot.show()
	slot.put_item(item)

func helping() -> void:
	slot.hide()
	workspace.stack.helping()

func trade(cell: Control) -> void:
	cell.image.holder = null
	inventory.logic.trade.add_slot(cell.slot)
