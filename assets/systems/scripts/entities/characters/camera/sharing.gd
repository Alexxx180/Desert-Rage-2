extends Camera2D

const zooming: float = 0.1
const minimum: float = 0.5
const maximum: float = 1.5

func change(node: Node, hero: CharacterBody2D):
	node.remove_child(self)
	hero.add_child(self)
	self.set_owner(hero)
	# position = Vector2.ZERO

func reset(nodes: Array, main: int, next: int) -> void:
	change(nodes[main], nodes[next])

func _input(_event):
	var z: float = Input.get_axis("view_left", "view_right") * zooming
	if z != 0:
		print("Z: ", z)
		z = clampf(zoom.x + z, 0.5, 1.5)
		zoom = Vector2(z, z)
