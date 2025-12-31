extends HFlowContainer

@onready var primary: Array[Button] = [$slot_0, $slot_1, $slot_2, $slot_3, $slot_4, $slot_5, $slot_6, $slot_7, $slot_8, $slot_9]
@onready var equipment: Array[Button] = [$weapon, $artifact, $armor, $legs, $boots]
@onready var title: HBoxContainer = $title

var group: Node2D
var items: Array[InventoryItem] = []
var inventory: Node:
	get: return group.deploy.party.leader.to.inventory

func connect_selection(selection: Array[Dictionary]) -> void:
	for i in items: i.selection = selection

func set_items(hero: String, _group: Node2D) -> void:
	group = _group
	var slot: int = Defaults.INT
	title.inventory = group.get(hero).to.inventory
	title.slot.margin.view.describe(title.inventory, InventoryItem.CRAFT)
	for item in get_children(): # items
		if item is InventoryItem:
			slot += 1
			item.margin.view.describe(title.inventory, slot)
			items.append(item) # item.margin.inventory = 
