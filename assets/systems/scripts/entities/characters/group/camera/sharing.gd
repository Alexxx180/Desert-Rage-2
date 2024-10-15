extends Camera2D

func regroup(group: Node, heroes: Array, hero: Vector2i) -> void:
	change(group, heroes[hero.x])
	switch(heroes, hero.y, hero.x)

func change(node: Node, hero: CharacterBody2D):
	node.remove_child(self)
	hero.add_child(self)
	self.set_owner(hero)

func switch(nodes: Array, main: int, next: int) -> void:
	Processors.switch_both(nodes[main], nodes[next])

func reset(nodes: Array, main: int, next: int) -> void:
	regroup(nodes[main], nodes, Vector2i(next, main))

func _input(_event) -> void:
	var z: float = CameraZooming.zoom()
	if z != 0: zoom = CameraZooming.new_zoom(zoom.x, z)
