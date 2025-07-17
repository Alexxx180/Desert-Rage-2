extends RefCounted

class_name FightRange

signal enter(enemy: PhysicsBody2D)
signal exit(enemy: PhysicsBody2D)

var area: Dictionary = {}

func enter_range(enemy: PhysicsBody2D) -> void:
	area[enemy.get_instance_id()] = enemy
	enter.emit(enemy)

func exit_range(enemy: PhysicsBody2D) -> void:
	area.erase(enemy.get_instance_id())
	exit.emit(enemy)

func hit_initial(enemy: PhysicsBody2D, damage: int) -> void:
	enemy.hit.emit(damage)

func hit(damage: int) -> void:
	for enemy in area.values(): hit_initial(enemy, damage)
