extends Node

func _connect_damagebox(box: Area2D, damage: Node) -> void:
	box.body_entered.connect(damage.hero_enter)
	box.body_exited.connect(damage.hero_exit)

func _connect_hitbox(hitbox: StaticBody2D, health: Node) -> void:
	hitbox.hit.connect(health.hit)
	hitbox.burn.connect(health.burns)

func _connect_health(processor: Node, animation: AnimationTree) -> void:
	processor.health.points.freeze.connect(processor.target.temporary_freeze)
	processor.health.points.dead.connect(func():
		processor.target.hit.stop(); animation.dead_animation())
	
	animation.dead.health = processor.health
	animation.dead.path = processor.target

func _connect_target_path(path: Node2D, target: Node) -> void:
	path.obstacle.body_entered.connect(target.enter_obstacle)
	path.obstacle.body_exited.connect(target.exit_obstacle)
	path.spark.body_entered.connect(target.paralyze)
	path.spark.body_exited.connect(target.stop_paralyze)

func controls(entity: CharacterBody2D) -> void:
	var logic: Node2D = entity.logic
	logic.processor.health.aura.entity = entity
	logic.processor.health.points.setup(logic.stats.health)
	logic.processor.damagebox.setup(logic.stats.power)
	logic.processor.target.enemy = entity
	logic.detector.box.body_entered.connect(logic.processor.health.thrown)
	_connect_damagebox(logic.detector.fight.damagebox, logic.processor.damagebox)
	_connect_hitbox(logic.detector.fight.hitbox, logic.processor.health)
	_connect_target_path(logic.detector.path, logic.processor.target)
	_connect_health(logic.processor, entity.view.animation)
