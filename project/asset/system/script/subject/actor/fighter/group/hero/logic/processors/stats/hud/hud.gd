extends Node

@onready var slots: Node = $slots

var display: CanvasLayer:
	set(value): slots.markers = display.detector.game.markers
var status: HBoxContainer:
	get: return display.detector.game.status

func dialog(text: Array[String]) -> void:
	display.detector.game.chat.add_blocks(text)

func notify(text: String):
	status.enemy[0].notify(text)
	return self

func set_slot_combo(caption):
	slots.set_combo_text(caption)
	return self

func set_slots(mark: Tick):
	var config: Dictionary = slots.get_config(mark.blackboard)
	slots.show(config.hint.slots, config.query)
	slots.hide_right(config.hint.slots, config.query)
	return self
