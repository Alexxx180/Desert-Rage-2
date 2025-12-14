extends RefCounted

class_name UseTypeItems

enum { N = 0, L1 = 10, L2 = 12, L3 = 15, M = 40 }

func get_item(no: int) -> Variant:
	return { "logic": effect[no], "item": names[no] }

func _init() -> void: size = names.size()

var size: int
var effect: Array[UseItem] = [
	UseItem.new(L1, L1), UseItem.new(M, N), UseItem.new(N, M),
	UseItem.new(L3, N), UseItem.new(N, L2),
	UseItem.new(L3, N, "m_poison"), UseItem.new(L2, N, "m_cough"),
]

var names: Array[Item] = [
	Item.new("Чистая вода", "+10 ЖЗ +10 ОУ", "Используется для создания водных растворов. Ингредиент", "items/water.svg"),
	Item.new("Чай", "+ 40 ЖЗ", "Немного восполняет ауру здоровья", "items/tea.svg", { "i": Item.TEA }),
	Item.new("Эфир", "+ 40 ОУ", "Немного восполняет ресурс очков умений", "items/ether.svg", { "i": Item.ETHER }),
	Item.new("Тамариск", "+15 ЖЗ", "Используется как ингридиент для лечебных отваров", "items/tamarisk.svg", { "o": [Item.TEA] }),
	Item.new("Перекати поле", "+12 ОУ", "Используется для восстановления бодрости. Ингридиент", "items/tumbleweed.svg", { "o": [Item.ETHER] }),
	Item.new("Опунция", "- время яда", "Помогает при лихорадке и симптомах отравления", "items/opuntia.svg", { "o": [Item.A_DOTE] }),
	Item.new("Юкка", "- время кашля", "Убирает симптомы кашля, с картофельным привкусом.", "items/yukka.svg", { "o": [Item.A_COUGH] })
]
