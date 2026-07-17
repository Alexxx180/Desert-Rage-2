extends VBoxContainer

"""
@onready var sound: VBoxContainer = $sound
@onready var experience: VBoxContainer = $experience
@onready var interface: VBoxContainer = $interface
@onready var accessibility: VBoxContainer = $accessibility
@onready var stats: VBoxContainer = $stats
@onready var focus: Node = $focus

var focused: bool:
	get: return focus.focused
	set(value): focus.focused = value

func _ready() -> void:
	focus.options = [sound.get_node("header"), stats.get_node("header"),
		experience.get_node("header"), interface.get_node("header"),
		sound.options.music.submit, stats.get_node("header")]



@onready var game: MarginContainer = $game
@onready var controls: MarginContainer = $controls

func switch_controls() -> void:
	game.hide()
	controls.show()

func switch_experience() -> void:
	controls.hide()
	game.show()

func set_transition(hud: CanvasLayer) -> void:
	game.items.set_transition(hud, game)
	controls.items.set_transition(hud, controls)

func set_soundtrack_transition(settings: CanvasLayer, sound: CanvasLayer) -> void:
	var experience: VBoxContainer = game.get_node("experience")
	experience.sound.options.set_soundtrack_transition(settings, sound)
"""
