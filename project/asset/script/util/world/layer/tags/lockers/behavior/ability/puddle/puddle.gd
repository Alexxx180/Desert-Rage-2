extends Node

@onready var rain: Node = $rain
@onready var spark: Node = $spark

var lay: Node:
	set(value):
		rain.lay = value
		spark.lay = value

func _ready() -> void:
	rain.flow.connect(spark.puddle_charge)
