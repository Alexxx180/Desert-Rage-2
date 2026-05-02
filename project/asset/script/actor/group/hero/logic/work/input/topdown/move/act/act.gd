extends Node

@onready var move: Node = $move
@onready var run: Node = $run

func _ready() -> void:
	move.behavior = self
	run.behavior = self
