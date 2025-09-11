extends Node

@onready var hiding: Timer = $preview

var display: CanvasLayer
var status: HBoxContainer:
	get: return display.detzector.game.status
var markers: HFlowContainer:
	get: return display.detector.game.markers

func _ready() -> void:
	hiding.timeout.connect(hide_slots)

func dialog(text: Array[String]) -> void:
	display.detector.game.chat.add_blocks(text)

func notify(text: String):
	status.enemy[0].notify(text)
	return self

func set_slot_combo(caption):
	markers.combo.heroes.ray.status.show()
	markers.combo.heroes.ray.status_caption.text = caption
	return self

func set_slots(mark: Tick):
	var hero: CharacterBody2D = mark.blackboard.get_value("tools").hero
	var combo: Dictionary = mark.blackboard.get_value("combo")
	var hint: HBoxContainer = markers.combo.heroes[hero.name]
	var count: int = len(combo.query)
	hint.slots.show()
	for i in range(0, count):
		var j: int = count - i - 1
		hint.slots.slots[j].text = Skills.unicode[combo.query[j]]
		hint.slots.slots[j].show()
	
	for i in range(count, len(hint.slots.slots)):
		hint.slots.slots[i].hide()
	if count == 0:
		hint.status.hide()
	hiding.start()
	return self

func hide_slots() -> void:
	print("HIDING!")
	for hero in markers.combo.heroes.values():
		# hero.hide()
		hero.slots.hide()
		hero.status.hide()
		#hero.status_caption.text = ""
		for slot in hero.slots.slots:
			slot.hide()
