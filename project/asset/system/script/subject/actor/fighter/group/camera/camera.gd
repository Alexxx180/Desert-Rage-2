extends Camera2D

@onready var analyze: Node2D = $analyze
@onready var deploy: Area2D = $deploy

func traverse(node: Node, hero: CharacterBody2D):
	node.remove_child(self)
	hero.add_child(self)
	self.set_owner(hero)

func _input(_event) -> void:
	var z: float = CameraZooming.zoom()
	if z != 0: zoom = CameraZooming.new_zoom(zoom.x, z)
