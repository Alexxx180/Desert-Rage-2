extends Node

@onready var combo: MarginContainer = $margin
var items: Array

func _ready() -> void:
	for i in range(1, 11):
		items.append(get_node("item_" + str(i % 10)))
