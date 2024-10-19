extends Camera2D

@onready var deploy: Area2D = $deploy

func change(node: Node, hero: CharacterBody2D):
	node.remove_child(self)
	hero.add_child(self)
	self.set_owner(hero)

func _logic(node: Node) -> Node: return node.logic.processors

func switch(nodes: Array, main: int, next: int) -> void:
	Processors.switch_both(_logic(nodes[main]), _logic(nodes[next]))

func initiate(group: Node, party: Array, hero: Vector2i) -> void:
	change(group, party[hero[0]])
	switch(party, hero[1], hero[0])

func regroup(party: Array, hero: Vector2i) -> void:
	change(party[hero[0]], party[hero[1]])
	switch(party, hero[0], hero[1])

func _input(_event) -> void:
	var z: float = CameraZooming.zoom()
	if z != 0: zoom = CameraZooming.new_zoom(zoom.x, z)
