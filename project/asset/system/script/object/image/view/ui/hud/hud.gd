extends Node

@export var progress: HelpPreview

@onready var game: CanvasLayer = $game
@onready var settings: CanvasLayer = $settings
@onready var information: CanvasLayer = $information
@onready var sound: CanvasLayer = $sound

@onready var group: Node2D  = get_node("../group")

func set_group() -> void:
	SessionStats.save_progress()
	#group
	for hero in group.deploy.party.heroes:
		hero.logic.processors.ui.hud.display = game
	game.set_preview(group, progress)

func _ready() -> void:
	set_group() # TODO 
	game.set_transitions({ "settings": settings,
		"information": information }, get_node("../ost"))
	information.set_transition(game)
	sound.set_settings_transition(settings)
	settings.set_transitions(game, sound)

func reset() -> void:
	game.detector.game.show()
	game.detector.pause.hide()
	settings.hide()
