extends Node

signal target_accept(enemy: CharacterBody2D)

var close: FightRange = FightRange.new()
var zone: FightRange = FightRange.new()
# var all: FightRange = FightRange.new() - simply enemies list

var auto_switch: bool = true
var group: Node2D

var hero: CharacterBody2D
var targeting: Array[CharacterBody2D] = []
var selection: int = 0

func set_target(enemy: CharacterBody2D) -> void:
	targeting.append(enemy)
	# hero.enemy = enemy # targets[selection].position
	hero.logic.processors.ui.input.movement.mode.target.enemy = enemy

func target_accepted(enemy: CharacterBody2D) -> void:
	# Works.turn(movement, true)
	set_target(enemy)
	target_accept.emit(enemy)
	if auto_switch and !group.deploy.anchored:
		group.deploy.select(group)

func _detector(entity: PhysicsBody2D) -> Node:
	return entity.logic.detector.fight

func _fight(hero: CharacterBody2D) -> Node:
	return hero.logic.processors.world.fight

func iterate_enemy(targets: Array, processor: Callable, interrupt: bool = false) -> void:
	for entity in targets:
		if entity.is_in_group("enemy"):
			processor.call(entity)
			if interrupt: return

func reveal_aims() -> void:
	var targets: Array = zone.area.values()
	iterate_enemy(targets, func(entity):
		entity.logic.detector.fight.reveal_aim()
		add_assignee(entity, group.leader))
	iterate_enemy(targets, func(entity):
		entity.logic.detector.fight.aim.grab_focus(), true)

func hide_aims() -> void:
	iterate_enemy(zone.area.values(), func(entity):
		entity.logic.detector.fight.hide_aim()
		drop_assignee(entity, group.leader))

func update_assignee(_party: HeroParty) -> void:
	iterate_enemy(zone.area.values(), func(entity):
		drop_assignee(entity, group.follower)
		add_assignee(entity, group.leader))

func add_assignee(entity: PhysicsBody2D, hero: CharacterBody2D) -> void:
	_detector(entity).assign.connect(_fight(hero).target_accepted)

func drop_assignee(entity: PhysicsBody2D, hero: CharacterBody2D) -> void:
	_detector(entity).assign.disconnect(_fight(hero).target_accepted)
