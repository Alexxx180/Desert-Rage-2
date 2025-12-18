extends Node

const RESERVE: int = 24

@onready var inventory: Node = $inventory
@onready var priorities: Node = $priorities
@onready var stats: Node = $stats

var navigation: Array:
	get: return [priorities, stats, inventory.navigation, inventory.ability]

func face_priorities(split: SplitContainer) -> void:
	var bag: SplitContainer = split.stats.inventory
	var focus: Control = split.topic.stack.record.ranking.priority.selection.pursuit
	priorities.ui = split
	priorities.face(inventory.X, inventory.PORTION.HALF, [RESERVE], focus, [[
		bag.topic.stack.status, bag.topic.stack.sticker,
		bag.ability.controls.preview.help,
		bag.ability.controls.status.sticker
	]])
	# split.ability.controls.status.sticker.points
	face_stats(split.stats, bag)

func face_stats(split: SplitContainer, bag: SplitContainer) -> void:
	var focus: Control = split.topic.stack.stats.title.equip
	stats.ui = split
	stats.face(inventory.X, -inventory.PORTION.FULL, [-RESERVE], focus, [[
		bag.ability.controls.preview.chats, bag.topic.stack.bag
	]])
	inventory.face_inventory(bag, split)

func controls(_hud: CanvasLayer, _group: Node2D, game: Control) -> void:
	face_priorities(game.priorities)
