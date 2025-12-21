extends Node

const MAX: int = 25

var hero: CharacterBody2D
var logic: Node
var log: PanelContainer:
	get: return hero.to.chats.log

func refill(hp: int, ap: int) -> void:
	hero.to.stats.health.refill(hp)
	hero.to.stats.aura.refill(ap)

func restore() -> void:
	hero.to.stats.health.restore()
	hero.to.stats.aura.restore()

func replenish(item: Dictionary) -> void:
	refill(item.logic.power, item.logic.supply)

func m_poison(item: Dictionary) -> void: hero.to.stats.status.decrease()
func m_cough(item: Dictionary) -> void: hero.to.stats.status.decrease()
func no_poison(item: Dictionary) -> void: hero.to.stats.status.remove()
func no_cough(item: Dictionary) -> void: hero.to.stats.status.remove()

func reload_resource() -> void:
	pass
