extends RefCounted

class_name ArmorTypeItems

func get_item(no: int) -> Dictionary:
	return { "logic": effect[no], "item": names[no] }

func _init() -> void: size = names.size()

var size: int
var effect: Array[ArmorItem] = [
	ArmorItem.new(1, 1), ArmorItem.new(3), ArmorItem.new(1),
	ArmorItem.new(2), ArmorItem.new(2), ArmorItem.new(5),
	ArmorItem.new(2), ArmorItem.new(0, 10)
]
var names: Array[Item] = [
	Item.new("К. Штаны", "Одежда", "Сделаны из цельного куска кожи", "armor/pants/pants.svg"),
	Item.new("К. Поножи", "Броня", "Надежно защищает от попадания стрел", "armor/pants/greaves.svg"),
	Item.new("К. Ботинки", "Одежда", "Без ботинок по раскаленным поверхностям перемещаться будет тяжеловато", "armor/boots/leather.svg"),
	Item.new("К. Сапоги", "Броня", "В них очень приятно давить ползающих гадюк", "armor/boots/iron.svg"),
	Item.new("К. Куртка", "Одежда", "Прикрывает спину от палящего солнца", "armor/breast-plate/leather.svg"),
	Item.new("К. Нагрудник", "Броня", "Плотная кольчуга хорошо защищает от пробитий", "armor/breast-plate/iron.svg"),
	Item.new("Ж. Щит", "Реликвия", "Защищает от внезапных ударов с 1% шансом", "armor/shield.svg"),
	Item.new("Зуб мудрости", "Реликвия", "Усиливает ваше влияние", "armor/shield.svg")
]
