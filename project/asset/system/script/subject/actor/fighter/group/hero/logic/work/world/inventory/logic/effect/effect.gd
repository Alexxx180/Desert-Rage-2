extends Node

const JAR: int = 0

@onready var status: Node = $status
@onready var logic: Node = get_parent()# var effect: ItemsEffect
@onready var doors: Node = $doors
@onready var special: Node = $special
var items: GameItems

func spend_item(slot: int, spending: int) -> bool:
	var result: bool = false
	match spending:
		KeyItem.Spend.INFINITE: result = true
		KeyItem.Spend.JAR: result = logic.items.replace_item(slot, JAR)
		KeyItem.Spend.LIMITED:
			logic.items.use_item(slot)
			result = true
	return result

func use_item(slot: int) -> int:
	var item: Dictionary = items.get_item(logic.items.get_item(slot).id)
	if spend_item(slot, item.logic.spending):
		var effect: Array = item.logic.effect.split('.')
		get(effect[0]).get(effect[1]).call(item)
	return logic.items.get_count(slot)

func remember(id: int) -> void: # func find(id: int) -> void: status.hero.to.chats.log.add_item(bank.get_item(id).item.name)
	status.log.add_item(items.get_item(id).item.name) #; print("REMEMBER ITEM NO = ", no)
