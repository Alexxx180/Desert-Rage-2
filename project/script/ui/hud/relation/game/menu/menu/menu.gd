extends Node

const RESERVE: int = 24

@onready var inventory: Node = $inventory
@onready var priorities: Node = $priorities
@onready var stats: Node = $stats

var bag: SplitContainer
var navigation: Array:
	get: return [priorities, stats, inventory.navigation, inventory.ability]

func load_priorities(stack: Container) -> void:
	var focus: Control = stack.record.ranking.priority.selection.pursuit # priorities.ui = split
	priorities.face(inventory.X, inventory.PORTION.HALF, [RESERVE], focus, [[
		bag.topic.stack.status, bag.topic.stack.sticker,
		bag.ability.controls.hints.space.preview.help,
		bag.ability.controls.status.sticker
	]])

func load_stats(stack: Container) -> void:
	var focus: Control = stack.stats.title.equip
	stats.face(inventory.X, -inventory.PORTION.FULL, [-RESERVE], focus, [[
		bag.ability.controls.hints.space.preview.chats, bag.topic.stack.bag
	]])

func face_priorities(split: SplitContainer) -> void:
	bag = split.stats.inventory
	split.topic.loaded.connect(load_priorities)
	priorities.ui = split
	# split.ability.controls.status.sticker.points
	face_stats(split.stats)

func face_stats(split: SplitContainer) -> void:
	split.topic.loaded.connect(load_stats)
	stats.ui = split
	inventory.face_inventory(bag, split)

func controls(_hud: CanvasLayer, _group: Node2D, game: Control) -> void:
	face_priorities(game.priorities)
