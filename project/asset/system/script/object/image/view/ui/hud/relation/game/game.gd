extends Node

@onready var pause: Node = $pause
@onready var help: Node = $help
@onready var gameplay: Node = $gameplay
@onready var inventory: Node = $inventory
@onready var menu: Node = $menu
@onready var hud: Node = $hud
var group: Node2D
var topic: Control
#@onready var equipment: Node = $equipment #@onready var stats: Node = $stats

func _e(space: Control) -> PanelContainer:
	return space.enemy # .space.title.enemies

func connect_card(stack: Container) -> void:
	if group.lay != null:
		group.lay.tags.layer.enemy.hud.card = [_e(topic), _e(stack.space)]

func controls(ui: CanvasLayer, game: Control) -> void:
	# pause.controls(ui, game.options.pause) # TODO FIXME PAUSE
	topic = game.controls.topic
	help.controls(ui, game)
	gameplay.controls(ui, topic)
	group = ui.get_node("../../group")
	game.priorities.stats.inventory.ability.topic.loaded.connect(connect_card)
	# game.get_enemy_cards()
	#stats.controls(hud, group, game.get_node("menu/stats"))
	inventory.controls(ui, group, game.priorities.stats.inventory)
	menu.controls(ui, group, game) #game.get_node("menu/stats/inventory/ability")
	hud.controls(ui, group, game)
