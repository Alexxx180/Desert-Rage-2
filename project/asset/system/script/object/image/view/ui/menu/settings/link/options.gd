extends Node

var t: Node

func controls(buttons: Array): # func enter() -> Callable: return resolve.t.set_button_input
	t.finish(buttons)
	t.logic.set_input_action(buttons)
	t.set_final_input(buttons)
	await get_tree().create_timer(0.1).timeout
	t.focus(t.topic, false, "grab")

func option(button: Button, named: String, machine: int) -> Callable:
	return func():
		t.focus(button, true, "release")
		t.logic.set_caption(named)
		t.set_title()
		t.logic.set_device(machine)
