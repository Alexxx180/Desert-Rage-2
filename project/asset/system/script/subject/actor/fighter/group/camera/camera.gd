extends Camera2D

@onready var analyze: Node2D = $analyze
@onready var deploy: Area2D = $deploy
@onready var music: Node2D = $music

var zooming: CameraZooming = CameraZooming.new()

func _ready() -> void: music.controls(self)

func traverse(node: Node, hero: CharacterBody2D):
	node.remove_child(self)
	hero.add_child(self)
	self.set_owner(hero)

func set_overworld() -> void:
	zooming.overworld()
	zoom = Vector2(0.2, 0.2)
	position_smoothing_enabled = true

func _input(_event) -> void:
	var z: float = zooming.zoom()
	if z != 0: zoom = zooming.new_zoom(zoom.x, z)
