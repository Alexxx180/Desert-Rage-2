extends StaticBody2D

@onready var animation: AnimationPlayer = $animation

var activated: bool = false

func _toggle() -> void:
	activated = !activated
	
	if activated:
		animation.play("levers/toggle_on")
	else:
		animation.play("levers/toggle_off")
