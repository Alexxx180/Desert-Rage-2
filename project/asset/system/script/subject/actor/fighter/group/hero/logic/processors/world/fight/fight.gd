extends Node

var close: FightRange = FightRange.new()
var zone: FightRange = FightRange.new()
# var all: FightRange = FightRange.new() - simply enemies list

var party: HeroParty

func _detector(entity: PhysicsBody2D) -> Node:
	return entity.logic.detector.fight

func _fight(hero: CharacterBody) -> Node:
	return hero.logic.processor.world.fight

func iterate_enemy(processor: Callable) -> void:
	for entity in zone.area.values():
		if entity.is_in_group("enemy"):
			processor.call(entity)

func reveal_aims() -> void:
	iterate_enemy(func(entity):
		entity.logic.detector.fight.reveal_aim()
		add_assignee(entity, party.leader))

func hide_aims() -> void:
	iterate_enemy(func(entity):
		entity.logic.detector.fight.hide_aim()
		drop_assignee(entity, party.leader))

func target_accepted(enemy: CharacterBody2D) -> void:
	# var hero: CharacterBody2D = 
	pass

func update_assignee(_party: HeroParty) -> void:
	iterate_enemy(func(entity):
		drop_assignee(entity, party.follower)
		add_assignee(entity, party.leader))

func add_assignee(entity: PhysicsBody2D, hero: CharacterBody) -> void:
	_detector(entity).assign.connect(_fight(hero))

func drop_assignee(entity: PhysicsBody2D, hero: CharacterBody) -> void:
	_detector(entity).assign.disconnect(_fight(hero))
