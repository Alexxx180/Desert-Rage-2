extends Node

class_name HeroInventory

@onready var logic: Node = $logic
@onready var chest: Node = $chest
@onready var items: GameItems = GameItems.new()

func _slot() -> Dictionary: return { "id": items.JAR, "x": 0, "with": -1, "up": 0 }

func _ready() -> void:
	logic.storage = [
		_slot(), _slot(), _slot(), _slot(), _slot(), _slot(), _slot(), _slot(), _slot(), _slot(),
		_slot(), _slot(), _slot(), _slot(), _slot(), _slot(), _slot(), _slot(), _slot(), _slot(),
	]
