extends Node

@onready var rain: Node = $rain
@onready var spark: Node = $spark

var execute: TileDecorator:
	set(value):
		rain.execute = value
		spark.execute = value
