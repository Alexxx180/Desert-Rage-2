extends Node

@export var progress: HelpPreview

@onready var game: CanvasLayer = $game
@onready var settings: CanvasLayer# = $settings
@onready var information: CanvasLayer# = $information
@onready var sound: CanvasLayer# = $sound

var hud: Dictionary = {
	"settings": preload("res://asset/system/scene/object/canvas/ui/menu/settings/settings.tscn"),
	"sound": preload("res://asset/system/scene/object/canvas/ui/menu/sound/sound.tscn"),
	"info": preload("res://asset/system/scene/object/canvas/ui/menu/information/information.tscn")
}

@onready var group: Node2D  = get_node("../group")

func set_group() -> void:
	SessionStats.save_progress()
	#group
	for hero in group.deploy.party.heroes:
		hero.logic.work.stats.hud.display = game
	game.set_preview(group, progress)

func set_transitions() -> String:
	settings = hud.settings.instantiate() # settings
	add_child(settings)
	settings.link.controls(game.see)
	return """
	game.set_transitions({ "settings": settings,
		"information": information }, get_node("../ost"))
	information.set_transition(game)
	sound.set_settings_transition(settings)
	settings.set_transitions(game, sound)
	"""

func _ready() -> void:
	set_group() # TODO
	set_transitions()

func reset() -> void:
	game.detector.game.show()
	game.detector.pause.hide()
	settings.hide()
