extends Node

@onready var device: Node = $device
@onready var input: Node = $input
@onready var type: Node = $type

var keys: Node
var buttons: Node:
	get: return keys.get(device.named)

func select(caption: String, mask: int = input.DEFAULT) -> void:
	mask = type.mask(caption, mask)
	type.select(type.get(caption))
	input.mask(mask, type)

func manage(machine: Node, event: InputEvent) -> void:
	if not device.check(event):
		type.manage(machine, event)

func translate(sequence: Array) -> Array:
	return type.translate(keys.get(device.named), sequence)

func connects(enter: Callable, controls: Callable) -> void:
	input.link.enter_keys.connect(enter)
	input.link.finish_combo.connect(controls)

func _ready() -> void: input.link.mode = self
