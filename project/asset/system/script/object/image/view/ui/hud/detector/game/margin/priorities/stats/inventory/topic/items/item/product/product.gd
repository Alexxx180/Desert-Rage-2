extends Button

@onready var margin: MarginContainer = $margin

var drag: Node

func _ready() -> void: pressed.connect(select_item)

func select_item() -> void: drag.select_item(self)
