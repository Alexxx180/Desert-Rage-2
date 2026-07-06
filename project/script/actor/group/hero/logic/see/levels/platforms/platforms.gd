extends Node2D

@onready var surface: Node2D = $surface
@onready var ledges: Area2D = $ledges
@onready var cargo: Area2D = $cargo

var direction: Vector2i
