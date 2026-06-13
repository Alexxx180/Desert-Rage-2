class_name HeroInventory extends RefCounted

enum { STICKS, OPUNTIA, TUMBLEWEED, YUKKA, JAR, ANTIDOTE, GOLD_KEY, SECRET_KEY,
	WATER, TEA, ETHER, L_PANTS, I_PANTS, L_ARMOR, I_ARMOR, L_BOOTS, I_BOOTS,
	SHIELD, CORETOOTH, KNUCKLES, SAW_STRING, W_RAPIER, T_RAPIER, SHOE, R_SCHO45,
	R_ENLIGHT, SHOTGUN, BOOMERANG, BUTTER, F_BUTTER, CLEANER, SHARPEN, AMMO,
	BLADE, PUMP, AIM, SLOTS = 25, CRAFT = 7, USE = 10, ARMOR = 28, KIT = 36 }

const aura: PackedByteArray = [10, 70, 0]
const resc: PackedByteArray = [10, 0, 50]

const power: PackedByteArray = [5, 5, 5, 5]
const shell: PackedByteArray = [5, 5, 5, 5]
const impac: PackedByteArray = [5, 5, 5, 5]
const react: PackedByteArray = [5, 5, 5, 5]

"""
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
"""
