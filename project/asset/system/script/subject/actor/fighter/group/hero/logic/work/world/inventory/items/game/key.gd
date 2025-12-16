extends TypeItems

class_name KeyTypeItems

func _icon(path: String) -> String: return "items/" + path

func _get_effect() -> Array:
	var e: Array[KeyItem] = []
	for name in ["store_water", "no_poison", "no_cough", "distract", "open_lock", "open_mystic"]: e.push_back(KeyItem.new(name))
	return e

func _get_names() -> Array[Item]: return [
		_item("Пустая банка", "Позволяет хранить жидкость", "Находится в сундуках, их наличие значительно облегчает поход.", "jar/bottle.svg"),
		_item("Антидот", "- Яд", "Снимает яд общего вида, горькое, но жить захочешь больше.", "jar/antidote.svg", Item.i(Item.A_DOTE)),
		_item("Антикашель", "- Кашель", "Безжалостно устраняет кашель.", "jar/anti-cough.svg", Item.i(Item.A_COUGH)),
		_item("Саксаул", "Создает кострище", "Некоторое время отпугивает монстров при зажигании костра из веток", "craft/saksaul.svg"),
		_item("Золотой ключ", "Открывает замки", "Отворяет запертые врата при использовании", "keys/gold.svg"),
		_item("Пурпурный ключ", "???", "???", "keys/secret.svg")
	]
