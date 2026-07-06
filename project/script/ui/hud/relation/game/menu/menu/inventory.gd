extends Node

enum { X = Vector2.Axis.AXIS_X, Y = Vector2.Axis.AXIS_Y }

const PORTION: Dictionary = { "HALF": 0.5, "FULL": 1.0 }
const INVENTORY: Array[int] = [-37, -74, -138] # [-318, ] # [37, 74] # -37
const ABILITY: Array[int] = [36, 188] # 109 # 

@onready var navigation: Node = $navigation
@onready var ability: Node = $ability

var stats: SplitContainer

func load_inventory(stack: Container) -> void:
	var focus: Control = stack.bag.ray.items.primary[0]
	navigation.face(Y, -PORTION.HALF, INVENTORY, focus, [[
		stats.topic.stack.bag.ray,
		navigation.ui.ability.controls.status.sticker.hp
	], [
		navigation.ui.ability.controls.status.markers
	], Def.ARRAY])

func load_ability(stack: Container) -> void:
	var status: HBoxContainer = stack.space.status.space.title.status
	var focus: Control = status.xp.body.space.options.pause
	ability.face(Y, PORTION.HALF, ABILITY, focus, [[
		ability.ui.controls.topic.status
	], Def.ARRAY])

func face_inventory(split: SplitContainer, s: SplitContainer) -> void:
	navigation.ui = split ; stats = s
	split.topic.loaded.connect(load_inventory)
	face_ability(split.ability)

func face_ability(split: SplitContainer) -> void:
	ability.ui = split # PORTION.FULL [336, 413]
	split.topic.loaded.connect(load_ability)
