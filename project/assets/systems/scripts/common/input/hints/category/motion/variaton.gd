extends VBoxContainer

signal on_hidden()

@onready var animation: AnimationPlayer = $animation

func show_hint() -> void:
	animation.play("hint_appearance/appear")

func hide_hint() -> void:
	animation.play("hint_appearance/disappear")

func on_hide() -> void:
	hide()
	on_hidden.emit()
