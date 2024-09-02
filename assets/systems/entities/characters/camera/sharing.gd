extends Camera2D

const zooming: float = 0.1
const minimum: Vector2 = Vector2(0.5, 0.5)
const maximum: Vector2 = Vector2(1.5, 1.5)

func change(previous: Node, next: Node):
	previous.remove_child(self)
	next.add_child(self)
	self.set_owner(next)
	position = Vector2.ZERO

func _input(_event):
	var z: float = Input.get_axis("view_left", "view_right") * zooming
	zoom = (zoom + Vector2(z, z)).clamp(minimum, maximum)
