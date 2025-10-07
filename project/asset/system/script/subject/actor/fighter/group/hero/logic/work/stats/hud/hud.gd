extends Node

@onready var slots: Node = $slots

var _display: CanvasLayer
var display: CanvasLayer:
	set(value):
		_display = value
		slots.markers = value.detector.game.markers
var status: HBoxContainer:
	get: return _display.detector.game.status

func dialog(text: Array[String]) -> void:
	_display.detector.game.chat.add_blocks(text)

func notify(text: String):
	status.enemy[0].notify(text)
	return self

func set_slot_combo(caption):
	slots.set_combo_text(caption)
	return self

func set_slots(mark: Tick):
	var config: Dictionary = slots.get_config(mark.blackboard)
	slots.show(config.hint.slots, config.query)
	slots.hide_right(config.hint, config.query)
	return self
