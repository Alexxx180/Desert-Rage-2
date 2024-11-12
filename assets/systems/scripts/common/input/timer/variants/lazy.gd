extends Node

class_name LazyTimer

@export var period: float = 0.05

@onready var tick: Node = $tick

var dial: TimerDial = TimerDial.new()

var _finished: bool = false
var finished: bool:
	get: return _finished

func _ready() -> void:
	tick.processor.play.connect(_play)

func _play(delta: float) -> void:
	_finished = dial.play(delta)
	if _finished: stop()

func stop() -> void: tick.stop()
func start() -> void:
	_finished = false
	dial.restart(period)
	tick.start()
