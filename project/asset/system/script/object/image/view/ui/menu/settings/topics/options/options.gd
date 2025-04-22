extends VBoxContainer

@onready var game: VBoxContainer = $game
@onready var controls: VBoxContainer = $controls

func switch_controls() -> void:
	game.hide()
	controls.show()

func switch_experience() -> void:
	controls.hide()
	game.show()
