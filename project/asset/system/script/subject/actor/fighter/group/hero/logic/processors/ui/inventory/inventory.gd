extends Node

var inventory: HFlowContainer

var items: Dictionary = {
	0: { "icon": "🫙", "name": "Пустая банка", "short": "Позволяет хранить жидкость",
		 "description": "Находится в сундуках, их наличие значительно облегчает поход." },
	1: { "icon": "🚰", "name": "Чистая вода", "short": "Восполняет ЖЗ и ДА. Ингредиент",
		"description": "Используется для создания водных растворов", "tiny": "+10 ЖЗ +10 ДА" },
	9: { "icon": "🎃", "name": "Чучело", "short": "Отвлекает противников", "recipe": "Глаз + Кость + Бинт",
		"description": "Образец собранный из подручных материалов, позволяет избежать сражения на определенное время." }
}

var storage: Dictionary = {
	0: { "item": 0, "count": 1 }, 1: { "item": 0, "count": 0 }, 2: { "item": 0, "count": 0 }, 3: { "item": 0, "count": 0 },
	4: { "item": 0, "count": 0 }, 5: { "item": 0, "count": 0 }, 6: { "item": 0, "count": 0 }, 7: { "item": 0, "count": 0 },
	8: { "item": 0, "count": 0 }, 9: { "item": 0, "count": 0 }, 10: { "item": 0, "count": 0 }, 11: { "item": 0, "count": 0 },
	12: { "item": 0, "count": 0 }, 13: { "item": 0, "count": 0 }, 14: { "item": 0, "count": 0 }, 15: { "item": 0, "count": 0 },
}

func _ready() -> void:
	# game.detector.menu.stats.inventory.topic.items.storage
	pass # UPDATE DEFAULT INVENTORY STATE

func use_inventory() -> void:
	pass

func put_to_inventory(atlas: Vector2i) -> bool:
	var enough_space: bool = true
	inventory
	return enough_space

func show_inventory(atlas: Vector2i) -> void:
	pass
