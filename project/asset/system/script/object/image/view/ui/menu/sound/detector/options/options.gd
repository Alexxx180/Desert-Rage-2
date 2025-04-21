extends Control

@onready var search: HBoxContainer = $search
@onready var back: Button = $back
@onready var play: Button = $play/play
@onready var skip: Button = $play/skip

func switch_skip() -> void:
	if !play.visible:
		skip.hide()
		play.show()

func switch_play() -> void:
	play.hide()
	skip.show()
