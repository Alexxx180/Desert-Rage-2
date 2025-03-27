extends Control

@onready var options: VBoxContainer = $detector/main/margin/title/content/options
@onready var processor: Node = $processor
@onready var relation: Node = $relation

func _ready() -> void:
	relation.controls(self, processor)
