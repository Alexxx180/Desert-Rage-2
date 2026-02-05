extends Node

var t: Node

func controls(buttons: Array) -> void: # func enter() -> Callable: return resolve.t.set_button_input
	t.finish()
	t.logic.set_input_action(buttons)
	t.set_final_input(buttons)
	# interrupt()
	await get_tree().create_timer(0.1).timeout
	t.focus(t.topic, "grab")

func interrupt() -> void:
	t.logic.mode.input.interrupt()

func option(button: Button, named: String, machine: int) -> Callable:
	return func():
		interrupt()
		t.focus(button, "release")
		t.logic.set_device(machine)
		t.logic.set_caption(named)
		t.set_title()
