extends TypeItems

class_name UseTypeItems

enum { N = 0, L1 = 10, L2 = 12, L3 = 15, M = 40 }

func _icon(path: String) -> String: return "items/" + path
func _type(short: String) -> String: return short.replace("h", "ЖЗ").replace("a", "ОУ")

func _get_effect() -> Array: return [
	UseItem.new(L1, L1, KeyItem.Spend.JAR),
	UseItem.new(M, N, KeyItem.Spend.JAR),
	UseItem.new(N, M, KeyItem.Spend.JAR),
	UseItem.new(L3, N), UseItem.new(N, L2),
	UseItem.new(L3, N, KeyItem.Spend.LIMITED, "status.m_poison"),
	UseItem.new(L2, N, KeyItem.Spend.LIMITED, "status.m_cough"),
]

func _get_names() -> Array[Item]:
	var tea: int = Item.TEA; var ether: int = Item.ETHER
	return [
		_item("Чистая вода", "10 h 10 a", "Используется для создания водных растворов. Ингредиент", "jar/water.svg"),
		_item("Чай", "40 h", "Немного восполняет ауру здоровья", "jar/tea.svg", Item.i(tea)),
		_item("Эфир", "40 a", "Немного восполняет ресурс очков умений", "jar/ether.svg", Item.i(ether)),
		_item("Тамариск", "15 h", "Используется как ингридиент для лечебных отваров", "craft/tamarisk.svg", Item.o([tea])),
		_item("Перекати поле", "12 a", "Используется для восстановления бодрости. Ингридиент", "craft/tumbleweed.svg", Item.o([ether])),
		_item("Опунция", "- время яда", "Помогает при лихорадке и симптомах отравления", "craft/opuntia.svg", Item.o([Item.A_DOTE])),
		_item("Юкка", "- время кашля", "Убирает симптомы кашля, с картофельным привкусом.", "craft/yukka.svg", Item.o([Item.A_COUGH]))
	]
