extends Area2D

signal pressed()
signal release()

var count: int = 0

@onready var animation: AnimationPlayer = $animation

func _on_press(_entity: CharacterBody2D) -> void:
	count += 1
	if count == 1:
		print("PRESSED")
		animation.play("buttons/button_down")
		pressed.emit()

func _on_release(_entity: CharacterBody2D) -> void:
	count -= 1
	if count == 0:
		print("RELEASED")
		animation.play("buttons/button_up")
		release.emit()
