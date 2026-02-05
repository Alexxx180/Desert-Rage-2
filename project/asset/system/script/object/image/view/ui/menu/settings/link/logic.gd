extends Node

var mode: Node
var option: String:
	get: return mode.input.link.option

const MASK: int = 1
const KEY: String = "MASK"

func activate(type: String, mask: int) -> Callable:
	return func(): mode.select(type, mask)

func join(sequence: Array) -> String:
	return mode.type.separator.join(sequence)

func set_device(machine: int) -> void:
	mode.device.set_as(machine)

func set_input_action(buttons: Array) -> void:
	mode.buttons.set_action(option, buttons)

func set_caption(caption: String) -> void:
	mode.input.link.option = caption

func valid(key: String) -> bool: return not key == KEY

func custom_mask(modes: Dictionary, named: String) -> int:
	if not modes.has(KEY): return MASK
	if not modes[KEY].has(named): return MASK
	return modes[KEY][named]

func connects(options: Node) -> void:
	mode.interrupts(options.t.finish)
	mode.connects(options.t.set_button_input, options.controls)
