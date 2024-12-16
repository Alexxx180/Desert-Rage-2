extends Button

@onready var timer: Timer = $timer
@onready var animation: AnimationPlayer = $animation

var fixed: bool = false

func _ready() -> void: _start_hide()

func _input(event: InputEvent) -> void:
	if fixed: return
	if event is InputEventMouseMotion:
		_show_pause()
		timer.start()

func _show_pause() -> void:
	if timer.time_left == 0:
		animation.play("pause_show")

func _start_hide() -> void:
	fixed = false
	timer.start()
	
func _stop_hide() -> void:
	fixed = true
	_show_pause()
	timer.stop()

func hide_pause() -> void:
	timer.stop()
	animation.play("pause_hide")
