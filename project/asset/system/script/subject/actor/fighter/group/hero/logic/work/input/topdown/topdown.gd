extends Node

@onready var move: Node = $move
@onready var levels: Node = $levels
@onready var actions: Node = $actions

func _ready() -> void:
	move.act.levels = levels
	move.act.actions = actions

func input(event: InputEvent) -> void:
	move.device.input(event)

func process_physics(delta: float) -> void: pass

func on_select() -> void: pass
