extends Node

@onready var pause: Node = $pause
@onready var help: Node = $help
@onready var gameplay: Node = $gameplay
@onready var inventory: Node = $inventory
@onready var ability: Node = $ability
@onready var hud: Node = $hud
#@onready var equipment: Node = $equipment
#@onready var stats: Node = $stats

func controls(ui: CanvasLayer, game: Control) -> void:
	pause.controls(ui, game.options.pause)
	help.controls(ui, game)
	gameplay.controls(ui, game.options)
	var group: Node2D = ui.get_node("../../group")
	var tags: TileMapLayer = ui.get_node("../../tags")
	tags.enemy.hud.cards = game.get_enemy_cards()
	#stats.controls(hud, group, game.get_node("menu/stats"))
	inventory.controls(ui, group, game.get_node("menu/stats/inventory"))
	ability.controls(ui, group, game) #game.get_node("menu/stats/inventory/ability")
	hud.controls(ui, group, game)
