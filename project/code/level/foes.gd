class_name Adversaries extends RefCounted

const boss: Array[PackedScene] = [
	preload("res://pre/adversary/foe/eye_seeker.tscn")
]

const foe: Array[PackedScene] = [
	preload("res://pre/adversary/foe/eye_seeker.tscn")
]


extends Node

const SOURCE = 4

var places: Array[Vector2i]
var lay: Node

func set_spawn(_lay: Node) -> void:
	lay = _lay
	places = lay.tags.layer.get_used_cells_by_id(SOURCE)

func from_pool(no: Dictionary, pool: Node, type: String) -> CharacterBody2D:
	return pool.get(type)[randi_range(0, no[type].size() - 1)].instantiate()

func decide(map: int, type: Array[PackedScene]) -> Array[int]:
	var monsters: Array[int] = []
	for i in range(0, type.size()):
		if Works.is_bit(map, i): monsters.append(i)
	return monsters

func select(pool: Node) -> Dictionary:
	return {
		"foe": decide(lay.tags.layer.monsters, pool.foe),
		"boss": decide(lay.tags.layer.bosses, pool.boss)
	}

func initiate(enemy: CharacterBody2D, i: int, tag: Vector2i) -> void:
	lay.execute.layer.add_child(enemy)
	teleport(enemy, i, lay.execute.get_pos(tag))

func teleport(enemy: CharacterBody2D, spawn: int, tag: Vector2) -> void:
	enemy.spawn_pos = spawn
	enemy.teleport(tag)

func dead(enemy: CharacterBody2D) -> void:
	var i: int = (enemy.spawn_pos + 1) % places.size()
	teleport(enemy, i, lay.execute.get_pos(places[i]))



extends RefCounted

class_name EnemyHUD

var boss_fight: bool = false

var foe: Node # var cards: Array
var card: Array
var hits: int = 0
var xp: Node

const CONTEST_TIME: float = 1.5
const DELAY: float = 0.2
const EXP: int = 1

var tween: Dictionary = {}

func set_timer(enemy: Node) -> void:
	foe = enemy
	foe.hud_reseter.timeout.connect(reset_stats)

func set_achievement() -> void: if hits >= 999: pass # set after 999 hits in a row

func setup(enemy: CharacterBody2D) -> void:
	var health: Node = enemy.logic.processor.health
	var hp: Node = health.points
	hp.update_bar.connect(func(_v): set_cards(in_game[enemy.caption], hp))
	health.interrogation.connect(func(): set_cards(in_game[enemy.caption], hp))

func _set_contested_health(id: int, health: ProgressBar, hp: Node) -> void:
	if tween.has(id): tween[id].kill()
	tween[id] = foe.create_tween()
	if hp.points == 0:
		health.value = hp.maximum
	else:
		health.value = hp.contested
	tween[id].tween_property(health, "value", hp.points, CONTEST_TIME).set_delay(DELAY)

func set_health(c: PanelContainer, hp: Node) -> void:
	for bar in [c.health, c.contested]:
		bar.max_value = hp.maximum
	c.health.value = hp.points
	_set_contested_health(c.get_instance_id(), c.contested, hp)

func set_damage(c: PanelContainer, hp: Node) -> void:
	var interrogation: bool = hp.contested == 0
	c.caption.interrogating = hp.points <= 0
	c.set_hp(hp)
	c.caption.show_start()
	# c.interrogate.visible = interrogation
	c.damage.visible = !interrogation

func set_hits(c: PanelContainer) -> void:
	if hits >= 2:
		c.hits.show()
		c.hits.set_count(hits)
		set_achievement()

func set_stats(c: PanelContainer, _enemy: String, hp: Node) -> void:
	# c.caption.text = enemy
	c.appear()
	set_health(c, hp)
	set_damage(c, hp)
	set_hits(c)
	foe.hud_reseter.start()

func set_cards(enemy: String, hp: Node):
	hits += 1
	if hp.points != 0: xp.add_exp(EXP)
	for c in card: 
		set_stats(c, enemy, hp)

func reset_stats() -> void:
	hits = 0 # caption = ""
	for c in card:
		c.damage.hide()
		c.hits.hide_all()
		if not boss_fight and c.modulator.appeared:
			c.disappear()

var in_game: Dictionary = { "eye-seeker": "Гляделкинс" }
