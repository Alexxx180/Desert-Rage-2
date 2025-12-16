extends Node

class_name HeroInventory

const SLOTS: int = 25

@onready var logic: Node = $logic
@onready var chest: Node = $chest
@onready var items: GameItems = GameItems.new()

static func slot() -> Dictionary:
	return { "id": 0, "x": 0, "with": -1, "up": 0 }

func _ready() -> void:
	logic.effect.logic = logic
	logic.effect.items = items
	logic.storage = []
	for i in range(0, SLOTS): logic.storage.append(slot())
