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
	var count: int = len(combo.query)
	hint.show()
	for i in range(0, count):
		var j: int = count - i - 1
		hint.slots.slots[j].text = Skills.unicode[combo.query[j]]
		hint.slots.slots[j].show()
	for i in range(count, len(hint.slots.slots)):
		hint.slots.slots[i].hide()
	hiding.start()
	return self

func hide_slots() -> void:
	print("HIDING!")
	for hero in markers.combo.heroes.values():
		hero.hide()
		for slot in hero.slots.slots:
			slot.hide()
