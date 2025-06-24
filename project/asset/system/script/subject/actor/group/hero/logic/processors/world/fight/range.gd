extends RefCounted

class_name FightRange

var area: Dictionary = {}

func enter_range(enemy: StaticBody2D) -> void:
	area[enemy.get_instance_id()] = enemy

func exit_range(enemy: StaticBody2D) -> void:
	area.erase(enemy.get_instance_id())

func hit_initial(enemy: StaticBody2D, damage: int) -> void:
	enemy.health.hit(damage)

func hit(damage: int) -> void:
	for enemy in area.values(): hit_initial(enemy, damage)
