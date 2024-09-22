extends Node

@export var value: float = 0

@export var start: float = 0
@export var factor: float = 1.0

func change(metric: int):
	value = start + metric * factor
