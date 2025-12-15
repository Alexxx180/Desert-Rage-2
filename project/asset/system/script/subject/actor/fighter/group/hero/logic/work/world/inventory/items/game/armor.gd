extends RefCounted

class_name ArmorTypeItems

var t: Dictionary = { "C": "Одежда", "A": "Броня", "R": "Реликвия" }

func get_item(no: int) -> Dictionary:
	return { "logic": effect[no], "item": names[no] }

func _init() -> void: size = names.size()

func _slot(name: String, type: String, description: String, icon: String) -> Item:
	return Item.new(name, t[type], description, "armor/" + icon)

var size: int
var effect: Array[ArmorItem] = [
	ArmorItem.new(1, 1), ArmorItem.new(3), ArmorItem.new(1),
	ArmorItem.new(2), ArmorItem.new(2), ArmorItem.new(5),
	ArmorItem.new(2), ArmorItem.new(0, 10)
]
var names: Array[Item] = [
	_slot("К. Штаны", "C", "Сделаны из цельного куска кожи", "pants/pants.svg"),
	_slot("К. Поножи", "A", "Надежно защищает от попадания стрел", "pants/greaves.svg"),
	_slot("К. Ботинки", "C", "Без ботинок по раскаленным поверхностям перемещаться будет тяжеловато", "boots/leather.svg"),
	_slot("К. Сапоги", "A", "В них очень приятно давить ползающих гадюк", "boots/iron.svg"),
	_slot("К. Куртка", "C", "Прикрывает спину от палящего солнца", "breast-plate/leather.svg"),
	_slot("К. Нагрудник", "A", "Плотная кольчуга хорошо защищает от пробитий", "breast-plate/iron.svg"),
	_slot("Ж. Щит", "R", "Защищает от внезапных ударов с 1% шансом", "artifact/shield.svg"),
	_slot("Зуб мудрости", "R", "Усиливает ваше влияние", "artifact/tooth.svg")
]
