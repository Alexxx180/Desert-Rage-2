extends Node

const JAR: int = 0

@onready var status: Node = $status
@onready var doors: Node = $doors
@onready var special: Node = $special

var logic: Node

func spend_item(slot: int, spending: int) -> bool:
	return TypeItems.spend(spending, slot, logic)

func use_item(slot: int) -> int:
	var item: Dictionary = logic.item(logic.slot(slot).id)
	if spend_item(slot, item.logic.spending):
		var effect: Array = item.logic.effect.split('.')
		get(effect[0]).get(effect[1]).call(item)
	return logic.items.get_count(slot)

func remember(id: int) -> void: # func find(id: int) -> void: status.hero.to.chats.log.add_item(bank.get_item(id).item.name)
	status.log.add_item(logic.item(id).item.name) #; print("REMEMBER ITEM NO = ", no)
