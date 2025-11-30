extends HFlowContainer

@onready var primary: Array[Button] = [$slot_0, $slot_1, $slot_2, $slot_3, $slot_4, $slot_5, $slot_6, $slot_7, $slot_8, $slot_9]
@onready var equipment: Array[Button] = [$weapon, $artifact, $armor, $legs, $boots]
@onready var group: Node2D = get_tree().current_scene.get_node("group") # get_node("/root/group") # get_tree().current_scene.

var items: Array[InventoryItem] = []

func _ready() -> void:
	for item in items: if item is InventoryItem: items.append(item) # item.margin.inventory = 

var inventory: Node:
	get: return group.deploy.party.leader.to.inventory
