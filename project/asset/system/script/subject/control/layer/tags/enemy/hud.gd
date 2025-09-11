extends RefCounted

class_name EnemyHUD

var boss_fight: bool = false

var foe: Node
var cards: Array
var hits: int = 0

const CONTEST_TIME: float = 1.5

var tween: Dictionary = {}

func set_timer(enemy: Node) -> void:
	foe = enemy
	foe.hud_reseter.timeout.connect(reset_stats)

func set_achievement() -> void: if hits >= 100: pass # set after 100 hits in a row

func setup(enemy: CharacterBody2D) -> void:
	var health: Node = enemy.logic.processor.health
	var hp: Node = health.points
	hp.update_bar.connect(func(v): set_cards(in_game[enemy.caption], hp))
	health.interrogation.connect(func(): set_cards(in_game[enemy.caption], hp))

func set_health(card: PanelContainer, hp: Node) -> void:
	for bar in [card.health, card.contested]:
		bar.max_value = hp.maximum
	card.health.value = hp.points
	var id: int = card.get_instance_id()
	if tween.has(id):
		tween[id].kill()
	tween[id] = foe.create_tween()

	if hp.points == 0:
		card.contested.value = hp.maximum
		print("HP SET TO MAX")
		# foe.create_tween().tween_property(card.contested, "value", hp.points, CONTEST_TIME)
		tween[id].tween_property(card.contested, "value", hp.points, CONTEST_TIME)
	else:
		card.contested.value = hp.contested
		tween[id].tween_property(card.contested, "value", hp.points, CONTEST_TIME)


func set_damage(card: PanelContainer, hp: Node) -> void:
	card.damage.health.text = str(int(hp.contested))
	card.damage.value.text = str(int(hp.contested - hp.points))
	var interrogation: bool = hp.contested == 0
	card.interrogate.visible = interrogation
	card.damage.visible = !interrogation

func set_hits(card: PanelContainer) -> void:
	if hits >= 2:
		card.hits.count.text = str(hits)
		card.hits.show()
		set_achievement()

func set_stats(card: PanelContainer, enemy: String, hp: Node) -> void:
	card.caption.text = enemy
	card.show()
	set_health(card, hp)
	set_damage(card, hp)
	set_hits(card)
	foe.hud_reseter.start()

func set_cards(enemy: String, hp: Node):
	hits += 1
	for card in cards: set_stats(card, enemy, hp)

func reset_stats() -> void:
	hits = 0 # caption = ""
	for card in cards:
		card.damage.hide()
		card.hits.hide()
		if not boss_fight:
			card.hide()

var in_game: Dictionary = { "eye-seeker": "Гляделкинс" }
