extends RefCounted

class_name IKey

var effect: String
var spending: int

func _init(_effect: String, spend: int = TypeItems.LIMITED) -> void:
	effect = _effect
	spending = spend

func buff(name: String) -> IKey:
	effect = name
	return self


extends IKey

class_name IUse

enum { AURA = 0, RESOURCE = 1, AR = 2, BOTH = 3 }

var power: int = 0
var supply: int = 0

func _init(_power: int, _supply: int, spend: int = TypeItems.LIMITED, _effect: String = "status.replenish") -> void:
	super._init(_effect, spend)
	power = _power
	supply = _supply

func rest(name: String) -> IUse:
	buff("status.replenish")
	return self

func same() -> bool: return power == supply
func less() -> bool: return power < supply

func _t(value: int) -> String: return str(value) + " "

func describes(check: Callable, a, b, c, d) -> String:
	if supply == 0: return a.call()
	if power == 0: return b.call()
	if check.call(): return c.call()
	return d.call()

func describe(ui: Node) -> String:
	return describes(same, func(): return _t(power) + ui.r(),
		func(): return _t(supply) + ui.a(),
		func(): return _t(power) + ui.ar(),
		func(): return ui.both() % [power, supply]
	)

func imagine(ui: Control) -> void:
	describes(less, ui.sresource, ui.saura, ui.sresource, ui.saura)


extends IArmor

class_name IWeapon

var cross: Array[int]

func _init(_power: int, _effect: String = "attack") -> void:
	super._init(_power, 0, _effect)

func eqw(value: Array[int]) -> IWeapon:
	eqa(value)
	return self

func of(_supply: int) -> IWeapon:
	supply = _supply
	return self

func crosses(_cross: Array[int]) -> IWeapon:
	cross = _cross
	return self


extends IUse

class_name IArmor

var equip: Array[int]

func _init(_power: int, _supply: int = 0, _effect: String = "defend") -> void:
	super._init(_power, _supply, TypeItems.INFINITE, _effect)

func aura(value: int) -> IArmor:
	supply = value
	return self

func eqa(value: Array[int]) -> IArmor:
	equip = value
	return self



extends IKey

class_name IEquip

var power: float = 0

func _init(_effect: String, _power: float) -> void:
	power = _power
	effect = _effect




class_name Item extends RefCounted

var name: String
var short: String
var description: String
var icon: String
var craft: Dictionary

func _init(_name: String, _short: String, _desc: String, _icon: String, _craft: Dictionary = {}) -> void:
	name = _name
	short = _short
	description = _desc
	icon = _icon
	craft = _craft



extends RefCounted

class_name GameItems

enum { ITEM = 0, CRAFT = 1, EQUIP = 2 }

var keys: KeyTypeItems = KeyTypeItems.new()
var uses: UseTypeItems = UseTypeItems.new()
var armor: ArmorTypeItems = ArmorTypeItems.new()
var weapon: WeaponTypeItems = WeaponTypeItems.new()
var equip: EquipTypeItems = EquipTypeItems.new()
var crafting: CraftingItems = CraftingItems.new(self)

func is_consumable(id: int) -> bool:
	return keys.in_items(id) or uses.in_items(id)

func is_equipable(id: int) -> bool:
	return weapon.in_items(id) or armor.in_items(id)

func craft(id: int) -> int:
	if equip.in_items(id): return EQUIP
	if crafting.in_items(id): return CRAFT
	return ITEM

func items() -> Array[String]: return ["keys", "uses", "armor", "weapon", "equip"]
func _init() -> void:
	var j: int = 0
	for i in items():
		var type = get(i)
		type.origin = j
		j += type.size

func get_item(no: int) -> Dictionary:
	if no < 0: return Def.DICT

	print("actual number: ", no)
	var j: int = 0 # var type
	for i in items():
		var type = get(i) ; print("type: ", i)
		if no < (type.size + j):
			print("category type: ", j); return type.get_item(no - j)#, type.get_item(j).item.name)
		j += type.size

	print("got untypical id number: ", no); return Def.DICT





extends TypeItems

class_name WeaponTypeItems

func _icon(path: String) -> String: return "weapon/" + path
func _pow(value: int) -> IWeapon: return IWeapon.new(value)

func _get_effect() -> Array[Dictionary]: return [
		_item("IKD", "WM", "melee/knuckle-duster", _pow(3).eqw([0, 1])),
		_item("IKW", "WM", "melee/knife", _pow(2)),
		_item("ISW", "WM", "melee/sword", _pow(4)),
		_item("IST", "WM", "melee/toy-sword", _pow(7)),
		_item("ICS", "WF", "firearm/schofield45-colt", _pow(5)),
		_item("IPT", "WF", "firearm/pacifist-colt", _pow(7)),
		_item("ISH", "WF", "firearm/shotgun", _pow(9)),
		_item("IBM", "WR", "boomerang", _pow(3)),
		_item("IBS", "WM", "melee/shoe", _pow(50)),
	]



extends TypeItems

class_name UseTypeItems

enum { N = 0, L1 = 10, L2 = 12, L3 = 15, M = 40 }

func _icon(path: String) -> String: return "items/" + path
func _type(short: String) -> String: return short#.replace("h", "ЖЗ").replace("a", "ОУ")
func _water() -> Dictionary: return o([TEA, ETHER, A_DOTE, A_COUGH])

func _use(power: int, supply: int, type: int = INFINITE) -> IUse:
	return IUse.new(power, supply, type)

func _buff(power: int, supply: int, effect) -> IUse:
	return _use(L3, N, LIMITED).rest("status.m_" + effect)

func _get_effect() -> Array[Dictionary]: return [
		_item("IW", "RC", "jar/water", _use(L1, L1, JAR), _water()),
		_item("IT", "RP", "jar/tea", _use(M, N, JAR), i(TEA)),
		_item("IE", "RP", "jar/ether", _use(N, M, JAR), i(ETHER)),
		_item("IR", "RP", "craft/tamarisk", _use(L3, N), o([TEA])),
		_item("IW", "RP", "craft/tumbleweed", _use(N, L2), o([ETHER])),
		_item("IO", "PT", "craft/opuntia", _buff(L3, N, "poison"), o([A_DOTE])),
		_item("IY", "CT", "craft/yukka", _buff(L2, N, "cough"), o([A_COUGH]))
	]




class_name TypeItems extends RefCounted

enum { INFINITE = 0, TEA = 0, LIMITED = 1, ETHER = 1, JAR = 2, A_DOTE = 2, A_COUGH = 3 }

static func spend(spending: int, slot: int, logic: Node) -> bool:
	match spending:
		JAR: return logic.items.replace_item(slot, JAR)
		LIMITED: logic.items.use_item(slot)
	return true

func i(product: int) -> Dictionary: return { "i": product }
func o(resources: Array[int]) -> Dictionary: return { "o": resources }
func recipe() -> Array: return [TEA, ETHER, A_DOTE, A_COUGH]

func crafts(result: Dictionary) -> void:
	for j in recipe(): result[j] = { "i": [], "o": -1 }

func get_item(no: int) -> Dictionary: return effect[no]
func _icon(path: String) -> String: return path + ".svg"
func _type(short: String) -> String: return short

func _items(name: String, type: String, description: String, icon: String, logic: Variant, _craft: Dictionary = {}) -> Dictionary:
	return { "logic": logic, "item": Item.new(name + "T", _type(type), description, _icon(icon), _craft) }

func _item(name: String, type: String, icon: String, logic: Variant, _craft: Dictionary = {}) -> Dictionary:
	return _items(name, type, name + "D", icon, logic, _craft)

func _get_effect() -> Array[Dictionary]: return []

func _init() -> void:
	effect = _get_effect()
	size = effect.size()

func in_items(id: int) -> bool: return origin <= id and id < origin + size

var origin: int
var size: int
var effect: Array[Dictionary]




extends TypeItems

class_name KeyTypeItems

func _icon(path: String) -> String: return "items/" + path

func k(effect: String) -> IKey: return IKey.new(effect)

func _get_effect() -> Array[Dictionary]: return [
		_item("IJ", "KL", "jar/bottle", k("store_water")),
		_item("ID", "PX", "jar/antidote", k("no_poison"), i(A_DOTE)),
		_item("IC", "CX", "jar/anti-cough", k("no_cough"), i(A_COUGH)),
		_item("IS", "CP", "craft/saksaul", k("distract")),
		_item("IG", "OL", "keys/gold", k("open_lock")),
		_items("IPK", "NA", "NA", "keys/secret", k("open_mystic"))
	]



extends TypeItems

class_name EquipTypeItems

enum { L1 = 5, L2 = 10, L3 = 15, L4 = 25 }

const E: Dictionary = { "RATE": "fire_rate", "DMG": "damage_increase" }

var items: Array = []

func _icon(path: String) -> String: return "armor/equip/" + path
func e(percent: int, effect: String) -> IEquip: return IEquip.new(effect, percent)

func _get_effect() -> Array[Dictionary]: return [
		_item("IU", "PAS", "butter.svg", e(L1, E.RATE)),
		_item("IF", "PBT", "fire-butter.svg", e(L4, "burn_time"), i(A_DOTE)),
		_item("IG", "PDG", "fasten.svg", e(L1, E.DMG), i(A_COUGH)),
		_item("IM", "PSD", "pump.svg", e(-L2, "spread_decrease")),
		_item("IT", "PDG", "metal-end.svg", e(L3, E.DMG)),
		_item("IA", "PRG", "target.svg", e(L1, "range")),
		_item("IL", "PAS", "cleaner.svg", e(L1, E.RATE)),
		_item("IEA", "PRC", "magazine.svg", e(-L2, "skip_cost"))
	]


extends RefCounted

class_name CraftingItems

var craft: Dictionary = {}
var items: Array = []

func in_items(id: int) -> bool: return id in items
func push_back(id: int) -> void:
	if not in_items(id):
		items.push_back(id)

func _add_item(c: Array, id: int) -> void:
	for o in c:
		craft[o].i.push_back(o)
	push_back(id)

func _connect_ingredients(c: Dictionary, id: int) -> void:
	if c.has("o"):
		_add_item(c.o, id)
	else:
		craft[c.i].o = id

func _set_craft(type, base: int) -> void:
	for j in type.size:
		var i: Item = type.effect[j].item
		if not i.craft.is_empty():
			print("CRAFT ITEM: ", i.name)
			_connect_ingredients(i.craft, base + j) #craft

func _init(items: GameItems) -> void:
	items.weapon.crafts(craft)
	var n: int = 0
	for i in ["keys", "uses"]:
		var type = items.get(i)
		_set_craft(type, n)
		n += type.size
	print("craft: ", craft)


extends TypeItems

class_name ArmorTypeItems

func _icon(path: String) -> String: return "armor/" + path
func _def(value: int) -> IArmor: return IArmor.new(value)

func _get_effect() -> Array[Dictionary]: return [
		_item("IN", "AC", "pants/pants.svg", _def(1).aura(1)),
		_item("IV", "AA", "pants/greaves.svg", _def(3)),
		_item("IH", "AC", "boots/leather.svg", _def(1)),
		_item("IB", "AA", "boots/iron.svg", _def(2)),
		_item("IK", "AC", "jacket/leather.svg", _def(2)),
		_item("IP", "AA", "jacket/iron.svg", _def(5)),
		_item("II", "AR", "artifact/shield.svg", _def(2)),
		_item("IWD", "AR", "artifact/tooth.svg", _def(0).aura(10))
	]
