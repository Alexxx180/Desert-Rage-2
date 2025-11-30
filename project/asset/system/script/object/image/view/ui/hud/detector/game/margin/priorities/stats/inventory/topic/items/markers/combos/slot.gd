extends HBoxContainer

@onready var slot: Label = $slot

var text: String:
	set(value): slot.text = value
