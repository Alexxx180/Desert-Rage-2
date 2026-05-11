class_name HeroInventory extends Node

const SLOTS: int = 25

@onready var logic: Node = $logic
@onready var chest: Node = $chest
@onready var items: GameItems = GameItems.new()

static func slot() -> Dictionary:
	return { "id": 0, "x": 0, "with": -1, "up": 0 }

func _ready() -> void:
	var s: Array = []
	logic.items.items = items
	logic.trade.craft.preview.cells.craft = items.crafting.craft
	logic.trade.drag.inventory = self
	logic.effect.logic = logic
	logic.items.storage = s
	for i in SLOTS: s.append(slot())
