extends Node

enum { X = Vector2.Axis.AXIS_X, Y = Vector2.Axis.AXIS_Y }

const PORTION: Dictionary = { "HALF": 0.5, "FULL": 1.0 }
const INVENTORY: Array[int] = [-37, -74] # [-318, ] # [37, 74] # -37
const ABILITY: Array[int] = [36, 113] # 109 # 

@onready var navigation: Node = $navigation
@onready var ability: Node = $ability

func face_inventory(split: SplitContainer, stats: SplitContainer) -> void:
	var focus: Control = split.topic.stack.bag.ray.items.primary[0]
	navigation.ui = split
	navigation.face(Y, -PORTION.HALF, INVENTORY, focus, [[
		stats.topic.stack.bag.ray
	], [
		split.ability.controls.status.markers
	]])
	face_ability(split.ability)

func face_ability(split: SplitContainer) -> void:
	var status: HBoxContainer = split.topic.stack.space.status.space.title.status
	var focus: Control = status.xp.body.space.options.pause
	ability.ui = split # PORTION.FULL [336, 413]
	ability.face(Y, PORTION.HALF, ABILITY, focus, [[
		split.controls.topic.status
	], [
		split.controls
	]]) # Defaults.ARRAY
