extends Node

@export var progress: HelpPreview

@onready var game: CanvasLayer = $game

var _settings: CanvasLayer = null
var settings: CanvasLayer:
	get: return Works.upload(self, _settings, Defaults.now.settings, "settings")

var _information: CanvasLayer = null
var information: CanvasLayer:
	get: return Works.upload(self, _information, Defaults.now.information, "information")

var _sound: CanvasLayer = null
var sound: CanvasLayer:
	get: return Works.upload(self, _sound, Defaults.now.sound, "sound")

func set_group() -> void:
	SessionStats.save_progress()
	#group
	# game.set_preview(group, progress)

func set_transitions() -> String:
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
	# set_transitions()

func reset() -> void:
	game.detector.game.show()
	game.detector.pause.hide()
	settings.hide()
