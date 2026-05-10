extends Node

@export var progress: HelpPreview

var game: CanvasLayer = $game

var stats: SessionStats
var settings: Control:
	get: return Works.uploads(self, LoadBus.settings, "settings")
var information: Control:
	get: return Works.uploads(self, LoadBus.information, "information")
var sound: Control:
	get: return Works.uploads(self, LoadBus.sound, "sound")

func set_group() -> void: 
	stats.save_progress()
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
