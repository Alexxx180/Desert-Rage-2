class_name FightRange extends RefCounted

enum { DAMAGE = 10 }

var enemies: Dictionary # all: FightRange - simply enemies list

func enter_range(enemy: PhysicsBody2D, area: Dictionary) -> void:
	if enemy.is_in_group("enemy"):
		area[enemy.get_instance_id()] = enemy

func exit_range(enemy: PhysicsBody2D, area: Dictionary) -> void:
	if enemy.is_in_group("enemy"):
		area.erase(enemy.get_instance_id())

func hit_initial(enemy: PhysicsBody2D, damage: int) -> void:
	print("ENEMY: ", enemy.name)
	enemy.hit(damage)

func hit(damage: int, area: Dictionary = enemies) -> void:
	for enemy in area.values(): hit_initial(enemy, damage)
