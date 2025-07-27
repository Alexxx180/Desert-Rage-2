extends Node

@onready var timing: Node = $timing
@onready var move: Node = $move
@onready var run: Node = $run

func _ready() -> void:
	move.behavior = self
	run.behavior = self
