extends Button

@onready var timer: Timer = $timer
@onready var animation: AnimationPlayer = $animation

func _ready() -> void:
	timer.start()

func _input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion: return
	
	if timer.time_left == 0:
		animation.play("pause_show")
	timer.start()

func hide_pause() -> void:
	timer.stop()
	animation.play("pause_hide")
