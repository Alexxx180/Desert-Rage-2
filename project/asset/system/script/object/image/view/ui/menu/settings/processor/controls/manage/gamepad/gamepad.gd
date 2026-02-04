extends Node

@onready var button: Node = $button

func c(e: InputEvent) -> int: return e.button_index

func one_key(_d, event: InputEvent) -> void:
	if event is InputEventJoypadMotion:
		button.finish(button.from_axis(event))
	else:
		button.finish([c(event)])

func hot(_d, event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		button.add_buttons(event.pressed, c(event))
	else:
		button.add_buttons(event.axis_value != 0, button.from_axis(event))
		
func aggregate(event: InputEvent) -> void:
	if event is InputEventJoypadMotion and button.all_axis(event): return
	if event.pressed: button.add_buttons(button.completed(), c(event))
