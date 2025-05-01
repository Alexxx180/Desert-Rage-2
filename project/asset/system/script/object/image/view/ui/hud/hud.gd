extends Node

@export var progress: HelpPreview

@onready var game: CanvasLayer = $game
@onready var settings: CanvasLayer = $settings
@onready var sound: CanvasLayer = $sound

func set_group() -> void:
	SessionStats.save_progress()
	var group: Node2D = get_node("../group")
	for hero in group.deploy.party.heroes:
		hero.logic.processors.hud.display = game
	game.set_preview(group, progress)

func _ready() -> void:
	set_group()
	game.set_settings_transition(settings, get_node("../ost"))
	sound.set_settings_transition(settings)
	settings.set_transitions(game, sound)

func reset() -> void:
	game.detector.game.show()
	game.detector.pause.hide()
	settings.hide()
