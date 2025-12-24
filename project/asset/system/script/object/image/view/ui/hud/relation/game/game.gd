extends Node

@onready var pause: Node = $pause
@onready var help: Node = $help
@onready var gameplay: Node = $gameplay
@onready var inventory: Node = $inventory
@onready var menu: Node = $menu
@onready var hud: Node = $hud
#@onready var equipment: Node = $equipment
#@onready var stats: Node = $stats

func _e(space: Control) -> PanelContainer:
	return space.status.space.title.enemies.enemy

func controls(ui: CanvasLayer, game: Control) -> void:
	# pause.controls(ui, game.options.pause) # TODO FIXME PAUSE
	help.controls(ui, game)
	gameplay.controls(ui, game.controls.topic)
	var group: Node2D = ui.get_node("../../group")
	if group.lay != null: 
		group.lay.tags.layer.enemy.hud.card = [_e(game.controls.topic),
			_e(game.priorities.stats.inventory.ability.topic.stack.space)]
	# game.get_enemy_cards()
	#stats.controls(hud, group, game.get_node("menu/stats"))
	inventory.controls(ui, group, game.priorities.stats.inventory)
	menu.controls(ui, group, game) #game.get_node("menu/stats/inventory/ability")
	hud.controls(ui, group, game)
