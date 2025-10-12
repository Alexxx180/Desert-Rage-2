extends Node

signal grab(pull: Node)
signal release(pull: Node)

@onready var move: Node = $move
@onready var press: Node = $press

func grab_box(pull: Node) -> void: grab.emit(pull)
func release_box(pull: Node) -> void: release.emit(pull)
