extends VBoxContainer

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
