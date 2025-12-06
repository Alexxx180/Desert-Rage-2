extends RefCounted

class_name EnemyHUD

var boss_fight: bool = false

var foe: Node # var cards: Array
var card: PanelContainer
var hits: int = 0
var xp: Node

const CONTEST_TIME: float = 1.5
const DELAY: float = 0.2
const EXP: int = 1

var tween: Dictionary = {}

func set_timer(enemy: Node) -> void:
	foe = enemy
	foe.hud_reseter.timeout.connect(reset_stats)

func set_achievement() -> void: if hits >= 100: pass # set after 100 hits in a row

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

func set_health(_card: PanelContainer, hp: Node) -> void:
	for bar in [card.health, card.contested]:
		bar.max_value = hp.maximum
	card.health.value = hp.points
	_set_contested_health(card.get_instance_id(), card.contested, hp)

func set_damage(_card: PanelContainer, hp: Node) -> void:
	# TODO CARD DAMAGE HEALTH
	"""
	card.damage.health.text = str(int(hp.contested))
	card.damage.value.text = str(int(hp.contested - hp.points))
	"""
	var interrogation: bool = hp.contested == 0
	card.caption.interrogating = hp.points <= 0
	card.set_hp(hp)
	card.caption.show_start()
	# card.interrogate.visible = interrogation
	card.damage.visible = !interrogation

func set_hits(_card: PanelContainer) -> void:
	if hits >= 2:
		# card.hits.count.text = str(hits)
		card.hits.show()
		card.hits.set_count(hits)
		set_achievement()

func set_stats(_card: PanelContainer, _enemy: String, hp: Node) -> void:
	# card.caption.text = enemy
	card.appear()
	set_health(card, hp)
	set_damage(card, hp)
	set_hits(card)
	foe.hud_reseter.start()

func set_cards(enemy: String, hp: Node):
	hits += 1
	if hp.points != 0: xp.add_exp(EXP)
	# for card in cards: 
	set_stats(card, enemy, hp)

func reset_stats() -> void:
	hits = 0 # caption = ""
	# for card in cards:
	card.damage.hide()
	card.hits.hide_all()
	if not boss_fight:
		card.disappear()

var in_game: Dictionary = { "eye-seeker": "Гляделкинс" }
