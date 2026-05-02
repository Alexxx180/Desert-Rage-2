extends Control

@onready var home: HBoxContainer = $home
@onready var mode: HBoxContainer = $mode
@onready var play: HBoxContainer = $play

func switch_skip() -> void: mode.play.switch_skip()
func switch_play() -> void: mode.play.switch_play()
func switch_mode() -> void:
	mode.switch_mode()
	play.switch_mode()
