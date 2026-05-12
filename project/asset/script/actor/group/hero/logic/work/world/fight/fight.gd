class_name FightRange extends RefCounted

enum { CLOSE, ZONE, AFTER_TILE }

const DAMAGE: int = 5

var close: Dictionary
var zone: Dictionary
var after_tile: Dictionary
var enemies: Dictionary # all: FightRange - simply enemies list

func take_effect(area: int) -> void: # print("AREA SIZE: ", after_tile.area.size())
	match area:
		CLOSE: close.hit(DAMAGE)
		AFTER_TILE: after_tile.hit(DAMAGE)
		ZONE: zone.hit(DAMAGE) # hero.logic.stats.power _formula

func enter_range(enemy: PhysicsBody2D, area: Dictionary) -> void:
	if enemy.is_in_group("enemy"):
		area[enemy.get_instance_id()] = enemy
		# enter.emit(enemy)

func exit_range(enemy: PhysicsBody2D, area: Dictionary) -> void:
	if enemy.is_in_group("enemy"):
		area.erase(enemy.get_instance_id())
		# exit.emit(enemy)

func hit_initial(enemy: PhysicsBody2D, damage: int) -> void:
	print("ENEMY: ", enemy.name)
	enemy.hit(damage)

func hit(damage: int, area: Dictionary = enemies) -> void:
	for enemy in area.values(): hit_initial(enemy, damage)
