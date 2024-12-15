extends Control

@onready var detector: MarginContainer = $detector
@onready var processor: Node = $processor
@onready var relation: Node = $relation

func _ready() -> void: relation.controls(self)
