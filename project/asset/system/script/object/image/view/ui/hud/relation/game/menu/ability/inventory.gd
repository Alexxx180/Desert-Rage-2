extends Node

enum { X = Vector2.Axis.AXIS_X, Y = Vector2.Axis.AXIS_Y }

const HALF_DIR: float = 0.5
const INVENTORY: Array[int] = [-37, 74]
const ABILITY: Array[int] = [32, 109]

@onready var navigation: Node = $navigation
@onready var ability: Node = $ability

func face_inventory(split: SplitContainer, stats: SplitContainer) -> void:
	var focus: Control = split.topic.stack.bag.ray.items.primary[0]
	navigation.ui = split
	navigation.face(Y, -HALF_DIR, INVENTORY, focus, [[
		stats.topic.stack.bag.ray
	], Defaults.ARRAY])
	face_ability(split.ability)

func face_ability(split: SplitContainer) -> void:
	var status: HBoxContainer = split.topic.stack.space.status.space.title.status
	var focus: Control = status.xp.body.space.options.pause
	ability.ui = split
	ability.face(Y, Y, ABILITY, focus, [[
		split.controls.topic.status
	], Defaults.ARRAY])
