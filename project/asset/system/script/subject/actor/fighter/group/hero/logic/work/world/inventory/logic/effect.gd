extends Node

var hero: CharacterBody2D
var logic: Node
var effect: ItemsEffect

var items: GameItems

func refill(hp: int, ap: int) -> void:
	hero.to.stats.health.refill(hp)
	hero.to.stats.aura.refill(ap)

func restore() -> void:
	hero.to.stats.health.restore()
	hero.to.stats.aura.restore()

func m_poison(slot: Dictionary, item: Variant) -> void:
	hero.to.stats.status.decrease()

func m_cough(slot: Dictionary, item: Variant) -> void:
	hero.to.stats.status.decrease()

func no_poison(slot: Dictionary, item: Variant) -> void:
	hero.to.stats.status.remove()

func no_cough(slot: Dictionary, item: Variant) -> void:
	hero.to.stats.status.remove()

func open_lock(slot: Dictionary, item: Variant) -> void:
	pass

func open_mystic(slot: Dictionary, item: Variant) -> void:
	pass

func distract(slot: Dictionary, item: Variant) -> void:
	pass

func attack(slot: Dictionary, item: Variant) -> void:
	pass

func defend(slot: Dictionary, item: Variant) -> void:
	pass

func replenish(slot: Dictionary, item: Variant) -> void:
	var jar: int = logic.items.find_item_or_slot(logic.storage, items.JAR)
	logic.use_the_jar(slot, jar, items.JAR)
	refill(item.power, item.supply)

func store_water(slot: Dictionary, item: Variant) -> void:
	logic.fill_the_jar()

func use_item(slot: Dictionary) -> void:
	var item: Variant = items.get_item(slot.item.id)
	get(item.effect).call(slot, item)

func drag_item() -> void: pass
