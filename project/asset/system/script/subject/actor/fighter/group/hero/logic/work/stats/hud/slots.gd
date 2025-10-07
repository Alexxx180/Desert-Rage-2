extends Node

@onready var hiding: Timer = $preview

var markers: HFlowContainer

func _ready() -> void:
	hiding.timeout.connect(hide_slots_status)

func show(ui, query) -> void:
	ui.show()
	for j in range(len(query) - 1, -1, -1):
		ui.slots[j].text = Skills.unicode[query[j]]
		ui.slots[j].show()

func hide_right(hint, query) -> void:
	var count: int = len(query)
	for i in range(count, len(hint.slots.slots)):
		hint.slots.slots[i].hide()
	if count == 0: hint.status.hide()
	hiding.start()

func set_combo_text(caption: String):
	markers.combo.heroes.ray.status.show()
	markers.combo.heroes.ray.status_caption.text = caption

func get_config(board: BehaviorBlackboard) -> Dictionary:
	var hero: CharacterBody2D = board.get_value("tools").hero
	return { "hint": markers.combo.heroes[hero.name], "query": board.get_value("combo").query } 

func hide_slots_separate(hero) -> void:
	hero.slots.hide()
	for slot in hero.slots.slots:
		slot.hide()

func hide_slots_status() -> void:
	for hero in markers.combo.heroes.values():
		hero.status.hide()
		hide_slots_separate(hero)
