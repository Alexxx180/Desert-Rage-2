extends HFlowContainer

@onready var primary: Array[Button] = [$slot_0, $slot_1, $slot_2, $slot_3, $slot_4]
@onready var equipment: Array[Button] = [$weapon, $artifact, $armor, $legs, $boots]

@onready var items: Array[Node] = get_children()
@onready var group: Node2D = get_tree().current_scene.get_node("group") # get_node("/root/group") # get_tree().current_scene.

var inventory: Node:
	get: return group.deploy.party.leader.to.inventory

#func _ready() -> void:
#	for i in items:
#		i.margin.inventory = 
