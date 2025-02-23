extends Node

@onready var rain: Node = $rain
@onready var spark: Node = $spark

var execute: TileMapLayer:
	set(value):
		rain.execute = value
