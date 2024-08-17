extends Area2D

@onready var ground: Node = $ground
@onready var surface: Node = $surface

func _ready():
	surface.ground = ground
