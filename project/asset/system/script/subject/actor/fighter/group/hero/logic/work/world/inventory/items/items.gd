extends Resource

class_name GameItems

enum { KEY = 0, USE = 1, ARMOR = 2, WEAPON = 3 }
enum { JAR = 0, A_DOTE = 1, A_COUGH = 2, SAKSAUL = 3, G_KEY = 4, P_KEY = 5, WATER = 6, TEA = 7, ETHER = 8, TAMARISK = 9,
	 RT_FIELD = 10, OPUNTIA = 11, YUKKA = 12, L_PANTS = 13, C_LEGS = 14, L_BOOTS = 15, C_BOOTS = 16, L_CLOTH = 17, C_MAIL = 18,
	 T_SHIELD = 19, K_DUSTER = 20, W_KNIFE = 21, A_SWORD = 22, T_SWORD = 23, COLT = 24, SHOTGUN = 25, BOOMERANG = 26 }

var effect: ItemsEffect = ItemsEffect.new()

func get_type(no: int) -> Variant:
	match items[no].type:
		KEY: return keys[no]
		USE: return uses[no]
		WEAPON: return weapon[no]
		ARMOR: return armor[no]
	return USE[no]

func get_item(no: int, hero: CharacterBody2D) -> void:
	var item: Variant = get_type(no)
	effect.get(item.effect).call(no, self, hero)

var items: Array[Item] = [
	Item.new(KEY, "Пустая банка", "Позволяет хранить жидкость", "Находится в сундуках, их наличие значительно облегчает поход."),
	Item.new(KEY, "Антидот", "- Яд", "Снимает яд общего вида, горькое, но жить захочешь больше."),
	Item.new(KEY, "Антикашель", "- Кашель", "Безжалостно устраняет кашель."),
	Item.new(KEY, "Саксаул", "Создает кострище", "Некоторое время отпугивает монстров при зажигании костра из веток"),
	Item.new(KEY, "Золотой ключ", "Открывает замки", "Отворяет запертые врата при использовании"),
	Item.new(KEY, "Пурпурный ключ", "???", "???"),
	Item.new(USE, "Чистая вода", "+10 ЖЗ +10 ОУ", "Используется для создания водных растворов. Ингредиент"),
	Item.new(USE, "Чай", "+ 40 ЖЗ", "Немного восполняет ауру здоровья"),
	Item.new(USE, "Эфир", "+ 40 ОУ", "Немного восполняет ресурс очков умений"),
	Item.new(USE, "Тамариск", "+15 ЖЗ", "Используется как ингридиент для лечебных отваров"),
	Item.new(USE, "Перекати поле", "+12 ОУ", "Используется для восстановления бодрости. Ингридиент"),
	Item.new(USE, "Опунция", "- время яда", "Помогает при лихорадке и симптомах отравления"),
	Item.new(USE, "Юкка", "- время кашля", "Убирает симптомы кашля, с картофельным привкусом."),
	Item.new(ARMOR, "К. Штаны", "Одежда", "Сделаны из цельного куска кожи"),
	Item.new(ARMOR, "К. Поножи", "Броня", "Надежно защищает от попадания стрел"),
	Item.new(ARMOR, "К. Ботинки", "Одежда", "Без ботинок по раскаленным поверхностям перемещаться будет тяжеловато"),
	Item.new(ARMOR, "К. Сапоги", "Броня", "В них очень приятно давить ползающих гадюк"),
	Item.new(ARMOR, "К. Куртка", "Одежда", "Прикрывает спину от палящего солнца"),
	Item.new(ARMOR, "К. Нагрудник", "Броня", "Плотная кольчуга хорошо защищает от пробитий"),
	Item.new(ARMOR, "Ж. Щит", "Реликвия", "Защищает от внезапных ударов с 2% шансом"),
	Item.new(WEAPON, "К. Кастет", "Б. Оружие", "Усиливает пробивающую силу удара"),
	Item.new(WEAPON, "П. Нож", "Б. Оружие", "Годится чтобы нарезать тортик"),
	Item.new(WEAPON, "А. Меч", "Б. Оружие", "Снова сэкономили..."),
	Item.new(WEAPON, "И. Меч", "Б. Оружие", "Простая игрушка?"),
	Item.new(WEAPON, "К. Шофилд-45", "Д. Оружие", "Простой, надежный револьвер"),
	Item.new(WEAPON, "Дробовик", "Д. Оружие", "Похоже кто-то обронил"),
	Item.new(WEAPON, "Д. Бумеранг", "Д. Оружие", "Осторожно - это деревянное лезвие не игрушка"),
]
var uses: Dictionary = {
	WATER: KeyItem.new(10, 10), TEA: UseItem.new(40), ETHER: UseItem.new(0, 40),
	RT_FIELD: KeyItem.new(0, 12), TAMARISK: KeyItem.new(15),
	OPUNTIA: KeyItem.new(15, 0, "m_poison"), YUKKA: UseItem.new(12, 0, "m_cough"),
}
var keys: Dictionary = {
	SAKSAUL: KeyItem.new("distract"), JAR: KeyItem.new("store_water"),
	A_DOTE: KeyItem.new("no_poison"), A_COUGH: KeyItem.new("no_cough"),
	G_KEY: KeyItem.new("open_lock"), P_KEY: KeyItem.new("open_mystic")
}
var weapon: Dictionary = {
	K_DUSTER: WeaponItem.new(3), W_KNIFE: WeaponItem.new(4), A_SWORD: WeaponItem.new(7),
	BOOMERANG: WeaponItem.new(3), COLT: WeaponItem.new(5), SHOTGUN: WeaponItem.new(9)
}
var armor: Dictionary = {
	L_BOOTS: ArmorItem.new(1), C_BOOTS: ArmorItem.new(2),
	L_PANTS: ArmorItem.new(1, 1), C_LEGS: ArmorItem.new(3), 
	L_CLOTH: ArmorItem.new(2), C_MAIL: ArmorItem.new(5), 
	T_SHIELD: ArmorItem.new(2)
}
var recipe: Dictionary = {
	ETHER: [WATER, RT_FIELD], TEA: [WATER, TAMARISK],
	ANTICOUGH: [WATER, YUKKA], ANTIDOTE: [WATER, OPUNTIA]
}
