extends CharacterBody2D

@onready var see: Node2D = $see
@onready var work: Node = $work
@onready var link: Node = $link

func _ready() -> void: link.controls(self)
