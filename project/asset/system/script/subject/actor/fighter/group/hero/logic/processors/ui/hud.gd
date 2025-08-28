extends Node

@onready var hiding: Timer = $preview

var display: CanvasLayer #Control
var status: VBoxContainer:
	get: return display.detector.game.status
var markers: HFlowContainer:
	get: return display.detector.game.markers

func _ready() -> void:
	hiding.timeout.connect(hide_slots)

func dialog(text: Array[String]) -> void:
	display.detector.game.chat.add_blocks(text)

func notify(text: String):
	status.hero.notify(text)
	return self

func set_slots(mark: Tick):
	var hero: CharacterBody2D = mark.blackboard.get_value("tools").hero
	var combo: Dictionary = mark.blackboard.get_value("combo")
	var hint: HBoxContainer = markers.combo.heroes[hero.name]
	hint.show()
	for i in range(0, len(combo.query)):
		hint.slots.slots[i].text = Skills.unicode[combo.query[i]]
		hint.slots.slots[i].show()
	hiding.start()
	return self

func hide_slots() -> void:
	print("HIDING!")
	for hero in markers.combo.heroes.values():
		hero.hide()
		for slot in hero.slots.slots:
			slot.hide()
