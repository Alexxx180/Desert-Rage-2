extends Node

class_name ActionTimer

signal timeout()

@export var period: float = 0.05

@onready var tick: Node = $tick

var dial: TimerDial = TimerDial.new() 

func _ready() -> void:
	tick.processor.play.connect(_play)

func _play(delta: float) -> void:
	print("time left: ", dial.time_left)
	if dial.play(delta):
		dial.restart(period)
		print("TIMEOUT")
		timeout.emit()

func stop() -> void: tick.stop()
func start() -> void:
	dial.restart(period)
	tick.start()