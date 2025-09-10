extends Node

@onready var pause: Node = $pause
@onready var help: Node = $help
@onready var gameplay: Node = $gameplay
@onready var inventory: Node = $inventory
@onready var ability: Node = $ability
#@onready var equipment: Node = $equipment
#@onready var stats: Node = $stats

func controls(hud: CanvasLayer, game: Control) -> void:
	pause.controls(hud, game.options.pause)
	help.controls(hud, game)
	gameplay.controls(hud, game.options)
	var group: Node2D = hud.get_node("../../group")
	var tags: TileMapLayer = hud.get_node("../../tags")
	tags.enemy.hud.cards = game.get_enemy_cards()
	#stats.controls(hud, group, game.get_node("menu/stats"))
	inventory.controls(hud, group, game.get_node("menu/stats/inventory"))
	ability.controls(hud, group, game) #game.get_node("menu/stats/inventory/ability")
