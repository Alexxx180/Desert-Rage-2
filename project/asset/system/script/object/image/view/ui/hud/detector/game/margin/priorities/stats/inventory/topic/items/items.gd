extends HFlowContainer

@onready var primary: Array[Button] = [$slot_0, $slot_1, $slot_2, $slot_3, $slot_4, $slot_5, $slot_6, $slot_7, $slot_8, $slot_9]
@onready var equipment: Array[Button] = [$weapon, $artifact, $armor, $legs, $boots]

var group: Node2D
var items: Array[InventoryItem] = []
var inventory: Node:
	get: return group.deploy.party.leader.to.inventory

func connect_selection(selection: Array[Dictionary]) -> void:
	for i in items: i.selection = selection

func set_items(hero: String, _group: Node2D) -> void:
	group = _group
	var slot: int = Defaults.INT
	for item in get_children(): # items
		if item is InventoryItem:
			slot += 1
			item.margin.view.describe(group.get(hero).to.inventory, slot)
			items.append(item) # item.margin.inventory = 
