extends RefCounted

class_name KeyTypeItems

func get_item(no: int) -> Variant:
	return { "logic": effect[no], "item": names[no] }

func _init() -> void:
	size = names.size()
	for name in ["store_water", "no_poison", "no_cough", "distract", "open_lock", "open_mystic"]:
		effect.push_back(KeyItem.new(name))

var size: int
var effect: Array[KeyItem] = []
var names: Array[Item] = [
	Item.new("Пустая банка", "Позволяет хранить жидкость", "Находится в сундуках, их наличие значительно облегчает поход.", "items/bottle.svg"),
	Item.new("Антидот", "- Яд", "Снимает яд общего вида, горькое, но жить захочешь больше.", "items/antidote.svg", { "i": Item.A_DOTE }),
	Item.new("Антикашель", "- Кашель", "Безжалостно устраняет кашель.", "items/anti-cough.svg", { "i": Item.A_COUGH }),
	Item.new("Саксаул", "Создает кострище", "Некоторое время отпугивает монстров при зажигании костра из веток", "craft/saksaul.svg"),
	Item.new("Золотой ключ", "Открывает замки", "Отворяет запертые врата при использовании", "keys/gold.svg"),
	Item.new("Пурпурный ключ", "???", "???", "keys/secret.svg")
]
