extends Camera2D

const zooming: float = 0.1
const minimum: float = 0.5
const maximum: float = 1.5

func reset(nodes: Array, main: int, next: int) -> void:
	nodes[main].remove_child(self)
	nodes[next].add_child(self)
	self.set_owner(nodes[next])
	# position = Vector2.ZERO

func _input(_event):
	var z: float = Input.get_axis("view_left", "view_right") * zooming
	z = clampf(z, 0.5, 1.5)
	zoom = Vector2(z, z)
