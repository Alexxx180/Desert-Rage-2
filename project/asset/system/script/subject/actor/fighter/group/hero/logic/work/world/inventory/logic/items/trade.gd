extends Node

enum { ITEMS = 0, SLOT = 1 }

var items: Node

func _copy(item: Dictionary, copied: Dictionary) -> Dictionary:
	item.id = copied.id
	item.x = copied.x
	return copied

func _trade(a, b, temp) -> void: _copy(_copy(_copy(temp, b), a), temp)

func bags(hero: Node, a: int, b: int) -> void:
	_trade(items.storage[a], hero.storage[b], HeroInventory.slot())
	for i in [[items, a], [hero, b]]:
		i[ITEMS].ui.update_item(i[SLOT], i[ITEMS].storage[i[SLOT]])
