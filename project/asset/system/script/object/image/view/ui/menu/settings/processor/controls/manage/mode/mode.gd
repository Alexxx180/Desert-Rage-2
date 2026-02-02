extends Node

@onready var device: Node = $device
@onready var input: Node = $input
@onready var type: Node = $type

var keys: Node
var buttons: Node:
	get: return keys.get(device.named)

func select(caption: String, key_mask = input.DEFAULT) -> void:
	key_mask = type.mask(caption, key_mask)
	type.select(type.get(caption))
	input.mask(key_mask, type)

func clear() -> void:
	input.clear()
	type.clear()

func manage(machine: Node, event: InputEvent) -> void:
	if not device.check(event):
		type.manage(machine, event)

func translate(sequence: Array) -> Array:
	return type.translate(keys.get(device.named), sequence)

func connects(enter: Callable, controls: Callable) -> void:
	input.enter_keys.connect(enter)
	input.finish_combo.connect(controls)

func _ready() -> void: input.mode = self
