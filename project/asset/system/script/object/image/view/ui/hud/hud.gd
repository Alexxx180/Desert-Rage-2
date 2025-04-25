extends Node

@export var progress: HelpPreview

@onready var game: CanvasLayer = $game
@onready var settings: CanvasLayer = $settings

func set_group() -> void:
	SessionStats.save_progress()
	var group: Node2D = get_node("../group")
	for hero in group.deploy.party.heroes:
		hero.logic.processors.hud.display = game
	game.set_preview(group, progress)

func _ready() -> void:
	#set_group()
	game.set_settings_transition(settings)
	settings.set_back(game)
