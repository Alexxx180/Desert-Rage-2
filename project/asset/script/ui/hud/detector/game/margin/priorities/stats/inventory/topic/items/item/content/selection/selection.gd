extends Control

@onready var fast: VBoxContainer = $fast
@onready var count: VBoxContainer = $count

func put_item(slot: Dictionary) -> void:
	count.set_value(slot.x)

func remove_item() -> void:
	count.remove_item()
