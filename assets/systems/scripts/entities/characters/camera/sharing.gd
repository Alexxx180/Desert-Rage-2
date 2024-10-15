extends Camera2D

func change(node: Node, hero: CharacterBody2D):
	node.remove_child(self)
	hero.add_child(self)
	self.set_owner(hero)

func switch(nodes: Array, main: int, next: int) -> void:
	Processors.switch_both(nodes[main], nodes[next])

func reset(nodes: Array, main: int, next: int) -> void:
	print("RESET")
	change(nodes[main], nodes[next])
	switch(nodes, main, next)

func _input(_event) -> void:
	var z: float = CameraZooming.zoom()
	if z != 0: zoom = CameraZooming.new_zoom(zoom.x, z)
