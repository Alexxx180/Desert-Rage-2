extends Node

class_name ActionTimer

signal timeout()

@export var period: float = 0.05

@onready var tick: Node = $tick

var _ticking: bool = false
var is_ticking: bool:
	get: return _ticking

var dial: TimerDial = TimerDial.new() 

func _ready() -> void:
	tick.processor.play.connect(_play)

func set_period(event: Callable, _period: float) -> void:
	timeout.connect(event)
	period = _period

func _play(delta: float) -> void:
	if dial.play(delta):
		dial.restart(period)
		timeout.emit()

func stop() -> void:
	_ticking = false
	tick.stop()

func start() -> void:
	_ticking = true
	dial.restart(period)
	tick.start()
