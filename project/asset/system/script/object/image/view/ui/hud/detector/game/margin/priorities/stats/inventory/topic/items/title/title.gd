extends HBoxContainer

@onready var slot: Button = $slot
@onready var workspace: PanelContainer = $workspace

func set_weapon(trade: Node) -> void: workspace.update_slots(trade.craft.slots, TradeSlots.EQUIP)
func set_resource(trade: Node) -> void: workspace.update_slots(trade.craft.slots, TradeSlots.CRAFT)
func describe(item: Dictionary) -> void: workspace.describe(item)

func _ready() -> void: helping()

func put_product(item: Dictionary) -> void: slot.put_item(item)

func helping() -> void:
	slot.hide()
	workspace.stack.helping()
